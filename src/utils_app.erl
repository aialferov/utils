-module(utils_app).
-export([get_env/1]).

get_env(Pars) -> lists:flatten([fun() -> case application:get_env(Par) of
	{ok, Val} -> {Par, Val}; undefined -> [] end end() || Par <- Pars]).
