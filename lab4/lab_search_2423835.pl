% Perform a BFS to find the nearest oracle

search_bsf :-
    my_agent(A), get_agent_position(A,P),
    singleton_heap(Heap, 0, P:[]),
    find_oracle(Po),
    search_bsf(Heap,[], Po, [_|Path]), !,
    agent_do_moves(A,Path).

search_bsf(Heap, _, _, Path) :-
    get_from_heap(Heap, _, Head, _),
    Head = Pos:RPath,
    complete(Pos),
    reverse([Pos|RPath], Path).

search_bsf(Heap, Visited, Po, Path) :-
    format("Heap: ~w, Visited: ~w, Target: ~w, Path: ~w ~n", [Heap, Visited, Po, Path]),
    get_from_heap(Heap, _, Head, RemovedHeap),
    format("Guhh: ~w ~n", [Head]),
    Head = Pos:RPath,
    format("Ermmm ~n"),

    findall(NewPos:[Pos|RPath], (
            map_adjacent(Pos,NewPos,empty),
            \+ member(NewPos,Visited),
            heap_to_list(Heap, Queue),
            \+ member(_-(NewPos:_),Queue)
    ), Children),
    format("Children: ~w ~n", [Children]),
    mapToPair(Children, Po, PairList),
    format("PairList: ~w ~n", [PairList]),
    list_to_heap(PairList, ChildrenHeap),
    merge_heaps(RemovedHeap, ChildrenHeap, NewHeap),
    format("~w, ~w ~n", [RemovedHeap, ChildrenHeap]),
    search_bsf(NewHeap,[Pos|Visited], Po, Path).

heuristic(p(X, Y), p(Tx, Ty), H) :-
	Xdiff is X - Tx,
	Ydiff is Y - Ty,

	Xdsq is Xdiff * Xdiff,
	Ydsq is Ydiff * Ydiff,

	Total is Xdsq + Ydsq,

	H is sqrt(Total).

mapToPair([], _, []).
mapToPair([X:Rst|Xs], Target, [Y|Ys]) :-
	heuristic(X, Target, H),

	Y = H-(X:Rst),

	mapToPair(Xs, Target, Ys).

% Test if the objective has been completed at a given position
complete(P) :- 
    map_adjacent(P, _, o(_)).

pos(P) :-
    my_agent(A),
    get_agent_position(A, P).

find_oracle(P) :-
	ailp_grid_size(N),
	between(0, N, X),
	between(0, N, Y),
	map_adjacent(p(X, Y), P, o(_)).
