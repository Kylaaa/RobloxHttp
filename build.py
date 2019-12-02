import subprocess

subprocess.run("rojo build -o bin/Http.rbxm default.project.json")
subprocess.run("rojo build -o bin/HttpTests.rbxm testRunner.project.json")