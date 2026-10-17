/-
Copyright (c) 2026 Adam Benenson. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Adam Benenson
-/
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.MeasureTheory.Measure.LogLikelihoodRatio
import Mathlib.MeasureTheory.Measure.WithDensity

/-!
# Discrimination of product measures

This file proves absolute-continuity, Radon--Nikodym, and log-likelihood factorization for product
probability measures. It also supplies reusable almost-everywhere lifting through either product
projection. The common-right-factor theorem specializes the result to a law and reference sharing
the same independently distributed apparatus.

## Main results

- `ae_fst_of_ae`: lift an almost-everywhere property through the first projection.
- `ae_snd_of_ae`: lift an almost-everywhere property through the second projection.
- `ae_comp_fst_of_ae`: lift an almost-everywhere equality through the first projection.
- `ae_comp_snd_of_ae`: lift an almost-everywhere equality through the second projection.
- `rnDeriv_prod`: the density of product laws is the product of their densities.
- `llr_prod`: the log likelihood of product laws is the sum of marginal log likelihoods.
- `llr_prod_common_right`: a common right factor contributes zero discrimination.
-/

namespace MeasureDiscrimination

open MeasureTheory

universe u v w

variable {α : Type u} {β : Type v} {γ : Type w}
  [MeasurableSpace α] [MeasurableSpace β]

/-- Lift an almost-everywhere property through the first projection of a product with a
probability measure. -/
theorem ae_fst_of_ae
    (μ : Measure α) (ν : Measure β) [SFinite ν] [IsProbabilityMeasure ν]
    {property : α → Prop} (h : ∀ᵐ point ∂μ, property point) :
    ∀ᵐ pair ∂μ.prod ν, property pair.1 := by
  have hMapped :
      ∀ᵐ point ∂Measure.map Prod.fst (μ.prod ν), property point := by
    rw [measurePreserving_fst.map_eq]
    exact h
  exact ae_of_ae_map measurable_fst.aemeasurable hMapped

/-- Lift an almost-everywhere property through the second projection of a product whose first
factor is a probability measure. -/
theorem ae_snd_of_ae
    (μ : Measure α) (ν : Measure β) [SFinite ν] [IsProbabilityMeasure μ]
    {property : β → Prop} (h : ∀ᵐ point ∂ν, property point) :
    ∀ᵐ pair ∂μ.prod ν, property pair.2 := by
  have hMapped :
      ∀ᵐ point ∂Measure.map Prod.snd (μ.prod ν), property point := by
    rw [measurePreserving_snd.map_eq]
    exact h
  exact ae_of_ae_map measurable_snd.aemeasurable hMapped

/-- Lift an almost-everywhere equality through the first projection of a product with a
probability measure. -/
theorem ae_comp_fst_of_ae
    (μ : Measure α) (ν : Measure β) [SFinite ν] [IsProbabilityMeasure ν]
    {f g : α → γ} (h : f =ᵐ[μ] g) :
    (fun pair : α × β ↦ f pair.1) =ᵐ[μ.prod ν]
      fun pair ↦ g pair.1 := by
  have hMapped : f =ᵐ[Measure.map Prod.fst (μ.prod ν)] g := by
    rw [measurePreserving_fst.map_eq]
    exact h
  exact ae_of_ae_map measurable_fst.aemeasurable hMapped

/-- Lift an almost-everywhere equality through the second projection of a product whose first
factor is a probability measure. -/
theorem ae_comp_snd_of_ae
    (μ : Measure α) (ν : Measure β) [SFinite ν] [IsProbabilityMeasure μ]
    {f g : β → γ} (h : f =ᵐ[ν] g) :
    (fun pair : α × β ↦ f pair.2) =ᵐ[μ.prod ν]
      fun pair ↦ g pair.2 := by
  have hMapped : f =ᵐ[Measure.map Prod.snd (μ.prod ν)] g := by
    rw [measurePreserving_snd.map_eq]
    exact h
  exact ae_of_ae_map measurable_snd.aemeasurable hMapped

