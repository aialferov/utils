%%%-------------------------------------------------------------------
%%% Created: 21 Dec 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

{application, utils, [
	{id, "utils"},
	{vsn, "0.0.1"},
	{description, "Functions of common use"},
	{modules, [
		utils,
		utils_app,
		utils_file,
		utils_http,
		utils_sasl,
		utils_test,
		utils_bench,
		utils_email,
		utils_lists,
		utils_monad,
		utils_crypto,
		utils_string
	]},
	{applications, [kernel, stdlib]}
]}.
