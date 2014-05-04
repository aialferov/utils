%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-lp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 06 Jun 2013 by Anton I Alferov <casper@ubca-lp>
%%%-------------------------------------------------------------------

-module(utils_email).

-export([local_part/1, domain/1]).
-export([normalize_address/1]).

-define(AddressRx, "^[A-Za-z0-9_%+.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$").
-define(AddressCharRx, "[A-Za-z0-9_%@+.-]").

local_part(Address) -> local_part(Address, []).
local_part([$@|_], Acc) -> lists:reverse(Acc);
local_part([H|T], Acc) -> local_part(T, [H|Acc]);
local_part([], Acc) -> lists:reverse(Acc).

domain([$@|T]) -> T;
domain([_|T]) -> domain(T);
domain([]) -> [].

normalize_address(Address) -> normalize_address(Address, []).
normalize_address([H|T], Acc) -> case re:run([H], ?AddressCharRx) of
	{match, _} -> normalize_address(T, [H|Acc]);
	nomatch -> normalize_address(T, Acc)
end;
normalize_address([], Acc) ->
	case re:run(Address = lists:reverse(Acc), ?AddressRx) of
		{match, _} -> {ok, Address}; nomatch -> {error, Address} end.
