%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 7 Dec 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_app).

-export([get_env/1]).
-export([get_key/1, get_all_key/1]).

-export([reload_configs/2]).

get_env(Pars) -> lists:flatten([fun() -> case application:get_env(Par) of
	{ok, Val} -> {Par, Val}; undefined -> [] end end() || Par <- Pars]).

get_key(Key) -> get_key(application:get_application(), {key, Key}).
get_key({ok, App}, {key, Key}) -> get_key(application:get_key(App, Key), ok);
get_key({ok, Value}, ok) -> Value;
get_key(undefined, _) -> [].

get_all_key(App) -> case application:get_all_key(App) of
	{ok, Keys} -> Keys; undefined -> [] end.

reload_configs(Apps, Configs) ->
	Env = application_controller:prep_config_change(),
	application_controller:change_application_data(
		[{application, App, get_all_key(App)} || App <- Apps], Configs),
	application_controller:config_change(Env).
