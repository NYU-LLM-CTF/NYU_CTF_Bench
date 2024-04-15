# elias did this barwani didn't

from fastapi import FastAPI, Response
from fastapi.responses import JSONResponse

from pydantic import BaseModel

import os
from time import time

import uvicorn

import subprocess

app = FastAPI()

if not os.path.exists("scores"):
    os.mkdir("scores")


class Score(BaseModel):
    name: str
    score: int
    time: int = int(time())
    uuid: str

    def __init__(self, **data):
        data["name"] = data["name"].replace(",", "")
        super().__init__(**data)


@app.post("/score")
def add_score(score: Score) -> Response:
    if os.path.exists(f"scores/{score.uuid}"):
        with open(f"scores/{score.uuid}", "r") as f:
            if not f.readlines():
                return None
            f.seek(0)
            line = f.readline().strip().split(",")
            old_score = Score(
                name=line[2], score=int(line[1]), time=int(line[0]), uuid=score.uuid
            )
    else:
        old_score = Score(name=score.name, score=-1, time=-1, uuid=score.uuid)

    if old_score.score > score.score:
        return JSONResponse(
            content={"ok": True, "content": "Score is lower than old score"},
            status_code=200,
        )

    cat_cmd = subprocess.Popen(
        ["bash", "-c", f"cat > scores/{score.uuid}"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    cat_out, cat_err = cat_cmd.communicate(
        f"{score.time},{score.score},{score.name}".encode()
    )

    if cat_err:
        return JSONResponse(
            content={"ok": False, "content": cat_err.decode("utf-8")}, status_code=500
        )
    else:
        return JSONResponse(
            content={"ok": True, "content": cat_out.decode("utf-8")}, status_code=200
        )


@app.get("/score")
def get_score(uuid: str) -> Score:
    if not os.path.exists(f"scores/{uuid}"):
        return None
    with open(f"scores/{uuid}", "r") as f:
        if not f.readlines():
            return None
        f.seek(0)
        line = f.readline().strip().split(",")
        return JSONResponse(
            content=dict(
                Score(name=line[2], score=int(line[1]), time=int(line[0]), uuid=uuid)
            ),
            status_code=200,
        )


@app.get("/leaderboard")
def get_leaderboard() -> list[Score]:
    scores = []
    files = os.listdir("scores")
    for uuid in files:
        if not os.path.exists(f"scores/{uuid}"):
            continue
        with open(f"scores/{uuid}", "r") as f:
            if not f.readlines():
                continue
            f.seek(0)
            line = f.readline().strip().split(",")
            scores.append(
                dict(
                    Score(
                        name=line[2], score=int(line[1]), time=int(line[0]), uuid=uuid
                    )
                )
            )
    return JSONResponse(
        content=sorted(scores, key=lambda x: x["score"], reverse=True), status_code=200
    )


if __name__ == "__main__":
    uvicorn.run("main:app", log_level="info", reload=True)
