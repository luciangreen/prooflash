# prooflash

flashcards from proofs, reviewed on a Leitner schedule. Each theorem becomes a card (front: its name; back: its statement). A card in box B is due on days divisible by 2^(B-1); a correct answer moves it up a box (at most 5), a wrong one sends it back to box 1.

## Use

```prolog
?- use_module(prolog/prooflash).
?- cards([thm(append_nil, 'append(L, [], L)')], Cs).   % Cs = [card(append_nil, 'append(L, [], L)', 1)]
?- review(card(t, s, 2), correct, C).                  % C = card(t, s, 3)
?- session([card(a, x, 1), card(b, y, 2)], 1, [a-wrong], S).   % b is not due on day 1
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every answer sequence of length 0..6 from every starting box 1..5.

1. Boxes stay between 1 and 5.
2. K correct answers from box 1 reach box min(1 + K, 5); a wrong answer always returns to box 1.
3. Every card is due at least once in any 16 days in a row, and box-1 cards every day.
4. A session changes only cards that were due and answered.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
