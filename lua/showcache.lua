local cache_ngx = ngx.shared.license_pay_cache
-- cache_ngx:set("key1","value1")
-- cache_ngx:set("key2","value2")
local keys = cache_ngx:get_keys(30)
ngx.say("key:value,", type(keys),",", table.concat(keys, ","))
for _, value in pairs(keys) do
    ngx.say(value, ":", cache_ngx:get(value))
end

local head = ngx.req.get_headers(0) -- ngx.header
ngx.say("head type=", type(head))
if head then
  for k, v in pairs(head) do
    ngx.say("k=", k, ",v=", v)
  end
else
  ngx.say("head=")
end
ngx.say("head=2", ngx.header.content_type)
if head["user-agent"] then
  ngx.say("user-agent=", head["user-agent"])
end
