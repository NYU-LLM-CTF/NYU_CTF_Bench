import requests
import argparse
from tqdm import tqdm
import os
import tarfile
import pygit2

REPO_URL = "https://github.com/NYU-LLM-CTF/LLM_CTF_Database.git"

version_info = {
    "20241001": {
        "branch": "release",
        "commit": "2bb3030fc13f2602e52fd7adaa4852976c4263ca"
    }
}

def download_dataset(version, target_dir):
    if version not in version_info.keys():
        print(f"Available version: {version_info.keys()}")
        return
    print("Start retrieving...")
    branch = version_info[version]["branch"]
    commit = version_info[version]["commit"]
    clone_and_checkout_commit(REPO_URL, target_dir, branch, commit)
    print(f"Changed to commit version {version}")

class Progress(pygit2.RemoteCallbacks):
    def __init__(self):
        super().__init__()
        self.progress_bar = None

    def transfer_progress(self, stats):
        if self.progress_bar is None:
            self.progress_bar = tqdm(total=stats.total_objects,
                                     desc="Progress",
                                     unit="obj",
                                     leave=True)
        self.progress_bar.n = stats.received_objects
        self.progress_bar.refresh()

    def __del__(self):
        if self.progress_bar:
            self.progress_bar.close()

def clone_and_checkout_commit(repo_url, target_dir, branch_name, commit_hash):
    repo = pygit2.clone_repository(repo_url, target_dir, checkout_branch=branch_name,
                                   callbacks=Progress())

    commit = repo.revparse_single(commit_hash)
    repo.checkout_tree(commit, strategy=pygit2.GIT_CHECKOUT_FORCE)
    repo.set_head(commit.id)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download an entire directory from a GitHub repository",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-v", "--version", help="Version of the dataset", default="20241001")
    parser.add_argument("-d", "--directory", help="Directory to download the dataset", default="./")
    parser.add_argument("-n", "--name", help="Database name", default="LLM_CTF_Database")
    args = parser.parse_args()
    download_dataset(args.version, os.path.join(args.directory, args.name))