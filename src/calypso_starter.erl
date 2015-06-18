-module(calypso_starter).
-author("begemot").

%% API
-export([
  start/1,
  empty_loop/1
]).

start(Application) when is_atom(Application) ->
  case application:start(Application) of
    {error,{not_started,App}} ->
      start(App),
      start(Application);
    ok -> ok;
    {error,{not_loaded, App}} ->
      error_logger:error_msg("Application ~p cannot be started", [ App ]),
      timer:sleep(100),
      error({not_loaded, App}, [ Application ]);
    {error,{already_started,App}} when App =:= Application ->
      ok
  end.

empty_loop(Fun) ->
  Fun(),
  (fun F() ->
    receive
      _ -> F()
    end
  end)().