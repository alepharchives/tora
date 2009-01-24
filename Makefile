APP_NAME="merle"
VSN="0.1"

all: compile

docs: 
	erl -noshell -run edoc_run application "'$(APP_NAME)'" '"."' '$(VSN)'

compile: clean
	erlc -o ebin/ src/*.erl

clean:
	rm -rfv ebin/*.beam

# Testing with a Tokyo Tyrant server instance
test: clean ttclean ttstartd runtest ttstopd
runtest:
	erlc -DTEST -I test/ -o ebin/ src/tora.erl
	erl -pa ebin/ -noshell -s tora test -s init stop
ttclean:
	rm -f /tmp/ttserver.pid /tmp/ttserver.tcb
ttstartd:
	ttserver -dmn -pid /tmp/ttserver.pid /tmp/ttserver.tcb
ttstopd:
	kill -TERM `cat /tmp/ttserver.pid`
ttstart:
	ttserver /tmp/ttserver.tcb
