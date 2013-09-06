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

-define(Result(Data), [#result{data = Data}|_]).
-define(Result(ID, Data), #result{id = ID, data = Data}).

-define(Error(Reason), [#error{reason = Reason}|_]).
-define(Error(ID, Reason, Data),
	#error{id = ID, reason = Reason, data = Data}).

-define(Function(ID, Name, Args),
	#function{id = ID, name = Name, args = Args}).

-define(Placeholder(ID), #placeholder{id = ID}).
