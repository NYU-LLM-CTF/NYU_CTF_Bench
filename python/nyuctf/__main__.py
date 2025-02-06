import argparse
import logging
from .dataset import CTFDataset
from .challenge import CTFChallenge

logging.basicConfig(level=logging.ERROR)

parser = argparse.ArgumentParser("List challenges that match filter")
parser.add_argument("-y", "--year", help="Challenge name")
parser.add_argument("-e", "--event", help="Event (CSAW-Quals, CSAW-Finals)")
parser.add_argument("-c", "--category", help="Category (rev, pwn, forensics, web, misc)")
parser.add_argument("-n", "--name", help="Challenge name")
parser.add_argument("-d", "--dataset", default="test", help="Dataset name or JSON path")
parser.add_argument("-D", "--details", action="store_true", help="Print details")
args = parser.parse_args()

if args.dataset and args.dataset.endswith(".json"):
    ds = CTFDataset(dataset_json=args.dataset)
else:
    ds = CTFDataset(split=args.dataset)

chals = ds.filter(year=args.year, event=args.event, category=args.category, challenge=args.name)

for chal in map(lambda c: CTFChallenge(c, basedir=ds.basedir), chals):
    print(chal.canonical_name)
    if args.details:
        print("\tName:", chal.name)
        print("\tCategory:", chal.category)
        print("\tCompose:", chal.container)
        print("\tFlag:", chal.flag)
        print("\tFiles:", chal.files)
        if chal.server_name:
            print("\tServer:", chal.server_name, chal.port)
