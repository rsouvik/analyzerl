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



-module(aggregrator).
-compile(export_all).
-define(DEBUGFILE, "debug.txt").

% This is the aggregrator 
% Data is of the format: ["word",freq]
init(Data) -> 
  ["empty",erlang:list_to_integer(Data)].

terminate() -> 
  ok.

handle_event(Event, Data) ->
  {ok, Fdd} = file:open(?DEBUGFILE, [append]),
  io:fwrite(Fdd, "~p~n", ["Aggregrator: Event handling"]),
  io:fwrite(Fdd, "~p~n", [Event]),
  io:fwrite(Fdd, "~p~n", [Data]),
  file:close(Fdd),
  [Event, lists:nth(2,Data) + 1]. 

%Data is of the format [Word, Freq]
output(Data) ->
  {erlang:integer_to_list(random:uniform(3)),"wordfreqsort",Data}.
