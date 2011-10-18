-module(generator).
-compile(export_all).
-define(EVENTS,20).
-define(DEBUGFILE, "debug.txt").

% Reads words from a file and then randomly emits it
start() -> 
  %global:register_name(generator, spawn(erlang:list_to_atom("node1@rsouvik-desktop"), generator, init, ["events.txt"])).
  global:register_name(generator, spawn(erlang:list_to_atom("eventMonitor@rsouvik-desktop"), generator, init, ["events.txt"])).
  %register(generator, spawn(generator, init, ["events.txt"])).

init(File) -> 
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["Generator initialized"]),
  file:close(Fdd),
  %end debug
  {ok, Fd} = file:open(File, [read]),
  Words = loopInitializeWords(Fd, 0, []),
  io:format("~p~n",[Words]),
  Resp = loop(Words,0).

loopInitializeWords(Fd, Count, Acc) ->
  case io:get_line(Fd, "") of 
    {error, Reason} -> {error, Reason};
    eof -> file:close(Fd),
           Acc;
    Line -> %io:format("~p~n",[Line]),
            loopInitializeWords(Fd, Count + 1, [string:strip(Line, right, $\n) | Acc])  
  end.

loop(Words, Cnt) ->
  if 
    Cnt < ?EVENTS -> 
      Index = random:uniform(length(Words)),
      Word = lists:nth(Index, Words),
      Response = timer:sleep(1000),
%      global:send(networkScheduler, {wordfreq, self(), Word}),
      %use erlang list_to_atom in actual client code
      driver:send("wordfreq", Word, Word, self()),
      %Debug
      {ok, Fdd} = file:open(?DEBUGFILE, [append]),
      io:fwrite(Fdd, "~p~n", ["Event sent"]),
      file:close(Fdd),
      %end debug
      UpCnt = Cnt+1,
      loop(Words, UpCnt); 
    true -> ok
  end.
