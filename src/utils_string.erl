%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 25 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_string).

-export([read_word/1]).
-export([sub/3]).

read_word(String) -> read_word(String, []).
read_word(" " ++ T, Word) -> read_word(sep, T, Word);
read_word("\n" ++ T, Word) -> read_word(sep, T, Word);
read_word("\r" ++ T, Word) -> read_word(sep, T, Word);
read_word([H|T], Word) -> read_word(T, [H|Word]);
read_word([], Word) -> {lists:reverse(Word), []}.
read_word(sep, T, []) -> read_word(T, []);
read_word(sep, T, Word) -> {lists:reverse(Word), T}.

sub(Str, Old, New) -> sub(Str, Old, New, string:str(Str, Old)).
sub(Str, _, _, 0) -> Str;
sub(Str, Old, New, I) ->
	NewStr = string:left(Str, I - 1) ++ New ++
		string:right(Str, string:len(Str) - I + 1 - string:len(Old)),
	sub(NewStr, Old, New, string:str(NewStr, Old)).
