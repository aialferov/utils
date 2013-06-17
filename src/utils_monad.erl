%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2012, Anton I Alferov
%%%
%%% Created : 22 Aug 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_monad).
-export([do/1, do_simple/1]).

-include("utils_monad.hrl").

do(Funs) ->
	MapArgs = fun(Args, Results) -> lists:map(
		fun (#placeholder{id = ID}) ->
				(lists:keyfind(ID, #result.id, Results))#result.data;
			(Other) -> Other
		end, Args
	) end,
	MakeResult = fun(ID, Fun, Args) ->
		fun (ok) -> #result{id = ID};
			({ok, Result}) -> #result{id = ID, data = Result};
			({error, Reason}) -> #error{id = ID, reason = Reason, data = Args}
		end (apply(Fun, Args))
	end,
	MakeResults = fun
		(Fun = #function{}, [#result{}|_] = Results) ->
			[MakeResult(Fun#function.id, Fun#function.name,
				MapArgs(Fun#function.args, Results))|Results];
		(_Fun, Result) -> Result
	end,
	lists:foldl(MakeResults, [#result{}], Funs).

do_simple(Funs) -> lists:foldl(fun
	(Fun, ok) -> Fun();
	(_Fun, {error, Reason}) -> {error, Reason}
end, ok, Funs).
