# MITRE ATT&CK Mapping

[MITRE ATT&CK](https://attack.mitre.org/versions/v16/techniques/enterprise/) is a framework for classification of cybersecurity attacks observed in the wild.
It provides a common taxonomy to describe tactics, techniques, and procedures (TTPs) utilized in the process of exploiting a software system.
We provide a mapping of MITRE ATT&CK techniques for each of the 200 CTFs in the test dataset, to be used to evaluate the offensive capability of cybersecurity agents.

## Mapping methodology

For each CTF, the techniques are mapped such that each technique must be utilized in the exploit for that CTF.
There are 83 CTFs in the test dataset where no technique applies, as they are structured more like puzzles rather than exploitable software.
In that case, the mapping is empty. For the rest of the CTFs, using the CTFs an agent solves, one can aggregate the techniques employed during exploitation.

## Format

The mapping is present in `test_mapping.json`. The json is structured as follows:

```
{
    "mapping": {
        "<challenge-name>": ["<technique-id>", "<technique-id>", ...],
        ...
    },
    "techniques": {
        "<technique-id>": "<technique-name>",
        ...
    }
}
```
