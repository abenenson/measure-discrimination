# measure-discrimination

A small Lean utility library for lossless measurable encodings and product likelihoods,
built on Mathlib.

For measurable `f : α → β` and `g : β → α` with `g ∘ f = id`, the library provides:

- preservation and reflection of absolute continuity;
- transport of measurable densities, and of exponential tilting for finite measures;
- almost-everywhere Radon–Nikodym transport for finite measures;
- `klDiv (μ.map f) (ν.map f) = klDiv μ ν` for finite measures.

The KL equality applies Mathlib's data-processing inequality in both directions. It needs
neither absolute continuity nor integrable log likelihoods; a measurable range of `f` is
also unnecessary. The contribution is a convenient left-inverse API, rather than a new
KL invariance principle. See the [pinned-source comparison](docs/overlap-audit.md).

For products, the library packages absolute continuity, almost-everywhere density
factorization, addition of log-likelihood ratios, and cancellation of a common independent
right factor. Density factorization assumes sigma-finite measures and marginal absolute
continuity. General log-likelihood addition is stated for probability measures; common-factor
cancellation only requires sigma-finiteness and absolute continuity. These are
almost-everywhere identities. General KL product additivity is outside the package's scope.

## Example

Duplicate an observation without any measurable-diagonal assumption:

```lean
import MeasureDiscrimination

open MeasureTheory InformationTheory

example {α : Type*} [MeasurableSpace α]
    (μ ν : Measure α) [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    klDiv (μ.map fun x ↦ (x, x)) (ν.map fun x ↦ (x, x)) = klDiv μ ν :=
  MeasureDiscrimination.klDiv_map_of_measurable_leftInverse μ ν
    (measurable_id.prodMk measurable_id) measurable_fst (fun _ ↦ rfl)
```

The built, opt-in [examples](MeasureDiscriminationExamples/Basic.lean) also attach an
independent fair Boolean observation and show its cancellation from the log-likelihood ratio.

## Build

The supported pair is **Lean 4.34.1** and **Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`**. Dependencies are locked in
`lake-manifest.json`; compatibility with other versions has not been established.

```bash
lake exe cache get
lake --rehash --wfail build
python3 -m unittest discover -s scripts -p 'test_*.py'
python3 scripts/verify.py
```

Verification rebuilds all authored sources and examples, runs all 16 source linters with
warnings fatal, checks public declaration coverage, and audits transitive axioms against
`Classical.choice`, `Quot.sound`, and `propext`. Authored build artifacts are removed before
the exact build; external dependency caches are retained. See [verification and qualification
notes](docs/overview.md) for the contract and retained local evidence. Fresh verifier output
and hosted CI results describe the source snapshot each actually checked.

## License and provenance

Copyright 2026 Adam Benenson. Apache 2.0. [LICENSE](LICENSE), [NOTICE](NOTICE), and
[ORIGIN.json](ORIGIN.json) retain the original extraction provenance; the origin hashes describe
the historical extracted files. Subsequent changes are recorded in Git history.
