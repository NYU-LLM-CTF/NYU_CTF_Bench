import argparse
import subprocess
from pathlib import Path

REPO_URL = "https://github.com/NYU-LLM-CTF/NYU_CTF_Bench.git"
AVAILABLE_VERSIONS = ["v20250206", "v20241008"]
DEFAULT_VERSION = "v20250206"
DEFAULT_DIRECTORY = "~/.nyuctf"

def download_dataset(version=DEFAULT_VERSION, download_dir=DEFAULT_DIRECTORY):
    if version not in AVAILABLE_VERSIONS:
        print(f"Available versions: {', '.join(AVAILABLE_VERSIONS)}")
        return
    target = (Path(download_dir) / version).expanduser().resolve()
    if target.exists():
        print(f"Target directory exists: {target}")
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    print("Cloning using git...")
    gitcmd = ["git", "clone", "--branch", version, "--depth", "1", REPO_URL, str(target)]
    subprocess.run(gitcmd)
    print("Cloned!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download the entire dataset from a GitHub",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-v", "--version", help="Version of the dataset",
                        default=DEFAULT_VERSION, choices=AVAILABLE_VERSIONS)
    parser.add_argument("-d", "--directory", help="Directory to download the dataset", default=DEFAULT_DIRECTORY)
    args = parser.parse_args()
    download_dataset(args.version, args.directory)
