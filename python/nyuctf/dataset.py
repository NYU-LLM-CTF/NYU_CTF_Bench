import json
import logging
from pathlib import Path
from typing import Optional

from .download import DEFAULT_DIRECTORY, DEFAULT_VERSION, AVAILABLE_VERSIONS, download_dataset

logger = logging.getLogger("CTFDataset")

class CTFDataset(dict):
    def __init__(self, dataset_json: Optional[Path|str]=None, split: Optional[str]=None, version: str=DEFAULT_VERSION):
        if dataset_json is not None:
            dataset_json = Path(dataset_json).expanduser().resolve()
        elif split in ("test", "development") and version in AVAILABLE_VERSIONS:
            dataset_json = Path(DEFAULT_DIRECTORY) / version / f"{split}_dataset.json"
            dataset_json = dataset_json.expanduser().resolve()
            if not dataset_json.exists():
                download_dataset(version)
        else:
            raise ValueError("Pass either dataset_json or split (one of 'test' or 'development')")

        # Confirm that dataset is present
        if not dataset_json.exists():
            raise ValueError(f"Dataset not found: {dataset_json.parent}")
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
