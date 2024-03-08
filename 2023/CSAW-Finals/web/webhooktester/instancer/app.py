from flask import Flask, render_template, request
from flask_turnstile import Turnstile
from redis import Redis
import docker
import requests
from datetime import datetime, timedelta
import secrets
import time
import threading
import os
import sys
import logging

app = Flask(__name__)
req = requests.Session()
req.headers.update({"Origin": "http://"+os.getenv("CADDY_SECRET")})

HOST = os.getenv("INSTANCER_HOST")# e.g. webhooktester.csaw.io
PORT = os.getenv("INSTANCER_PORT")# e.g. 9000

TS_SITE_KEY = os.getenv("TURNSTILE_SITE_KEY", None)
TS_SECRET_KEY = os.getenv("TURNSTILE_SECRET_KEY", None)

app.config["TURNSTILE_SITE_KEY"] = TS_SITE_KEY
app.config["TURNSTILE_SECRET_KEY"] = TS_SECRET_KEY

if not TS_SITE_KEY or not TS_SECRET_KEY:
    app.config["TURNSTILE_ENABLED"] = False

turnstile = Turnstile(app=app)
docker_client = docker.DockerClient(base_url="unix://var/run/docker.sock")
redis_client = Redis(host="redis", port=6379, decode_responses=True)

CONTAINER_LIFETIME = 300  # in seconds
CLEANUP_INTERVAL = 300  # in seconds
CHALLENGE_IMAGE = "ctf-challenge"

# port inside container
CHALLENGE_PORT = 80


def cleanup_loop(interval):
    while True:
        cleanup()
        time.sleep(interval)


def kill_container(container):
    try:
        container.remove(force=True)
        redis_client.delete(container.name)

        req.delete(f"http://caddy:2019/id/{container.name}")

        print(f"Container {container.name} has been cleaned up.")
    except docker.errors.NotFound:
        # The container was not found, which means it's already been cleaned up.
        print(f"Container {container.name} was already cleaned up.")
        pass
    except Exception as e:
        # Handle any other exceptions.
        print(f"An error occurred while cleaning up container {container.name}: {e}")


def cleanup():
    current_time = datetime.utcnow()
    containers = []
    for container in docker_client.containers.list():
        if not container.name.startswith("inst-"):
            continue
        containers.append(container.name)
        # Assuming each container's name is a UUID set as the instance id
        # Retrieve the expiration time of the container from Redis
        expiration_time_str = redis_client.get(container.name)
        if expiration_time_str:
            expiration_time = datetime.strptime(
                expiration_time_str, "%Y-%m-%dT%H:%M:%S.%fZ"
            )
            #print(f"checking container {container.name}: {current_time} {expiration_time}")
            # this should never happen with key TTLs, but whatever
            if current_time >= expiration_time:
                print(f"ERR: found expired container {container.name}...")
                kill_container(container)
        else:
            print(f"Found untracked container {container.name}... removing")
            kill_container(container)
    print(len(containers), containers)


# Start the cleanup task in a new daemon thread
cleanup_thread = threading.Thread(target=cleanup_loop, args=(CLEANUP_INTERVAL,))
cleanup_thread.daemon = True
cleanup_thread.start()


def listen_for_expired_keys():
    pubsub = redis_client.pubsub()
    pubsub.psubscribe("__keyevent@0__:expired")
    for message in pubsub.listen():
        if message["type"] == "pmessage":
            print(f"Received expiration event... killing container {message['data']}")

            # The expired key will be the container's instance_id
            instance_id = message["data"]
            try:
                container = docker_client.containers.get(instance_id)
                kill_container(container)
            except docker.errors.NotFound:
                print(
                    f"Container {instance_id} not found, it might have already been removed."
                )


listen_thread = threading.Thread(target=listen_for_expired_keys)
listen_thread.daemon = (
    True  # This will allow the main program to exit even though the listener is running
)
listen_thread.start()

@app.route("/", methods=["GET", "POST"])
def start_challenge():
    if request.method != "POST":
        return render_template("index.html")
    # else POST
    if turnstile.verify():
        # chance of collision really low...
        instance_id = "inst-" + secrets.token_hex(5)
        try:
            # Start a new Docker container for the challenge
            docker_client.containers.run(
                CHALLENGE_IMAGE,
                name=instance_id,
                #ports={f"{CHALLENGE_PORT}/tcp": port},
                #environment={"CHALLENGE_HOST": f"{instance_id}.{HOST}"},
                network="instancer_chal-instance",
                detach=True,
            )

            config_section = {
                "@id": instance_id,
                "handle": [
                    {
                        "handler": "subroute",
                        "routes": [
                            {
                                "handle": [
                                    {
                                        "handler": "reverse_proxy",
                                        "upstreams": [{"dial": f"{instance_id}:80"}],
                                    }
                                ]
                            }
                        ],
                    }
                ],
                "match": [{"host": [f"{instance_id}.{HOST}"]}],
                "terminal": True,
            }
            req.put(
                "http://caddy:2019/config/apps/http/servers/srv0/routes/0",
                json=config_section,
            )

            expiration_time = (
                datetime.utcnow() + timedelta(seconds=CONTAINER_LIFETIME)
            ).strftime("%Y-%m-%dT%H:%M:%S.%fZ")
            print(f"Created instance {instance_id}, expiry={expiration_time}")
            redis_client.setex(
                name=instance_id, time=CONTAINER_LIFETIME, value=expiration_time
            )
            return render_template(
                "index.html", instance_url=f"http://{instance_id}.{HOST}:{PORT}"
            )
        except docker.errors.ContainerError as e:
            print(e)
            return render_template("index.html", error="Container error occurred"), 500
        except docker.errors.ImageNotFound as e:
            print(e)
            return render_template("index.html", error="Challenge image not found"), 500
        except docker.errors.APIError as e:
            print(e)
            return render_template("index.html", error="Docker server error"), 500
    else:
        return render_template("index.html", error="Failed captcha"), 500


print("Starting instancer webserver...")
