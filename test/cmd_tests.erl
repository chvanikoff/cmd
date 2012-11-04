-module(cmd_tests).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).



cmd_test_() ->
	[
		?_assertEqual(
			"testing",
			cmd:run("echo testing")
		),
		?_assertEqual(
			<<"testing">>,
			cmd:run("echo testing", [{datatype, binary}])
		),
		?_assertEqual(
			[],
			cmd:run("echo")
		),
		?_assertEqual(
			<<>>,
			cmd:run("echo", [{datatype, binary}])
		),
		?_assertEqual(
			[],
			cmd:run("sleep 1", [{timeout, 2000}])
		)
	].

cmd2_test_() ->
	[
		?_assertThrow(
			{commandfailed, _},
			cmd:run("ls thisFileNotExists")
		),
		?_assertThrow(
			timeout,
			cmd:run("sleep 10", [{timeout, 20}])
		)
	].