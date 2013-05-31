%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2012, Anton I Alferov
%%%
%%% Created : 30 Sep 2012 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(utils_sasl).

-export([plain_message/2]).
-export([digest_md5_response/5, digest_md5_response/6]).

-include("sasl.hrl").

-record(challenge, {realm = "", nonce = "",
	qop = "", charset = "", algorithm = "md-sess"}).

-define(CNonceFormat, [4, 2, 2, 2, 6]).

plain_message(AuthcID, Passwd) ->
	binary_to_list(base64:encode([0] ++ AuthcID ++ [0] ++ Passwd)).

digest_md5_response(UserName, Password, Host, Challenge, Config) ->
	digest_md5_response(UserName, Password, Host, "", Challenge, Config).

digest_md5_response(UserName, Password, Host, Service, Challenge, Config) ->
	Qop = Config#digest_md5_config.qop,
	Charset = Config#digest_md5_config.charset,
	ServType = Config#digest_md5_config.serv_type,
	response(UserName, Password, Host, Service, ServType,
		read_challenge(Challenge, Charset, Qop)).

response(UserName, Password, Host, Service, ServType, Challenge) ->
	Cnonce = generate_cnonce(),
	NonceCount = string:right(integer_to_list(1, 16), 8, $0),
	DigestUri = ServType ++ "/" ++ Host ++
		case Service of "" -> ""; Service -> "/" ++ Service end,

	binary_to_list(base64:encode(
		"charset=" ++ Challenge#challenge.charset ++ "," ++
		"username=\"" ++ UserName ++ "\"," ++
		"realm=\"" ++ Challenge#challenge.realm ++ "\"," ++
		"nonce=\"" ++ Challenge#challenge.nonce ++ "\"," ++
		"cnonce=\"" ++ Cnonce ++ "\"," ++
		"nc=" ++ NonceCount ++ "," ++
		"qop=" ++ Challenge#challenge.qop ++ "," ++
		"digest-uri=\"" ++ DigestUri ++ "\"," ++
		"response=" ++ response(UserName, Password,
			Challenge#challenge.realm, Challenge#challenge.nonce,
			Cnonce, NonceCount, Challenge#challenge.qop, DigestUri
		)
	)).

response(
	UserName, Password, Realm, Nonce,
	Cnonce, NonceCount, Qop, DigestUri
) ->
	A1 = h(UserName ++ ":" ++ Realm ++ ":" ++ Password) ++
		":" ++ Nonce ++ ":" ++ Cnonce,
	A2 = "AUTHENTICATE:" ++ DigestUri,
	hex(kd(hex(h(A1)), Nonce ++ ":" ++ NonceCount ++ ":" ++
		Cnonce ++ ":" ++ Qop ++ ":" ++ hex(h(A2)))).


read_challenge(Challenge, Charset, Qop) ->
	read_challenge(binary_to_list(base64:decode(Challenge)),
		#challenge{charset = Charset, qop = Qop}).

read_challenge("realm=\"" ++ T, R) -> gather(realm, T, R);
read_challenge("nonce=\"" ++ T, R) -> gather(nonce, T, R);
read_challenge("qop=\"" ++ T, R) -> gather(qop, T, R);
read_challenge("charset=" ++ T, R) -> gather(charset, T, R);
read_challenge("algorithm=" ++ T, R) -> gather(algorithm, T, R);
read_challenge([_|T], R) -> read_challenge(T, R);
read_challenge([], R) -> R.

gather(Name, T, R) ->
	{Value, T1} = gather_tail(T, []),
	read_challenge(T1, setelement(challenge_field_index(Name), R, Value)).

gather_tail("\"" ++ T, L) -> {lists:reverse(L), T};
gather_tail("," ++ T, L) -> {lists:reverse(L), T};
gather_tail([H|T], L) -> gather_tail(T, [H|L]);
gather_tail([], L) -> {lists:reverse(L), []}.

challenge_field_index(realm) -> #challenge.realm;
challenge_field_index(nonce) -> #challenge.nonce;
challenge_field_index(qop) -> #challenge.qop;
challenge_field_index(charset) -> #challenge.charset;
challenge_field_index(algorithm) -> #challenge.algorithm.

h(String) -> binary_to_list(crypto:md5(String)).
kd(HexK, HexD) -> h(HexK ++ ":" ++ HexD).

generate_cnonce() -> utils_crypto:generate_nonce(?CNonceFormat).
hex(L) -> utils_crypto:hex(L).
