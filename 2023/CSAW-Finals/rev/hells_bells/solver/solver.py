import subprocess
import os


def solve():
    my_env = os.environ.copy()
    my_env["UNLOCK_ME"] = "AyeCdC"
    process = subprocess.Popen(['hells_bells.exe'], env=my_env, stdin=subprocess.PIPE, bufsize=1, close_fds=False)
    inputs = [
        b"WTB1X0dvdF9tM19yMW5nMW5nX0gzbGxzX2JlTGw1",
        b":",
        b"r_0_L_l_1_n_g_-_t_H_u_n_d_3_r_r_"
    ]
    process.communicate(input=b"\n".join(inputs))


if __name__ == "__main__":
    solve()
