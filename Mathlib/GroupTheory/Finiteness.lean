/-
Copyright (c) 2021 Riccardo Brasca. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Riccardo Brasca

! This file was ported from Lean 3 source module group_theory.finiteness
! leanprover-community/mathlib commit dde670c9a3f503647fd5bfdf1037bad526d3397a
! Please do not edit these lines, except to modify the commit id
! if you have ported upstream changes.
-/
import Mathlib.Data.Set.Pointwise.Finite
import Mathlib.GroupTheory.QuotientGroup
import Mathlib.GroupTheory.Submonoid.Operations
import Mathlib.GroupTheory.Subgroup.Basic
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Data.Finset.Preimage

/-!
# Finitely generated monoids and groups

We define finitely generated monoids and groups. See also `Submodule.Fg` and `Module.Finite` for
finitely-generated modules.

## Main definition

* `Submonoid.Fg S`, `AddSubmonoid.Fg S` : A submonoid `S` is finitely generated.
* `Monoid.Fg M`, `AddMonoid.Fg M` : A typeclass indicating a type `M` is finitely generated as a
monoid.
* `Subgroup.Fg S`, `AddSubgroup.fg S` : A subgroup `S` is finitely generated.
* `Group.Fg M`, `AddGroup.Fg M` : A typeclass indicating a type `M` is finitely generated as a
group.

-/


/-! ### Monoids and submonoids -/


open Pointwise

variable {M N : Type _} [Monoid M] [AddMonoid N]

section Submonoid

/-- A submonoid of `M` is finitely generated if it is the closure of a finite subset of `M`. -/
@[to_additive]
def Submonoid.Fg (P : Submonoid M) : Prop :=
  ∃ S : Finset M, Submonoid.closure ↑S = P
#align submonoid.fg Submonoid.Fg
#align add_submonoid.fg AddSubmonoid.Fg

/-- An additive submonoid of `N` is finitely generated if it is the closure of a finite subset of
`M`. -/
add_decl_doc AddSubmonoid.Fg

/-- An equivalent expression of `Submonoid.Fg` in terms of `Set.Finite` instead of `Finset`. -/
@[to_additive "An equivalent expression of `AddSubmonoid.fg` in terms of `Set.Finite` instead of
`Finset`."]
theorem Submonoid.fg_iff (P : Submonoid M) :
    Submonoid.Fg P ↔ ∃ S : Set M, Submonoid.closure S = P ∧ S.Finite :=
  ⟨fun ⟨S, hS⟩ => ⟨S, hS, Finset.finite_toSet S⟩, fun ⟨S, hS, hf⟩ =>
    ⟨Set.Finite.toFinset hf, by simp [hS]⟩⟩
#align submonoid.fg_iff Submonoid.fg_iff
#align add_submonoid.fg_iff AddSubmonoid.fg_iff

theorem Submonoid.fg_iff_add_fg (P : Submonoid M) : P.Fg ↔ P.toAddSubmonoid.Fg :=
  ⟨fun h =>
    let ⟨S, hS, hf⟩ := (Submonoid.fg_iff _).1 h
    (AddSubmonoid.fg_iff _).mpr
      ⟨Additive.toMul ⁻¹' S, by simp [← Submonoid.toAddSubmonoid_closure, hS], hf⟩,
    fun h =>
    let ⟨T, hT, hf⟩ := (AddSubmonoid.fg_iff _).1 h
    (Submonoid.fg_iff _).mpr
      ⟨Multiplicative.ofAdd ⁻¹' T, by simp [← AddSubmonoid.toSubmonoid'_closure, hT], hf⟩⟩
#align submonoid.fg_iff_add_fg Submonoid.fg_iff_add_fg

theorem AddSubmonoid.fg_iff_mul_fg (P : AddSubmonoid N) : P.Fg ↔ P.toSubmonoid.Fg := by
  convert (Submonoid.fg_iff_add_fg (toSubmonoid P)).symm
#align add_submonoid.fg_iff_mul_fg AddSubmonoid.fg_iff_mul_fg