/-- Absolute continuity is closed under products. -/
theorem prod_absolutelyContinuous
    (μ₁ ν₁ : Measure α) (μ₂ ν₂ : Measure β)
    [SFinite ν₂] (hFirst : μ₁ ≪ ν₁) (hSecond : μ₂ ≪ ν₂) :
    μ₁.prod μ₂ ≪ ν₁.prod ν₂ := by
  let : SFinite μ₂ := sFinite_of_absolutelyContinuous hSecond
  exact hFirst.prod hSecond

/-- The Radon--Nikodym derivative of product laws is the product of the marginal derivatives. -/
theorem rnDeriv_prod
    (μ₁ ν₁ : Measure α) (μ₂ ν₂ : Measure β)
    [SigmaFinite μ₁] [SigmaFinite ν₁] [SigmaFinite μ₂] [SigmaFinite ν₂]
    (hFirst : μ₁ ≪ ν₁) (hSecond : μ₂ ≪ ν₂) :
    (μ₁.prod μ₂).rnDeriv (ν₁.prod ν₂) =ᵐ[ν₁.prod ν₂]
      fun pair : α × β ↦ μ₁.rnDeriv ν₁ pair.1 * μ₂.rnDeriv ν₂ pair.2 := by
  have hDensity : Measurable
      (fun pair : α × β ↦ μ₁.rnDeriv ν₁ pair.1 * μ₂.rnDeriv ν₂ pair.2) :=
    ((Measure.measurable_rnDeriv μ₁ ν₁).comp measurable_fst).mul
      ((Measure.measurable_rnDeriv μ₂ ν₂).comp measurable_snd)
  have hProduct :
      μ₁.prod μ₂ = (ν₁.prod ν₂).withDensity
        (fun pair : α × β ↦ μ₁.rnDeriv ν₁ pair.1 * μ₂.rnDeriv ν₂ pair.2) := by
    calc
      μ₁.prod μ₂ =
          (ν₁.withDensity (μ₁.rnDeriv ν₁)).prod
            (ν₂.withDensity (μ₂.rnDeriv ν₂)) := by
        rw [Measure.withDensity_rnDeriv_eq μ₁ ν₁ hFirst,
          Measure.withDensity_rnDeriv_eq μ₂ ν₂ hSecond]
      _ = (ν₁.prod ν₂).withDensity
          (fun pair : α × β ↦ μ₁.rnDeriv ν₁ pair.1 * μ₂.rnDeriv ν₂ pair.2) :=
        prod_withDensity (Measure.measurable_rnDeriv μ₁ ν₁)
          (Measure.measurable_rnDeriv μ₂ ν₂)
  rw [hProduct]
  exact Measure.rnDeriv_withDensity _ hDensity

