# Dependency overlap and private inspection scope

Source audit date: 2026-10-22. This package supplies scoped, reusable API packaging; it does not
claim new KL mathematics or Mathlib acceptance.

Current Mathlib at `6ea173996caaa665b0a3c4f81ce472e04e4f7754` already proves finite-measure data processing:
[`InformationTheory.klDiv_map_le`](https://github.com/leanprover-community/mathlib4/blob/6ea173996caaa665b0a3c4f81ce472e04e4f7754/Mathlib/InformationTheory/KullbackLeibler/DataProcessing.lean).
With measurable encoding and decoding whose composition is identity, applying this inequality
in both directions mathematically gives the advertised KL equality. This is a source-based
inference about overlap, not an additional native-checked implementation in this release.
The retained direct density proof and left-inverse API are useful packaging on the pinned pair;
they must not be called a novel KL invariance principle.

Current Mathlib's [KL chain rule](https://github.com/leanprover-community/mathlib4/blob/6ea173996caaa665b0a3c4f81ce472e04e4f7754/Mathlib/InformationTheory/KullbackLeibler/ChainRule.lean)
includes `klDiv_compProd_left` and `klDiv_compProd_eq_add`; its
[likelihood-ratio API](https://github.com/leanprover-community/mathlib4/blob/6ea173996caaa665b0a3c4f81ce472e04e4f7754/Mathlib/MeasureTheory/Measure/LogLikelihoodRatio.lean)
and Radon-Nikodym machinery are nearby foundations. The package's explicit a.e. product-density,
log-likelihood and common-right-factor API must be compared against that infrastructure before
any upstream submission. No general new product KL theorem is advertised here.

The audit compared current source signatures and hypotheses, without building the newer
Mathlib revision. Native qualification remains specific to the locked d13f23b/Lean4.34.1 pair.
No outside library acceptance, external review or upstream submission occurred.
