import os
import pathlib
import socket
import subprocess
import threading

FILENAME = "maze"


def handle_client(conn):
    with subprocess.Popen(f"{DIR}/{FILENAME}", stdin=conn, stdout=conn, stderr=conn) as proc:
        proc.communicate()
        conn.close()


if __name__ == "__main__":
    DIR = pathlib.Path(__file__).parent.absolute()
    PORT = 5000

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind(("0.0.0.0", PORT))

    sock.listen()

    while True:
        conn, _ = sock.accept()
        threading.Thread(target=handle_client, args=(conn,)).start()

