module Impl.CSwap

open FStar.UInt32
open FStar.UInt
let uint32 = FStar.UInt32.t

open Spec.CSwap

(* Lemmata that help proving correctness. (A little more than necessary :) *)

val xor_rules: a:uint32 -> b:uint32 -> c:uint32 -> Lemma
  (ensures (UInt32.logxor a (UInt32.logxor a b) = b /\
            UInt32.logxor a (UInt32.logxor b a) = b /\
            UInt32.logxor a 0ul = a /\
            UInt32.logxor a 0xFFFFFFFFul = UInt32.lognot a /\
            UInt32.logxor (UInt32.logxor a b) c = UInt32.logxor a (UInt32.logxor b c)
  ))
let xor_rules x y z =
  UInt.logxor_associative (v x) (v y) (v z);
  UInt.logxor_associative (v x) (v x) (v y);
  UInt.logxor_commutative (v x) (v y);
  UInt.logxor_commutative (v 0ul) (v y);
  UInt.logxor_self (v x);
  UInt.logxor_lemma_1 (v x);
  UInt.logxor_lemma_1 (v y);
  UInt.logxor_lemma_2 (v x);
  UInt.logxor_lemma_2 (v y)

val and_rules: a:uint32 -> b:uint32{b = 0xFFFFFFFFul \/ b = 0ul} -> Lemma
  (ensures (
    UInt32.logand 0xFFFFFFFFul a = a /\
    UInt32.logand 0ul a = 0ul /\
    UInt32.logand a b = UInt32.logand b a /\
    (if b = 0xFFFFFFFFul then UInt32.logand a b = a else UInt32.logand a b = 0ul)
  ))
let and_rules x y =
  UInt.logand_lemma_1 (v x);
  UInt.logand_lemma_2 (v x);
  UInt.logand_commutative (v x) (v 0ul);
  UInt.logand_commutative (v x) (v 0xFFFFFFFFul);
  UInt.logand_commutative (v x) (v y)

val cswap_step_rules: x:uint32 -> y:uint32 -> c:uint32{c = 0xFFFFFFFFul \/ c = 0ul} -> Lemma
  (ensures (
    let r = (x ^^ y) &^ c in
    if c = 0xFFFFFFFFul then
      r = x ^^ y
    else
      r = 0ul
  ))
let cswap_step_rules x y c =
  xor_rules x y c;
  and_rules (x ^^ y) c

(* Swapping two uint32 variables in constant time *)

val cswap_constant_time: x:uint32 -> y:uint32 -> c:uint32{c = 0xFFFFFFFFul \/ c = 0ul} ->
  Tot (uint32 * uint32)
let cswap_constant_time x y c =
  let mask = (x ^^ y) &^ c in
  let a = x ^^ mask in
  let b = y ^^ mask in
  (a, b)

(* Prove correctness of the constant time conditional swap using Spec.CSwap. *)

val cswap_constant_time_is_correct:
  x:uint32 -> y:uint32 -> c:uint32{c = 0xFFFFFFFFul \/ c = 0ul} -> Lemma
  (ensures (
    let a, b = cswap_constant_time x y c in
    let c, d = cswap x y c in
    a = c /\ b = d
  ))
let cswap_constant_time_is_correct x y c =
  cswap_step_rules x y c;
  xor_rules x y c;
  xor_rules y x c

(* Tests *)
let test () =
  let a = 123456789ul in
  let b = 987654321ul in

  (* Don't swap *)
  let c, d = cswap_constant_time a b 0ul in
  if c = a && d = b then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n";

  (* Swap *)
  let e, f = cswap_constant_time a b 0xFFFFFFFFul in
  if e = b && f = a then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n"
