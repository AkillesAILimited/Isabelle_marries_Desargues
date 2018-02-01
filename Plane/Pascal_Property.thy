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
"is_pascal A B C D E F \<equiv> distinct6 A B C D E F \<and>
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
  have "distinct6 F A B C D E"
    using assms distinct6_rot_CW is_pascal_def by blast
  then show "is_pascal F A B C D E"
    using assms is_pascal_def col_def inter_comm_line_line_comm col_rot_CW 
      inter_line_line_comm inter_comm line_comm distinct6_def by auto
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

lemma is_pascal_under_AB:
  assumes "is_pappus" and "line B C \<noteq> line E F" and "line C D \<noteq> line A F"
    and "line A B \<noteq> line D E" and "line A C \<noteq> line E F" and "line B F \<noteq> line C D" 
    and "is_pascal A B C D E F"
  shows "is_pascal B A C D E F"
proof -
  have "distinct6 B A C D E F"
    using assms(7) distinct6_def is_pascal_def by auto
  define W where "W = inter (line A C) (line E F)"
  have "col A C W"
    by (simp add: col_A_B_ABl W_def)
  define P Q R where "P = inter (line B C) (line E F)"
    and "Q = inter (line A B) (line D E)"
    and "R = inter (line C D) (line A F)"
  have "col P Q R"
    using P_def Q_def R_def assms(7) col_2cycle is_pascal_def by force
      (* Below we take care of a few degenerate cases *)
  have "is_pascal B A C D E F" if "P = Q"
    by (smt P_def Q_def \<open>distinct6 B A C D E F\<close> col_ABA col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left inter_comm is_pascal_def that uniq_inter)
  have "is_pascal B A C D E F" if "P = R"
    by (smt P_def R_def \<open>distinct6 B A C D E F\<close> assms(5) assms(6) col_A_B_ABl distinct6_def incidB_lAB incid_inter_left incid_inter_right is_pascal_def line_comm that uniq_inter)
  have "is_pascal B A C D E F" if "P = A"
    by (smt P_def Q_def R_def \<open>P = Q \<Longrightarrow> is_pascal B A C D E F\<close> \<open>P = R \<Longrightarrow> is_pascal B A C D E F\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> assms(2) ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right that)
  have "is_pascal B A C D E F" if "P = C"
    by (smt P_def Q_def R_def \<open>P = R \<Longrightarrow> is_pascal B A C D E F\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right is_pascal_def that)
  have "is_pascal B A C D E F" if "P = W"
    by (smt P_def Q_def R_def W_def \<open>P = C \<Longrightarrow> is_pascal B A C D E F\<close> \<open>P = Q \<Longrightarrow> is_pascal B A C D E F\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right is_pascal_def that) 
  have "is_pascal B A C D E F" if "Q = R"
    by (smt Q_def R_def \<open>distinct6 B A C D E F\<close> ax_uniqueness col_ABB col_def distinct6_def incidA_lAB incid_inter_left incid_inter_right is_pascal_def line_comm that)
  have "is_pascal B A C D E F" if "Q = A"
    by (smt P_def Q_def R_def \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> assms(6) col_ABA col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right is_pascal_def that uniq_inter)
  have "is_pascal B A C D E F" if "Q = C"
    by (smt P_def Q_def R_def \<open>P = Q \<Longrightarrow> is_pascal B A C D E F\<close> \<open>Q = R \<Longrightarrow> is_pascal B A C D E F\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> assms(4) ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right that)
  have "is_pascal B A C D E F" if "Q = W"
    by (metis Q_def W_def \<open>distinct6 B A C D E F\<close> col_ABA is_pascal_def line_comm that)
  have "is_pascal B A C D E F" if "R = A"
    by (smt P_def Q_def R_def \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> assms(6) col_ABA col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right is_pascal_def that uniq_inter)
  have "is_pascal B A C D E F" if "R = C"
    by (smt P_def Q_def R_def W_def \<open>P = R \<Longrightarrow> is_pascal B A C D E F\<close> \<open>P = W \<Longrightarrow> is_pascal B A C D E F\<close> \<open>R = A \<Longrightarrow> is_pascal B A C D E F\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right is_pascal_def that)
  have "is_pascal B A C D E F" if "R = W"
    by (metis R_def W_def \<open>R = A \<Longrightarrow> is_pascal B A C D E F\<close> \<open>R = C \<Longrightarrow> is_pascal B A C D E F\<close> assms(3) ax_uniqueness incidA_lAB incidB_lAB incid_inter_left incid_inter_right that)
  have "is_pascal B A C D E F" if "A = W"
    by (smt P_def Q_def R_def W_def \<open>P = R \<Longrightarrow> is_pascal B A C D E F\<close> \<open>Q = A \<Longrightarrow> is_pascal B A C D E F\<close> \<open>col P Q R\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness col_def distinct6_def incidA_lAB incidB_lAB incid_inter_left incid_inter_right is_pascal_def that)
  have "is_pascal B A C D E F" if "C = W"
    by (metis P_def W_def \<open>P = W \<Longrightarrow> is_pascal B A C D E F\<close> assms(2) ax_uniqueness incidB_lAB incid_inter_left incid_inter_right that)
  have "col (inter (line P C) (line A Q)) (inter (line Q W) (line C R)) 
    (inter (line P W) (line A R))" if "distinct6 P Q R A C W"
    using assms(1) is_pappus_def is_pappus2_def \<open>distinct6 P Q R A C W\<close> \<open>col P Q R\<close>
      \<open>col A C W\<close> inter_is_a_intersec inter_line_line_comm by metis
  have "is_pascal B A C D E F" if "C \<in> line_ext (line E F)"
    using P_def \<open>P = C \<Longrightarrow> is_pascal B A C D E F\<close> assms(2) ax_uniqueness incidB_lAB incid_inter_left incid_inter_right line_ext_def that by fastforce 
  have "is_pascal B A C D E F" if "A \<in> line_ext (line D E)"
    using Q_def \<open>Q = A \<Longrightarrow> is_pascal B A C D E F\<close> assms(4) ax_uniqueness incidA_lAB incid_inter_left incid_inter_right line_ext_def that by blast
  have "is_pascal B A C D E F" if "line B C = line A B"
    by (metis P_def W_def \<open>P = W \<Longrightarrow> is_pascal B A C D E F\<close> \<open>distinct6 B A C D E F\<close> ax_uniqueness distinct6_def incidA_lAB incidB_lAB that)
  have "inter (line P C) (line A Q) = B" if
    "C \<notin> line_ext (line E F)" and "A \<notin> line_ext (line D E)" and "line B C \<noteq> line A B"
    by (smt CollectI P_def Q_def ax_uniqueness incidA_lAB incidB_lAB incid_inter_left incid_inter_right line_ext_def that(1) that(2) that(3))
  have "is_pascal B A C D E F" if "line E F = line A F"
    by (metis W_def \<open>A = W \<Longrightarrow> is_pascal B A C D E F\<close> assms(5) ax_uniqueness incidA_lAB incid_inter_left incid_inter_right that)
  have "inter (line P W) (line A R) = F" if "line E F \<noteq> line A F" 