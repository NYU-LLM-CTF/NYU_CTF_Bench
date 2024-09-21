import re

class SafeDict(dict):
    """
    Helper so that we can format the challenge description without worrying about
    missing keys from accidental use of braces in the description
    """
    def __missing__(self, key):
        return '{' + key + '}'

CATEGORY_FRIENDLY = {
    "rev": "reverse engineering",
    "pwn": "binary exploitation",
    "web": "web security",
    "crypto": "cryptography",
    "misc": "miscellaneous",
    "forensics": "forensics",
}

CATEGORY_SHORT = {
    "crypto": "cry",
    "forensics": "for",
    "misc": "msc",
    "pwn": "pwn",
    "rev": "rev",
    "web": "web",
}

_rep_underscore = re.compile(r'_+')
def safe_name(s: str) -> str:
    """
    Create a safe name (suitable for docker) from a string
    """
    # Replace all non-alphanumeric characters with underscores
    safe = s.replace(' ', '_').lower()
    safe = ''.join(c if c.isalnum() else '_' for c in safe).rstrip('_')
    safe = _rep_underscore.sub('_', safe)
    return safe

def get_canonical_name(challenge_info: dict) -> str:
    """
    Create a safe image name from a challenge; this is the same scheme
    that was used by the builder script to create the image name, so it
    can be used to predict the OCI name.
    """
    year = challenge_info["year"]
    event = challenge_info["event"]
    category = challenge_info["category"]
    name = challenge_info["challenge"]

    chal_name = safe_name(name)
    event = event.rsplit('-',1)[1]
    event_char = event.lower()[0]
    cat = CATEGORY_SHORT[category]
    return f"{year}{event_char}-{cat}-{chal_name}"
