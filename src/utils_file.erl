%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 21 Nov 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_file).
-export([path/2]).

path(FileName, Module) -> case filename:pathtype(FileName) of
	absolute -> FileName;
	relative -> filename:join(filename:dirname(code:which(Module)), FileName)
end.