end Submonoid

section Monoid

variable (M N)

/-- A monoid is finitely generated if it is finitely generated as a submonoid of itself. -/
class Monoid.Fg : Prop where
  out : (⊤ : Submonoid M).Fg
#align monoid.fg Monoid.Fg

/-- An additive monoid is finitely generated if it is finitely generated as an additive submonoid of
itself. -/
class AddMonoid.Fg : Prop where
  out : (⊤ : AddSubmonoid N).Fg
#align add_monoid.fg AddMonoid.Fg

attribute [to_additive] Monoid.Fg

variable {M N}

theorem Monoid.fg_def : Monoid.Fg M ↔ (⊤ : Submonoid M).Fg :=
  ⟨fun h => h.1, fun h => ⟨h⟩⟩
#align monoid.fg_def Monoid.fg_def

theorem AddMonoid.fg_def : AddMonoid.Fg N ↔ (⊤ : AddSubmonoid N).Fg :=
  ⟨fun h => h.1, fun h => ⟨h⟩⟩
#align add_monoid.fg_def AddMonoid.fg_def

/-- An equivalent expression of `Monoid.Fg` in terms of `Set.Finite` instead of `Finset`. -/
@[to_additive
      "An equivalent expression of `AddMonoid.fg` in terms of `Set.Finite` instead of `Finset`."]
theorem Monoid.fg_iff :
    Monoid.Fg M ↔ ∃ S : Set M, Submonoid.closure S = (⊤ : Submonoid M) ∧ S.Finite :=
  ⟨fun h => (Submonoid.fg_iff ⊤).1 h.out, fun h => ⟨(Submonoid.fg_iff ⊤).2 h⟩⟩
#align monoid.fg_iff Monoid.fg_iff
#align add_monoid.fg_iff AddMonoid.fg_iff

theorem Monoid.fg_iff_add_fg : Monoid.Fg M ↔ AddMonoid.Fg (Additive M) :=
  ⟨fun h => ⟨(Submonoid.fg_iff_add_fg ⊤).1 h.out⟩, fun h => ⟨(Submonoid.fg_iff_add_fg ⊤).2 h.out⟩⟩
#align monoid.fg_iff_add_fg Monoid.fg_iff_add_fg

theorem AddMonoid.fg_iff_mul_fg : AddMonoid.Fg N ↔ Monoid.Fg (Multiplicative N) :=
  ⟨fun h => ⟨(AddSubmonoid.fg_iff_mul_fg ⊤).1 h.out⟩, fun h =>
    ⟨(AddSubmonoid.fg_iff_mul_fg ⊤).2 h.out⟩⟩
#align add_monoid.fg_iff_mul_fg AddMonoid.fg_iff_mul_fg

instance AddMonoid.fg_of_monoid_fg [Monoid.Fg M] : AddMonoid.Fg (Additive M) :=
  Monoid.fg_iff_add_fg.1 ‹_›
#align add_monoid.fg_of_monoid_fg AddMonoid.fg_of_monoid_fg

instance Monoid.fg_of_addMonoid_fg [AddMonoid.Fg N] : Monoid.Fg (Multiplicative N) :=
  AddMonoid.fg_iff_mul_fg.1 ‹_›
#align monoid.fg_of_add_monoid_fg Monoid.fg_of_addMonoid_fg

@[to_additive]
instance (priority := 100) Monoid.fg_of_finite [Finite M] : Monoid.Fg M := by
  cases nonempty_fintype M
  exact ⟨⟨Finset.univ, by rw [Finset.coe_univ] ; exact Submonoid.closure_univ⟩⟩
#align monoid.fg_of_finite Monoid.fg_of_finite
#align add_monoid.fg_of_finite AddMonoid.fg_of_finite

end Monoid

