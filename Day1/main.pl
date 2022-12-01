:- use_module(library(lists)).
:- use_module(library(pio)).

lines([]) --> call(eos), !.
lines([Line | Lines]) --> line(Line), lines(Lines).

eos([],[]).

line([]) --> ("\n" ; call(eos)), !.
line([Val | Vals]) --> [Val], line(Vals).

counts(List, Counts) :- counts(List, 0, [], Counts).

counts([], Count, Inc, Results) :- reverse([Count | Inc], Results).
counts([[]|Vals], Count, Inc, Results) :- counts(Vals, 0, [Count | Inc], Results).
counts([Val | Vals], Count, Inc, Results) :-
    string_codes(Val, String),
    number_string(Num, String),
    NewCount is Count + Num,
    counts(Vals, NewCount, Inc, Results).

solve(Counts, Results) :- max_list(Counts, Results).

solve2(Counts, Results) :-
    sort(Counts, SortedCounts),
    reverse(SortedCounts, [A, B, C| X]),
    sum_list([A,B,C], Results).


:- phrase_from_file(lines(Lines), 'C:/.SSHome/NotSchool/AOC/AdventOfCode2022/Day1/data.txt'), counts(Lines, Counts), solve(Counts, Results1), writeln(Results1), solve2(Counts, Results2), writeln(Results2).