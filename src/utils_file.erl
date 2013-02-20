-module(utils_file).
-export([path/2]).

path(FileName, Module) -> case filename:pathtype(FileName) of
	absolute -> FileName;
	relative -> filename:join(filename:dirname(code:which(Module)), FileName)
end.
