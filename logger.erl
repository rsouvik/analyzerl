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



-module(logger).
-compile(export_all).

init(File) -> 
  {ok, Fd} = file:open(File, write),
  Fd.

terminate(Fd) -> file:close(Fd).

handle_event(Event, Fd) -> 
 {MegaSec, Sec, MicroSec} = now(),
 Args = io:format(Fd, "~w,~w,~w,~p~n",
	           [MegaSec, Sec, MicroSec, Event]),
 Fd;
handle_event(_, Fd) -> 
 Fd.
