local http = require "socket.http"

describe("pressure test", function()
  local looptimes=5000
  it("multi-free user test", function()
    for i=1,looptimes do
        local res, code = http.request("http://localhost:8080/tpm/agent.do?license_key=X0haQQpYHlfd44tDCQkVBANUf425AlNcAAxWDA6ee9oGAUlUDQQH57d7UwFeXAQMXgcF"..i)
        -- print("res=", res, ",code=", code)
        assert.is_truthy(string.find(res, "free server"))
    end
  end)
  it("multi-paid user test", function()
    for i=1,looptimes do
        local res, code = http.request("http://localhost:8080/tpm/agent.do?license_key=10haQQpYHlfd44tDCQkVBANUf425AlNcAAxWDA6ee9oGAUlUDQQH57d7UwFeXAQMXgcF"..i)
        -- print("res=", res, ",code=", code)
        assert.is_truthy(string.find(res, "paid server"))
    end
  end)
end)
