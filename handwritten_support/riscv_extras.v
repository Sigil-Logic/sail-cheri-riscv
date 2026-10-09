(*=======================================================================================*)
(*  This Sail RISC-V architecture model, comprising all files and                        *)
(*  directories except where otherwise noted is subject the BSD                          *)
(*  two-clause license in the LICENSE file.                                              *)
(*                                                                                       *)
(*  SPDX-License-Identifier: BSD-2-Clause                                                *)
(*=======================================================================================*)

(* Copied from riscv/sail-riscv handwritten_support/riscv_extras.v at
   549e723031b34b5ffea5bbb56367be15c7a38a9e, whose Rocq CI builds with Sail 0.20.  The
   nested sail-riscv submodule's copy still targets the pre-0.20 library, so
   the Makefile loads this one instead. *)

Require Import SailStdpp.Base.
Require Import List.
Require Import Lia.
Import List.ListNotations.
Open Scope Z.

Definition shift_bits_left {a b} (v : mword a) (n : mword b) : mword a :=
  shiftl v (int_of_mword false n).

Definition shift_bits_right {a b} (v : mword a) (n : mword b) : mword a :=
  shiftr v (int_of_mword false n).

Definition shift_bits_right_arith {a b} (v : mword a) (n : mword b) : mword a :=
  arith_shiftr v (int_of_mword false n).

(*val get_time_ns : unit -> integer*)
Definition get_time_ns (_:unit) : Z := 0.
(*declare ocaml target_rep function get_time_ns := `(fun () -> Big_int.of_int (int_of_float (1e9 *. Unix.gettimeofday ())))`*)

Definition sys_enable_experimental_extensions (_:unit) : bool := false.

(* Override the more general version *)

Definition mults_vec {n} (l : mword n) (r : mword n) : mword (2 * n) := mults_vec l r.
Definition mult_vec {n} (l : mword n) (r : mword n) : mword (2 * n) := mult_vec l r.
Definition print_string (_ _:string) : unit := tt.

(* The rest is carried over from the nested sail-riscv's own riscv_extras.v
   (CTSRD-CHERI/sail-riscv e6752e8), without its pre-0.20 monadic memory
   primitives, which the generated model no longer calls.  This version of
   the model still reads its platform configuration through sys_* externs,
   which upstream has since replaced with a configuration file; they stay
   uninterpreted axioms, exactly as in the nested copy. *)

Definition elf_entry (_:unit) : Z := 0.
Definition elf_tohost (_:unit) : Z := 0.

Definition print_endline (_:string) : unit := tt.
Definition prerr_endline (_:string) : unit := tt.
Definition prerr_string (_:string) : unit := tt.
Definition putchar {T} (_:T) : unit := tt.
Definition print_bits {n} msg (bs : mword n) := prerr_endline (msg ++ (string_of_bits bs)).
Require DecimalString.
Definition string_of_int z := DecimalString.NilZero.string_of_int (Z.to_int z).

(* One uninterpreted axiom per sys_* extern the model declares (sail-riscv
   model/riscv_sys_regs.sail, riscv_sys_regs_envcfg.sail, riscv_vlen.sail,
   riscv_zihpm.sail, riscv_sstc.sail, riscv_insts_vext_vset.sail).  A range
   result gets a bound axiom with the declared range; sys_pa_bits and
   sys_asid_bits take the RV64 upper bound, which is the weaker assumption
   for RV32.  Proofs are therefore about every platform configuration. *)

Axiom sys_vext_vl_use_ceil : unit -> bool.
Axiom sys_enable_sstc : unit -> bool.
Axiom sys_enable_writable_misa : unit -> bool.
Axiom sys_enable_rvc : unit -> bool.
Axiom sys_enable_fdext : unit -> bool.
Axiom sys_enable_svinval : unit -> bool.
Axiom sys_enable_zcb : unit -> bool.
Axiom sys_enable_zfinx : unit -> bool.
Axiom sys_enable_zfh : unit -> bool.
Axiom sys_enable_zfhmin : unit -> bool.
Axiom sys_enable_zvfh : unit -> bool.
Axiom sys_enable_zvfhmin : unit -> bool.
Axiom sys_enable_zba : unit -> bool.
Axiom sys_enable_zbb : unit -> bool.
Axiom sys_enable_zbc : unit -> bool.
Axiom sys_enable_zbs : unit -> bool.
Axiom sys_enable_zbkb : unit -> bool.
Axiom sys_enable_zbkc : unit -> bool.
Axiom sys_enable_zbkx : unit -> bool.
Axiom sys_enable_zknd : unit -> bool.
Axiom sys_enable_zkne : unit -> bool.
Axiom sys_enable_zknh : unit -> bool.
Axiom sys_enable_zksed : unit -> bool.
Axiom sys_enable_zksh : unit -> bool.
Axiom sys_misa_x : unit -> bool.
Axiom sys_enable_rvy : unit -> bool.
Axiom sys_force_countinhibit_bits : unit -> mword 32.
Axiom sys_medeleg_writable_bits : unit -> mword 64.
Axiom sys_mideleg_writable_bits : unit -> mword 64.
Axiom sys_xtvec_writable_bits : unit -> mword 64.
Axiom sys_xcause_bits : unit -> Z.
Axiom sys_xcause_bits_ok : 0 <= sys_xcause_bits tt <= 63.
Axiom sys_pmp_count : unit -> Z.
Axiom sys_pmp_count_ok : 0 <= sys_pmp_count tt <= 64.
Axiom sys_pmp_writable : unit -> mword 64.
Axiom sys_pmp_grain : unit -> Z.
Axiom sys_pmp_grain_ok : 0 <= sys_pmp_grain tt <= 63.
Axiom sys_writable_hpm_counters : unit -> mword 32.
Axiom sys_pa_bits : unit -> Z.
Axiom sys_pa_bits_ok : 13 <= sys_pa_bits tt <= 56.
Axiom sys_asid_bits : unit -> Z.
Axiom sys_asid_bits_ok : 1 <= sys_asid_bits tt <= 16.
Axiom sys_enable_sv32 : unit -> bool.
Axiom sys_enable_sv39 : unit -> bool.
Axiom sys_enable_sv48 : unit -> bool.
Axiom sys_enable_sv57 : unit -> bool.
Axiom sys_enable_tlb : unit -> bool.
Axiom sys_enable_svnapot : unit -> bool.
Axiom sys_enable_vext : unit -> bool.
Axiom sys_enable_bext : unit -> bool.
Axiom sys_enable_zicbom : unit -> bool.
Axiom sys_enable_zicboz : unit -> bool.
Axiom sys_maskmax6 : unit -> Z.
Axiom sys_maskmax6_ok : 0 <= sys_maskmax6 tt <= 63.
Axiom sys_enable_zkr : unit -> bool.
Axiom sys_writable_stip : unit -> bool.
Axiom sys_enable_writable_fiom : unit -> bool.
Axiom sys_enable_pbmt : unit -> bool.
Axiom sys_vector_elen_exp : unit -> Z.
Axiom sys_vector_elen_exp_ok : 3 <= sys_vector_elen_exp tt <= 16.
Axiom sys_vector_vlen_exp : unit -> Z.
Axiom sys_vector_vlen_exp_ok : 3 <= sys_vector_vlen_exp tt <= 16.
Axiom sys_hpmevent_writable_bits : unit -> mword 64.
Axiom sys_enable_zihpm : unit -> bool.
Axiom sys_enable_sscofpmf : unit -> bool.
