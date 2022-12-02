:- use_module(library(lists)).
:- use_module(library(pio)).



lines([]) --> call(eos), !.
lines([Line | Lines]) --> [Line], lines(Lines).

% End of stream
eos([],[]).

line([]) --> ("\n" ; call(eos)), !.
line([L |Ls]) --> [L], line(Ls).


rps('AX', 4). % 1 + 3
rps('BX', 1). % 1 + 0
rps('CX', 7). % 1 + 6
rps('AY', 8). % 2 + 6
rps('BY', 5). % 2 + 3
rps('CY', 2). % 2 + 0
rps('AZ', 3). % 3 + 0
rps('BZ', 9). % 3 + 6
rps('CZ', 6). % 3 + 3
rps(_, 0).

rps2('AX', 3).
rps2('BX', 1).
rps2('CX', 2).
rps2('AY', 4).
rps2('BY', 5).
rps2('CY', 6).
rps2('AZ', 8).
rps2('BZ', 9).
rps2('CZ', 7).
rps2(_, 0).

count(List, Result1, Result2) :- count(List, [], [], Result1, Result2).
count([], Counter1, Counter2, Result1, Result2) :- sum_list(Counter1, Result1), sum_list(Counter2, Result2).
count([Me, _, You], Counter1, Counter2, Result1, Result2) :- 
    L = [Me, You],
    atom_codes(X, L),
    rps(X, Pts1),
    rps2(X, Pts2),
    sum_list([Pts1 | Counter1], Result1),
    sum_list([Pts2 | Counter2], Result2).

count([Me, _, You, _ | Lines], Counter1, Counter2, Result1, Result2) :-
    L = [Me, You],
    atom_codes(X, L),
    rps(X, Pts1),
    rps2(X, Pts2),
    count(Lines, [Pts1 | Counter1], [Pts2 | Counter2], Result1, Result2).


:- phrase_from_file(lines(Lines), 'data.txt'),
    count(Lines, Totals, Totals2),
    writeln(Totals),
    writeln(Totals2).
