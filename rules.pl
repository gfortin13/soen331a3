%author: Guillaume Fortin, Emmanuel Tsapekis
%date: 2/4/2015

:- [facts].

%Part 6, Rules

%1.
is_loop(Event, Guard) :- transition(S, S, Event, Guard, _),
	Event \= 'null',
	Guard \= 'null'.

%2.
all_loops(Set) :- findall(E-G, is_loop(E, G), L),
	list_to_set(L, Set).

%3.
is_edge(Event, Guard) :- transition(_, _, Event, Guard, _),
	Event \= 'null',
	Guard \= 'null'.
%4.
size(Length) :- findall(E-G, is_edge(E, G), L),
	length(L, Length).

%5
is_link(Event, Guard) :- transition(S1, S2, Event, Guard, _),
	S1 \= S2,
	Event \= 'null',
	Guard \= 'null'.

%6
all_superstates(Set) :- findall(S, superstate(S, _), L),
	list_to_set(L, Set).

%7
ancestor(Ancestor, Descendant) :- superstate(Ancestor, Descendant);
	superstate(Ancestor, S),
	ancestor(S, Descendant).

%8
inherits_transitions(State, List) :- findall(transition(S1, S2, E, G, A), ancestor(S, S1), List).

%9
all_states(L) :- findall(S, state(S), L).

%10
all_init_states(L) :- findall(S, initial_state(S, _), L).

%11
get_starting_state(State) :- initial_state(State, null).

%12
state_is_reflexive(State) :- transition(State, State, _, _, _).

%13
graph_is_reflexive :- state_is_reflexive(State).

%14
get_guards(Set) :-  findall(G, transition(_, _, _, G, _), L),
	list_to_set(L, Set).

%15
get_events(Set) :-  findall(E, transition(_, _, E, _, _), L),
	list_to_set(L, Set).

%16
get_actions(Set) :-  findall(A, transition(_, _, _, _, A), L),
	list_to_set(L, Set).

%17
get_only_guarded(Set) :-  findall(S1-S2, transition(S1, S2, null, G, null), L),
	list_to_set(L, Set).

%18
legal_events_of(State, L) :- findall(E-G, transition(State, _, E, G, _), L).
