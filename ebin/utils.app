%%%-------------------------------------------------------------------
%%% Created: 21 Dec 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

{application, utils, [
	{id, "utils"},
	{vsn, "0.0.1"},
	{description, "Utils."},
	{modules, [
		utils_app,
		utils_bench,
		utils_crypto,
		utils_file,
		utils_http,
		utils_monad
	]},
	{registered, []},
	{applications, [kernel, stdlib]}
]}.
