:- use_module(library(lists)).
:- use_module(library(pio)).



% Get values from data and put in a list with sublists
lines([]) --> call(eos), !.
lines([Line | Lines]) --> line(Line), lines(Lines).

% End of stream
eos([],[]).

% Make sublists of every inventory
line([]) --> ("\n" ; call(eos)), !.
line([Inv | Invs]) --> [Inv], line(Invs).

% Creates the counter and the list of the totals
counts(List, Counts) :- counts(List, 0, [], Counts).

% puts the inventories in the right order
counts([], Count, Totals, Results) :- reverse([Count | Totals], Results).

% Begins a new inventory and adds the total to the totals list
counts([[]|Invs], Count, Totals, Results) :- counts(Invs, 0, [Count | Totals], Results).

% Sums up the values of an inventory
counts([Inv | Invs], Count, Totals, Results) :-
    string_codes(Inv, String),
    number_string(Num, String),
    NewCount is Count + Num,
    counts(Invs, NewCount, Totals, Results).


% Get the highest total of calories in an inventory
solve(Counts, Results) :- max_list(Counts, Results).

% Get the sum of the three highest total of calories in an inventory
solve2(Counts, Results) :-
    sort(Counts, SortedCounts),
    reverse(SortedCounts, [A, B, C | _]),
    sum_list([A,B,C], Results).


:- phrase_from_file(lines(Lines), 'data.txt'), 
counts(Lines, Counts), 
solve(Counts, Results1), 
writeln(Results1), 
solve2(Counts, Results2), 
writeln(Results2).