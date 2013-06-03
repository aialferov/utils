%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 03 Jun 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_test).
-export([xdg_open/1]).

xdg_open(Param) -> os:cmd("xdg-open \"" ++ Param ++ "\"").
