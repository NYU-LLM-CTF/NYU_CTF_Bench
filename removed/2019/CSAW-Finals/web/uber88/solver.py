import requests
import json

API_URL = "http://ec2-54-215-246-41.us-west-1.compute.amazonaws.com"


def register_user(name, password):
    r = requests.post(
        API_URL + "/user/register",
        data=json.dumps({"name": name, "password": password}),
        headers={"X-API-AGENT": "ANDROID"},
    )
    print(r.text)


def login_user(name, password):
    r = requests.post(
        API_URL + "/user/login",
        data=json.dumps({"name": name, "password": password}),
        headers={"X-API-AGENT": "ANDROID"},
    )
    print(r.text)
    return r.json()["token"]


def request_trip(token, startloc, desttime, pickupnotes):
    r = requests.post(
        API_URL + "/trips/request",
        data=json.dumps(
            {"startloc": startloc, "desttime": desttime, "pickupnotes": pickupnotes}
        ),
        headers={"X-API-AGENT": "ANDROID", "X-API-TOKEN": token},
    )
    print(r.text)
    return r.json()["id"]


def trip_status(token, tripid):
    r = requests.get(
        API_URL + "/trips/status?tripid=" + str(tripid),
        headers={"X-API-AGENT": "ANDROID", "X-API-TOKEN": token},
    )
    print(r.text)


def trip_notes(token, tripid):
    r = requests.get(
        API_URL + "/trips/notes?tripid=" + str(tripid),
        headers={"X-API-AGENT": "ANDROID", "X-API-TOKEN": token},
    )
    print(r.text)


def location(lat, lng):
    return {"latitude": "{}".format(lat), "longitude": "{}".format(lng)}


register_user("test", "test")
token = login_user("test", "test")
tripid1 = request_trip(
    token,
    location(0, 0),
    "1970-01-01T00:00:00.014147984Z",
    "{{ setDateFormat 100000 }}{{ formatDate 100000 }}{{ getFormattedDates }}",
)
# trip_notes(token, tripid1)
trip_notes(token, tripid1)
