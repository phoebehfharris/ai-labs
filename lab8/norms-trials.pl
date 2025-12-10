:- discontiguous initially/1, initiates/3, terminates/3, holds/2, fluent/1.

holds(F,[]) :- initially(F).
holds(F,[E|Es]) :- holds(F,Es) -> not(terminates(E,F,Es)) ; initiates(E,F,Es).

fluent(F) :- member(F,[conditional, detached, satisfied, violated, expired]).
fluent(remaining_trials(N)) :- between(0,10,N).
fluent(registered).

event(E) :- member(E,[use_for_free, sign_up, timeout, other, monthly_reset]).

initially(conditional).
initially(remaining_trials(2)).

% ...Please fill in the rest!

initiates(sign_up, registered, _).

initiates(use_for_free, remaining_trials(0), Es) :-
    holds(remaining_trials(1), Es).

initiates(use_for_free, remaining_trials(New), Es) :-
    holds(remaining_trials(N), Es),
    N > 0,
    New is N - 1.

terminates(use_for_free, remaining_trials(N), Es) :-
    N > 0,
    holds(remaining_trials(N), Es).

initiates(monthly_reset, remaining_trials(2), _).
terminates(monthly_reset, remaining_trials(N), Es) :-
    N =\= 2,
    holds(remaining_trials(N), Es).
% Norm stuff

initiates(sign_up, satisfied, Es) :- holds(conditional, Es).
terminates(sign_up, conditional, Es) :- holds(conditional, Es).

initiates(sign_up, satisfied, Es) :- holds(detached, Es).
terminates(sign_up, detached, Es) :- holds(detached, Es).

initiates(use_for_free, detached, Es) :-
    holds(remaining_trials(1), Es),
    holds(conditional, Es).
terminates(use_for_free, conditional, Es) :-
    holds(remaining_trials(1), Es),
    holds(conditional, Es).

initiates(timeout, violated, Es) :- holds(detached, Es).
terminates(timeout, detached, Es) :- holds(detached, Es).

initiates(timeout, expired, Es) :- holds(conditional, Es).
terminates(timeout, conditional, Es) :- holds(conditional, Es).

holds(antecedent,Es) :- holds(remaining_trials(0),Es).
holds(consequent,Es) :- holds(registered,Es).
derived(F) :- member(F,[antecedent, consequent]).
fluent(F) :- derived(F).
