% True if A is a possible movement direction
m(n).
m(e).
m(s).
m(w).

% True if p(X,Y) is on the board
on_board(p(X, Y)) :-
    1 =< X,
    1 =< Y,
    ailp_grid_size(S),
    X =< S,
    Y =< S.

% True if p(X1,Y1) is one step in direction M from p(X,Y) (no bounds check)
pos_step(p(X,Y), m(M), p(X1,Y1)) :-
    (M = n, X1 is X, Y1 is Y - 1);
    (M = e, X1 is X + 1, Y1 is Y);
    (M = s, X1 is X, Y1 is Y + 1);
    (M = w, X1 is X - 1, Y1 is Y).

% True if NPos is one step in direction M from Pos (with bounds check)
new_pos(Pos,m(M),NPos) :-
    pos_step(Pos, m(M), NPos),
    on_board(NPos).

% True if a L has the same length as the number of squares on the board
complete(L) :-
    ailp_grid_size(S),
    Len is S * S,
    length(L, Len).

line([], _, _, X) :-
    X =:= 0.

line([p(X1, Y1) | HS], p(X1, Y1), m(M), StepCount) :-
    new_pos(p(X1, Y1), m(M), NewPos),
    line(HS, NewPos, m(M), StepCount - 1).
    
loop(L, p(X1, Y1), StepCount) :-
    line(L1, p(X1 ,Y1), m(s), StepCount),
    last(L1, E1),
    new_pos(E1, m(s), P2),
    line(L2, P2, m(e), StepCount),
    last(L2, E2),
    new_pos(E2, m(e), P3),
    line(L3, P3, m(n), StepCount),
    last(L3, E3),
    new_pos(E3, m(n), P4),
    line(L4, P4, m(w), StepCount),
    last(L4, E4),
    new_pos(E4, m(w), p(ReturnPointX, ReturnPointY)),
    X1 =:= ReturnPointX,
    Y1 =:= ReturnPointY,
    flatten([L1, L2, L3, L4], L).

loopRecursive(L, p(X1, Y1), 1) :- loop(L, p(X1, Y1), 1).
loopRecursive([p(X1, Y1)], p(X1, Y1), 0).
loopRecursive(L, p(X1, Y1), StepCount) :-
    loop(Loop, p(X1, Y1), StepCount),
    last(Loop, E1),
    new_pos(E1, m(s), P2),
    NewStepCount is StepCount - 2,
    loopRecursive(Rest, P2, NewStepCount),
    append(Loop, Rest, L).

% Perform a sequence of moves creating a spiral pattern, return the moves as L
spiral(L) :-
    ailp_grid_size(S),
    StepCount is S - 1,
    loopRecursive(L, p(1, 1), StepCount),
    L = [_ | MS],
    complete(L),
    my_agent(A),
    agent_do_moves(A, MS).
    
    
