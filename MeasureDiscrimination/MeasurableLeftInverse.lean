/-
Copyright (c) 2026 Adam Benenson. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Adam Benenson
-/
module

public import Mathlib.InformationTheory.KullbackLeibler.DataProcessing
public import Mathlib.MeasureTheory.Integral.Lebesgue.Map

/-!
# Relative entropy under a measurable left inverse

This file proves that a measurable encoding with a measurable left inverse preserves absolute
continuity, Radon--Nikodym derivatives, and Kullback--Leibler divergence. Unlike a measurable
embedding argument, the proofs do not require the encoded range to be measurable.
KL invariance specializes Mathlib's data-processing inequality in both directions; the density
and tilting transport lemmas remain useful independently of that consequence.

## Main results

- `absolutelyContinuous_map_iff_of_leftInverse`: exact absolute-continuity transport.
- `map_tilted_of_leftInverse`: exponential tilting commutes with lossless encoding.
- `rnDeriv_map_comp_of_leftInverse`: Radon--Nikodym density transport.
- `klDiv_map_of_measurable_leftInverse`: exact KL invariance under lossless encoding.
-/

@[expose] public section

namespace MeasureDiscrimination

open MeasureTheory
open _root_.InformationTheory
open scoped ENNReal

universe u v

variable {α : Type u} {β : Type v} [MeasurableSpace α] [MeasurableSpace β]
  {f : α → β} {g : β → α}

/-- Pushforward commutes with a density pulled back along a measurable left inverse. -/
theorem map_withDensity_comp_of_leftInverse (ν : Measure α) (density : α → ℝ≥0∞)
    (hf : Measurable f) (hg : Measurable g) (hdensity : Measurable density)
    (hleft : Function.LeftInverse g f) :
    (ν.map f).withDensity (density ∘ g) = (ν.withDensity density).map f := by
  ext set hset
  rw [withDensity_apply _ hset, Measure.map_apply hf hset,
    withDensity_apply _ (hf hset), setLIntegral_map hset (hdensity.comp hg) hf]
  apply setLIntegral_congr_fun_ae (hf hset)
  exact ae_of_all _ fun point _ ↦ congrArg density (hleft point)

/-- Absolute continuity is preserved and reflected by a measurable map with measurable left
inverse. -/
theorem absolutelyContinuous_map_iff_of_leftInverse (μ ν : Measure α)
    (hf : Measurable f) (hg : Measurable g) (hleft : Function.LeftInverse g f) :
    μ.map f ≪ ν.map f ↔ μ ≪ ν := by
  constructor
  · intro hmap
    have hdecoded : (μ.map f).map g ≪ (ν.map f).map g := hmap.map hg
    have hcomp : g ∘ f = id := funext hleft
    simpa only [Measure.map_map hg hf, hcomp, Measure.map_id] using hdecoded
  · intro hμν
    exact hμν.map hf

/-- Exponential tilting commutes with a measurable lossless encoding. -/
theorem map_tilted_of_leftInverse (μ : Measure α) [IsFiniteMeasure μ]
    (potential : α → ℝ) (hf : Measurable f) (hg : Measurable g)
    (hpotential : Measurable potential) (hleft : Function.LeftInverse g f) :
    (μ.tilted potential).map f = (μ.map f).tilted (potential ∘ g) := by
  have hintegral :
      ∫ point, Real.exp ((potential ∘ g) point) ∂μ.map f =
        ∫ point, Real.exp (potential point) ∂μ := by
    calc
      (∫ point, Real.exp ((potential ∘ g) point) ∂μ.map f) =
          ∫ point, Real.exp ((potential ∘ g) (f point)) ∂μ := by
        exact integral_map hf.aemeasurable
          (Real.measurable_exp.comp (hpotential.comp hg)).aestronglyMeasurable
      _ = ∫ point, Real.exp (potential point) ∂μ :=
        integral_congr_ae <| ae_of_all _ fun point ↦ by
          simp only [Function.comp_apply, hleft point]
  ext set hset
  rw [Measure.map_apply hf hset, tilted_apply μ potential (f ⁻¹' set),
    tilted_apply (μ.map f) (potential ∘ g) set, hintegral]
  let density : β → ℝ≥0∞ := fun point ↦
    ENNReal.ofReal
      (Real.exp (potential (g point)) / ∫ x, Real.exp (potential x) ∂μ)
  have hdensity : Measurable density :=
    ((Real.measurable_exp.comp (hpotential.comp hg)).div_const _).ennreal_ofReal
  have hmap :
      (∫⁻ point in set, density point ∂μ.map f) =
        ∫⁻ point in f ⁻¹' set, density (f point) ∂μ :=
    setLIntegral_map hset hdensity hf
  change
    (∫⁻ point in f ⁻¹' set,
      ENNReal.ofReal
        (Real.exp (potential point) / ∫ x, Real.exp (potential x) ∂μ) ∂μ) =
      ∫⁻ point in set, density point ∂μ.map f
  rw [hmap]
  apply setLIntegral_congr_fun_ae (hf hset)
  exact ae_of_all _ fun point _ ↦ by
    unfold density
    rw [hleft point]

/-- Radon--Nikodym derivatives commute almost everywhere with a measurable lossless encoding. -/
theorem rnDeriv_map_comp_of_leftInverse (μ ν : Measure α)
    [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (hf : Measurable f) (hg : Measurable g) (hleft : Function.LeftInverse g f)
    (hμν : μ ≪ ν) :
    (μ.map f).rnDeriv (ν.map f) =ᵐ[ν.map f] (μ.rnDeriv ν) ∘ g := by
  let : IsFiniteMeasure (μ.map f) := Measure.isFiniteMeasure_map μ f
  let : IsFiniteMeasure (ν.map f) := Measure.isFiniteMeasure_map ν f
  apply (withDensity_eq_iff_of_sigmaFinite
    (Measure.measurable_rnDeriv _ _).aemeasurable
    ((Measure.measurable_rnDeriv _ _).comp hg).aemeasurable).mp
  rw [Measure.withDensity_rnDeriv_eq _ _ (hμν.map hf),
    map_withDensity_comp_of_leftInverse ν (μ.rnDeriv ν) hf hg
      (Measure.measurable_rnDeriv _ _) hleft,
    Measure.withDensity_rnDeriv_eq _ _ hμν]

/-- KL divergence of finite measures is invariant under a measurable map with a measurable left
inverse. Apply Mathlib's data-processing inequality to the encoder and decoder; no absolute
continuity or log-likelihood integrability assumption is needed. -/
theorem klDiv_map_of_measurable_leftInverse (μ ν : Measure α)
    [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (hf : Measurable f) (hg : Measurable g) (hleft : Function.LeftInverse g f) :
    klDiv (μ.map f) (ν.map f) = klDiv μ ν := by
  let : IsFiniteMeasure (μ.map f) := Measure.isFiniteMeasure_map μ f
  let : IsFiniteMeasure (ν.map f) := Measure.isFiniteMeasure_map ν f
  refine le_antisymm (klDiv_map_le μ ν hf) ?_
  have hcomp : g ∘ f = id := funext hleft
  simpa only [Measure.map_map hg hf, hcomp, Measure.map_id] using
    klDiv_map_le (μ.map f) (ν.map f) hg

end MeasureDiscrimination
