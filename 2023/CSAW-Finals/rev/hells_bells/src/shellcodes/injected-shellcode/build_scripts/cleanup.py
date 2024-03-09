import os
import re

STACK_ALIGN = """

entry PROC
    push rsi
    mov rsi, rsp
    and rsp, 0FFFFFFFFFFFFFFF0h
    sub rsp, 020h
    call main
    mov rsp, rsi
    pop rsi
    ret
entry ENDP

"""


def cleanup():
    print("Starting asm cleanup")
    with open("..\\build\\main.asm", "r") as f:
        data = f.read()
        print("Removing FLAT:")
        data = data.replace("FLAT:", "")
        print("Removing INCLUDELIB")
        data = re.sub(r"INCLUDELIB .*", "", data)
        pdata_sections = re.compile(r"^(pdata	SEGMENT)([\s\S]*?)^(pdata	ENDS)", re.MULTILINE)
        xdata_sections = re.compile(r"^(xdata	SEGMENT)([\s\S]*?)^(xdata	ENDS)", re.MULTILINE)
        print("Removing pdata sections")
        data = re.sub(pdata_sections, "", data)
        print("Removing xdata sections")
        data = re.sub(xdata_sections, "", data)
        print("Fixing 'gs:'")
        data = data.replace("gs:96", "gs:[96]")
        print("Adding entry")
        text_segment = "_TEXT	SEGMENT"
        first_index = data.find(text_segment)
        data = data[:first_index + len(text_segment)] + STACK_ALIGN + data[first_index:]

    with open("..\\build\\main_out.asm", "w") as f2:
        print("Writing output")
        f2.write(data)


if __name__ == "__main__":
    cleanup()
