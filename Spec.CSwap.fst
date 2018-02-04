module Spec.CSwap

open FStar.UInt32
let uint32 =  FStar.UInt32.t

(* Swapping two uint32 variables *)

val cswap: x:uint32 -> y:uint32 -> c:uint32 ->
  Tot (uint32 * uint32)
let cswap x y c =
  if c = 0ul then
    (x, y)
  else
    (y, x)

val cswap_is_correct: x:uint32 -> y:uint32 -> c:uint32{c = 1ul \/ c = 0ul} -> Lemma
  (ensures (
    let a, b = cswap x y c in
    if c = 0ul then
      a = x /\ b = y
    else
      a = y /\ b = x
  ))
let cswap_is_correct x y c = ()

(* Tests *)
let test () =
  let a = 123456789ul in
  let b = 987654321ul in

  (* Don't swap *)
  let c, d = cswap a b 0ul in
  if c = a && d = b then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n";

  (* Swap *)
  let e, f = cswap a b 1ul in
  if e = b && f = a then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n";

  (* Swap *)
  let e, f = cswap a b 0xFFFFFFFFul in
  if e = b && f = a then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n"
