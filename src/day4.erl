
-module(day4).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<"..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.">>.

parse(Input) ->
   sets:from_list([{X, Y} || {Y, Row} <- lists:enumerate(binary:split(Input, <<"\n">>, [global])), {X, Cell} <- lists:enumerate(binary_to_list(Row)), Cell =:= $@]).

first(Papers) ->
    sets:size(removable(Papers)).

second(Papers) ->
    Removable = removable(Papers),
    NewPapers = sets:subtract(Papers, Removable),
    case sets:is_equal(Papers, NewPapers) of
        true -> 0;
        false -> sets:size(Removable) + second(NewPapers)
    end.

removable(Papers) ->
    sets:filter(fun ({X, Y}) ->
        Adjacent = [{X + A, Y + B} || A <- lists:seq(-1, 1), B <- lists:seq(-1, 1), A =/= 0 orelse B =/= 0],
        length(lists:filter(fun (T) -> sets:is_element(T, Papers) end, Adjacent)) < 4 
    end, Papers).