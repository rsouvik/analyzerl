-module(driver).
-compile(export_all).
-define(DEBUGFILE, "debug.txt").

% driver provides the glue for events generated by user and event manager

%serializing, deserializing
send(EventType, EventKey, EventData, Pid) ->
   Reply = global:send(eventManager, {EventType, EventKey, EventData, Pid}),
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p", ["Reply received: "]),
  io:fwrite(Fdd, "~p~n", [Reply]),
  file:close(Fdd).
  %end debug
  % io:format("~p~n",[Reply]).
