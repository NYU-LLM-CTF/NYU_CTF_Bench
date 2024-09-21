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
    def __init__(self, challenge: dict, basedir: Path|str):
        self.challenge_info = challenge
        self.challenge_dir = Path(basedir) / challenge["path"]
        self.challenge_dir = self.challenge_dir.expanduser().resolve()

        # Load challenge details from JSON
        self.load_challenge(self.challenge_dir / "challenge.json")

    def load_challenge(self, challenge_json : Path):
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
        self.flag = self.challenge["flag"]
        if "{" not in self.flag:
            logger.warning(f"Flag for challenge {self.name} does not follow a standard format, please check!")
            self.flag_format = "not provided"
        else:
            self.flag_format = re.sub(r'\{.*?\}', '{...}', self.flag)
        assert self.flag_format != self.flag, f"Flag format for {self.asiname} would leak the flag!"

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
