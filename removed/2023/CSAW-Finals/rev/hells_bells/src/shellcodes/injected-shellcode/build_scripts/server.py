import os
import uvicorn

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    os.system(".\\build_asm.bat")
    return 200

if __name__ == '__main__':
    uvicorn.run(app, port=8001, host='0.0.0.0')
