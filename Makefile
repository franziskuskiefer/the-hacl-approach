
cswap.exe: Spec.CSwap.fst
	mkdir -p cswap-ml
	fstar.exe --codegen OCaml --extract_module Spec.CSwap --odir cswap-ml $^
	@echo '\n\nlet _ = test()' >> cswap-ml/Spec_CSwap.ml
	# This assumes that FStar/bin is in the PATH.
	OCAMLPATH="${PATH}" ocamlfind opt -package fstarlib -linkpkg -w -20-26-3-8-58 -w -8-20-26-28-10 -I cswap-ml cswap-ml/Spec_CSwap.ml -o cswap.exe
	./cswap.exe

clean:
	rm -rf cswap-ml cswap.exe
