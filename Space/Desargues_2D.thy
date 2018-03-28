theory Desargues_2D
  imports Main Higher_Projective_Space_Rank_Axioms Matroid_Rank_Properties
begin

(*
Contents:
- We prove Desargues's theorem: if two triangles ABC and A'B'C' are perspective from a point P (ie. 
the lines AA', BB' and CC' are concurrent in P), then they are perspective from a line (ie. the points
\<alpha> = BC \<inter> B'C', \<beta> = AC \<inter> A'C' and \<gamma> = AB \<inter> A'B' are collinear).
In this file we restrict ourself to the case where the two triangles ABC and A'B'C' are coplanar. 
*)

definition desargues_config_2D :: "[Points, Points, Points, Points, Points, Points, Points, Points, Points, Points] \<Rightarrow> bool" 
  where "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma> \<equiv> rk {A, B, C} = 3 \<and> rk {A', B', C'} = 3 \<and> 
rk {A, A', P} = 2 \<and> rk {B, B', P} = 2 \<and> rk {C, C', P} = 2 \<and> rk {A, B, \<gamma>} = 2 \<and> rk {A', B', \<gamma>} = 2 \<and>
rk {A, C, \<beta>} = 2 \<and> rk {A', C', \<beta>} = 2 \<and> rk {B, C, \<alpha>} = 2 \<and> rk {B', C', \<alpha>} = 2 \<and> 
rk {A, B, C, A', B', C'} = 3 \<and> 
(* We add the following non-degeneracy conditions *)
rk {A, B, P} = 3 \<and> rk {A, C, P} = 3 \<and> rk {B, C, P} = 3 \<and> 
rk {A, A'} = 2 \<and> rk {B, B'} = 2 \<and> rk {C, C'} = 2"

lemma coplanar_ABCA'B'C'P :
  assumes "rk {A, A'} = 2" and "rk {A, B, C, A', B', C'} = 3" and "rk {A, A', P} = 2"
  shows "rk {A, B, C, A', B', C', P} = 3"
proof-
  have "rk {A, B, C, A', B', C', P} + rk {A, A'} \<le> rk {A, B, C, A', B', C'} + rk {A, A', P}"
    using matroid_ax_3_alt[of "{A, A'}" "{A, B, C, A', B', C'}" "{A, A', P}"]
    by (simp add: insert_commute)
  then have "rk {A, B, C, A', B', C', P} \<le> 3" 
    using assms(1) assms(2) assms(3)
    by linarith
  then show "rk {A, B, C, A', B', C', P} = 3" 
    using assms(2) matroid_ax_2
    by (metis Un_insert_right Un_upper2 le_antisym sup_bot.right_neutral)
qed

lemma non_colinear_A'B'P :
  assumes "rk {A, B, P} = 3" and "rk {A, A', P} = 2" and "rk {B, B', P} = 2" and "rk {A', P} = 2" 
and "rk {B', P} = 2"
  shows "rk {A', B', P} = 3" 
proof-
  have f1:"rk {A', B', P} \<le> 3" 
    using rk_triple_le by auto
  have "rk {A, B, A', B', P} \<ge> 3" 
    using assms(1) matroid_ax_2
    by (metis insert_mono insert_subset subset_insertI)
  then have f2:"rk {A, B, A', B', P} = 3" 
    using matroid_ax_3_alt[of "{P}" "{A, A', P}" "{B, B', P}"] assms(2) assms(3)
    by (simp add: insert_commute rk_singleton)
  have "rk {A, B, A', B', P} + rk {B', P} \<le> rk {A, A', B', P} + rk {B, B', P}" 
    using matroid_ax_3_alt[of "{B', P}" "{A, A', B', P}" "{B, B', P}"]
    by (simp add: insert_commute)
  then have "rk {A, A', B', P} \<ge> 3" 
    using f2 assms(3) assms(5) by linarith
  then have f3:"rk {A, A', B', P} = 3" 
    using f2 matroid_ax_2
    by (metis eq_iff insert_commute subset_insertI)
  have "rk {A, A', B', P} + rk {A', P} \<le> rk {A', B', P} + rk {A, A', P}" 
    using matroid_ax_3_alt[of "{A', P}" "{A', B', P}" "{A, A', P}"]
    by (simp add: insert_commute)
  then have "rk {A', B', P} \<ge> 3" 
    using f3 assms(2) assms(4) by linarith
  thus "rk {A', B', P} = 3" 
    using f1 by auto
qed

lemma desargues_config_2D_non_collinear_P :
  assumes "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma>" and "rk {A', P} = 2" and "rk {B', P} = 2" 
and "rk {C', P} = 2"
  shows "rk {A', B', P} = 3" and "rk {A', C', P} = 3" and "rk {B', C', P} = 3"
proof-
  show "rk {A', B', P} = 3" 
    using non_colinear_A'B'P assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(3)
    by blast
  show "rk {A', C', P} = 3"
    using non_colinear_A'B'P assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(4)
    by blast
  show "rk {B', C', P} = 3"
    using non_colinear_A'B'P assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(3) assms(4)
    by blast
qed

lemma rk_A'B'PQ :
  assumes "rk {A, A'} = 2" and "rk {A, B, C, A', B', C'} = 3" and "rk {A, A', P} = 2" and 
"rk {A, B, P} = 3" and "rk {B, B', P} = 2" and "rk {A', P} = 2" and "rk {B', P} = 2" and 
"rk {A, B, C, A', B', C', P, Q} \<ge> 4"
  shows "rk {A', B', P, Q} = 4"
proof-
  have "card {A', B', P, Q} \<le> 4"
    by (smt One_nat_def Suc_numeral card.insert card_empty finite.emptyI finite_insert insert_absorb insert_not_empty linear nat_add_left_cancel_le numeral_3_eq_3 numeral_Bit0 numeral_code(3) numeral_le_one_iff numerals(1) one_plus_numeral semiring_norm(4) semiring_norm(69) semiring_norm(70) semiring_norm(8))
  then have f1:"rk {A', B', P, Q} \<le> 4" 
    using matroid_ax_1b dual_order.trans by blast
  have "rk {A, B, C, A', B', C', P, Q} + rk {A', B', P} \<le> rk {A', B', P, Q} + rk {A, B, C, A', B', C', P}"
    using matroid_ax_3_alt[of "{A', B', P}" "{A', B', P, Q}" "{A, B, C, A', B', C', P}"]
    by (simp add: insert_commute)
  then have "rk {A', B', P, Q} \<ge> rk {A, B, C, A', B', C', P, Q} + rk {A', B', P} - rk {A, B, C, A', B', C', P}"
    using le_diff_conv by blast
  then have f2:"rk {A', B', P, Q} \<ge> 4" 
    using assms non_colinear_A'B'P coplanar_ABCA'B'C'P
    by (smt diff_add_inverse2 le_trans)
  from f1 and f2 show "rk {A', B', P, Q} = 4"
    by (simp add: f1 eq_iff)
qed

lemma desargues_config_2D_rkA'B'PQ_rkA'C'PQ_rkB'C'PQ :
  assumes "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma>" and "rk {A', P} = 2" and "rk {B', P} = 2"
and "rk {C', P} = 2" and "rk {A, B, C, A', B', C', P, Q} \<ge> 4"
  shows "rk {A', B', P, Q} = 4" and "rk {A', C', P, Q} = 4" and "rk {B', C', P, Q} = 4"
proof-
  show "rk {A', B', P, Q} = 4" 
    using rk_A'B'PQ[of "A" "A'" "B" "C" "B'" "C'" "P" "Q"] assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] 
assms(2) assms(3) assms(5) by blast
  show "rk {A', C', P, Q} = 4"
    using rk_A'B'PQ[of "A" "A'" "C" "B" "C'" "B'" "P" "Q"] assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(4) assms(5)
    by (metis insert_commute)
  show "rk {B', C', P, Q} = 4"
    using rk_A'B'PQ[of "B" "B'" "C" "A" "C'" "A'" "P" "Q"] assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(3) assms(4) assms(5)
    by (metis insert_commute)
qed

lemma rk_A'B'PR :
  assumes "rk {P, Q, R} = 2" and "rk {P, R} = 2" and "rk {A', B', P, Q} = 4"
shows "rk {A', B', P, R} = 4"
proof-
  have "card {A', B', P, R} \<le> 4"
    by (smt Suc_numeral assms(2) card_empty card_insert_disjoint dual_order.trans finite.emptyI finite_insert insert_absorb linear nat_add_left_cancel_le numeral_2_eq_2 numeral_3_eq_3 numeral_Bit0 numeral_code(3) numeral_le_one_iff rk_singleton rk_triple_le semiring_norm(2) semiring_norm(69) semiring_norm(8))
  then have f1:"rk {A', B', P, R} \<le> 4" 
    using dual_order.trans matroid_ax_1b by auto
  have f2:"rk {A', B', P, Q, R} + rk {P, R} \<le> rk {A', B', P, R} + rk {P, Q, R}" 
    using matroid_ax_3_alt[of "{P, R}" "{A', B', P, R}" "{P, Q, R}"]
    by (simp add: insert_commute)
  have f3:"rk {A', B', P, Q, R} \<ge> 4" using matroid_ax_2 assms(3)
    by (metis insert_mono subset_insertI)
  from f2 and f3 have f4:"rk {A', B', P, R} \<ge> 4" 
    using assms(1) assms(2) by linarith
  thus "rk {A', B', P, R} = 4" using f1 f4
    by (simp add: f1 le_antisym)
qed

lemma rk_A'C'PR :
  assumes "rk {P, Q, R} = 2" and "rk {P, R} = 2" and "rk {A', C', P, Q} = 4"
  shows "rk {A', C', P, R} = 4"
  using assms(1) assms(2) assms(3) rk_A'B'PR by blast

lemma rk_B'C'PR :
  assumes "rk {P, Q, R} = 2" and "rk {P, R} = 2" and "rk {B', C', P, Q} = 4"
  shows "rk {B', C', P, R} = 4"
  using assms(1) assms(2) assms(3) rk_A'C'PR by blast

lemma rk_ABA' :
  assumes "rk {A, B, P} = 3" and "rk {A, A'} = 2" and "rk {A, A', P} = 2"
  shows "rk {A, B, A'} = 3"
proof-
  have "rk {A, B, A', P} + rk {A, A'} \<le> rk {A, B, A'} + rk {A, A', P}" 
    using matroid_ax_3_alt[of "{A, A'}" "{A, B, A'}" "{A, A', P}"]
    by (simp add: insert_commute)
  then have "rk {A, B, A'} \<ge> 3" using assms(1) assms(2) assms(3) matroid_ax_2
    by (smt eq_iff insert_absorb2 insert_commute non_colinear_A'B'P rk_couple)
  thus "rk {A, B, A'} = 3"
    by (simp add: le_antisym rk_triple_le)
qed

lemma desargues_config_2D_non_collinear :
  assumes "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma>"
  shows "rk {A, B, A'} = 3" and "rk {A, B, B'} = 3" and "rk {A, C, C'} = 3"
proof-
  show "rk {A, B, A'} = 3" 
    using assms desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] rk_ABA' by auto
  show "rk {A, B, B'} = 3" 
    using assms desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] rk_ABA'
    by (smt insert_commute)
  show "rk {A, C, C'} = 3" 
    using assms desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] rk_ABA'
    by (smt insert_commute)
