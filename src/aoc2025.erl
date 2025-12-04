-module(aoc2025).
-export([main/1]).

main(Args) ->
    {Day, Example} = case Args of
        [D, "-e"] -> {D, true};
        [D] -> {D, false}
    end,
    Name = "day" ++ Day,
    Filename = "./src/" ++ Name ++ ".erl",
    InputFilename = "./input/" ++ Day ++ ".txt",
    case filelib:is_regular(Filename) of
        true ->
            Module = list_to_atom(Name),
            Input = grab_input(InputFilename, Module, Example),
            io:format("First: ~p~nSecond: ~p~n", [Module:first(Input), Module:second(Input)]);
        false ->
            file:write_file(Filename, new_file(Name)),
            download_input(InputFilename, Day),
            io:format("File created.")
    end.

new_file(Name) -> "
-module(" ++ Name ++ ").
-export([example/0, parse/1, first/1, second/1]).

example() -> <<\"\">>.

parse(Input) ->
    Input.

first(_Input) ->
    ok.

second(_Input) ->
    ok.".

download_input(InputFilename, Day) ->
    inets:start(),
    ssl:start(),
    Url = "https://adventofcode.com/2025/day/" ++ Day ++ "/input",
    Session = os:getenv("ADVENT_OF_CODE_SESSION"),
    Headers = [{"Cookie", "session=" ++ Session}],
    {ok, {{_, 200, _}, _, Body}} = httpc:request(get, {Url, Headers}, [], []),
    file:write_file(InputFilename, Body).

grab_input(_InputFilename, Module, true) ->
    Module:parse(Module:example());
grab_input(InputFilename, Module, false) ->
    {ok, Content} = file:read_file(InputFilename),
    Module:parse(Content).