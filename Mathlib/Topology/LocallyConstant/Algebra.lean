/-
Copyright (c) 2021 Johan Commelin. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johan Commelin

! This file was ported from Lean 3 source module topology.locally_constant.algebra
! leanprover-community/mathlib commit bcfa726826abd57587355b4b5b7e78ad6527b7e4
! Please do not edit these lines, except to modify the commit id
! if you have ported upstream changes.
-/
import Mathlib.Algebra.Algebra.Pi
import Mathlib.Topology.LocallyConstant.Basic

/-!
# Algebraic structure on locally constant functions

This file puts algebraic structure (`Group`, `AddGroup`, etc)
on the type of locally constant functions.

-/

namespace LocallyConstant

variable {X Y : Type _} [TopologicalSpace X]

@[to_additive]
instance [One Y] : One (LocallyConstant X Y) where one := const X 1

@[to_additive (attr := simp)]
theorem coe_one [One Y] : ⇑(1 : LocallyConstant X Y) = (1 : X → Y) :=
  rfl
#align locally_constant.coe_one LocallyConstant.coe_one
#align locally_constant.coe_zero LocallyConstant.coe_zero

@[to_additive]
theorem one_apply [One Y] (x : X) : (1 : LocallyConstant X Y) x = 1 :=
  rfl
#align locally_constant.one_apply LocallyConstant.one_apply
#align locally_constant.zero_apply LocallyConstant.zero_apply

@[to_additive]
instance [Inv Y] : Inv (LocallyConstant X Y) where inv f := ⟨f⁻¹, f.isLocallyConstant.inv⟩

@[to_additive (attr := simp)]
theorem coe_inv [Inv Y] (f : LocallyConstant X Y) : ⇑(f⁻¹ : LocallyConstant X Y) = (f : X → Y)⁻¹ :=
  rfl
#align locally_constant.coe_inv LocallyConstant.coe_inv
#align locally_constant.coe_neg LocallyConstant.coe_neg

@[to_additive]
theorem inv_apply [Inv Y] (f : LocallyConstant X Y) (x : X) : f⁻¹ x = (f x)⁻¹ :=
  rfl
#align locally_constant.inv_apply LocallyConstant.inv_apply
#align locally_constant.neg_apply LocallyConstant.neg_apply

@[to_additive]
instance [Mul Y] : Mul (LocallyConstant X Y)
    where mul f g := ⟨f * g, f.isLocallyConstant.mul g.isLocallyConstant⟩

@[to_additive (attr := simp)]
theorem coe_mul [Mul Y] (f g : LocallyConstant X Y) : ⇑(f * g) = f * g :=
  rfl
#align locally_constant.coe_mul LocallyConstant.coe_mul
#align locally_constant.coe_add LocallyConstant.coe_add

@[to_additive]
theorem mul_apply [Mul Y] (f g : LocallyConstant X Y) (x : X) : (f * g) x = f x * g x :=
  rfl
#align locally_constant.mul_apply LocallyConstant.mul_apply
#align locally_constant.add_apply LocallyConstant.add_apply

@[to_additive]
instance [MulOneClass Y] : MulOneClass (LocallyConstant X Y) :=
  Function.Injective.mulOneClass FunLike.coe FunLike.coe_injective' rfl fun _ _ => rfl

/-- `coe_fn` is a `monoid_hom`. -/
@[to_additive "`coe_fn` is an `add_monoid_hom`.", simps]
def coeFnMonoidHom [MulOneClass Y] : LocallyConstant X Y →* X → Y where
  toFun := FunLike.coe
  map_one' := rfl
  map_mul' _ _ := rfl
#align locally_constant.coe_fn_monoid_hom LocallyConstant.coeFnMonoidHom
#align locally_constant.coe_fn_add_monoid_hom LocallyConstant.coeFnAddMonoidHom

/-- The constant-function embedding, as a multiplicative monoid hom. -/
@[to_additive "The constant-function embedding, as an additive monoid hom.", simps]
def constMonoidHom [MulOneClass Y] : Y →* LocallyConstant X Y where
  toFun := const X
  map_one' := rfl
  map_mul' _ _ := rfl
#align locally_constant.const_monoid_hom LocallyConstant.constMonoidHom
#align locally_constant.const_add_monoid_hom LocallyConstant.constAddMonoidHom

instance [MulZeroClass Y] : MulZeroClass (LocallyConstant X Y) :=
  Function.Injective.mulZeroClass FunLike.coe FunLike.coe_injective' rfl fun _ _ => rfl

instance [MulZeroOneClass Y] : MulZeroOneClass (LocallyConstant X Y) :=
  Function.Injective.mulZeroOneClass FunLike.coe FunLike.coe_injective' rfl rfl fun _ _ => rfl