qed

lemma rk_Aa :
  assumes "rk {A, B, P} = 3" and "rk {A, A'} = 2" and "rk {A, A', P} = 2" and "rk {Q, A', a} = 2" 
and "rk {A, B, C, A', B', C', P, Q} \<ge> 4" and "rk {A, B, C, A', B', C'} \<le> 3"
  shows "rk {A, a} = 2"
proof-
  have "rk {Q, A', A, a} + rk {a} \<le> rk {Q, A', a} + rk {A, a}" 
    using matroid_ax_3_alt[of "{a}" "{Q, A', a}" "{A, a}"]
    by (simp add: insert_commute)
  then have "rk {Q, A', A, a} \<le> rk {Q, A', a} + rk {A, a} - rk {a}"
    using add_le_imp_le_diff by blast
  then have "rk {Q, A', A, a} \<le> 2" if "rk {A, a} = 1"
    using assms(4)
    by (simp add: rk_singleton that)
  then have "rk {Q, A', A} \<le> 2" if "rk {A, a} = 1" 
    using matroid_ax_2
    by (metis One_nat_def assms(4) le_numeral_extra(4) nat_add_left_cancel_le numeral_2_eq_2 numeral_3_eq_3 one_add_one rk_couple rk_triple_le that)
  then have "rk {Q, A', A} = 2" if "rk {A, a} = 1" 
    using assms(2) matroid_ax_2
    by (metis assms(4) numeral_eq_one_iff rk_couple semiring_norm(85) that) 
  then have "rk {A, A', P, Q} = 2" if "rk {A, a} = 1" 
    using assms(3) matroid_ax_3_alt'[of "{A, A'}" "P" "Q"]
    by (simp add: assms(2) insert_commute that)
  then have f1:"rk {A, A', B, P, Q} \<le> 3" if "rk {A, a} = 1"
    by (metis One_nat_def Un_insert_right add.right_neutral add_Suc_right insert_commute matroid_ax_2_alt numeral_2_eq_2 numeral_3_eq_3 sup_bot.right_neutral that)
  have "rk {A, B, C, A', B', C', P, Q} + rk {A, B, A'} \<le> rk {A, A', B, P, Q} + rk {A, B, C, A', B', C'}"
    using matroid_ax_3_alt[of "{A, B, A'}" "{A, A', B, P, Q}" "{A, B, C, A', B', C'}"]
    by (simp add: insert_commute)
  then have "rk {A, B, C, A', B', C', P, Q} \<le> rk {A, A', B, P, Q} + rk {A, B, C, A', B', C'} - rk {A, B, A'}"
    by linarith
  then have "rk {A, B, C, A', B', C', P, Q} \<le> 3" if "rk {A, a} = 1"
    using assms(1) assms(2) assms(3) assms(6) f1 rk_ABA'
    by (smt \<open>rk {A, B, C, A', B', C', P, Q} + rk {A, B, A'} \<le> rk {A, A', B, P, Q} + rk {A, B, C, A', B', C'}\<close> add_diff_cancel_right' add_leD2 le_less_trans not_le ordered_cancel_comm_monoid_diff_class.add_diff_inverse ordered_cancel_comm_monoid_diff_class.le_add_diff that)
  then have "\<not> (rk {A, a} = 1)" 
    using assms(5) by linarith
  thus "rk {A, a} = 2"
    using rk_couple rk_singleton_bis by blast
qed

lemma desargues_config_2D_rkAa_rkBb_rkCc :
  assumes "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma>" and "rk {A, B, C, A', B', C', P, Q} \<ge> 4"
and "rk {Q, A', a} = 2" and "rk {Q, B', b} = 2" and "rk {Q, C', c} = 2"
  shows "rk {A, a} = 2" and "rk {B, b} = 2" and "rk {C, c} = 2"
proof-
  show "rk {A, a} = 2" 
    using rk_Aa assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(3)
    by (metis rk_triple_le)
  show "rk {B, b} = 2" 
    using rk_Aa assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(4)
    by (smt insert_commute rk_triple_le)
  show "rk {C, c} = 2"
    using rk_Aa[of "C" "A" "P" "C'" "Q" "c" "B" "B'" "A'"] assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(5)
    by (metis insert_commute rk_triple_le)
qed

lemma rk_ABPRa :
  assumes "rk {A, B, P} = 3" and "rk {A, B, C, A', B', C', P} = 3" and "rk {P, Q, R} = 2" 
and "rk {P, R} = 2" and "rk {A', B', P, Q} = 4"
  shows "rk {A, B, P, R, a} \<ge> 4"
proof-
  have "rk {A', B', P, R, a, A, B} \<ge> rk {A', B', P, R}" 
    using matroid_ax_2 by auto
  then have f1:"rk {A', B', P, R, a, A, B} \<ge> 4" 
    using rk_A'B'PR assms(3) assms(4) assms(5) by auto
  have f2:"rk {A', B', A, B, P} \<le> 3" 
    using matroid_ax_2 assms(2)
    by (smt insertI1 insert_subset subset_insertI)
  have "rk {A', B', P, R, a, A, B} + rk {A, B, P} \<le> rk {A, B, P, R, a} + rk {A', B', A, B, P}"
    using matroid_ax_3_alt[of "{A, B, P}" "{A, B, P, R, a}" "{A', B', A, B, P}"]
    by (simp add: insert_commute)
  then have "rk {A, B, P, R, a} \<ge> rk {A', B', P, R, a, A, B} + rk {A, B, P} - rk {A', B', A, B, P}"
    by linarith
  thus "rk {A, B, P, R, a} \<ge> 4" 
    using f1 assms(1) f2
    by linarith
qed

lemma rk_ABPa :
  assumes "rk {A, B, P} = 3" and "rk {A, A'} = 2" and "rk {A, A', P} = 2" and "rk {Q, A', a} = 2"
and "rk {A, B, C, A', B', C', P, Q} \<ge> 4" and "rk {A, B, C, A', B', C', P} = 3" and "rk {P, Q, R} = 2"
and "rk {P, R} = 2" and "rk {A', B', P, Q} = 4" and "rk {R, A, a} = 2"
  shows "rk {A, B, P, a} \<ge> 4"
proof-
  have "rk {A, B, C, A', B', C'} \<le> 3" 
    using matroid_ax_2 assms(6)
    by (smt insert_iff subsetI)
  then have f1:"rk {A, a} = 2" 
    using assms(1) assms(2) assms(3) assms(4) assms(5) rk_Aa by blast
  have f2:"rk {A, B, P, R, a} \<ge> 4" 
    using assms(1) assms(6) assms(7) assms(8) assms(9) rk_ABPRa by blast
  have "rk {A, B, P, R, a} + rk {A, a} \<le> rk {A, B, P, a} + rk {R, A, a}"
    using matroid_ax_3_alt[of "{A, a}" "{A, B, P, a}" "{R, A, a}"]
    by (simp add: insert_commute)
  thus "rk {A, B, P, a} \<ge> 4" using f1 f2 assms(10) 
    by (smt add_le_imp_le_diff diff_add_inverse2 order_trans)
qed

lemma desargues_config_2D_rkABPa_rkABPb_rkABPc :
  assumes "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma>" and "rk {A, B, C, A', B', C', P, Q} \<ge> 4" 
and "rk {P, Q, R} = 2" and "rk {P, R} = 2" and "rk {A', P} = 2" and "rk {B', P} = 2" and "rk {C', P} = 2" 
"rk {Q, A', a} = 2" and "rk {R, A, a} = 2" and "rk {Q, B', b} = 2" and "rk {R, B, b} = 2" and 
"rk {Q, C', c} = 2" and "rk {R, C, c} = 2"
  shows "rk {A, B, P, a} \<ge> 4" and "rk {A, B, P, b} \<ge> 4" and "rk {A, B, P, c} \<ge> 4"
proof-
  have f1:"rk {A, B, C, A', B', C', P} = 3" 
    using assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] coplanar_ABCA'B'C'P by auto
  have f2:"rk {A', B', P, Q} = 4" 
    using assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(2) assms(5) assms(6) rk_A'B'PQ[of "A" "A'" "B" "C" "B'" "C'" "P" "Q"] by auto
  show "rk {A, B, P, a} \<ge> 4" 
    using f1 f2 assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(8) assms(2) assms(3) assms(4) assms(9) rk_ABPa by auto
  show "rk {A, B, P, b} \<ge> 4" 
    using f1 f2 assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] assms(10) assms(2) assms(3) 
