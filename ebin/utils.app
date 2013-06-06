%%%-------------------------------------------------------------------
%%% Created: 21 Dec 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

{application, utils, [
	{id, "utils"},
	{vsn, "0.0.1"},
	{description, "Functions of common use"},
	{modules, [
		utils_app,
		utils_bench,
		utils_crypto,
		utils_email,
		utils_file,
		utils_http,
		utils_lists,
		utils_monad,
		utils_string,
		utils_test
	]},
	{registered, []},
	{applications, [kernel, stdlib]}
]}.
