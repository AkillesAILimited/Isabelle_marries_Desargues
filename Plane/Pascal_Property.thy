theory Pascal_Property
  imports Main Projective_Plane_Axioms Pappus_Property
begin

(* Contents:
- A hexagon is pascal if its three opposite sides meet in collinear points [is_pascal].
- A plane is pascal, or has Pascal property, if for every hexagon of that plane
Pascal property is stable under any permutation of that hexagon. 
*)

definition inters :: "Lines \<Rightarrow> Lines \<Rightarrow> Points set" where
"inters l m \<equiv> {P. incid P l \<and> incid P m}"

lemma inters_is_singleton:
  assumes "l \<noteq> m" and "P \<in> inters l m" and "Q \<in> inters l m"
  shows "P = Q"
  using assms(1) assms(2) assms(3) ax_uniqueness inters_def by blast

definition inter :: "Lines \<Rightarrow> Lines \<Rightarrow> Points" where
"inter l m \<equiv> @P. P \<in> inters l m"

lemma uniq_inter:
  assumes "l \<noteq> m" and "incid P l" and "incid P m"
  shows "inter l m = P"
proof -
  have "P \<in> inters l m"
    by (simp add: assms(2) assms(3) inters_def)
  have "\<forall>Q. Q \<in> inters l m \<longrightarrow> Q = P"
    using \<open>P \<in> inters l m\<close> assms(1) inters_is_singleton by blast
  show "inter l m = P"
    using \<open>P \<in> inters l m\<close> assms(1) inter_def inters_is_singleton by auto
qed

(* The configuration of a hexagon where the three pairs of opposite sides meet in 
collinear points *)
definition is_pascal :: "[Points, Points, Points, Points, Points, Points] \<Rightarrow> bool" where
"is_pascal A B C D E F \<equiv> distinct6 A B C D E F \<longrightarrow> line B C \<noteq> line E F \<longrightarrow> line C D \<noteq> line A F
\<longrightarrow> line A B \<noteq> line D E \<longrightarrow> 
(let P = inter (line B C) (line E F) in
let Q = inter (line C D) (line A F) in
let R = inter (line A B) (line D E) in 
col P Q R)"

lemma col_rot_CW:
  assumes "col P Q R"
  shows "col R P Q"
  using assms col_def by auto

lemma col_2cycle: 
  assumes "col P Q R"
  shows "col P R Q"
  using assms col_def by auto

lemma distinct6_rot_CW:
  assumes "distinct6 A B C D E F"
  shows "distinct6 F A B C D E"
  using assms distinct6_def by auto

lemma lines_comm: "lines P Q = lines Q P"
  using lines_def by auto

lemma line_comm:
  assumes "P \<noteq> Q"
  shows "line P Q = line Q P"
  by (metis ax_uniqueness incidA_lAB incidB_lAB)
  
lemma inters_comm: "inters l m = inters m l"
  using inters_def by auto

lemma inter_comm: "inter l m = inter m l"
  by (simp add: inter_def inters_comm)

lemma inter_line_line_comm:
  assumes "C \<noteq> D"
  shows "inter (line A B) (line C D) = inter (line A B) (line D C)"
  using assms line_comm by auto

lemma inter_line_comm_line:
  assumes "A \<noteq> B"
  shows "inter (line A B) (line C D) = inter (line B A) (line C D)"
  using assms line_comm by auto

lemma inter_comm_line_line_comm:
  assumes "C \<noteq> D" and "line A B \<noteq> line C D"
  shows "inter (line A B) (line C D) = inter (line D C) (line A B)"
  by (metis inter_comm line_comm)

