:- module(cases, [title/1, case/3]).
:- use_module('../prolog/prooflash').
:- use_module(engine).
title('prooflash').
names([append_nil, rev_rev, len_app, sort_idem, member_app]).
card_g(card(N, S, B)) :- names(Ns), rnd_pick(Ns, N), atom_concat(N, '_statement', S), rnd_int(1, 5, B).
case(review, [C, R], review) :- card_g(C), rnd_pick([correct, wrong], R).
case(due, [C, D], due) :- card_g(C), rnd_int(0, 40, D).
case(session, [Cs, D, As], session) :- names(Ns), rnd_int(1, 5, K), length(Ns0, K), append(Ns0, _, Ns), maplist([N, card(N, s, B)]>>rnd_int(1, 5, B), Ns0, Cs), rnd_int(0, 20, D), include([_]>>rnd_chance(60), Ns0, Ans), maplist([N, N-R]>>rnd_pick([correct, wrong], R), Ans, As).
