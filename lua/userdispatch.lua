local cjson = require "cjson.safe"
local utils = require "utils"
local cache_ngx = ngx.shared.license_pay_cache

function isPaidLicense(license)
    local http = require("resty.http")
    local client = http.new()
    local isPaid = "f"

    client:set_timeout(500)
    local resp, err = client:request_uri("http://127.0.0.1:8210/", {
        method = "GET",
        path = "/v1/userService/getPayStatus/ai?license_key="..license,
        headers = {
            ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64)"
        }
    })

    if not resp then
        ngx.log(ngx.INFO, "request userService error :", err)
        return false
    end

    if not resp.body then
        ngx.log(ngx.INFO, "request userService error : body is nil")
        return false
    end

    ngx.log(ngx.INFO, "userService resp.status=", resp.status)
    ngx.log(ngx.INFO, "userService resp.body=", resp.body)

    -- {"status":"success"/"failed", "result":true, "error_message":"no such user"}
    local data = cjson.decode(resp.body)
    if data then
        if utils:table_is_map(data) then
            local status = data.status
            local result = data.result
            if status == "success" then
                ngx.log(ngx.INFO, "get userService sucess, isPaid = t,", ",result=", data.result)
                if data.result == true then
                    isPaid = "t"
                    cache_ngx:set(license, "t", 3600) -- seconds
                else
                    cache_ngx:set(license, "f", 3600) -- seconds
                end
            end
        end
    end

    client:close()
    ngx.log(ngx.INFO, "return isPaid=", isPaid)
    return isPaid
end

-- main code start -------------------------------------------------------
local args = ngx.req.get_uri_args()
local license = utils:getLicenseKeyFromUriArgs(args)

if license then
    local paid = cache_ngx:get(license)
    ngx.log(ngx.INFO, "get paid state from cache=", paid)
    if paid == nil then
        ngx.log(ngx.NOTICE, "get paid state from cache is nil")
        paid = isPaidLicense(license)
    end

    if paid == "t" then
        -- local succ, err, forcible = cache_ngx:set(license, payLevel)
        ngx.log(ngx.INFO, "proxy to paid user, license=",license)
        ngx.var.backend_url = "dcpaid"
    else
        ngx.log(ngx.INFO, "proxy to free user, license=",license)
        ngx.var.backend_url = "dcfree"
    end
end
