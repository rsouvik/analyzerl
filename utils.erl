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

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Util functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(utils).
-compile(export_all).

mergesort(X,Y) ->
   C = lists:merge(fun(A,B) -> 
                    {A1, A2} = A,
                    {B1, B2} = B,
                    if
                      A2 >= B2 -> 
                        true;
                      true -> 
                        false 
                    end
                  end, X, Y),
   C.

prune(DictA,D,DictB,N,Size) ->
  case dict:is_key(lists:nth(N,D),DictA) of
     true -> 
      DictBNew = dict:erase(lists:nth(N,D), DictB); 
     false ->
      DictBNew = DictB 
  end,
  if 
    N==Size -> 
        DictBNew;
    true  ->
        prune(DictA,D,DictBNew, N+1, Size)
  end.

pruneList(X,Y) -> 

  DictA = dict:from_list(X),
  DictB = dict:from_list(Y),
%  C = dict:fetch_keys(DictA),
  D = dict:fetch_keys(DictB),
  dict:to_list(prune(DictA,D,DictB,1,length(D))).
