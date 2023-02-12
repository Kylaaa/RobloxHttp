local Project = script.Parent
local TargetSource = Project.Src
local TestEZ = require(Project.DevPackages.TestEZ)
local Reporter = TestEZ.Reporters.TextReporterQuiet

TestEZ.TestBootstrap:run(TargetSource, Reporter)