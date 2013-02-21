%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 30 Sep 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_crypto).
-export([generate_nonce/1]).

generate_nonce(Format) ->
	F = fun(X) -> hex(binary_to_list(crypto:rand_bytes(X))) end,
	lists:foldl(fun(X, []) -> F(X);
		(X, Acc) -> Acc ++ "-" ++ F(X) end, [], Format).

digit(N) when N < 10 -> $0 + N;
digit(N) -> $a + N - 10.

hex([H|T]) -> [digit(H bsr 4), digit(H band 16#f) | hex(T)];
hex([]) -> [].

