local Http = script.Parent
local targetSource = Http.src
local TestEZ = require(Http.packages.TestEZ)
local Reporter = TestEZ.Reporters.TextReporterQuiet

TestEZ.TestBootstrap:run(targetSource:GetChildren(), Reporter)