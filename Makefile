PWD_DIR := $(shell pwd)

rst:
	- test -f logs/nginx.pid && kill -HUP `cat logs/nginx.pid`

st: dn
	SERVICE_LUA_FILE=unittest/upstreamnginx/lua nginx -p $(PWD_DIR)/ -c conf/nginx.conf

dn:
	- test -f logs/nginx.pid && kill -QUIT `cat logs/nginx.pid`

start_pseudo_backend: stop_pseudo_backend
	- test -d unittest/upstreamnginx/logs || mkdir -p unittest/upstreamnginx/logs
	cd unittest/upstreamnginx; nginx -p $(PWD_DIR)/unittest/upstreamnginx/ -c conf/nginx.conf

stop_pseudo_backend:
	- test -f unittest/upstreamnginx/logs/nginx.pid && kill -QUIT `cat unittest/upstreamnginx/logs/nginx.pid`

# I have to kill nginx here, for stop_pseudo_backend has been run for start_pseudo_backend
run_prove:
	- cd unittest && SERVICE_LUA_FILE=lua prove -rv t
	- test -f unittest/upstreamnginx/logs/nginx.pid && kill -QUIT `cat unittest/upstreamnginx/logs/nginx.pid`


test: st
	busted -v unittest/spec/
	#- test -f logs/nginx.pid && kill -QUIT `cat logs/nginx.pid`

ptest: start_pseudo_backend run_prove stop_pseudo_backend

tmp:
	test -e abc && NGINX_PID=`cat abc` && echo $$NGINX_PID
	@echo $$NGINX_PID

ps:
	#ps -ef | grep "nginx: "
	ps auxw |head -n 1; ps auxw| grep nginx


.PHONY:rst st shut test start_pseudo_backend run_prove stop_pseudo_backend
