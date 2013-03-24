%%%-------------------------------------------------------------------
%%% Created: 25 Mar 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils).
-export([start/0, stop/0]).

start() -> application:start(?MODULE).
stop() -> application:stop(?MODULE).
