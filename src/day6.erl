
-module(day6).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<"123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  ">>.

parse(Input) ->
    Input.

first(Input) ->
    [OpsBins | [FirstRow | _] = NumbersTransposed] = lists:reverse(lists:map(fun (Line) -> 
        lists:filter(fun (<<>>) -> false; (_) -> true end, binary:split(Line, <<" ">>, [global]))
    end, binary:split(Input, <<"\n">>, [global]))),
    Ops = lists:map(fun (<<"+">>) -> fun lists:sum/1; (<<"*">>) -> fun product/1 end, OpsBins),
    NumbersTransposedTuples = lists:map(fun list_to_tuple/1, NumbersTransposed),
    Numbers = lists:map(fun (I) ->
        [binary_to_integer(element(I, Tuple)) || Tuple <- NumbersTransposedTuples]
    end, lists:seq(1, length(FirstRow))),
    lists:sum(lists:map(fun ({Fun, Ns}) -> Fun(Ns) end, lists:zip(Ops, Numbers))).

second(Input) ->
    [OpsLine | [FirstRow | _] = NumberLines] = lists:reverse(lists:map(fun binary_to_list/1, binary:split(Input, <<"\n">>, [global]))),
    Ops = lists:filter(fun ({_, $+}) -> true; ({_, $*}) -> true; (_) -> false end, lists:enumerate(OpsLine)),
    NumberTuples = lists:map(fun list_to_tuple/1, lists:reverse(NumberLines)),
    Numbers = maps:from_list(lists:filtermap(fun (I) ->
        case string:strip([element(I, Tuple) || Tuple <- NumberTuples], both, $ ) of
            [] -> false;
            NStr -> {true, {I, list_to_integer(NStr)}}
        end
    end, lists:seq(1, length(FirstRow)))),
    Construct = fun
        Construct([{I1, Op}, {I2, _} = Snd | Rest]) ->
            [{Op, lists:seq(I1, I2 - 1)} | Construct([Snd | Rest])];
        Construct([{I, Op}]) ->
            [{Op, lists:seq(I, length(OpsLine))}]
    end,
    lists:sum(lists:map(fun ({Op, Indices}) ->
        {Fun, Neutral} = case Op of $+ -> {fun lists:sum/1, 0}; $* -> {fun product/1, 1} end,
        Fun(lists:map(fun (I) -> maps:get(I, Numbers, Neutral) end, Indices))
    end, Construct(Ops))).

product(List) ->
    lists:foldl(fun (A, B) -> A * B end, 1, List).