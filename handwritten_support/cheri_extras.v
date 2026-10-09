(*=======================================================================================*)
(*  CHERI RISCV Sail Model                                                               *)
(*                                                                                       *)
(*  This CHERI Sail RISC-V architecture model here, comprising all files and             *)
(*  directories except for the snapshots of the Lem and Sail libraries in the            *)
(*  prover_snapshots directory (which include copies of their licenses), is subject      *)
(*  to the BSD two-clause licence below.                                                 *)
(*                                                                                       *)
(*  Copyright (c) 2017-2021                                                              *)
(*    Alasdair Armstrong                                                                 *)
(*    Thomas Bauereiss                                                                   *)
(*    Brian Campbell                                                                     *)
(*    Jessica Clarke                                                                     *)
(*    Nathaniel Wesley Filardo (contributions prior to July 2020, thereafter Microsoft)  *)
(*    Alexandre Joannou                                                                  *)
(*    Microsoft                                                                          *)
(*    Prashanth Mundkur                                                                  *)
(*    Robert Norton-Wright (contributions prior to March 2020, thereafter Microsoft)     *)
(*    Alexander Richardson                                                               *)
(*    Peter Rugg                                                                         *)
(*    Peter Sewell                                                                       *)
(*                                                                                       *)
(*  All rights reserved.                                                                 *)
(*                                                                                       *)
(*  This software was developed by SRI International and the University of               *)
(*  Cambridge Computer Laboratory (Department of Computer Science and                    *)
(*  Technology) under DARPA/AFRL contract FA8650-18-C-7809 ("CIFV"), and                 *)
(*  under DARPA contract HR0011-18-C-0016 ("ECATS") as part of the DARPA                 *)
(*  SSITH research programme.                                                            *)
(*                                                                                       *)
(*  This software was developed within the Rigorous Engineering of                       *)
(*  Mainstream Systems (REMS) project, partly funded by EPSRC grant                      *)
(*  EP/K008528/1, at the Universities of Cambridge and Edinburgh.                        *)
(*                                                                                       *)
(*  This project has received funding from the European Research Council                 *)
(*  (ERC) under the European Union’s Horizon 2020 research and innovation                *)
(*  programme (grant agreement 789108, ELVER).                                           *)
(*                                                                                       *)
(*  Redistribution and use in source and binary forms, with or without                   *)
(*  modification, are permitted provided that the following conditions                   *)
(*  are met:                                                                             *)
(*  1. Redistributions of source code must retain the above copyright                    *)
(*     notice, this list of conditions and the following disclaimer.                     *)
(*  2. Redistributions in binary form must reproduce the above copyright                 *)
(*     notice, this list of conditions and the following disclaimer in                   *)
(*     the documentation and/or other materials provided with the                        *)
(*     distribution.                                                                     *)
(*                                                                                       *)
(*  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''                   *)
(*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED                    *)
(*  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A                      *)
(*  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR                  *)
(*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,                         *)
(*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT                     *)
(*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF                     *)
(*  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                  *)
(*  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,                   *)
(*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT                   *)
(*  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF                   *)
(*  SUCH DAMAGE.                                                                         *)
(*=======================================================================================*)

(* Sail >= 0.19 generates Rocq against the stdpp-based library, SailStdpp,
   in its concurrency-interface monad (M, defined in the generated
   riscv_types.v).  read_ram and write_ram are now Sail functions
   (sail-riscv/model/prelude_mem.sail) and the tag is carried by
   __ReadRAM_Meta and __WriteRAM_Meta (src/cheri_mem_metadata.sail), so the
   only CHERI externs left to supply are the two tag primitives that
   src/cheri_prelude.sail declares:
     val MEMr_tag = pure   "read_tag_bool"  : bits(64) -> bool
     val MEMw_tag = impure "write_tag_bool" : (bits(64), bool) -> unit

   Both are UNINTERPRETED here.  The concurrency interface has no tag-only
   write (SailStdpp.ConcurrencyInterfaceBuiltins: "TODO: ought to support
   tag-only writes"), and MEMr_tag is declared pure, so it is called outside
   the monad and cannot observe any write.  Nothing in this Rocq model
   relates a tag read to an earlier tag write: a theorem that depends on tag
   memory must state that dependence as a hypothesis. *)

Require Import SailStdpp.Base.
Require Import riscv_types.
Open Scope Z.

Parameter write_tag_bool : mword 64 -> bool -> M unit.
Parameter read_tag_bool : mword 64 -> bool.

(* Platform externs whose types mention model types. *)
Axiom plat_nmi_handler : unit -> xlenbits.
Axiom plat_get_16_random_bits : unit -> M (mword 16).
