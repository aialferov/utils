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

-export([basic_auth_header/2]).

-export([b64_encode/1]).
-export([uri_encode/1, uri_decode/1]).

-export([secure_path/1]).

-define(BasicAuthHeader(Credentials),
	{"Authorization", "Basic " ++ Credentials}).

read_query(Query) -> read_query(Query, [], []).

read_query("=" ++ T, Item, Query) -> read_query(T, [], [Item|Query]);
read_query("&" ++ T, Item, Query) ->
	read_query(T, [], complete_query_item(Item, Query));
read_query([H|T], Item, Query) -> read_query(T, [H|Item], Query);
read_query([], [], []) -> [];
read_query([], Item, Query) ->
	lists:reverse(complete_query_item(Item, Query)).

complete_query_item(Item, [Field|Query]) ->
	[{lists:reverse(Field), uri_decode(lists:reverse(Item))}|Query].

query_string(Params) -> query_string(Params, no_encode).
query_string(Params, Encode) -> kv_string(Params, Encode, fun({K, V}, Acc) ->
	[Acc, case Acc of [] -> []; Acc -> "&" end, K, "=", V] end).

header_string(Params) -> header_string(Params, no_encode).
header_string(Params, Encode) -> kv_string(Params, Encode, fun({K, V}, Acc) ->
	[Acc, case Acc of [] -> []; Acc -> ", " end, K, "=", "\"", V, "\""] end).

kv_string(Params, Encode, Builder) -> lists:foldl(fun(Pair, Acc) ->
	lists:append(Builder(encode(Pair, Encode), Acc)) end, [], Params).

encode({K, V}, encode_key) -> {uri_encode(K), V};
encode({K, V}, encode_value) -> {K, uri_encode(V)};
encode({K, V}, encode) -> {uri_encode(K), uri_encode(V)};
encode(Pair, no_encode) -> Pair.

url(Url, Params) -> url(Url, Params, no_encode).
url(Url, [], _Encode) -> Url;
url(Url, Params, Encode) when is_atom(Encode) ->
	Url ++ "?" ++ utils_http:query_string(Params, Encode);
url(Url, Params, ParamString) -> url(Url, Params, ParamString, no_encode).
url(Url, Params, [], Encode) -> url(Url, Params, Encode);
url(Url, Params, ParamString, Encode) ->
	url(Url, Params, Encode) ++ "&" ++ ParamString.

basic_auth_header(UserID, Password) ->
	?BasicAuthHeader(base64:encode_to_string(UserID ++ ":" ++ Password)).

b64_encode(S) -> b64_encode(S, lists:reverse(S), []).
b64_encode(S, "=" ++ Rest, Acc) -> b64_encode(S, Rest, "%3D" ++ Acc);
b64_encode(S, _Rest, []) -> S;
b64_encode(_S, Rest, Acc) -> lists:reverse(Rest) ++ Acc.

uri_encode(S) -> uri_encode(http_uri:encode(S), []).
uri_encode("\r" ++ T, Acc) -> uri_encode(T, [$D,$0,$%|Acc]);
uri_encode("\n" ++ T, Acc) -> uri_encode(T, [$A,$0,$%|Acc]);
uri_encode([H|T], Acc) -> uri_encode(T, [H|Acc]);
uri_encode([], Acc) -> lists:reverse(Acc).

uri_decode(S) -> http_uri:decode(S).

secure_path(Path) -> secure_path(Path, []).
secure_path("../" ++ T, _Acc) -> secure_path(T, [$/]);
secure_path([H|T], Acc) -> secure_path(T, [H|Acc]);
secure_path([], Acc) -> lists:reverse(Acc).
