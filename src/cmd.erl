-module(cmd).

-author('Chvanikoff <chvanikoff@gmail.com>').

-export([run/1, run/2]).

-define(TIMEOUT, 5000).
-define(DATATYPE, list).

run(Cmd) ->
	run(Cmd, []).

run(Cmd, Options) ->
	run(Cmd, proplists:get_value(timeout, Options, ?TIMEOUT), proplists:get_value(datatype, Options, ?DATATYPE)).

run(Cmd, Timeout, binary) ->
	Port = erlang:open_port({spawn, Cmd}, [exit_status, binary]),
	loop(Port, <<>>, Timeout, binary);

run(Cmd, Timeout, list) ->
	Port = erlang:open_port({spawn, Cmd}, [exit_status]),
	loop(Port, [], Timeout, list).

loop(Port, Data, Timeout, binary) ->
	receive
		{Port, {data, NewData}} ->
			loop(Port, <<Data/binary, NewData/binary>>, Timeout, binary);
		{Port, {exit_status, 0}} ->
			cut_nl(Data);
		{Port, {exit_status, S}} ->
			throw({commandfailed, S})
	after Timeout ->
		throw(timeout)
	end;

loop(Port, Data, Timeout, list) ->
	receive
		{Port, {data, NewData}} ->
			loop(Port, [NewData | Data], Timeout, list);
		{Port, {exit_status, 0}} ->
			cut_nl(lists:flatten(lists:reverse(Data)));
		{Port, {exit_status, S}} ->
			throw({commandfailed, S})
	after Timeout ->
		throw(timeout)
	end.

cut_nl(<<>>) ->
	<<>>;
cut_nl([]) ->
	[];
cut_nl(Str) when is_binary(Str) ->
	%% a binary field without size is only allowed at the end of a binary pattern
	%% what a crap =(
	Skip = byte_size(Str) -1,
	<<H:Skip/binary, T:1/binary>> = Str,
	cut_nl(H, T);
cut_nl(Str) when is_list(Str) ->
	[H | T] = lists:reverse(Str),
	cut_nl(T, H).

cut_nl(Str, $\n) when is_list(Str) ->
	cut_nl(Str);
cut_nl(Str, <<"\n">>) when is_binary(Str) ->
	cut_nl(Str);
cut_nl(Str, T) when is_binary(Str) ->
	<<Str/binary, T/binary>>;
cut_nl(Str, T) when is_list(Str) ->
	[T | Str].