local Networking = require(script.Parent.Networking)

return function()
	describe("new()", function()
		it("should return an object", function()
			local n = Networking.new()
			expect(n).to.be.ok()
		end)
	end)

	describe("mock()", function()
		
	end)

	describe("GET()", function()
		it("should validate input", function()

		end)

		it("should return a promise", function()

		end)

		it("should allow custom headers", function()

		end)
	end)

	describe("POST()", function()
		it("should validate input", function()

		end)

		it("should return a promise", function()

		end)

		it("should allow custom headers", function()

		end)
	end)
end