section CharFn

variable (Y) [MulZeroOneClass Y] {U V : Set X}

/-- Characteristic functions are locally constant functions taking `x : X` to `1` if `x ∈ U`,
  where `U` is a clopen set, and `0` otherwise. -/
noncomputable def charFn (hU : IsClopen U) : LocallyConstant X Y :=
  indicator 1 hU
#align locally_constant.char_fn LocallyConstant.charFn

theorem coe_charFn (hU : IsClopen U) : (charFn Y hU : X → Y) = Set.indicator U 1 :=
  rfl
#align locally_constant.coe_char_fn LocallyConstant.coe_charFn

theorem charFn_eq_one [Nontrivial Y] (x : X) (hU : IsClopen U) : charFn Y hU x = (1 : Y) ↔ x ∈ U :=
  Set.indicator_eq_one_iff_mem _
#align locally_constant.char_fn_eq_one LocallyConstant.charFn_eq_one

theorem charFn_eq_zero [Nontrivial Y] (x : X) (hU : IsClopen U) : charFn Y hU x = (0 : Y) ↔ x ∉ U :=
  Set.indicator_eq_zero_iff_not_mem _
#align locally_constant.char_fn_eq_zero LocallyConstant.charFn_eq_zero

theorem charFn_inj [Nontrivial Y] (hU : IsClopen U) (hV : IsClopen V)
    (h : charFn Y hU = charFn Y hV) : U = V :=
  Set.indicator_one_inj Y <| coe_inj.mpr h
#align locally_constant.char_fn_inj LocallyConstant.charFn_inj

end CharFn

@[to_additive]
instance [Div Y] : Div (LocallyConstant X Y)
    where div f g := ⟨f / g, f.isLocallyConstant.div g.isLocallyConstant⟩

@[to_additive]
theorem coe_div [Div Y] (f g : LocallyConstant X Y) : ⇑(f / g) = f / g :=
  rfl
#align locally_constant.coe_div LocallyConstant.coe_div
#align locally_constant.coe_sub LocallyConstant.coe_sub

@[to_additive]
theorem div_apply [Div Y] (f g : LocallyConstant X Y) (x : X) : (f / g) x = f x / g x :=
  rfl
#align locally_constant.div_apply LocallyConstant.div_apply
#align locally_constant.sub_apply LocallyConstant.sub_apply

@[to_additive]
instance [Semigroup Y] : Semigroup (LocallyConstant X Y) :=
  Function.Injective.semigroup FunLike.coe FunLike.coe_injective' fun _ _ => rfl

instance [SemigroupWithZero Y] : SemigroupWithZero (LocallyConstant X Y) :=
  Function.Injective.semigroupWithZero FunLike.coe FunLike.coe_injective' rfl fun _ _ => rfl

@[to_additive]
instance [CommSemigroup Y] : CommSemigroup (LocallyConstant X Y) :=
  Function.Injective.commSemigroup FunLike.coe FunLike.coe_injective' fun _ _ => rfl

@[to_additive]
instance instSMulLocallyConstant [SMul α Y] : SMul α (LocallyConstant X Y) where
  smul n f := f.map (n • ·)

@[to_additive (attr := simp)]
theorem coe_smul [SMul R Y] (r : R) (f : LocallyConstant X Y) : ⇑(r • f) = r • (f : X → Y) :=
  rfl
#align locally_constant.coe_smul LocallyConstant.coe_smul

@[to_additive]
theorem smul_apply [SMul R Y] (r : R) (f : LocallyConstant X Y) (x : X) : (r • f) x = r • f x :=
  rfl
#align locally_constant.smul_apply LocallyConstant.smul_apply

@[to_additive existing instSMulLocallyConstant]
instance [Pow Y α] : Pow (LocallyConstant X Y) α where
  pow f n := f.map (· ^ n)

@[to_additive]
instance [Monoid Y] : Monoid (LocallyConstant X Y) :=
  Function.Injective.monoid FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl) fun _ _ => rfl

instance [NatCast Y] : NatCast (LocallyConstant X Y) where
  natCast n := const X n

instance [IntCast Y] : IntCast (LocallyConstant X Y) where
  intCast n := const X n

instance [AddMonoidWithOne Y] : AddMonoidWithOne (LocallyConstant X Y) :=
  Function.Injective.addMonoidWithOne FunLike.coe FunLike.coe_injective' rfl rfl (fun _ _ => rfl)
    (fun _ _ => rfl) fun _ => rfl

@[to_additive]
instance [CommMonoid Y] : CommMonoid (LocallyConstant X Y) :=
  Function.Injective.commMonoid FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl)
    fun _ _ => rfl

