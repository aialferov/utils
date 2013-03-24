%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2012, Anton I Alferov
%%%
%%% Created: 28 Nov 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_bench).
-export([start/3]).

%% C - Concurrency, N - Request number

start(Fun, C, N) ->
	{Time, _} = timer:tc(fun() -> run(Fun, C, N) end),
	io:format("~p sec.~n", [Time/1000000]).

run(Fun, C, N) ->
	F = fun() ->
		Pid = spawn(fun() -> run(Fun, trunc(N/C)) end),
		monitor(process, Pid), Pid
	end,
	wait([F() || _ <- lists:seq(1, C)]).

wait([]) -> ok;
wait(L) -> receive
	{'DOWN', _MonitorRef, process, Pid, normal} ->
		wait(lists:delete(Pid, L))
end.

run(_, 0) -> ok;
run(Fun, N) -> Fun(), run(Fun, N - 1).
