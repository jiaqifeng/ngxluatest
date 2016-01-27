use Test::Nginx::Socket;
use Cwd qw(cwd);

#below should be all tests runned, change it to excat test numbers
plan tests => repeat_each() * blocks() * 2;

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "../lua/?.lua;/usr/local/share/lua/5.1/resty/?.lua;$pwd/lua/?.lua;;";
    lua_shared_dict license_pay_cache 3m;
    error_log logs/error.agent.do.log info;
    upstream dcfree {
        server localhost:8280;
        server localhost:8281;
        server localhost:8282;
        server localhost:8283;
        server localhost:8284;
    }
    upstream dcpaid {
        server localhost:8290;
        server localhost:8291;
    }
};

run_tests();

__DATA__

=== TEST 1: paid2
--- http_config eval: $::HttpConfig
--- config
    location /tpm/agent.do {
            lua_code_cache off;
            set $backend_url "dcfree";
            access_by_lua_file ../../../lua/userdispatch.lua;
            proxy_pass http://$backend_url;
    }
--- request
    GET /tpm/agent.do?license_key=10haQQpYHlfd44tDCQkVBANUf425AlNcAAxWDA6ee9oGAUlUDQQH57d7UwFeXAQMXgcF
--- response_body_like
paid server at .*
--- error_code: 200

=== TEST 2: free
--- http_config eval: $::HttpConfig
--- config
    location /tpm/agent.do {
            lua_code_cache off;
            set $backend_url "dcfree";
            access_by_lua_file ../../../lua/userdispatch.lua;
            proxy_pass http://$backend_url;
    }
--- request
    GET /tpm/agent.do?license_key=X0haQQpYHlfd44tDCQkVBANUf425AlNcAAxWDA6ee9oGAUlUDQQH57d7UwFeXAQMXgcF
--- response_body_like
free server at .*
--- error_code: 200
