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



-module(networkManager).
-compile(export_all).
-define(DEBUGFILE, "debug.txt").

startOnNode() ->
  start("node3@rsouvik-desktop").

startNow() ->
  {ok, Fd} = file:open("cluster.txt",[read]),
  Nodes = loopInitializeCluster(Fd, 0, []),
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [write]),
  io:fwrite(Fdd, "~p~n", ["debug mode"]),
  file:close(Fdd),
  %end debug
  start(lists:nth(random:uniform(length(Nodes)),Nodes)).

start(Node) -> 
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p", ["Nw Manager intialized on node: "]),
  io:fwrite(Fdd, "~p~n", [Node]),
  file:close(Fdd),
  global:register_name(networkManager, spawn(erlang:list_to_atom(Node), networkManager, init, [["cluster.txt","config.txt"]])).
  %global:register_name(networkManager, spawn(erlang:list_to_atom(Node), networkManager, init, [])).

init() -> 
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["init"]),
  file:close(Fdd).

% spawn aggregator processes
init(ConfigFiles) -> 
%  {ok, Fd} = file:open("/home/rsouvik/Erlang/cluster.txt", [read]),
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["networkManager initialized"]),
  file:close(Fdd),
  %end debug
  {ok, Fd} = file:open(lists:nth(1,ConfigFiles), [read]),
  io:format("~w~n",[Fd]),
  %AggregratorNodes = [],
  AggregratorNodes = loopInitializeCluster(Fd, 0, []),
  %io:format("~p~n",[AggregratorNodes]),
  io:fwrite("~p~n",[AggregratorNodes]),
  {ok, Fdh} = file:open(lists:nth(2,ConfigFiles), [read]),
  Dict = dict:new(),
  NewDict = loopInitializeHandlerMapping(Fdh, Dict),
  loop(AggregratorNodes, NewDict).

% use a include file .hrl
loopInitializeCluster(Fd, Count, Acc) ->
  case io:get_line(Fd, "") of 
    {error, Reason} -> {error, Reason};
    eof -> file:close(Fd),
           Acc;
    Line -> %io:format("~p~n",[Line]),
            loopInitializeCluster(Fd, Count + 1, [string:strip(Line, right, $\n) | Acc])  
  end.

%Keeps on listening to routing events and routes using 
%appropriate routing protocol
loop(AggregratorNodes, Dict) ->
  %Debug
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["networkManager Waiting for events"]),
  file:close(Fdd),
  %end debug
  receive 
  {EventKey, EventType, EventData, Pid} ->
   %Debug
   {ok, Fd} = file:open(?DEBUGFILE, [append]),
   io:fwrite(Fd, "~p~n", ["Network Manager: Event Received"]),
   file:close(Fd),
   %end debug
     Reply = distribute(EventKey, EventType, EventData, AggregratorNodes, Dict),
     reply(Pid, Reply),
     loop(AggregratorNodes, Dict); 
   {request, Pid, stop} ->
      reply(Pid, ok)
  end. 

%Stores the handler mapping in a hashmap
loopInitializeHandlerMapping(Fd, Dict) ->
  case io:get_line(Fd, "") of 
    {error, Reason} -> {error, Reason};
    eof -> file:close(Fd),
           Dict;
    Line -> %io:format("~p~n",[Line]),
            Tokens = string:tokens(string:strip(Line, right, $\n), "\t"),
            HandlerStr = string:strip(lists:nth(2,Tokens), both, $;),
            HandlerTokens = string:tokens(HandlerStr, ","),
            %NewDict = dict:store(lists:nth(1,Tokens), lists:nth(2,Tokens), Dict),
            NewDict = dict:store(lists:nth(1,Tokens), HandlerTokens, Dict),
            loopInitializeHandlerMapping(Fd, NewDict)  
  end.

%Distribute the message to the appropriate aggregrator node
%check if event node already exists
%if not, spawn a new event node or hash node for DHT
%route the event to the appropriate DHT/hash node
%if Word is not present, spawn a new process which handles the Word freq
%The routing protocol must be made generic
distribute(EventKey, EventType, EventData, AggregratorNodes, Dict) ->
  io:format("~p~n",[length(AggregratorNodes)]),
  Index = erlang:phash2(EventKey) rem length(AggregratorNodes) + 1,
  AggNode = lists:nth(Index, AggregratorNodes),
  io:format("~p~n",[AggNode]),
  io:format("~p~n",[EventKey]),
  io:format("~p~n",[EventData]),
  case global:whereis_name(EventKey) of
     undefined ->   
     %spawn the processor on a randomly selected node
     %global:register_name(erlang:list_to_atom(Event), spawn(erlang:list_to_atom(AggNode), aggregrator, loop, [0])),
     %HandlerList is read from conf file
     %Debug
     {ok, Fdd} = file:open(?DEBUGFILE, [append]),
     io:fwrite(Fdd, "~p~n", ["networkManager: before dict"]),
     file:close(Fdd),
     %end debug
     {ok, Value} = dict:find(EventType, Dict),
     %Debug
     {ok, Fd} = file:open(?DEBUGFILE, [append]),
     io:fwrite(Fd, "~p~n", ["networkManager: after dict"]),
     io:fwrite(Fd, "~p~n", [Value]),
     file:close(Fd),
     %end debug
     %format: EventKey, AggNode, [{handler,initData}]
     computeElement:start(EventKey, AggNode, [{erlang:list_to_atom(lists:nth(1,Value)),lists:nth(2,Value)}]),
     %Debug
     {ok, Fdn} = file:open(?DEBUGFILE, [append]),
     io:fwrite(Fdn, "~p~n", ["networkManager: after compute element started"]),
     file:close(Fdn),
     %end debug
     % sleep for few seconds
     timer:sleep(1000),
     %global:send(erlang:list_to_atom(Event), {request, self(), Event});
     computeElement:send(erlang:list_to_atom(EventKey), EventData),
     %Debug
     {ok, Fdnn} = file:open(?DEBUGFILE, [append]),
     io:fwrite(Fdnn, "~p~n", ["networkManager: event sent to compute element"]),
     file:close(Fdnn);
     %end debug
     Pid -> 
       Pid ! {request, self(), EventData}  
  end.

% client functions
route(EventKey, EventType, EventData, Pid) -> 
  global:send(networkManager, {EventKey, EventType, EventData, Pid}).
%  receive
%     {reply, Reply} -> Reply
%  end.

reply(To, Msg) ->
  To ! {reply, Msg}.

stop() ->
  global:send(networkManager, {request, self(), stop}),
  receive {reply, Reply} -> Reply end.