@[to_additive]
instance [Group Y] : Group (LocallyConstant X Y) :=
  Function.Injective.group FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl)
    (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

@[to_additive]
instance [CommGroup Y] : CommGroup (LocallyConstant X Y) :=
  Function.Injective.commGroup FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl)
    (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [Distrib Y] : Distrib (LocallyConstant X Y) :=
  Function.Injective.distrib FunLike.coe FunLike.coe_injective' (fun _ _ => rfl) fun _ _ => rfl

instance [NonUnitalNonAssocSemiring Y] : NonUnitalNonAssocSemiring (LocallyConstant X Y) :=
  Function.Injective.nonUnitalNonAssocSemiring FunLike.coe FunLike.coe_injective' rfl
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [NonUnitalSemiring Y] : NonUnitalSemiring (LocallyConstant X Y) :=
  Function.Injective.nonUnitalSemiring FunLike.coe FunLike.coe_injective' rfl
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [NonAssocSemiring Y] : NonAssocSemiring (LocallyConstant X Y) :=
  Function.Injective.nonAssocSemiring FunLike.coe FunLike.coe_injective' rfl rfl
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) fun _ => rfl

/-- The constant-function embedding, as a ring hom.  -/
@[simps]
def constRingHom [NonAssocSemiring Y] : Y →+* LocallyConstant X Y :=
  { constMonoidHom, constAddMonoidHom with toFun := const X }
#align locally_constant.const_ring_hom LocallyConstant.constRingHom

instance [Semiring Y] : Semiring (LocallyConstant X Y) :=
  Function.Injective.semiring FunLike.coe FunLike.coe_injective' rfl rfl
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) fun _ => rfl

instance [NonUnitalCommSemiring Y] : NonUnitalCommSemiring (LocallyConstant X Y) :=
  Function.Injective.nonUnitalCommSemiring FunLike.coe FunLike.coe_injective' rfl
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [CommSemiring Y] : CommSemiring (LocallyConstant X Y) :=
  Function.Injective.commSemiring FunLike.coe FunLike.coe_injective' rfl rfl
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) fun _ => rfl

instance [NonUnitalNonAssocRing Y] : NonUnitalNonAssocRing (LocallyConstant X Y) :=
  Function.Injective.nonUnitalNonAssocRing FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [NonUnitalRing Y] : NonUnitalRing (LocallyConstant X Y) :=
  Function.Injective.nonUnitalRing FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [NonAssocRing Y] : NonAssocRing (LocallyConstant X Y) :=
  Function.Injective.nonAssocRing FunLike.coe FunLike.coe_injective' rfl rfl (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)
    (fun _ => rfl) (fun _ => rfl)

instance [Ring Y] : Ring (LocallyConstant X Y) :=
  Function.Injective.ring FunLike.coe FunLike.coe_injective' rfl rfl (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) fun _ => rfl

instance [NonUnitalCommRing Y] : NonUnitalCommRing (LocallyConstant X Y) :=
  Function.Injective.nonUnitalCommRing FunLike.coe FunLike.coe_injective' rfl (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)

instance [CommRing Y] : CommRing (LocallyConstant X Y) :=
  Function.Injective.commRing FunLike.coe FunLike.coe_injective' rfl rfl (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) fun _ => rfl

variable {R : Type _}

instance [Monoid R] [MulAction R Y] : MulAction R (LocallyConstant X Y) :=
  Function.Injective.mulAction _ coe_injective fun _ _ => rfl

instance [Monoid R] [AddMonoid Y] [DistribMulAction R Y] :
    DistribMulAction R (LocallyConstant X Y) :=
  Function.Injective.distribMulAction coeFnAddMonoidHom coe_injective fun _ _ => rfl

instance [Semiring R] [AddCommMonoid Y] [Module R Y] : Module R (LocallyConstant X Y) :=
  Function.Injective.module R coeFnAddMonoidHom coe_injective fun _ _ => rfl

section Algebra

variable [CommSemiring R] [Semiring Y] [Algebra R Y]

instance : Algebra R (LocallyConstant X Y) where
  toRingHom := constRingHom.comp <| algebraMap R Y
  commutes' := by
    intros
    ext
    exact Algebra.commutes' _ _
  smul_def' := by
    intros
    ext
    exact Algebra.smul_def' _ _

@[simp]
theorem coe_algebraMap (r : R) : ⇑(algebraMap R (LocallyConstant X Y) r) = algebraMap R (X → Y) r :=
  rfl
#align locally_constant.coe_algebra_map LocallyConstant.coe_algebraMap

end Algebra

end LocallyConstant