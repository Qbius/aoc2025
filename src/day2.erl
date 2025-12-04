
-module(day2).
-export([example/0, parse/1, first/1, second/1]).

example() -> <<"11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124">>.

parse(Input) ->
    [{list_to_integer(binary_to_list(AStr)), list_to_integer(binary_to_list(BStr))} || [AStr, BStr] <- lists:map(fun (Range) -> binary:split(Range, <<"-">>) end, binary:split(Input, <<",">>, [global]))].

first(Input) ->
    lists:sum(lists:map(fun ({Start, End}) ->
        lists:sum(lists:filter(fun (N) ->
            is_sequential(integer_to_list(N))
        end, lists:seq(Start, End)))
    end, Input)).

is_sequential(List) when length(List) rem 2 =:= 1 -> false;
is_sequential(List) ->
    Half = length(List) div 2,
    string:slice(List, 0, Half) =:= string:slice(List, Half, Half).


second(Input) ->
    lists:sum(lists:map(fun ({Start, End}) ->
        lists:sum(lists:filter(fun (N) ->
            is_sequential2(integer_to_list(N))
        end, lists:seq(Start, End)))
    end, Input)).

is_sequential2(List) ->
    is_sequential2(List, 1, length(List)).
is_sequential2(_List, Size, Len) when Size > (Len div 2) ->
    false;
is_sequential2(List, Size, Len) when Len rem Size =/= 0 ->
    is_sequential2(List, Size + 1, Len);
is_sequential2(List, Size, Len) ->
    Chunks = lists:map(fun (I) -> string:slice(List, Size * (I - 1), Size) end, lists:seq(1, Len div Size)),
    case length(lists:uniq(Chunks)) of
        1 -> true;
        _ -> is_sequential2(List, Size + 1, Len)
    end.
