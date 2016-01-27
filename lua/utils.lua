local _M = {}

function _M:table_is_empty(t)
    return next(t) == nil
end

function _M:table_is_array(t)
    if type(t) ~= "table" then return false end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

function _M:table_is_map(t)
    if type(t) ~= "table" then return false end
    for k,_ in pairs(t) do
        if type(k) == "number" then return false end
    end
    return true
end

---
-- extract license_key from uri args
-- @param args, typcially from ngx.req.get_uri_args()
-- @return value of license_key if present, others nil
function _M:getLicenseKeyFromUriArgs(args)
    for key, val in pairs(args) do
        if key == "license_key" then
            if type(val) == "table" then
                -- multi license parameters, use the first one
                license = val[1]
                ngx.log(ngx.INFO, "license_key=", key,",val=", table.concat(val,","))
            else
                return val
            end
            ngx.log(ngx.INFO, "got license_key=", license)
        end
    end
    return nil
end

return _M
