%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 26 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_lists).

-export([keyfind/2, value/2, value/3]).
-export([to_lower/1, to_upper/1]).

keyfind(Key, List) -> case lists:keyfind(Key, 1, List) of
	{Key, Value} -> {ok, Value}; false -> {error, not_found} end.

value(Key, List) -> value(Key, List, false).
value(Key, List, MfaOrFun) -> case lists:keyfind(Key, 1, List) of
	{Key, Value} -> Value; false -> value(MfaOrFun) end.

value({F, A}) -> apply(F, A);
value({M, F, A}) -> apply(M, F, A);
value(F) when is_function(F) -> F();
value(_) -> false.

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
