/-
Copyright (c) 2026 Adam Benenson. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Adam Benenson
-/
module

public import MeasureDiscrimination
public import Mathlib.Probability.Distributions.Uniform
public import Mathlib.Tactic.NormNum

/-!
# Lossless duplication and an independent fair auxiliary

The duplicate encoding needs no measurable-range hypothesis. A genuinely random
common auxiliary contributes no additional log-likelihood discrimination.
-/

@[expose] public section

namespace MeasureDiscrimination.Examples

open MeasureTheory InformationTheory

variable {α : Type*} [MeasurableSpace α]

/-- Duplicating an observation preserves KL, without assuming its diagonal range measurable. -/
theorem klDiv_duplicate (μ ν : Measure α) [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    klDiv (μ.map fun point ↦ (point, point)) (ν.map fun point ↦ (point, point)) =
      klDiv μ ν :=
  klDiv_map_of_measurable_leftInverse μ ν
    (measurable_id.prodMk measurable_id) measurable_fst (fun _ ↦ rfl)

/-- A fair auxiliary observation, independent of the law being discriminated. -/
noncomputable def fairAuxiliary : Measure Bool :=
  Measure.uniformOfFinset (Finset.univ : Finset Bool)

/-- The auxiliary is a probability law. -/
instance : IsProbabilityMeasure fairAuxiliary := by
  constructor
  norm_num [fairAuxiliary, Measure.uniformOfFinset_apply, ENNReal.div_self]

/-- Attaching the same fair auxiliary preserves absolute continuity. -/
theorem fairAuxiliary_preserves_ac (μ ν : Measure α) (hAC : μ ≪ ν) :
    μ.prod fairAuxiliary ≪ ν.prod fairAuxiliary :=
  prod_absolutelyContinuous_common_right μ ν fairAuxiliary hAC

/-- The independent auxiliary cancels from the actual product log-likelihood ratio. -/
theorem fairAuxiliary_cancels_llr (μ ν : Measure α)
    [SigmaFinite μ] [SigmaFinite ν] (hAC : μ ≪ ν) :
    llr (μ.prod fairAuxiliary) (ν.prod fairAuxiliary) =ᵐ[μ.prod fairAuxiliary]
      fun pair : α × Bool ↦ llr μ ν pair.1 :=
  llr_prod_common_right μ ν fairAuxiliary hAC

end MeasureDiscrimination.Examples
