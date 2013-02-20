%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2012, Anton I Alferov
%%%
%%% Created : 22 Aug 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-record(result, {id, data}).
-record(error, {id, reason, data}).
-record(function, {id, name, args}).
-record(placeholder, {id}).
