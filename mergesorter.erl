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



-module(mergesorter).
-compile(export_all).

% This is the aggregrator 

init(Data) -> 
  %Data.
  [{"empty",0}].

terminate() -> 
  ok.

%Each time a new partially sorted list comes in, it is mergesorted with the 
%existing list and topN list is stored
handle_event(EventData, Data) ->
  DataPruned = lists:reverse(lists:keysort(2,utils:pruneList(EventData,Data))),
  if
    length(DataPruned)==0 ->
        NewData = lists:reverse(lists:keysort(2, EventData));
    true -> 
  %NewData = lists:sublist(utils:mergesort(EventData, Data),1,10),
        NewData = lists:sublist(utils:mergesort(EventData, DataPruned),1,10)
  end,
  NewData.  

%Whenever output is called, sort the Data dict and output partial sorted list
%serialization/deserialization required ?
output(Data) ->
  %{lists:sublist(Data,1,10)}.
   {Data}.

printState(Data) ->
 "".
