import subprocess

commands = [
	"foreman install",
	"wally install",
	"rojo build -o Bin/Http.rbxm default.project.json",
	"rojo build -o Bin/HttpTests.rbxm testRunner.project.json"
];

for c in commands:
	subprocess.run(c);