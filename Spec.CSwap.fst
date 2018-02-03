module Spec.CSwap

(* Swapping two variables *)

val cswap: x: nat -> y: nat -> c: nat{c = 0 \/ c = 1} -> Tot (nat * nat)
let cswap x y c =
  if c = 0 then
    (x, y)
  else
    (y, x)

(* Tests *)
let test () =
  let a = 123456789 in
  let b = 9876543210 in

  (* Don't swap *)
  let c, d = cswap a b 0 in
  if c = a && d = b then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n";

  (* Swap *)
  let e, f = cswap a b 1 in
  if e = b && f = a then
    IO.print_string "SUCCESS\n"
  else
    IO.print_string "ERROR :/\n"
