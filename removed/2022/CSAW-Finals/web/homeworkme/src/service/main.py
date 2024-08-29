#!/usr/bin/env python3

import os
import json

from fastapi import FastAPI
from fastapi.responses import FileResponse
from pydantic import BaseModel

app = FastAPI()
path = "files"

# flag{bro_can_i_use_your_chegg}

class File(BaseModel):
    filename: str
    subject: str


@app.post("/retrieve")
async def retrieve(file: File):
    file_dict = file.dict()
    file_path = os.path.join(path, file_dict["subject"], file_dict["filename"])
    try:
        return FileResponse(file_path)
    except:
        return "file not found"


@app.get("/directory")
async def directory():
    data = {"files": []}
    for dirpath, dirnames, filenames in os.walk(path):
        if filenames:
            for f in filenames:
                obj = {"subject": dirpath.split("/")[1], "filename": f}
                data["files"].append(obj)
    return data["files"]
