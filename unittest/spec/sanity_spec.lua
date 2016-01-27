local http = require "socket.http"

describe("a test", function()
  it("free user test", function()
    local res, code = http.request("http://localhost:8080/tpm/agent.do?license_key=X0haQQpYHlfd44tDCQkVBANUf425AlNcAAxWDA6ee9oGAUlUDQQH57d7UwFeXAQMXgcF")
    -- print("res=", res, ",code=", code)
    assert.is_truthy(string.find(res, "free server"))
  end)
  it("free user test", function()
    local res, code = http.request("http://localhost:8080/tpm/agent.do?license_key=10haQQpYHlfd44tDCQkVBANUf425AlNcAAxWDA6ee9oGAUlUDQQH57d7UwFeXAQMXgcF")
    -- print("res=", res, ",code=", code)
    assert.is_truthy(string.find(res, "paid server"))
  end)
end)
