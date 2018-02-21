theory Higher_Projective_Space_Rank_Axioms
  imports Main
begin

(* We have a type of points *)
typedecl "Points"

(* We have a rank function "rk" on the sets of points *)
consts rk :: "Points set \<Rightarrow> nat"

(* The function rk satisfies the following axioms *)
axiomatization where
matroid_ax_1a: "\<forall>X. rk X \<ge> 0" and
matroid_ax_1b: "\<forall>X. rk X \<le> card X" and
matroid_ax_2: "\<forall>X Y. X \<subseteq> Y \<longrightarrow> rk X \<le> rk Y" and
matroid_ax_3: "\<forall>X Y. rk (X \<union> Y) + rk (X \<inter> Y) \<le> rk X + rk Y"

(* To capture higher projective geometry, we need to introduce the following additional axioms *)
axiomatization where
rk_ax_singleton: "\<forall>P. rk {P} \<ge> 1" and
rk_ax_couple: "\<forall>P Q. P \<noteq> Q \<longrightarrow> rk {P,Q} \<ge> 2" and
rk_ax_pasch: "\<forall>A B C D. rk {A,B,C,D} \<le> 3 \<longrightarrow> (\<exists>J. rk {A,B,J} = 2 \<and> rk {C,D,J} = 2)" and
rk_axiom_3_points: "\<forall> A B. \<exists>C. rk {A,B,C} = 2 \<and> rk {B,C} = 2 \<and> rk {A,C} = 2" and
rk_ax_dim: "\<exists>A B C D. rk {A,B,C,D} \<ge> 4"

(*
References:
- Nicolas Magaud, Julien Narboux, Pascal Schreck, "A Case Study in Formalizing Projective Geometry
in Coq: Desargues Theorem", Computational Geometry: Theory and Applications, 45 (2012) 406-424.
*)

end




