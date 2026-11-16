% prooflash: flashcards from proofs, reviewed on a Leitner schedule. Each theorem becomes a card
% (front: its name; back: its statement). A card in box B is due on days divisible by 2^(B-1);
% a correct answer moves it up a box (at most 5), a wrong one sends it back to box 1.
%?- cards([thm(append_nil, 'append(L, [], L)')], Cs).   % Cs = [card(append_nil, 'append(L, [], L)', 1)]
%?- review(card(t, s, 2), correct, C).                  % C = card(t, s, 3)
%?- session([card(a, x, 1), card(b, y, 2)], 1, [a-wrong], S).   % b is not due on day 1
:- module(prooflash, [cards/2, review/3, due/2, session/4, due_cards/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

cards(Thms, Cs) :- maplist([thm(N, S), card(N, S, 1)]>>true, Thms, Cs).

review(card(N, S, B), correct, C) :- !, B2 is min(5, B + 1), C = card(N, S, B2).
review(card(N, S, _), wrong, card(N, S, 1)).

due(card(_, _, B), Day) :- P is 2 ^ (B - 1), Day mod P =:= 0.
due_cards(Cs, Day, Due) :- include([C]>>due(C, Day), Cs, Due).

% session(+Cards, +Day, +Answers, -Cards2): Answers are Name-correct or Name-wrong; due cards with
% an answer are reviewed, all others stay as they are.
session(Cs, Day, As, Cs2) :- maplist([C, C2]>>( C = card(N, _, _), due(C, Day), memberchk(N-R, As) -> review(C, R, C2) ; C2 = C ), Cs, Cs2).
