swap([X, Y | Rst], [Y, X | Rst]).

swap([X | Xs], [X | Ys]) :- swap(Xs, Ys).

edge(0,1).
edge(1,2).
edge(1,3).
edge(2,3).
edge(3,4).
edge(4,0).
edge(4,1).

% A cute visualisation
%  0-->1-->2
%  ^  ^ \  |
%  |/     vv
%  4<------3

fitness(Path, N) :-
    fitness(Path, 0, N).

fitness([], N, N).
fitness([_], N, N).
fitness([X, Y | Rst], Nin, Nout) :-
    edge(X, Y),
    Temp is Nin + 1,
    fitness([Y | Rst], Temp, Nout).

fitness([X, Y | Rst], Nin, Nout) :-
    \+ edge(X, Y),
    fitness([Y | Rst], Nin, Nout).

tabu(Best) :-
    tabu([4, 3, 2, 1, 0], [4, 3, 2, 1, 0], [], 10, Best).

tabu(_, BestSoFar, _, 0, BestSoFar).

tabu(CurrentSolution, BestSoFar, VisitedStates, NIter, BestFound) :-
    format("~w ~w ~w ~w ~n", [BestSoFar, VisitedStates, NIter, BestFound]),
    NIter > 0,
    findall(
        Score:NewSolution, (
            swap(CurrentSolution, NewSolution),
            \+member(NewSolution, VisitedStates),
            fitness(NewSolution, Score)
        ), NewSolutions
    ),

    sort(0, @>, NewSolutions, SortedNewSolutions),

    format("SortedNewSolutions: ~w ~n", [SortedNewSolutions]),

    [NewScore:NewSolution|_] = SortedNewSolutions,

    lastN(VisitedStates, 10, VisitedStatesLoseOld),

    format("VisitedStatesLoseOld: ~w ~n", [VisitedStatesLoseOld]),

    append(VisitedStatesLoseOld, [NewSolution], NewVisitedStates),

    fitness(BestSoFar, Score),

    format("CURRENT: ~w ~n", [CurrentSolution]),
    format("BEST SCORE: ~w ~n", [Score]),
    format("BEST: ~w ~n", [BestSoFar]),

    NewNIter is NIter - 1,

    (
        NewScore > Score
    ->  format("TRYING SOMETHING NEW ~n"),
        tabu(NewSolution, NewSolution, NewVisitedStates, NewNIter, BestFound)
    ;   format("STICKING WITH WHAT WE GOT ~n"),
        tabu(NewSolution, BestSoFar, NewVisitedStates, NewNIter, BestFound)
    ).

lastN(List, N, List) :-
    length(List, Length),
    N >= Length.

lastN(List, N, New) :-
    length(List, Length),
    N < Length,
    List = [_|Rst],
    lastN(Rst, N, New).
