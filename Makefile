
all: cswap.exe cswap_impl.exe

cswap.exe: Spec.CSwap.fst
	mkdir -p cswap-ml
	fstar.exe --codegen OCaml --extract_module Spec.CSwap --odir cswap-ml $^
	@echo '\n\nlet _ = test()' >> cswap-ml/Spec_CSwap.ml
	# This assumes that FStar/bin is in the PATH.
	OCAMLPATH="${PATH}" ocamlfind opt -package fstarlib -linkpkg -w -20-26-3-8-58 -w -8-20-26-28-10 -I cswap-ml cswap-ml/Spec_CSwap.ml -o cswap.exe
	./cswap.exe

cswap_impl.exe: Impl.CSwap.fst
	mkdir -p cswap-ml
	fstar.exe --z3rlimit 50 --codegen OCaml --extract_module Impl.CSwap --odir cswap-ml $^
	@echo '\n\nlet _ = test()' >> cswap-ml/Impl_CSwap.ml
	# This assumes that FStar/bin is in the PATH.
	OCAMLPATH="${PATH}" ocamlfind opt -package fstarlib -linkpkg -w -20-26-3-8-58 -w -8-20-26-28-10 -I cswap-ml cswap-ml/Impl_CSwap.ml -o cswap_ct.exe
	./cswap_ct.exe

clean:
	rm -rf cswap-ml cswap.exe cswap_ct.exe
