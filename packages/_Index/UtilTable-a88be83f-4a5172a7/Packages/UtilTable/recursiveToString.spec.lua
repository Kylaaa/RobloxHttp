local recursiveToString = require(script.Parent.recursiveToString)

return function()
	it("should handle nil", function()
		local s = recursiveToString(nil)
		expect(s).to.be.ok()
	end)

	it("should handle numbers", function()
		local s = recursiveToString(12345)
		expect(s).to.be.ok()
	end)

	it("should handle strings", function()
		local s = recursiveToString("hello world")
		expect(s).to.be.ok()
	end)

	it("should handle tables", function()
		local s = recursiveToString({})
		expect(s).to.be.ok()
	end)

	it("should handle userdata", function()
		local s = recursiveToString(newproxy())
		expect(s).to.be.ok()
	end)

	it("should handle booleans", function()
		local s = recursiveToString(true)
		expect(s).to.be.ok()
	end)

	it("should list all keys and values in all nested tables", function()
		
	end)
end