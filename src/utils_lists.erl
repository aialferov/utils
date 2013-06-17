%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 26 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_lists).
-export([keyfind/2, keyfind2/2]).

keyfind(Key, List) -> keyfind(v1, Key, List).
keyfind2(Key, List) -> keyfind(v2, Key, List).

keyfind(V, Key, List) -> case lists:keyfind(Key, 1, List) of
	{Key, Value} -> case V of v1 -> {ok, Value}; v2 -> Value end;
	false -> case V of v1 -> {error, not_found}; v2 -> false end
end.