/-- The log-likelihood ratio of product probability laws is the sum of the marginal log
likelihoods almost everywhere under the product law. -/
theorem llr_prod
    (μ₁ ν₁ : Measure α) (μ₂ ν₂ : Measure β)
    [IsProbabilityMeasure μ₁] [IsProbabilityMeasure ν₁]
    [IsProbabilityMeasure μ₂] [IsProbabilityMeasure ν₂]
    (hFirst : μ₁ ≪ ν₁) (hSecond : μ₂ ≪ ν₂) :
    llr (μ₁.prod μ₂) (ν₁.prod ν₂) =ᵐ[μ₁.prod μ₂]
      fun pair : α × β ↦ llr μ₁ ν₁ pair.1 + llr μ₂ ν₂ pair.2 := by
  have hProductAC := prod_absolutelyContinuous μ₁ ν₁ μ₂ ν₂ hFirst hSecond
  have hRN := hProductAC.ae_le (rnDeriv_prod μ₁ ν₁ μ₂ ν₂ hFirst hSecond)
  have hFirstPosBase := Measure.rnDeriv_pos hFirst
  have hFirstFiniteBase := hFirst.ae_le (Measure.rnDeriv_lt_top μ₁ ν₁)
  have hFirstPosMapped :
      ∀ᵐ pair ∂μ₁.prod μ₂, 0 < μ₁.rnDeriv ν₁ pair.1 :=
    ae_fst_of_ae μ₁ μ₂ hFirstPosBase
  have hFirstFiniteMapped :
      ∀ᵐ pair ∂μ₁.prod μ₂, μ₁.rnDeriv ν₁ pair.1 < ⊤ :=
    ae_fst_of_ae μ₁ μ₂ hFirstFiniteBase
  have hSecondPosBase := Measure.rnDeriv_pos hSecond
  have hSecondFiniteBase := hSecond.ae_le (Measure.rnDeriv_lt_top μ₂ ν₂)
  have hSecondPosMapped :
      ∀ᵐ pair ∂μ₁.prod μ₂, 0 < μ₂.rnDeriv ν₂ pair.2 :=
    ae_snd_of_ae μ₁ μ₂ hSecondPosBase
  have hSecondFiniteMapped :
      ∀ᵐ pair ∂μ₁.prod μ₂, μ₂.rnDeriv ν₂ pair.2 < ⊤ :=
    ae_snd_of_ae μ₁ μ₂ hSecondFiniteBase
  filter_upwards [hRN, hFirstPosMapped, hFirstFiniteMapped,
    hSecondPosMapped, hSecondFiniteMapped] with pair hpair hFirstPos hFirstFinite
      hSecondPos hSecondFinite
  unfold llr
  rw [hpair, ENNReal.toReal_mul,
    Real.log_mul
      (ENNReal.toReal_ne_zero.mpr ⟨hFirstPos.ne', hFirstFinite.ne⟩)
      (ENNReal.toReal_ne_zero.mpr ⟨hSecondPos.ne', hSecondFinite.ne⟩)]

/-- A common independent right factor preserves absolute continuity. -/
theorem prod_absolutelyContinuous_common_right
    (μ ν : Measure α) (κ : Measure β) [SFinite κ] (hAC : μ ≪ ν) :
    μ.prod κ ≪ ν.prod κ :=
  hAC.prod Measure.AbsolutelyContinuous.rfl

/-- A common independent right factor contributes no Radon--Nikodym density. -/
theorem rnDeriv_prod_common_right
    (μ ν : Measure α) (κ : Measure β)
    [SigmaFinite μ] [SigmaFinite ν] [SigmaFinite κ]
    (hAC : μ ≪ ν) :
    (μ.prod κ).rnDeriv (ν.prod κ) =ᵐ[ν.prod κ]
      fun pair : α × β ↦ μ.rnDeriv ν pair.1 := by
  have hDensity : Measurable (fun pair : α × β ↦ μ.rnDeriv ν pair.1) :=
    (Measure.measurable_rnDeriv μ ν).comp measurable_fst
  have hProduct :
      μ.prod κ = (ν.prod κ).withDensity
        (fun pair : α × β ↦ μ.rnDeriv ν pair.1) := by
    calc
      μ.prod κ = (ν.withDensity (μ.rnDeriv ν)).prod κ := by
        rw [Measure.withDensity_rnDeriv_eq μ ν hAC]
      _ = (ν.prod κ).withDensity (fun pair : α × β ↦ μ.rnDeriv ν pair.1) :=
        prod_withDensity_left (Measure.measurable_rnDeriv μ ν)
  rw [hProduct]
  exact Measure.rnDeriv_withDensity _ hDensity

/-- A common independent right factor contributes zero log-likelihood discrimination. -/
theorem llr_prod_common_right
    (μ ν : Measure α) (κ : Measure β)
    [SigmaFinite μ] [SigmaFinite ν] [SigmaFinite κ]
    (hAC : μ ≪ ν) :
    llr (μ.prod κ) (ν.prod κ) =ᵐ[μ.prod κ]
      fun pair : α × β ↦ llr μ ν pair.1 := by
  have hProductAC := prod_absolutelyContinuous_common_right μ ν κ hAC
  have hRN := hProductAC.ae_le (rnDeriv_prod_common_right μ ν κ hAC)
  filter_upwards [hRN] with pair hpair
  unfold llr
  rw [hpair]

end MeasureDiscrimination
