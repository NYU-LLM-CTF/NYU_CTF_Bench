import base64
import os

os.system("bzip2 -d floating_points")

output = ""
with open("floating_points.out") as file:
    f = file.read()
    output = base64.a85decode(f).decode()
    print(output)

with open("output.html", "w") as file:
    file.write("<!DOCTYPE html>\n<html>\n<body>")
    file.write(f"<svg width='1000'>\n<path d='{output}'\n/>")
    file.write("</svg>\n</body>\n</html>")
    file.close()