(* Pascal's property is stable under the 6-cycle [A B C D E F] *)
lemma is_pascal_rot_CW:
  assumes "is_pascal A B C D E F"
  shows "is_pascal F A B C D E"
proof -
  define P Q R where "P = inter (line A B) (line D E)" and "Q = inter (line B C) (line E F)" and
    "R = inter (line F A) (line C D)"
  have "col P Q R" if "distinct6 F A B C D E" and "line A B \<noteq> line D E" and "line B C \<noteq> line E F" 
    and "line F A \<noteq> line C D"
    using P_def Q_def R_def assms col_rot_CW distinct6_def inter_comm is_pascal_def line_comm that(1) that(2) that(3) that(4) by auto
  then show "is_pascal F A B C D E"
    by (metis P_def Q_def R_def is_pascal_def line_comm)
qed

(* We recall that the group of permutations S_6 is generated by the 2-cycle [1 2]
and the 6-cycle [1 2 3 4 5 6] *)

(* Assuming Pappus property, Pascal property is stable under the 2-cycle [A B] *)

lemma incid_C_AB: 
  assumes "A \<noteq> B" and "incid A l" and "incid B l" and "incid C l"
  shows "incid C (line A B)"
  using assms(1) assms(2) assms(3) assms(4) ax_uniqueness incidA_lAB incidB_lAB by blast

lemma incid_inters_left: 
  assumes "P \<in> inters l m"
  shows "incid P l"
  using assms inters_def by auto

lemma incid_inters_right:
  assumes "P \<in> inters l m"
  shows "incid P m"
  using assms incid_inters_left inters_comm by blast

lemma inter_in_inters: "inter l m \<in> inters l m"
proof -
  have "\<exists>P. P \<in> inters l m"
    using inters_def ax2 by auto
  show "inter l m \<in> inters l m"
    by (metis \<open>\<exists>P. P \<in> inters l m\<close> inter_def some_eq_ex)
qed

lemma incid_inter_left: "incid (inter l m) l"
  using incid_inters_left inter_in_inters by blast

lemma incid_inter_right: "incid (inter l m) m"
  using incid_inter_left inter_comm by fastforce

lemma col_A_B_ABl: "col A B (inter (line A B) l)"
  using col_def incidA_lAB incidB_lAB incid_inter_left by blast

lemma col_A_B_lAB: "col A B (inter l (line A B))"
  using col_A_B_ABl inter_comm by auto

lemma inter_is_a_intersec: "is_a_intersec (inter (line A B) (line C D)) A B C D"
  by (simp add: col_A_B_ABl col_A_B_lAB col_rot_CW is_a_intersec_def)

definition line_ext :: "Lines \<Rightarrow> Points set" where
"line_ext l \<equiv> {P. incid P l}"

lemma line_left_inter_1: 
  assumes "P \<in> line_ext l" and "P \<notin> line_ext m"
  shows "line (inter l m) P = l"
  by (metis CollectD CollectI assms(1) assms(2) incidA_lAB incidB_lAB incid_inter_left incid_inter_right line_ext_def uniq_inter)

lemma line_left_inter_2:
  assumes "P \<in> line_ext m" and "P \<notin> line_ext l"
  shows "line (inter l m) P = m"
  using assms(1) assms(2) inter_comm line_left_inter_1 by fastforce

lemma line_right_inter_1:
  assumes "P \<in> line_ext l" and "P \<notin> line_ext m"
  shows "line P (inter l m) = l"
  by (metis assms(1) assms(2) line_comm line_left_inter_1)

lemma line_right_inter_2:
  assumes "P \<in> line_ext m" and "P \<notin> line_ext l"
  shows "line P (inter l m) = m"
  by (metis assms(1) assms(2) inter_comm line_comm line_left_inter_1)

lemma inter_ABC_1: 
  assumes "line A B \<noteq> line C A"
  shows "inter (line A B) (line C A) = A"
  using assms ax_uniqueness incidA_lAB incidB_lAB incid_inter_left incid_inter_right by blast

lemma line_inter_2:
  assumes "inter l m \<noteq> inter l' m" 
  shows "line (inter l m) (inter l' m) = m"
  using assms ax_uniqueness incidA_lAB incidB_lAB incid_inter_right by blast

lemma col_line_ext_1:
  assumes "col A B C" and "A \<noteq> C"
  shows "B \<in> line_ext (line A C)"
  by (metis CollectI assms(1) assms(2) ax_uniqueness col_def incidA_lAB incidB_lAB line_ext_def)

lemma inter_line_ext_1:
  assumes "inter l m \<in> line_ext n" and "l \<noteq> m" and "l \<noteq> n"
  shows "inter l m = inter l n"
  using assms(1) assms(3) ax_uniqueness incid_inter_left incid_inter_right line_ext_def by blast

lemma inter_line_ext_2:
  assumes "inter l m \<in> line_ext n" and "l \<noteq> m" and "m \<noteq> n"
  shows "inter l m = inter m n"
  by (metis assms(1) assms(2) assms(3) inter_comm inter_line_ext_1)

definition pascal_prop :: "bool" where
"pascal_prop \<equiv> \<forall>A B C D E F. is_pascal A B C D E F \<longrightarrow> is_pascal B A C D E F"

lemma pappus_pascal:
  assumes "is_pappus"
  shows "pascal_prop"
proof-
  have "is_pascal B A C D E F" if "is_pascal A B C D E F" for A B C D E F
  proof-
  define X Y Z where "X = inter (line A C) (line E F)" and "Y = inter (line C D) (line B F)"
   and "Z = inter (line B A) (line D E)" 
  have "col X Y Z" if "distinct6 B A C D E F" and "line A C \<noteq> line E F" and "line C D \<noteq> line B F" 
    and "line B A \<noteq> line D E" and "line B C = line E F"
   by (smt X_def Y_def ax_uniqueness col_ABA col_rot_CW distinct6_def incidB_lAB incid_inter_left incid_inter_right line_comm that(1) that(2) that(3) that(5))
  have "col X Y Z" if "distinct6 B A C D E F" and "line A C \<noteq> line E F" and "line C D \<noteq> line B F" 
    and "line B A \<noteq> line D E" and "line C D = line A F"
    by (metis X_def Y_def col_ABA col_rot_CW distinct6_def inter_ABC_1 line_comm that(1) that(2) that(3) that(5))
  have "col X Y Z" if "distinct6 B A C D E F" and "line A C \<noteq> line E F" and "line C D \<noteq> line B F" 
    and "line B A \<noteq> line D E" and "line B C \<noteq> line E F" and "line C D \<noteq> line A F"
  proof-
  define W where "W = inter (line A C) (line E F)"
  have "col A C W"
    by (simp add: col_A_B_ABl W_def)
  define P Q R where "P = inter (line B C) (line E F)"
    and "Q = inter (line A B) (line D E)"
    and "R = inter (line C D) (line A F)"
  have "col P Q R"
    using P_def Q_def R_def \<open>is_pascal A B C D E F\<close> col_2cycle distinct6_def is_pascal_def line_comm that(1) that(4) that(5) that(6) by auto
      (* Below we take care of a few degenerate cases *)
  have "col X Y Z" if "P = Q"
    by (smt P_def Q_def X_def Y_def Z_def \<open>distinct6 B A C D E F\<close> ax_uniqueness col_ABA col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left inter_comm that)
  have "col X Y Z" if "P = R"
    by (smt P_def R_def X_def Y_def Z_def \<open>distinct6 B A C D E F\<close> \<open>line A C \<noteq> line E F\<close> \<open>line C D \<noteq> line B F\<close> col_2cycle col_A_B_ABl col_rot_CW distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right that uniq_inter)
  have "col X Y Z" if "P = A"
    by (smt P_def Q_def R_def X_def Y_def Z_def \<open>P = Q \<Longrightarrow> col X Y Z\<close> \<open>P = R \<Longrightarrow> col X Y Z\<close> \<open>col P Q R\<close> \<open>line B C \<noteq> line E F\<close> ax_uniqueness col_def incidA_lAB incid_inter_left incid_inter_right line_comm that)
  have "col X Y Z" if "P = C"
    by (smt P_def Q_def R_def X_def Y_def Z_def \<open>P = R \<Longrightarrow> col X Y Z\<close> \<open>col P Q R\<close> \<open>line A C \<noteq> line E F\<close> ax_uniqueness col_def incidA_lAB incid_inter_left incid_inter_right line_comm that)
  have "col X Y Z" if "P = W"
    by (smt P_def Q_def R_def W_def X_def Y_def Z_def \<open>P = C \<Longrightarrow> col X Y Z\<close> \<open>P = Q \<Longrightarrow> col X Y Z\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_def distinct6_def incidB_lAB incid_inter_left incid_inter_right line_comm that) 
  have "col X Y Z" if "Q = R"
    by (smt Q_def R_def X_def Y_def Z_def \<open>distinct6 B A C D E F\<close> ax_uniqueness col_A_B_lAB col_rot_CW distinct6_def incidB_lAB incid_inter_right inter_comm line_comm that)
  have "col X Y Z" if "Q = A"
    by (smt P_def Q_def R_def X_def Y_def Z_def \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> \<open>line C D \<noteq> line B F\<close> ax_uniqueness col_ABA col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right that)
  have "col X Y Z" if "Q = C"
    by (metis P_def Q_def W_def \<open>P = W \<Longrightarrow> col X Y Z\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness distinct6_def incidA_lAB incid_inter_left line_comm that)
  have "col X Y Z" if "Q = W"
    by (metis Q_def W_def X_def Z_def col_ABA line_comm that)
  have "col X Y Z" if "R = A"
    by (smt P_def Q_def R_def W_def X_def Y_def \<open>P = W \<Longrightarrow> col X Y Z\<close> \<open>Q = A \<Longrightarrow> col X Y Z\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_ABA col_def col_rot_CW distinct6_def incidA_lAB incidB_lAB incid_inter_right inter_comm that)
  have "col X Y Z" if "R = C"
    by (smt P_def Q_def R_def X_def Y_def Z_def \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> \<open>line A C \<noteq> line E F\<close> ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left inter_comm that)
  have "col X Y Z" if "R = W"
    by (metis R_def W_def \<open>R = A \<Longrightarrow> col X Y Z\<close> \<open>R = C \<Longrightarrow> col X Y Z\<close> \<open>line C D \<noteq> line A F\<close> ax_uniqueness incidA_lAB incidB_lAB incid_inter_left incid_inter_right that)
  have "col X Y Z" if "A = W"
    by (smt P_def Q_def R_def W_def X_def Y_def Z_def \<open>P = R \<Longrightarrow> col X Y Z\<close> \<open>Q = A \<Longrightarrow> col X Y Z\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right that)
  have "col X Y Z" if "C = W"
    by (metis P_def W_def \<open>P = C \<Longrightarrow> col X Y Z\<close> \<open>line B C \<noteq> line E F\<close> ax_uniqueness incidB_lAB incid_inter_left incid_inter_right that)
  have f1:"col (inter (line P C) (line A Q)) (inter (line Q W) (line C R)) 
    (inter (line P W) (line A R))" if "distinct6 P Q R A C W"
    using assms(1) is_pappus_def is_pappus2_def \<open>distinct6 P Q R A C W\<close> \<open>col P Q R\<close>
      \<open>col A C W\<close> inter_is_a_intersec inter_line_line_comm by metis
  have "col X Y Z" if "C \<in> line_ext (line E F)"
    using P_def \<open>P = C \<Longrightarrow> col X Y Z\<close> \<open>line B C \<noteq> line E F\<close> incidB_lAB line_ext_def that uniq_inter by auto 
  have "col X Y Z" if "A \<in> line_ext (line D E)"
    by (metis Q_def \<open>Q = A \<Longrightarrow> col X Y Z\<close> \<open>line B A \<noteq> line D E\<close> ax_uniqueness incidA_lAB incid_inter_left incid_inter_right line_comm line_ext_def mem_Collect_eq that)
  have "col X Y Z" if "line B C = line A B"
    by (metis P_def W_def \<open>P = W \<Longrightarrow> col X Y Z\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness distinct6_def incidA_lAB incidB_lAB that)
  (* We can resume our proof with the non-degenerate case *)
  have f2:"inter (line P C) (line A Q) = B" if
    "C \<notin> line_ext (line E F)" and "A \<notin> line_ext (line D E)" and "line B C \<noteq> line A B"
    by (smt CollectI P_def Q_def ax_uniqueness incidA_lAB incidB_lAB incid_inter_left incid_inter_right line_ext_def that(1) that(2) that(3))
  (* Again, we need to take care of a few particular cases *)
  have "col X Y Z" if "line E F = line A F"
    by (metis W_def \<open>A = W \<Longrightarrow> col X Y Z\<close> \<open>line A C \<noteq> line E F\<close> inter_ABC_1 inter_comm that)
  have "col X Y Z" if "A \<in> line_ext (line C D)"
    using R_def \<open>R = A \<Longrightarrow> col X Y Z\<close> \<open>line C D \<noteq> line A F\<close> ax_uniqueness incidA_lAB incid_inter_left incid_inter_right line_ext_def that by blast 
  have "col X Y Z" if "inter (line B C) (line E F) = inter (line A C) (line E F)"
    by (simp add: P_def W_def \<open>P = W \<Longrightarrow> col X Y Z\<close> that)
  (* We resume the general case *)
  have f3:"inter (line P W) (line A R) = F" if "line E F \<noteq> line A F" and "A \<notin> line_ext (line C D)"
    and "inter (line B C) (line E F) \<noteq> inter (line A C) (line E F)"
    by (smt CollectI P_def R_def W_def ax_uniqueness incidA_lAB incidB_lAB incid_inter_left incid_inter_right line_ext_def that(1) that(2) that(3))
  (* Once again, first we need to handle a particular case, namely C \<in> AF, then 
  we resume the general case *)
  have "col X Y Z" if "C \<in> line_ext (line A F)"
    using R_def \<open>R = C \<Longrightarrow> col X Y Z\<close> \<open>line C D \<noteq> line A F\<close> ax_uniqueness incidA_lAB incid_inter_left incid_inter_right line_ext_def that by blast
  have f4:"inter (line Q W) (line C R) = inter (line Q W) (line C D)" if "C \<notin> line_ext (line A F)"
    using R_def incidA_lAB line_ext_def line_right_inter_1 that by auto
  then have "inter (line Q W) (line C D) \<in> line_ext (line B F)" if "distinct6 P Q R A C W"
    and  "C \<notin> line_ext (line E F)" and "A \<notin> line_ext (line D E)" and "line B C \<noteq> line A B"
    and "line E F \<noteq> line A F" and "A \<notin> line_ext (line C D)"
    and "inter (line B C) (line E F) \<noteq> inter (line A C) (line E F)"
    by (smt R_def \<open>distinct6 B A C D E F\<close> ax_uniqueness col_line_ext_1 distinct6_def f1 f2 f3 incidA_lAB incidB_lAB incid_inter_left that(1) that(2) that(3) that(5) that(6) that(7))
  then have "inter (line Q W) (line C D) = inter (line C D) (line B F)" if "distinct6 P Q R A C W"
    and  "C \<notin> line_ext (line E F)" and "A \<notin> line_ext (line D E)" and "line B C \<noteq> line A B"
    and "line E F \<noteq> line A F" and "A \<notin> line_ext (line C D)"
    and "inter (line B C) (line E F) \<noteq> inter (line A C) (line E F)"
    by (smt W_def \<open>distinct6 B A C D E F\<close> \<open>line C D \<noteq> line B F\<close> ax_uniqueness distinct6_def f2 incidA_lAB incidB_lAB incid_inter_left incid_inter_right inter_line_ext_2 that(1) that(2) that(3) that(5) that(6) that(7))
  moreover have "inter (line C D) (line B F) \<in> line_ext (line Q W)" if "distinct6 P Q R A C W"
    and  "C \<notin> line_ext (line E F)" and "A \<notin> line_ext (line D E)" and "line B C \<noteq> line A B"
    and "line E F \<noteq> line A F" and "A \<notin> line_ext (line C D)"
    and "inter (line B C) (line E F) \<noteq> inter (line A C) (line E F)"
    by (metis calculation col_2cycle col_A_B_ABl col_line_ext_1 distinct6_def that(1) that(2) that(3) that(4) that(5) that(6) that(7))
  ultimately have "col (inter (line A C) (line E F)) (inter (line C D) (line B F))
   (inter (line A B) (line D E))" if "distinct6 P Q R A C W"
    and  "C \<notin> line_ext (line E F)" and "A \<notin> line_ext (line D E)" and "line B C \<noteq> line A B"
    and "line E F \<noteq> line A F" and "A \<notin> line_ext (line C D)"
    and "inter (line B C) (line E F) \<noteq> inter (line A C) (line E F)"
    by (metis Q_def W_def col_A_B_ABl col_rot_CW that(1) that(2) that(3) that(4) that(5) that(6) that(7))
  show "col X Y Z"
    by (metis P_def W_def X_def Y_def Z_def \<open>A = W \<Longrightarrow> col X Y Z\<close> \<open>A \<in> line_ext (line C D) \<Longrightarrow> col X Y Z\<close> \<open>A \<in> line_ext (line D E) \<Longrightarrow> col X Y Z\<close> \<open>C = W \<Longrightarrow> col X Y Z\<close> \<open>C \<in> line_ext (line E F) \<Longrightarrow> col X Y Z\<close> \<open>P = A \<Longrightarrow> col X Y Z\<close> \<open>P = C \<Longrightarrow> col X Y Z\<close> \<open>P = Q \<Longrightarrow> col X Y Z\<close> \<open>P = R \<Longrightarrow> col X Y Z\<close> \<open>Pascal_Property.inter (line B C) (line E F) = Pascal_Property.inter (line A C) (line E F) \<Longrightarrow> col X Y Z\<close> \<open>Q = A \<Longrightarrow> col X Y Z\<close> \<open>Q = C \<Longrightarrow> col X Y Z\<close> \<open>Q = R \<Longrightarrow> col X Y Z\<close> \<open>Q = W \<Longrightarrow> col X Y Z\<close> \<open>R = A \<Longrightarrow> col X Y Z\<close> \<open>R = C \<Longrightarrow> col X Y Z\<close> \<open>R = W \<Longrightarrow> col X Y Z\<close> \<open>\<lbrakk>distinct6 P Q R A C W; C \<notin> line_ext (line E F); A \<notin> line_ext (line D E); line B C \<noteq> line A B; line E F \<noteq> line A F; A \<notin> line_ext (line C D); Pascal_Property.inter (line B C) (line E F) \<noteq> Pascal_Property.inter (line A C) (line E F)\<rbrakk> \<Longrightarrow> col (Pascal_Property.inter (line A C) (line E F)) (Pascal_Property.inter (line C D) (line B F)) (Pascal_Property.inter (line A B) (line D E))\<close> \<open>line B C = line A B \<Longrightarrow> col X Y Z\<close> \<open>line E F = line A F \<Longrightarrow> col X Y Z\<close> distinct6_def line_comm)
qed
  show "is_pascal B A C D E F"
    using X_def Y_def Z_def \<open>\<lbrakk>distinct6 B A C D E F; line A C \<noteq> line E F; line C D \<noteq> line B F; line B A \<noteq> line D E; line B C = line E F\<rbrakk> \<Longrightarrow> col X Y Z\<close> \<open>\<lbrakk>distinct6 B A C D E F; line A C \<noteq> line E F; line C D \<noteq> line B F; line B A \<noteq> line D E; line B C \<noteq> line E F; line C D \<noteq> line A F\<rbrakk> \<Longrightarrow> col X Y Z\<close> \<open>\<lbrakk>distinct6 B A C D E F; line A C \<noteq> line E F; line C D \<noteq> line B F; line B A \<noteq> line D E; line C D = line A F\<rbrakk> \<Longrightarrow> col X Y Z\<close> is_pascal_def by force
qed
  thus "pascal_prop" using pascal_prop_def by auto
qed

lemma is_pascal_under_alternate_vertices:
  assumes "pascal_prop" and "is_pascal A B C A' B' C'"
  shows "is_pascal A B' C A' B C'"
  using assms(1) assms(2) pascal_prop_def is_pascal_rot_CW by presburger

lemma col_inter:
  assumes "distinct6 A B C D E F" and "col A B C" and "col D E F"
  shows "inter (line B C) (line E F) = inter (line A B) (line D E)"
  by (smt assms(1) assms(2) assms(3) ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB)

lemma pascal_pappus1:
  assumes "pascal_prop"
  shows "is_pappus1 A B C A' B' C' P Q R"
proof-
  define a1 a2 a3 a4 a5 a6 where "a1 = distinct6 A B C A' B' C'"  and "a2 = col A B C" and "a3 = col A' B' C'" and 
    "a4 = is_a_proper_intersec P A B' A' B" and "a5 = is_a_proper_intersec Q B C' B' C" and "a6 = is_a_proper_intersec R A C' A' C" 
  (* i.e. we have assumed a Pappus configuration *)
  have "inter (line B C) (line B' C') = inter (line A B) (line A' B')" if a1 a2 a3 a4 a5 a6
    using a1_def a2_def a3_def col_inter that(1) that(2) that(3) by blast
  then have "is_pascal A B C A' B' C'" if a1 a2 a3 a4 a5 a6
    using a1_def col_ABA is_pascal_def that(1) that(2) that(3) that(4) that(5) that(6) by auto
  then have "is_pascal A B' C A' B C'" if a1 a2 a3 a4 a5 a6
    using assms is_pascal_under_alternate_vertices that(1) that(2) that(3) that(4) that(5) that(6) by blast
  then have "col P Q R" if a1 a2 a3 a4 a5 a6
    by (smt a1_def a4_def a5_def a6_def ax_uniqueness col_def distinct6_def incidB_lAB incid_inter_left incid_inter_right is_a_proper_intersec_def is_pascal_def line_comm that(1) that(2) that(3) that(4) that(5) that(6))
  show "is_pappus1 A B C A' B' C' P Q R"
    by (simp add: \<open>\<lbrakk>a1; a2; a3; a4; a5; a6\<rbrakk> \<Longrightarrow> col P Q R\<close> a1_def a2_def a3_def a4_def a5_def a6_def is_pappus1_def)
qed

lemma pascal_pappus:
  assumes "pascal_prop"
  shows "is_pappus"
  by (simp add: assms is_pappus_def pappus12 pascal_pappus1)

theorem pappus_iff_pascal: "is_pappus = pascal_prop"
  using pappus_pascal pascal_pappus by blast

end





