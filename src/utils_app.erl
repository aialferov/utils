-module(utils_app).
-export([get_env/1, get_key/1]).

get_env(Pars) -> lists:flatten([fun() -> case application:get_env(Par) of
	{ok, Val} -> {Par, Val}; undefined -> [] end end() || Par <- Pars]).

get_key(Key) -> get_key(application:get_application(), {key, Key}).
get_key({ok, Application}, {key, Key}) ->
	get_key(application:get_key(Application, Key), ok);
get_key({ok, Value}, ok) -> Value;
get_key(undefined, _) -> [].
