
-module(day3).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<"987654321111111
811111111111119
234234234234278
818181911112111">>.

parse(Input) ->
    lists:map(fun (Line) -> [C - $0 || C <- binary_to_list(Line)] end, binary:split(Input, <<"\n">>, [global])).

first(Input) ->
    lists:sum(lists:map(fun (Bank) ->
        list_to_integer(extract_largest_number(Bank, 2))
    end, Input)).

second(Input) ->
    lists:sum(lists:map(fun (Bank) ->
        list_to_integer(extract_largest_number(Bank, 12))
    end, Input)).

extract_largest_number(_Excerpt, 0) ->
    [];
extract_largest_number(Excerpt, Length) ->
    Max = lists:max(lists:sublist(Excerpt, length(Excerpt) - Length + 1)),
    Index = string:str(Excerpt, [Max]),
    [Max + $0 | extract_largest_number(lists:sublist(Excerpt, Index + 1, length(Excerpt)), Length - 1)].