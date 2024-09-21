import json
import logging
from pathlib import Path

logger = logging.getLogger("CTFDataset")

class CTFDataset(dict):
    def __init__(self, dataset_json: Path|str):
        dataset_json = Path(dataset_json).expanduser().resolve()
        self.dataset_dir = dataset_json.parent
        self.dataset = json.loads(dataset_json.open().read())

    @property
    def basedir(self):
        return self.dataset_dir

    def all(self):
        return self.dataset.items()

    def get(self, chal):
        """Get a challenge by canonical name"""
        return self.dataset[chal]

    def filter(self, year=None, event=None, category=None, challenge=None):
        """
        Filter challenges by year, event, category, and challenge name.
        Returns a generator.

        Examples:
          # Get all the pwn challenges from year 2018
          dataset.filter(year="2018", category="pwn")

          # Get all the quals challenges
          dataset.filter(event="CSAW-Quals")

          # Get rev and crypto quals challenges from 2020
          dataset.filter(year="2020", category=["rev", "crypto"])

          # Search by just the challenge name
          dataset.filter(challenge="maze")
        """
        for chal in self.dataset.values():
            if year is not None:
                if isinstance(year, str) and year != chal["year"]:
                    continue
                elif isinstance(year, list) and chal["year"] not in year:
                    continue
            if category is not None:
                if isinstance(category, str) and category != chal["category"]:
                    continue
                elif isinstance(category, list) and chal["category"] not in category:
                    continue
            if event is not None:
                if isinstance(event, str) and event != chal["event"]:
                    continue
                elif isinstance(event, list) and chal["event"] not in event:
                    continue
            if challenge is not None:
                if isinstance(challenge, str) and challenge != chal["challenge"]:
                    continue
                elif isinstance(challenge, list) and chal["challenge"] not in challenge:
                    continue
            yield chal

    def __len__(self):
        return len(self.dataset)
