%%%----------------------------------------------------
%%% Copyright AnalyzERL 2011
%%% All rights reserved. No part of this computer programs(s) may be 
%%% used, reproduced,stored in any retrieval system, or transmitted,
%%% in any form or by any means, electronic, mechanical, photocopying,
%%% recording, or otherwise without prior written permission of 
%%% the authors
%%%--------------------------------------------------------------------- 

%%%--------------------------------------------------------------------- 
%%% Revision History
%%%--------------------------------------------------------------------- 
%%% Revision 1.0 Author: Souvik Ray (rsouvik@gmail.com)
%%%--------------------------------------------------------------------- 



-module(eventManager).
-compile(export_all).
-define(DEBUGFILE, "debug.txt").

startOnNode() ->
  start("networkMonitor@rsouvik-desktop", [{logger, "logger.txt" }]).

startNow() ->
  {ok, Fd} = file:open("cluster.txt",[read]),
  Nodes = loopInitializeCluster(Fd, 0, []),
  start(lists:nth(random:uniform(length(Nodes)),Nodes), [{logger, "logger.txt" }]).

%Wrapper script starts the eventManager on a randomly selected cluster host
%Handler => logger etc.
start(Node, HandlerList) -> 
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p", ["Event Manager intialized on node: "]),
  io:fwrite(Fdd, "~p~n", [Node]),
  file:close(Fdd),
  global:register_name(eventManager, spawn(erlang:list_to_atom(Node), eventManager, init, [HandlerList])).

init(HandlerList) ->
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["eventManager"]),
  file:close(Fdd),
  %end debug
  loop(initialize(HandlerList)).

initialize([]) -> [];
initialize([{Handler, InitData}|Rest]) ->
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["eventManager souvik"]),
  file:close(Fdd),
  %end debug
[{Handler, Handler:init(InitData)}|initialize(Rest)].
  %end debug

loopInitializeCluster(Fd, Count, Acc) ->
  case io:get_line(Fd, "") of 
    {error, Reason} -> {error, Reason};
    eof -> file:close(Fd),
           Acc;
    Line -> %io:format("~p~n",[Line]),
            loopInitializeCluster(Fd, Count + 1, [string:strip(Line, right, $\n) | Acc])  
  end.

%Message Loop
loop(State) ->
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["Waiting for events in eventManager"]),
  file:close(Fdd),
  %end debug
  receive 
   {EventType, EventKey, EventData, Pid} -> 
   %Debug
   {ok, Fd} = file:open(?DEBUGFILE, [append]),
   io:fwrite(Fd, "~p~n", ["EventManager: Event Received"]),
   file:close(Fd),
   %end debug
     networkManager:route(EventKey, EventType, EventData, Pid),
     %Reply = networkManager:route(EventKey, EventType, EventData, Pid),
     %reply(Pid, Reply),
     %{Reply, NewState} = handle_msg(EventData, State),
     %loop(NewState); 
     loop(State); 
   {request, Pid, stop} ->
      reply(Pid, ok)
  end.

%client functions 

reply(To, Msg) ->
  To ! {reply, Msg}.

stop(Name) ->
  Name ! {stop, self()},
  receive {reply, Reply} -> Reply end.

terminate([]) -> [];
terminate([{Handler, Data}|Rest]) ->
  [{Handler, Handler:terminate(Data)}|terminate(Rest)].

handle_msg(Event, LoopData) ->
  {ok, event(Event, LoopData)}.

event(_Event, []) -> [];
event(Event, [{Handler, Data}|Rest]) ->
  [{Handler, Handler:handle_event(Event, Data)}|event(Event, Rest)].
