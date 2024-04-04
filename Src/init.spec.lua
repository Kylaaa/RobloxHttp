local Networking = require(script.Parent)

return function()
	describe("new()", function()
		it("should return an object", function()
			local n = Networking.new()
			expect(n).to.be.ok()
		end)
	end)

	describe("mock()", function()
		
	end)

	describe("request()", function()
		it("should validate input", function()

		end)

		it("should return a promise", function()

		end)
	end)

	describe("GET()", function()
		it("should act as a formatted request()", function()

		end)
	end)

	describe("POST()", function()
		it("should act as a formatted request()", function()

		end)
	end)
end