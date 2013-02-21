-module(utils_http).
-export([read_query/1]).

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
