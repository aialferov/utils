%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 26 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_lists).

-export([keyfind/2, keyfind2/2]).
-export([to_lower/1, to_upper/1]).

keyfind(Key, List) -> keyfind(v1, Key, List).
keyfind2(Key, List) -> keyfind(v2, Key, List).

keyfind(V, Key, List) -> case lists:keyfind(Key, 1, List) of
	{Key, Value} -> case V of v1 -> {ok, Value}; v2 -> Value end;
	false -> case V of v1 -> {error, not_found}; v2 -> false end
end.

to_upper(S) -> to_upper(S, []).
to_upper([H1,H2|T], Acc) -> to_upper(T, case {H1,H2} of
	{209,145} -> [H2 - 16,208|Acc];
	{208,191} -> [H2 - 31,208|Acc]; 
	{209,128} -> [H2 + 31,208|Acc];
	{208,X} when 176 =< X, X =< 190 -> [X - 32,208|Acc];
	{209,X} when 129 =< X, X =< 143 -> [X + 32,208|Acc];
	_ -> [H2,H1|Acc]
end);
to_upper([H], Acc) -> lists:reverse([H|Acc]);
to_upper([], Acc) -> lists:reverse(Acc).

to_lower(S) -> to_lower(S, []).
to_lower([208,H|T], Acc) -> to_lower(T, case H of
	129 -> [H + 16,209|Acc];
	160 -> [H + 31,208|Acc];
	159 -> [H - 31,209|Acc];
	X when 144 =< X, X =< 158 -> [X + 32,208|Acc];
	X when 159 =< X, X =< 175 -> [X - 32,209|Acc];
	H -> [H,208|Acc]
end);
to_lower([H], Acc) -> lists:reverse([H|Acc]);
to_lower([H|T], Acc) -> to_lower(T, [H|Acc]);
to_lower([], Acc) -> lists:reverse(Acc).
