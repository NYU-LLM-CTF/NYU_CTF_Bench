# NYU CTF Dataset

This repository hosts the NYU CTF Dataset, a collection of CTF challenges from the CSAW CTF competitions, designed for evaluation of LLM agents.
The CTF challenges are dockerized and easily deployable to allow an LLM-based automation framework to interact with the challenge and attempt a solution.
The main dataset contains 200 challenges across 6 CTF categories: web, binary exploitation (pwn), forensics, reverse engineering (rev), cryptography (crypto), and miscellaneous (misc).

## Dataset structure

The `test/` folder contains the main dataset of 200 challenges. A smaller development dataset will be added soon.

The folder structure is as follows: `<year>/<event>/<category>/<challenge>`.
`<year>` is the year of the competition, `<event>` is either "CSAW-Quals" or "CSAW-Finals", `<category>` is among the 6 categories, and `<challenge>` is the challenge name.
Note that the challenge name may have spaces and single-quotes, so it is advisable to wrap it in double-quotes when using in scripts.

Each challenge contains a `challenge.json` containing the metadata of the challenge, and the corresponding challenge files.
Challenges that require a server to host some challenge files are set up with a docker image, and a `docker-compose.yaml` file.
The docker image is loaded directly using `docker compose up`.

## Setup 

Download this repository.

```
git clone --depth 1 https://github.com/NYU-LLM-CTF/LLM_CTF_Database
```

Install the python package.

```
cd LLM_CTF_Database/python
pip install .
```

## Usage

The following python snippet shows how to load challenge details using the python module:

```
from nyuctf.dataset import CTFDataset
from nyuctf.challenge import CTFChallenge

ds = CTFDataset("~/LLM_CTF_Database/test_dataset.json")
chal = CTFChallenge(ds.get("2021f-rev-maze"), ds.basedir)

print(chal.name)
print(chal.flag)
print(chal.files)
```

## Tests

Run tests on the challenges, for docker setup and network connection.
Requires the docker network to be setup.

```
cd LLM_CTF_Database/python
python -m unittest -v test.test_challenges
```

Optionally filter the tests with the unittest `-k` flag.
