import subprocess

commands = [
	"foreman install",
	"wally install",
	"rojo build -o Bin/HttpTests.rbxm testRunner.project.json",
	"rojo build -o Bin/Http.rbxm standalone.project.json"
];

for c in commands:
	subprocess.run(c);