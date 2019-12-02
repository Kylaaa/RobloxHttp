local Promise = script.Parent
local targetSource = Promise.src
local TestEZ = require(Promise.packages.TestEZ)
local Reporter = TestEZ.Reporters.TextReporterQuiet

TestEZ.TestBootstrap:run(targetSource:GetChildren(), Reporter)