from functools import cached_property
import json
import re
import subprocess
import tempfile
from typing import List
from pathlib import Path
import logging

from .utils import SafeDict, get_canonical_name

logger = logging.getLogger("CTFChallenge")

class CTFChallenge:
    def __init__(self, challenge: dict):
        self.challenge_info = challenge
        self.challenge_dir = Path(challenge["path"])

        # Load challenge details from JSON
        self.load_challenge(self.challenge_dir / "challenge.json")

    def load_challenge(self, challenge_json : Path):
        # TODO redo
        # Load in all the challenge information from the challenge.json file
        self.challenge_json = challenge_json
        self.challenge = json.loads(challenge_json.read_text())
        self.container = self.challenge.get("compose", False)

        self.files = self.challenge.get("files", [])
        self.has_files = len(self.files) > 0

        self.name = self.challenge.get("name", "UNKNOWN")
        self.category = self.challenge.get("category")
        self.year = int(self.challenge_info["year"])
        self.event = self.challenge_info["event"]
        
        self.points = self.challenge.get("points", self.challenge.get("initial", 0))
        self.real_flag = self.challenge["flag"]
        if "{" not in self.real_flag:
            logger.warning(f"Flag for challenge {self.name} does not follow a standard format, please check!")
            self.flag_format = "not provided"
        else:
            self.flag_format = re.sub(r'\{.*?\}', '{...}', self.real_flag)
        assert self.flag_format != self.real_flag, f"Flag format for {self.asiname} would leak the flag!"

        self.server_name = self.challenge.get("box", None)
        self.port = self.challenge.get("internal_port", None)
        self.server_description = self.challenge.get("server_description", None)

        # If the chal description contains {box} or {port} but we don't have
        # a server name, raise an error
        if "{box}" in self.challenge["description"] and not self.server_name:
            raise RuntimeError(f"Challenge {self.name} has placeholder for {{box}} in the description but no server name found")
        if "{port}" in self.challenge["description"] and not self.port:
            raise RuntimeError(f"Challenge {self.name} has placeholder for {{port}} in the description but no internal_port found")

    @property
    def description(self):
        return self.challenge["description"].format_map(
            SafeDict(box=self.server_name, port=self.port)
        )


    def get_server_description(self):
        # TODO move to automation
        if self.challenge.get("server_description", None) is not None:
            return self.challenge["server_description"]
        # NB: Docker compose challenges are expected to have all the information
        # included in the description from challenge.json
        # TODO: simplify this / make it consistent
        if self.challenge_server_name:
            if self.category == "web" or self.category == "misc" and self.challenge.get("proto") != "nc":
                return f"The challenge web server is running on `{self.challenge_server_name}` port `{self.challenge_port}` and you can access it from within the container environment using `curl http://{self.challenge_server_name}:{self.challenge_port}`.\n\n"
            else:
                return f"The challenge server is running on `{self.challenge_server_name}` port `{self.challenge_port}` and you can access it from within the container environment using `nc {self.challenge_server_name} {self.challenge_port}`.\n\n"
        else:
            return ""

    def get_container_logs(self):
        if not self.container:
            return
        return subprocess.check_output(
            ["docker", "compose", "-f", self.challenge_dir / "docker-compose.yml", "logs"],
            text=True,
        )

    def start_challenge_container(self):
        if not self.container:
            return
        logger.info(f"Starting challenge services with docker-compose")
        subprocess.run(
           ["docker", "compose", "-f", self.challenge_dir / "docker-compose.yml",
            "up", "-d", "--force-recreate"],
            check=True, capture_output=True,
        )

    def stop_challenge_container(self):
        if not self.container:
            return
        logger.info(f"Stopping challenge services with docker-compose")
        self.container_output = self.get_container_logs()
        subprocess.run(
            ['docker', 'compose', '-f', self.challenge_dir / 'docker-compose.yml', 'down', '--volumes'],
            check=True, capture_output=True,
        )

if __name__ == "__main__":
    import argparse

    logging.basicConfig(level=logging.DEBUG)

    parser = argparse.ArgumentParser("Print challenge details")
    parser.add_argument("--challenge", required=True, help="Challenge name")
    parser.add_argument("--dataset", default="main_dataset.json", help="Dataset JSON")
    args = parser.parse_args()

    dataset_json = Path(args.dataset)
    with dataset_json.open() as jf:
        dataset = json.load(jf)

    if args.challenge not in dataset:
        print("Challenge", args.challenge, "not found in dataset. Make sure you use the exact canonical name")
        exit(1)
    challenge = CTFChallenge(dataset[args.challenge])

    print("Name:", challenge.name)
    print("Category:", challenge.category)
    print("Compose:", challenge.container)
    print("Flag:", challenge.real_flag)
    print("Files:", challenge.files)
    print("Server:", challenge.server_name, challenge.port)
