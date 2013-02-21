%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 21 Oct 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_http).

-export([read_query/1]).
-export([header_string/1, query_string/1]).

read_query(Query) -> read_query(Query, [], []).

read_query("=" ++ T, Item, Query) -> read_query(T, [], [Item|Query]);
read_query("&" ++ T, Item, Query) ->
	read_query(T, [], complete_query_item(Item, Query));
read_query([H|T], Item, Query) -> read_query(T, [H|Item], Query);
read_query([], [], []) -> [];
read_query([], Item, Query) ->
	lists:reverse(complete_query_item(Item, Query)).

complete_query_item(Item, [Field|Query]) ->
	[{lists:reverse(Field), http_uri:decode(lists:reverse(Item))}|Query].

query_string(Params) -> kv_string(Params, fun(K, V, Acc) ->
	[Acc, case Acc of [] -> []; Acc -> "&" end, K, "=", V] end).

header_string(Params) -> kv_string(Params, fun(K, V, Acc) ->
	[Acc, case Acc of [] -> []; Acc -> ", " end, K, "=", "\"", V, "\""] end).

kv_string(Params, Builder) -> lists:foldl(fun({K, V}, Acc) ->
	lists:append(Builder(K, V, Acc)) end, [], Params).
