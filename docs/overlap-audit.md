# Pinned Mathlib overlap and contribution scope

Source audit: 2026-10-23, against the actual checked-out Mathlib commit
`d13f23b723b8a846827a245b89c10fc7d3f11612`, the historical revision used for this comparison.
That comparison used Lean 4.34.1. This is a small convenience library built from existing
measure-theoretic foundations, with no claim of new KL mathematics or upstream acceptance.

## KL invariance is already a consequence of the pinned dependency

[`InformationTheory.klDiv_map_le`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/InformationTheory/KullbackLeibler/DataProcessing.lean#L160)
has the following assumptions: measurable spaces on the domain and codomain, finite measures
`μ` and `ν` on the domain, and `Measurable g`. Its conclusion is
`klDiv (μ.map g) (ν.map g) ≤ klDiv μ ν`. Neither absolute continuity nor log-likelihood
integrability is an input assumption. The codomain need not be a standard Borel space.

For a measurable encoder `f` and decoder `g` with `Function.LeftInverse g f`, apply the
inequality first to `f`, then to `g` on the pushed-forward finite measures. Rewriting
`Measure.map_map`, `g ∘ f = id`, and `Measure.map_id` proves the reverse inequality.
`klDiv_map_of_measurable_leftInverse` now uses exactly this proof, including when KL is infinite.
This refactoring replaces the original direct density proof; it preserves the statement and
leaves the independently useful density and tilting API intact.

## API comparison

All Mathlib links below refer to the same pinned revision. This table distinguishes package
conveniences from their existing foundations; absence of a matching searched name is not a
claim that an equivalent result cannot be derived elsewhere.

| Package API | Pinned Mathlib foundation and scope |
| --- | --- |
| `klDiv_map_of_measurable_leftInverse` | The two applications of `klDiv_map_le` above. |
| `absolutelyContinuous_map_iff_of_leftInverse` | [`Measure.AbsolutelyContinuous.map`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Measure/Map.lean) plus composition and identity. |
| `map_withDensity_comp_of_leftInverse`, `map_tilted_of_leftInverse` | [`setLIntegral_map`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Integral/Lebesgue/Map.lean), `integral_map`, and the definitions of density/tilting; packages an explicit measurable decoder without a measurable-range premise. |
| `rnDeriv_map_comp_of_leftInverse` | Density uniqueness and reconstruction. Mathlib's [`MeasurableEmbedding.rnDeriv_map`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Measure/Decomposition/RadonNikodym.lean) uses a different measurable-embedding hypothesis. |
| `ae_fst_of_ae`, `ae_snd_of_ae`, equality variants | [`measurePreserving_fst`, `measurePreserving_snd`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Measure/Prod.lean#L258) and `ae_of_ae_map`; short application conveniences. |
| `prod_absolutelyContinuous`, common-right variant | [`Measure.AbsolutelyContinuous.prod`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Measure/Prod.lean#L416); direct wrappers. |
| `rnDeriv_prod`, common-right variant | [`prod_withDensity`, `prod_withDensity_left`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Measure/WithDensity.lean#L691) and `Measure.rnDeriv_withDensity`; packages the resulting a.e. derivative identities. |
| `llr_prod`, common-right variant | The density identities plus [`llr`](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/MeasureTheory/Measure/LogLikelihoodRatio.lean) and `Real.log_mul`; explicit sigma-finiteness/probability and absolute-continuity hypotheses remain in the source. |

The pinned [KL chain rule](https://github.com/leanprover-community/mathlib4/blob/d13f23b723b8a846827a245b89c10fc7d3f11612/Mathlib/InformationTheory/KullbackLeibler/ChainRule.lean)
already includes `klDiv_compProd_left` and `klDiv_compProd_eq_add`. This package does not
reimplement that theory or claim a new general product KL theorem.

## Bounded candidates for upstream discussion

These are possible small patches to assess against Mathlib's API and naming conventions,
not submissions or promises of acceptance:

1. A measurable-left-inverse density transport lemma, with its absolute-continuity equivalence
   and finite-measure Radon–Nikodym corollary. Its useful distinction is the explicit decoder
   hypothesis rather than a measurable range.
2. Product Radon–Nikodym factorization and a common-factor corollary, placed near existing
   `prod_withDensity` lemmas; compare equivalent formulations and minimal hypotheses first.
3. A product log-likelihood convenience derived from those density lemmas, if its probability
   and sigma-finiteness variants fit the existing likelihood-ratio API.

The KL equality is a short corollary of data processing, and the absolute-continuity/product
projection wrappers largely expose existing results. They do not justify a large independent
upstream contribution claim. Any discussion should be one focused mathematical patch at a time.
Repository visibility and release records establish publication status; local qualification
does not establish a hosted run or upstream acceptance.

## Current compatibility pin

The supported pair is now Lean 4.35.0 / Mathlib
`56a005855ea17e0b0958f73ec801ae140b0a1679`. The comparison above remains historical;
this compatibility change preserves the theorem statements and does not claim upstream acceptance.
