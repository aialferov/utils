%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 29 Jun 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_tree).
-export([leaf/2]).

leaf(Path, Tree) -> lists:foldl(fun
	(Node, {ok, RestTree}) -> utils_lists:keyfind(Node, RestTree);
	(_, Error) -> Error
end, {ok, Tree}, Path).
