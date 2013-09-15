%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 26 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_lists).

-export([keyfind/2, keyfind2/2]).
-export([to_lower/1]).

keyfind(Key, List) -> keyfind(v1, Key, List).
keyfind2(Key, List) -> keyfind(v2, Key, List).

keyfind(V, Key, List) -> case lists:keyfind(Key, 1, List) of
	{Key, Value} -> case V of v1 -> {ok, Value}; v2 -> Value end;
	false -> case V of v1 -> {error, not_found}; v2 -> false end
end.

to_lower(S) -> to_lower(S, []).
to_lower([208,X|T], Acc) when 160 == X -> to_lower(T, [X + 31,208|Acc]);
to_lower([208,X|T], Acc) when 129 == X -> to_lower(T, [X + 16,209|Acc]);
to_lower([208,X|T], Acc) when 159 == X -> to_lower(T, [X - 31,209|Acc]);
to_lower([208,X|T], Acc) when 144 =< X, X =< 158 ->
	to_lower(T, [X + 32,208|Acc]);
to_lower([208,X|T], Acc) when 159 =< X, X =< 175 ->
	to_lower(T, [X - 32,209|Acc]);
to_lower([H|T], Acc) -> to_lower(T, [H|Acc]);
to_lower([], Acc) -> lists:reverse(Acc).
