
-module(day1).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<"L68
L30
R48
L5
R60
L55
L1
L99
R14
L82">>.

parse(Input) ->
    lists:filtermap(fun
        (<<"R", Number/binary>>) -> {true, list_to_integer(binary_to_list(Number))};
        (<<"L", Number/binary>>) -> {true, -list_to_integer(binary_to_list(Number))};
        (_) -> false
    end, binary:split(Input, <<"\n">>, [global])).

first(Input) ->
    rotate(Input, 50, 0).

rotate([Number | Rest], Acc, Count) ->
    NextAcc = Acc + Number,
    rotate(Rest, NextAcc, Count + case NextAcc rem 100 of 0 -> 1; _ -> 0 end);
rotate([], _, Count) ->
    Count.

second(Input) ->
    rotate2(Input, 50, 0).

rotate2([0 | Rest], Acc, Count) ->
    rotate2(Rest, Acc, Count);
rotate2([Number | Rest], Acc, Count) when Number > 0 ->
    NewAcc = Acc + 1,
    rotate2([Number - 1 | Rest], NewAcc, Count + case NewAcc rem 100 of 0 -> 1; _ -> 0 end);
rotate2([Number | Rest], Acc, Count) ->
    NewAcc = Acc - 1,
    rotate2([Number + 1 | Rest], NewAcc, Count + case NewAcc rem 100 of 0 -> 1; _ -> 0 end);
rotate2([], _, Count) ->
    Count.
