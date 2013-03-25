%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 26 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_lists).
-export([keyfind/2]).

keyfind(Key, List) -> case lists:keyfind(Key, 1, List) of
	{Key, Value} -> Value; false -> false end.
