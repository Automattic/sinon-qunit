BINPATH := ./node_modules/.bin
MODULEPATH := ./node_modules
LOGPATH := ./log
JSTESTDRIVER := java -jar $(MODULEPATH)/jstestdriver/lib/jstestdriver.jar

default: test lint build
build: lib/sinon-qunit.js
	./build
test: lib/sinon-qunit.js
	$(JSTESTDRIVER) --port 4224 & echo "$$!" > $(LOGPATH)/server.pid
	$(BINPATH)/phantomjs phantomjs-jstd.js & echo "$$!" > $(LOGPATH)/phantomjs.pid
	echo "Waiting for servers to start"
	`sleep 5`
	$(JSTESTDRIVER) --tests all --reset
	kill `cat $(LOGPATH)/phantomjs.pid`
	kill `cat $(LOGPATH)/server.pid`

clean:
	rm -fr pkg
lint:
	juicer verify {lib,test}/*.js
	jsl --conf jsl.conf lib/*.js test/*.js
