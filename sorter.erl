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



-module(sorter).
-compile(export_all).
-define(DEBUGFILE, "debug.txt").

% This is the aggregrator 

init(Data) -> 
  Dict = dict:new(),
  Dict.

terminate() -> 
  ok.

%Data is the data structure which stores the list [{Event1, Freq1}, {Event, Freq2}....]
%We use a dict
%EventData is of the format: [Word, Freq]
handle_event(EventData, Data) ->
  NewData = dict:store(lists:nth(1, EventData), lists:nth(2, EventData), Data),
  NewData.  

%Whenever output is called, sort the Data dict and output partial sorted list
%serialization/deserialization required ?
output(Data) ->
  %turn dict to a list of tuples
  TupleList = dict:to_list(Data),
  OutputData = lists:reverse(lists:keysort(2, TupleList)),
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["Output from sorter: "]),
  io:fwrite(Fdd, "~p~n", [OutputData]),
  file:close(Fdd),
  {"123","wordfreqmergesort",OutputData}.
