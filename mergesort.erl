-module(mergesort).
-compile(export_all).

init() -> 
A = [{"souvik",5}, {"ray",4}, {"house",1}],
%B = [{"cupertino",10}, {"santa clara",3}],
B = [],

C = lists:merge(fun(A,B) -> 
                 {A1, A2} = A,
                 {B1, B2} = B,
                 if
                    A2 > B2 -> 
                       true;
                    true -> 
                       false 
                 end
               end, A, B),
  io:format("~p~n",[C]).
