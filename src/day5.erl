
-module(day5).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<"3-5
10-14
16-20
12-18

1
5
8
11
17
32">>.

parse(Input) ->
    [RangesBin, IDsBin] = binary:split(Input, <<"\n\n">>),
    Ranges = [{binary_to_integer(A), binary_to_integer(B)} || [A, B] <- lists:map(fun (Line) -> binary:split(Line, <<"-">>) end, binary:split(RangesBin, <<"\n">>, [global]))],
    IDs = lists:map(fun binary_to_integer/1, binary:split(IDsBin, <<"\n">>, [global])),
    {Ranges, IDs}.

first({Ranges, IDs}) ->
    length(lists:filter(fun (ID) -> lists:any(fun ({A, B}) when ID >= A andalso ID =< B -> true; (_) -> false end, Ranges) end, IDs)).

second({Ranges, _}) ->
    {AStarts, AEnds} = lists:unzip(Ranges),
    Points = lists:sort([{Val, b} || Val <- AStarts] ++ [{Val, e} || Val <- AEnds]),
    {0, Relevant} = lists:foldl(fun
        ({Val, b}, {0, Relevant}) ->
            {1, [Val | Relevant]};
        ({_Val, b}, {Depth, Relevant}) ->
            {Depth + 1, Relevant};
        ({Val, e}, {1, Relevant}) ->
            {0, [Val | Relevant]};
        ({_Val, e}, {Depth, Relevant}) ->
            {Depth - 1, Relevant}
    end, {0, []}, Points),
    R = remove_same(lists:reverse(Relevant)),
    summarize(R).

remove_same([First | Rest]) ->
    remove_same(Rest, [First]).
remove_same([A, A | Rest], Points) ->
    remove_same(Rest, Points);
remove_same([A, B | Rest], Points) ->
    remove_same(Rest, [B, A | Points]);
remove_same([Last], Points) ->
    lists:reverse([Last | Points]).

summarize([A, B | Rest]) -> B - A + 1 + summarize(Rest);
summarize([]) -> 0.