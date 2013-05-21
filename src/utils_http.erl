%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 21 Oct 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_http).

-export([url/2, url/3, url/4]).
-export([read_query/1]).
-export([header_string/1, header_string/2, query_string/1, query_string/2]).

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

query_string(Params) -> query_string(Params, no_encode).
query_string(Params, Encode) -> kv_string(Params, Encode, fun({K, V}, Acc) ->
	[Acc, case Acc of [] -> []; Acc -> "&" end, K, "=", V] end).

header_string(Params) -> header_string(Params, no_encode).
header_string(Params, Encode) -> kv_string(Params, Encode, fun({K, V}, Acc) ->
	[Acc, case Acc of [] -> []; Acc -> ", " end, K, "=", "\"", V, "\""] end).

kv_string(Params, Encode, Builder) -> lists:foldl(fun(Pair, Acc) ->
	lists:append(Builder(encode(Pair, Encode), Acc)) end, [], Params).

encode({K, V}, encode_key) -> {http_uri:encode(K), V};
encode({K, V}, encode_value) -> {K, http_uri:encode(V)};
encode({K, V}, encode) -> {http_uri:encode(K), http_uri:encode(V)};
encode(Pair, no_encode) -> Pair.

url(Url, Params) -> url(Url, Params, no_encode).
url(Url, [], _Encode) -> Url;
url(Url, Params, Encode) when is_atom(Encode) ->
	Url ++ "?" ++ utils_http:query_string(Params, Encode);
url(Url, Params, ParamString) -> url(Url, Params, ParamString, no_encode).
url(Url, Params, [], Encode) -> url(Url, Params, Encode);
url(Url, Params, ParamString, Encode) ->
	url(Url, Params, Encode) ++ "&" ++ ParamString.
