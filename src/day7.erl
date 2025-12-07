
-module(day7).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............">>.

parse(Input) ->
    [Start | Rest] = lists:map(fun binary_to_list/1, binary:split(Input, <<"\n">>, [global])),
    {value, {SI, _}} = lists:search(fun ({_, $S}) -> true; (_) -> false end, lists:enumerate(Start)),
    Splitters = lists:map(fun (Line) ->
        lists:filtermap(fun ({I, $^}) -> {true, I}; (_) -> false end, lists:enumerate(Line))
    end, Rest),
    {SI, Splitters}.

first({SI, Splitters}) ->
    traverse([SI], Splitters, 0).

traverse(Current, [Line | Rest], Count) ->
    {NewCurrent, AddCount} = lists:foldl(fun (I, {NewCurrent, AddCount}) ->
        case lists:member(I, Line) of
            true -> {lists:uniq([I - 1, I + 1 | NewCurrent]), AddCount + 1};
            false -> {[I | NewCurrent], AddCount}
        end
    end, {[], Count}, Current),
    traverse(NewCurrent, Rest, AddCount);
traverse(_Current, [], Count) ->
    Count.

second({SI, Splitters}) ->
    timeline(SI, Splitters).

timeline(Current, Splitters) ->
    {Res, _Cache} = timeline(Current, lists:enumerate(Splitters), #{}),
    Res.
timeline(Current, [{I, Line} | Rest], Cache) ->
    case Cache of
        #{{Current, I} := Val} ->
            {Val, Cache};
        _ ->
            {Value, UpdatedCache} = case lists:member(Current, Line) of
                true ->
                    {L, SubUpdatedCache1} = timeline(Current - 1, Rest, Cache),
                    {R, SubUpdatedCache2} = timeline(Current + 1, Rest, SubUpdatedCache1),
                    {L + R, SubUpdatedCache2};
                false -> 
                    timeline(Current, Rest, Cache)
            end,
            {Value, UpdatedCache#{{Current, I} => Value}}
    end;
timeline(_Current, [], Cache) ->
    {1, Cache}.