assms(4) assms(11) rk_ABPa[of "B" "A" "P" "B'" "Q" "b" "C" "A'" "C'" "R"]
    by (metis insert_commute)
  have f3:"rk {B', C', P, Q} = 4" 
    using desargues_config_2D_rkA'B'PQ_rkA'C'PQ_rkB'C'PQ assms(1) assms(2) assms(5) assms(6) assms(7) by auto
  show "rk {A, B, P, c} \<ge> 4" using assms(1) desargues_config_2D_def[of A B C A' B' C' P \<alpha> \<beta> \<gamma>] rk_ABPa




lemma rk_AA'C :
  assumes "rk {A, C, P} = 3" and "rk {A, A'} = 2" and "rk {A, A', P} = 2"
  shows "rk {A, A', C} \<ge> 3"
proof-
  have f1:"rk {A, C, A', P} \<ge> 3" 
    using assms(1) matroid_ax_2
    by (metis insert_commute subset_insertI)
  have "rk {A, C, A', P} + rk {A, A'} \<le> rk {A, A', C} + rk {A, A', P}" 
    using matroid_ax_3_alt[of "{A, A'}" "{A, A', C}" "{A, A', P}"]
    by (simp add: insert_commute)
  thus "rk {A, A', C} \<ge> 3" 
    using f1 assms(2) assms(3) by linarith
qed

lemma rk_AA'Ca :
  assumes "rk {A, A', C} \<ge> 3" and "rk {A, B, P, a} \<ge> 4" and "rk {A, B, C, A', B', C', P} = 3"
  shows "rk {A, A', C, a} \<ge> 4"
proof-
  have f1:"rk {A, A', C, a, B, P} \<ge> 4" 
    using assms(2) matroid_ax_2
    by (smt dual_order.trans insert_commute insert_mono insert_subset subset_insertI)
  have f2:"rk {A, B, C, P, A'} \<le> 3" 
    using assms(3) matroid_ax_2
    by (smt empty_subsetI insert_commute insert_mono semiring_norm(3))
  have "rk {A, A', C, a, B, P} + rk {A, A', C} \<le> rk {A, A', C, a} + rk {A, B, C, P, A'}"
    using matroid_ax_3_alt[of "{A, A', C}" "{A, A', C, a}" "{A, B, C, P, A'}"]
    by (simp add: insert_commute)
  then have "rk {A, A', C, a} \<ge> rk {A, A', C, a, B, P} + rk {A, A', C} - rk {A, B, C, P, A'}"
    using le_diff_conv by blast
  thus "rk {A, A', C, a} \<ge> 4" using f1 assms(1) f2
    by linarith
qed

theorem desargues_2D :
  assumes "desargues_config_2D A B C A' B' C' P \<alpha> \<beta> \<gamma>"
  shows "rk {\<alpha>, \<beta>, \<gamma>} \<le> 2"