@[to_additive]
theorem Submonoid.Fg.map {M' : Type _} [Monoid M'] {P : Submonoid M} (h : P.Fg) (e : M →* M') :
    (P.map e).Fg := by
  classical
    obtain ⟨s, rfl⟩ := h
    exact ⟨s.image e, by rw [Finset.coe_image, MonoidHom.map_mclosure]⟩
#align submonoid.fg.map Submonoid.Fg.map
#align add_submonoid.fg.map AddSubmonoid.Fg.map

@[to_additive]
theorem Submonoid.Fg.map_injective {M' : Type _} [Monoid M'] {P : Submonoid M} (e : M →* M')
    (he : Function.Injective e) (h : (P.map e).Fg) : P.Fg := by
  obtain ⟨s, hs⟩ := h
  use s.preimage e (he.injOn _)
  apply Submonoid.map_injective_of_injective he
  rw [← hs, MonoidHom.map_mclosure e, Finset.coe_preimage]
  congr
  rw [Set.image_preimage_eq_iff, ← MonoidHom.coe_mrange e, ← Submonoid.closure_le, hs,
      MonoidHom.mrange_eq_map e]
  exact Submonoid.monotone_map le_top
#align submonoid.fg.map_injective Submonoid.Fg.map_injective
#align add_submonoid.fg.map_injective AddSubmonoid.Fg.map_injective

@[to_additive (attr := simp)]
theorem Monoid.fg_iff_submonoid_fg (N : Submonoid M) : Monoid.Fg N ↔ N.Fg := by
  conv_rhs => rw [← N.range_subtype, MonoidHom.mrange_eq_map]
  exact ⟨fun h => h.out.map N.subtype, fun h => ⟨h.map_injective N.subtype Subtype.coe_injective⟩⟩
#align monoid.fg_iff_submonoid_fg Monoid.fg_iff_submonoid_fg
#align add_monoid.fg_iff_add_submonoid_fg AddMonoid.fg_iff_addSubmonoid_fg

@[to_additive]
theorem Monoid.fg_of_surjective {M' : Type _} [Monoid M'] [Monoid.Fg M] (f : M →* M')
    (hf : Function.Surjective f) : Monoid.Fg M' := by
  classical
    obtain ⟨s, hs⟩ := Monoid.fg_def.mp ‹_›
    use s.image f
    rwa [Finset.coe_image, ← MonoidHom.map_mclosure, hs, ← MonoidHom.mrange_eq_map,
      MonoidHom.mrange_top_iff_surjective]
#align monoid.fg_of_surjective Monoid.fg_of_surjective
#align add_monoid.fg_of_surjective AddMonoid.fg_of_surjective

@[to_additive]
instance Monoid.fg_range {M' : Type _} [Monoid M'] [Monoid.Fg M] (f : M →* M') :
    Monoid.Fg (MonoidHom.mrange f) :=
  Monoid.fg_of_surjective f.mrangeRestrict f.mrangeRestrict_surjective
#align monoid.fg_range Monoid.fg_range
#align add_monoid.fg_range AddMonoid.fg_range

@[to_additive AddSubmonoid.multiples_fg]
theorem Submonoid.powers_fg (r : M) : (Submonoid.powers r).Fg :=
  ⟨{r}, (Finset.coe_singleton r).symm ▸ (Submonoid.powers_eq_closure r).symm⟩
#align submonoid.powers_fg Submonoid.powers_fg
#align add_submonoid.multiples_fg AddSubmonoid.multiples_fg

@[to_additive AddMonoid.multiples_fg]
instance Monoid.powers_fg (r : M) : Monoid.Fg (Submonoid.powers r) :=
  (Monoid.fg_iff_submonoid_fg _).mpr (Submonoid.powers_fg r)
#align monoid.powers_fg Monoid.powers_fg
#align add_monoid.multiples_fg AddMonoid.multiples_fg

@[to_additive]
instance Monoid.closure_finset_fg (s : Finset M) : Monoid.Fg (Submonoid.closure (s : Set M)) := by
  refine' ⟨⟨s.preimage Subtype.val (Subtype.coe_injective.injOn _), _⟩⟩
  rw [Finset.coe_preimage, Submonoid.closure_closure_coe_preimage]
#align monoid.closure_finset_fg Monoid.closure_finset_fg
#align add_monoid.closure_finset_fg AddMonoid.closure_finset_fg

@[to_additive]
instance Monoid.closure_finite_fg (s : Set M) [Finite s] : Monoid.Fg (Submonoid.closure s) :=
  haveI := Fintype.ofFinite s
  s.coe_toFinset ▸ Monoid.closure_finset_fg s.toFinset
#align monoid.closure_finite_fg Monoid.closure_finite_fg
#align add_monoid.closure_finite_fg AddMonoid.closure_finite_fg

/-! ### Groups and subgroups -/


variable {G H : Type _} [Group G] [AddGroup H]

section Subgroup

/-- A subgroup of `G` is finitely generated if it is the closure of a finite subset of `G`. -/
@[to_additive]
def Subgroup.Fg (P : Subgroup G) : Prop :=
  ∃ S : Finset G, Subgroup.closure ↑S = P
#align subgroup.fg Subgroup.Fg
#align add_subgroup.fg AddSubgroup.Fg

/-- An additive subgroup of `H` is finitely generated if it is the closure of a finite subset of
`H`. -/
add_decl_doc AddSubgroup.Fg

/-- An equivalent expression of `Subgroup.Fg` in terms of `Set.Finite` instead of `Finset`. -/
@[to_additive "An equivalent expression of `AddSubgroup.fg` in terms of `Set.Finite` instead of
`Finset`."]
theorem Subgroup.fg_iff (P : Subgroup G) :
    Subgroup.Fg P ↔ ∃ S : Set G, Subgroup.closure S = P ∧ S.Finite :=
  ⟨fun ⟨S, hS⟩ => ⟨S, hS, Finset.finite_toSet S⟩, fun ⟨S, hS, hf⟩ =>
    ⟨Set.Finite.toFinset hf, by simp [hS]⟩⟩
#align subgroup.fg_iff Subgroup.fg_iff
#align add_subgroup.fg_iff AddSubgroup.fg_iff

/-- A subgroup is finitely generated if and only if it is finitely generated as a submonoid. -/
@[to_additive AddSubgroup.FgIffAddSubmonoid.fg "An additive subgroup is finitely generated if
and only if it is finitely generated as an additive submonoid."]
theorem Subgroup.fg_iff_submonoid_fg (P : Subgroup G) : P.Fg ↔ P.toSubmonoid.Fg := by
  constructor
  · rintro ⟨S, rfl⟩
    rw [Submonoid.fg_iff]
    refine' ⟨S ∪ S⁻¹, _, S.finite_toSet.union S.finite_toSet.inv⟩
    exact (Subgroup.closure_toSubmonoid _).symm
  · rintro ⟨S, hS⟩
    refine' ⟨S, le_antisymm _ _⟩
    · rw [Subgroup.closure_le, ← Subgroup.coe_toSubmonoid, ← hS]
      exact Submonoid.subset_closure
    · rw [← Subgroup.toSubmonoid_le, ← hS, Submonoid.closure_le]
      exact Subgroup.subset_closure
#align subgroup.fg_iff_submonoid_fg Subgroup.fg_iff_submonoid_fg
#align add_subgroup.fg_iff_add_submonoid.fg AddSubgroup.FgIffAddSubmonoid.fg

theorem Subgroup.fg_iff_add_fg (P : Subgroup G) : P.Fg ↔ P.toAddSubgroup.Fg := by
  rw [Subgroup.fg_iff_submonoid_fg, AddSubgroup.FgIffAddSubmonoid.fg]
  exact (Subgroup.toSubmonoid P).fg_iff_add_fg
#align subgroup.fg_iff_add_fg Subgroup.fg_iff_add_fg

theorem AddSubgroup.fg_iff_mul_fg (P : AddSubgroup H) : P.Fg ↔ P.toSubgroup.Fg := by
  rw [AddSubgroup.FgIffAddSubmonoid.fg, Subgroup.fg_iff_submonoid_fg]
  exact AddSubmonoid.fg_iff_mul_fg (AddSubgroup.toAddSubmonoid P)
#align add_subgroup.fg_iff_mul_fg AddSubgroup.fg_iff_mul_fg

end Subgroup

section Group

variable (G H)

/-- A group is finitely generated if it is finitely generated as a submonoid of itself. -/
class Group.Fg : Prop where
  out : (⊤ : Subgroup G).Fg
#align group.fg Group.Fg

/-- An additive group is finitely generated if it is finitely generated as an additive submonoid of
itself. -/
class AddGroup.Fg : Prop where
  out : (⊤ : AddSubgroup H).Fg
#align add_group.fg AddGroup.Fg

attribute [to_additive] Group.Fg

variable {G H}

theorem Group.fg_def : Group.Fg G ↔ (⊤ : Subgroup G).Fg :=
  ⟨fun h => h.1, fun h => ⟨h⟩⟩
#align group.fg_def Group.fg_def

theorem AddGroup.fg_def : AddGroup.Fg H ↔ (⊤ : AddSubgroup H).Fg :=
  ⟨fun h => h.1, fun h => ⟨h⟩⟩
#align add_group.fg_def AddGroup.fg_def

/-- An equivalent expression of `Group.Fg` in terms of `Set.Finite` instead of `Finset`. -/
@[to_additive
      "An equivalent expression of `AddGroup.fg` in terms of `Set.Finite` instead of `Finset`."]
theorem Group.fg_iff : Group.Fg G ↔ ∃ S : Set G, Subgroup.closure S = (⊤ : Subgroup G) ∧ S.Finite :=
  ⟨fun h => (Subgroup.fg_iff ⊤).1 h.out, fun h => ⟨(Subgroup.fg_iff ⊤).2 h⟩⟩
#align group.fg_iff Group.fg_iff
#align add_group.fg_iff AddGroup.fg_iff

@[to_additive]
theorem Group.fg_iff' :
    Group.Fg G ↔ ∃ (n : _)(S : Finset G), S.card = n ∧ Subgroup.closure (S : Set G) = ⊤ :=
  Group.fg_def.trans ⟨fun ⟨S, hS⟩ => ⟨S.card, S, rfl, hS⟩, fun ⟨_n, S, _hn, hS⟩ => ⟨S, hS⟩⟩
#align group.fg_iff' Group.fg_iff'
#align add_group.fg_iff' AddGroup.fg_iff'

/-- A group is finitely generated if and only if it is finitely generated as a monoid. -/
@[to_additive AddGroup.FgIffAddMonoid.fg "An additive group is finitely generated if and only
if it is finitely generated as an additive monoid."]
theorem Group.FgIffMonoid.fg : Group.Fg G ↔ Monoid.Fg G :=
  ⟨fun h => Monoid.fg_def.2 <| (Subgroup.fg_iff_submonoid_fg ⊤).1 (Group.fg_def.1 h), fun h =>
    Group.fg_def.2 <| (Subgroup.fg_iff_submonoid_fg ⊤).2 (Monoid.fg_def.1 h)⟩
#align group.fg_iff_monoid.fg Group.FgIffMonoid.fg
#align add_group.fg_iff_add_monoid.fg AddGroup.FgIffAddMonoid.fg

theorem GroupFg.iff_add_fg : Group.Fg G ↔ AddGroup.Fg (Additive G) :=
  ⟨fun h => ⟨(Subgroup.fg_iff_add_fg ⊤).1 h.out⟩, fun h => ⟨(Subgroup.fg_iff_add_fg ⊤).2 h.out⟩⟩
#align group_fg.iff_add_fg GroupFg.iff_add_fg

theorem AddGroup.fg_iff_mul_fg : AddGroup.Fg H ↔ Group.Fg (Multiplicative H) :=
  ⟨fun h => ⟨(AddSubgroup.fg_iff_mul_fg ⊤).1 h.out⟩, fun h =>
    ⟨(AddSubgroup.fg_iff_mul_fg ⊤).2 h.out⟩⟩
#align add_group.fg_iff_mul_fg AddGroup.fg_iff_mul_fg

instance AddGroup.fg_of_group_fg [Group.Fg G] : AddGroup.Fg (Additive G) :=
  GroupFg.iff_add_fg.1 ‹_›
#align add_group.fg_of_group_fg AddGroup.fg_of_group_fg

instance Group.fg_of_mul_group_fg [AddGroup.Fg H] : Group.Fg (Multiplicative H) :=
  AddGroup.fg_iff_mul_fg.1 ‹_›
#align group.fg_of_mul_group_fg Group.fg_of_mul_group_fg

@[to_additive]
instance (priority := 100) Group.fg_of_finite [Finite G] : Group.Fg G := by
  cases nonempty_fintype G
  exact ⟨⟨Finset.univ, by rw [Finset.coe_univ] ; exact Subgroup.closure_univ⟩⟩
#align group.fg_of_finite Group.fg_of_finite
#align add_group.fg_of_finite AddGroup.fg_of_finite

@[to_additive]
theorem Group.fg_of_surjective {G' : Type _} [Group G'] [hG : Group.Fg G] {f : G →* G'}
    (hf : Function.Surjective f) : Group.Fg G' :=
  Group.FgIffMonoid.fg.mpr <| @Monoid.fg_of_surjective G _ G' _ (Group.FgIffMonoid.fg.mp hG) f hf
#align group.fg_of_surjective Group.fg_of_surjective
#align add_group.fg_of_surjective AddGroup.fg_of_surjective

@[to_additive]
instance Group.fg_range {G' : Type _} [Group G'] [Group.Fg G] (f : G →* G') : Group.Fg f.range :=
  Group.fg_of_surjective f.rangeRestrict_surjective
#align group.fg_range Group.fg_range
#align add_group.fg_range AddGroup.fg_range

@[to_additive]
instance Group.closure_finset_fg (s : Finset G) : Group.Fg (Subgroup.closure (s : Set G)) := by
  refine' ⟨⟨s.preimage Subtype.val (Subtype.coe_injective.injOn _), _⟩⟩
  rw [Finset.coe_preimage, ← Subgroup.coeSubtype, Subgroup.closure_preimage_eq_top]
#align group.closure_finset_fg Group.closure_finset_fg
#align add_group.closure_finset_fg AddGroup.closure_finset_fg

@[to_additive]
instance Group.closure_finite_fg (s : Set G) [Finite s] : Group.Fg (Subgroup.closure s) :=
  haveI := Fintype.ofFinite s
  s.coe_toFinset ▸ Group.closure_finset_fg s.toFinset
#align group.closure_finite_fg Group.closure_finite_fg
#align add_group.closure_finite_fg AddGroup.closure_finite_fg

variable (G)

/-- The minimum number of generators of a group. -/
@[to_additive "The minimum number of generators of an additive group"]
noncomputable def Group.rank [h : Group.Fg G] :=
  @Nat.find _ (Classical.decPred _) (Group.fg_iff'.mp h)
#align group.rank Group.rank
#align add_group.rank AddGroup.rank

@[to_additive]
theorem Group.rank_spec [h : Group.Fg G] :
    ∃ S : Finset G, S.card = Group.rank G ∧ Subgroup.closure (S : Set G) = ⊤ :=
  @Nat.find_spec _ (Classical.decPred _) (Group.fg_iff'.mp h)
#align group.rank_spec Group.rank_spec
#align add_group.rank_spec AddGroup.rank_spec

@[to_additive]
theorem Group.rank_le [h : Group.Fg G] {S : Finset G} (hS : Subgroup.closure (S : Set G) = ⊤) :
    Group.rank G ≤ S.card :=
  @Nat.find_le _ _ (Classical.decPred _) (Group.fg_iff'.mp h) ⟨S, rfl, hS⟩
#align group.rank_le Group.rank_le
#align add_group.rank_le AddGroup.rank_le

variable {G} {G' : Type _} [Group G']

@[to_additive]
theorem Group.rank_le_of_surjective [Group.Fg G] [Group.Fg G'] (f : G →* G')
    (hf : Function.Surjective f) : Group.rank G' ≤ Group.rank G := by
  classical
    obtain ⟨S, hS1, hS2⟩ := Group.rank_spec G
    trans (S.image f).card
    · apply Group.rank_le
      rw [Finset.coe_image, ← MonoidHom.map_closure, hS2, Subgroup.map_top_of_surjective f hf]
    · exact Finset.card_image_le.trans_eq hS1
#align group.rank_le_of_surjective Group.rank_le_of_surjective
#align add_group.rank_le_of_surjective AddGroup.rank_le_of_surjective

@[to_additive]
theorem Group.rank_range_le [Group.Fg G] {f : G →* G'} : Group.rank f.range ≤ Group.rank G :=
  Group.rank_le_of_surjective f.rangeRestrict f.rangeRestrict_surjective
#align group.rank_range_le Group.rank_range_le
#align add_group.rank_range_le AddGroup.rank_range_le

@[to_additive]
theorem Group.rank_congr [Group.Fg G] [Group.Fg G'] (f : G ≃* G') : Group.rank G = Group.rank G' :=
  le_antisymm (Group.rank_le_of_surjective f.symm f.symm.surjective)
    (Group.rank_le_of_surjective f f.surjective)
#align group.rank_congr Group.rank_congr
#align add_group.rank_congr AddGroup.rank_congr

end Group

namespace Subgroup

@[to_additive]
theorem rank_congr {H K : Subgroup G} [Group.Fg H] [Group.Fg K] (h : H = K) :
    Group.rank H = Group.rank K := by subst h; rfl
#align subgroup.rank_congr Subgroup.rank_congr
#align add_subgroup.rank_congr AddSubgroup.rank_congr

@[to_additive]
theorem rank_closure_finset_le_card (s : Finset G) : Group.rank (closure (s : Set G)) ≤ s.card := by
  classical
    let t : Finset (closure (s : Set G)) := s.preimage Subtype.val (Subtype.coe_injective.injOn _)
    have ht : closure (t : Set (closure (s : Set G))) = ⊤ :=
      by
      rw [Finset.coe_preimage]
      exact closure_preimage_eq_top (s : Set G)
    apply (Group.rank_le (closure (s : Set G)) ht).trans
    suffices H : Set.InjOn Subtype.val (t : Set (closure (s : Set G)))
    rw [← Finset.card_image_of_injOn H, Finset.image_preimage]
    · apply Finset.card_filter_le
    · apply Subtype.coe_injective.injOn
#align subgroup.rank_closure_finset_le_card Subgroup.rank_closure_finset_le_card
#align add_subgroup.rank_closure_finset_le_card AddSubgroup.rank_closure_finset_le_card

@[to_additive]
theorem rank_closure_finite_le_nat_card (s : Set G) [Finite s] :
    Group.rank (closure s) ≤ Nat.card s := by
  haveI := Fintype.ofFinite s
  rw [Nat.card_eq_fintype_card, ← s.toFinset_card, ← rank_congr (congr_arg _ s.coe_toFinset)]
  exact rank_closure_finset_le_card s.toFinset
#align subgroup.rank_closure_finite_le_nat_card Subgroup.rank_closure_finite_le_nat_card
#align add_subgroup.rank_closure_finite_le_nat_card AddSubgroup.rank_closure_finite_le_nat_card

end Subgroup

section QuotientGroup

@[to_additive]
instance QuotientGroup.fg [Group.Fg G] (N : Subgroup G) [Subgroup.Normal N] : Group.Fg <| G ⧸ N :=
  Group.fg_of_surjective <| QuotientGroup.mk'_surjective N
#align quotient_group.fg QuotientGroup.fg
#align quotient_add_group.fg QuotientAddGroup.fg

end QuotientGroup