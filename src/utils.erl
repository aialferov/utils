%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2012, Anton I Alferov
%%%
%%% Created : 22 Aug 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils).

-export([perform/1]).
-export([filepath/2]).

-include("utils").

perform(Funs) ->
	MapArgs = fun(Args, Results) -> lists:map(
		fun (#placeholder{id = ID}) ->
				(lists:keyfind(ID, 2, Results))#result.data;
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

filepath(FileName, Module) -> case filename:pathtype(FileName) of
	absolute -> FileName;
	relative -> filename:dirname(code:which(Module)) ++ "/" ++ FileName
end.
