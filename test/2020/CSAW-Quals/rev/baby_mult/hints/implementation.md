Run the following python script to get the flag:

```
import angr

with open("/home/ctfplayer/ctf_files/program.txt", "r") as p, open("/tmp/program.bin", "wb") as w:
    prog = bytes(map(int, p.read().strip().split(", ")))
    prog += b"\xc3"
    w.write(prog)

proj = angr.Project("/tmp/program.bin", main_opts={"backend": "blob"}, arch="AMD64")
s = proj.factory.call_state(0x0, ret_addr=0xDEADC0DE)
rsp = s.solver.eval(s.regs.rsp)

simgr = proj.factory.simgr(s)
simgr.run(filter_func=lambda y: "deadended" if y.solver.eval(y.regs.ip) == 0xDEADC0DE else "active")

s2 = simgr.deadended[0]

flag = ""
for i in range(0x79, 0x99):
    b = s2.memory.load(rsp-i, 1)
    v = b.args[0]
    # print(hex(rsp-i), v, chr(v))
    if v > 0:
        flag += chr(v)
print(flag)
```
