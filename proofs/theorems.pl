% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/prooflash').

% Domain: every answer sequence of length 0..6 from every starting box 1..5.
answers(As) :- between(0, 6, N), length(As, N), maplist([A]>>member(A, [correct, wrong]), As).
run(C, As, C2) :- foldl([A, X, Y]>>review(X, A, Y), As, C, C2).

% 1. Boxes stay between 1 and 5.
theorem(boxes_in_range) :- forall(( between(1, 5, B), answers(As) ), ( run(card(t, s, B), As, card(t, s, B2)), between(1, 5, B2) )).

% 2. K correct answers from box 1 reach box min(1 + K, 5); a wrong answer always returns to box 1.
theorem(correct_climbs_wrong_resets) :- forall(between(0, 6, K), ( length(As, K), maplist(=(correct), As), run(card(t, s, 1), As, card(_, _, B)), B =:= min(1 + K, 5) )), forall(between(1, 5, B0), review(card(t, s, B0), wrong, card(t, s, 1))).

% 3. Every card is due at least once in any 16 days in a row, and box-1 cards every day.
theorem(due_within_16_days) :- forall(( between(1, 5, B), between(0, 40, D0) ), ( D1 is D0 + 15, between(D0, D1, D), due(card(t, s, B), D) -> true )), forall(between(0, 40, D), due(card(t, s, 1), D)).

% 4. A session changes only cards that were due and answered.
theorem(session_changes_only_due) :- forall(( between(1, 3, B1), between(1, 3, B2), between(0, 8, Day), member(As, [[], [a-correct], [b-wrong], [a-wrong, b-correct]]) ), ( Cs = [card(a, x, B1), card(b, y, B2)], session(Cs, Day, As, Cs2), forall(( nth1(I, Cs, C), nth1(I, Cs2, C2), C \== C2 ), ( due(C, Day), C = card(N, _, _), memberchk(N-_, As) )) )).
