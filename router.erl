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
%%% Revision 0.1 Author: Souvik Ray (rsouvik@gmail.com)
%%%--------------------------------------------------------------------- 



-module(router).
-compile(export_all).

%This is the handler for routing of traffic by network Manager 

init(Data) -> 
  Data.

terminate() -> 
  ok.

next_hop(Event) ->
 ok.

handle_event(Event, Data) ->
  Data + 1. 

%output stream name and data
%{event-type, event-key, data}
output(Data) ->
  {"wordfreqsort",1,Data}.
