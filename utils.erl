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



-module(utils).
-compile(export_all).

mergesort(X,Y) ->
   C = lists:merge(fun(A,B) -> 
                    {A1, A2} = A,
                    {B1, B2} = B,
                    if
                      A2 > B2 -> 
                        true;
                      true -> 
                        false 
                    end
                  end, X, Y),
   C.

