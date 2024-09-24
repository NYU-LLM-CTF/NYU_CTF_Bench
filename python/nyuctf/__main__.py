import argparse
import logging
from .dataset import CTFDataset
from .challenge import CTFChallenge

logging.basicConfig(level=logging.DEBUG)

parser = argparse.ArgumentParser("Print challenge details")
parser.add_argument("--challenge", required=True, help="Challenge name")
parser.add_argument("--dataset", required=True, help="Dataset JSON")
args = parser.parse_args()

ds = CTFDataset(args.dataset)
challenge = CTFChallenge(ds.get(args.challenge), ds.basedir)

print("Name:", challenge.name)
print("Category:", challenge.category)
print("Compose:", challenge.container)
print("Flag:", challenge.real_flag)
print("Files:", challenge.files)
print("Server:", challenge.server_name, challenge.port)
