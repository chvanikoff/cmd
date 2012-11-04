all:
	./rebar compile

clean:
	./rebar clean

.PHONY: test

test:
	./rebar eunit

PLT_NAME=.cmd.plt

$(PLT_NAME):
	@ERL_LIBS=deps dialyzer --build_plt --output_plt $@ \
		--apps kernel stdlib crypto || true

dialyze: $(PLT_NAME)
	@dialyzer ebin --plt $(PLT_NAME) --no_native \
		-Werror_handling -Wunderspecs