%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 25 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_string).
-export([sub/3]).

sub(Str, Old, New) -> sub(Str, Old, New, string:str(Str, Old)).
sub(Str, _, _, 0) -> Str;
sub(Str, Old, New, I) ->
	NewStr = string:left(Str, I - 1) ++ New ++
		string:right(Str, string:len(Str) - I + 1 - string:len(Old)),
	sub(NewStr, Old, New, string:str(NewStr, Old)).
