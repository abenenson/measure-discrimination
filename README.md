# measure-discrimination

Lossless measurable encodings and product discrimination, formalized in Lean with Mathlib only.

Private preparation. Local qualification and its exact source identities are recorded
in `docs/qualification.json` when complete. Hosted CI execution is a separate result;
no hosted pass or public release is claimed.

## Mathematical scope

Two independent, Mathlib-only measure-theoretic modules share one purpose: transport
actual measure discrimination through explicit measurable constructions.

`MeasurableLeftInverse` proves preservation and reflection of absolute continuity,
density transport, compatibility with exponential tilting, and exact KL invariance
under a measurable encoder with a measurable left inverse. A measurable encoded
range is not an assumption. KL invariance here assumes finite measures.

`ProductDiscrimination` proves product absolute continuity, almost-everywhere
Radon–Nikodym factorization and log-likelihood addition, plus cancellation of a common
independent right factor. Sigma-finiteness, probability and absolute-continuity
hypotheses are retained exactly where the relevant theorem requires them. Density
and log-likelihood identities are almost-everywhere statements, not pointwise identities.
No general KL product-additivity theorem or arbitrary lossy-map invariance is advertised.

## Build and verification

The supported tested pair is Lean 4.34.1 and Mathlib commit
`d13f23b723b8a846827a245b89c10fc7d3f11612`. Every transitive dependency is locked in
`lake-manifest.json`. The author's earlier libraries currently pin Lean 4.29.1;
compatibility with that older pair has not been tested or claimed here.

```bash
lake exe cache get
lake --rehash --wfail build
python3 scripts/verify.py
```

The verifier builds every authored module and example, re-elaborates
each source with all 16 linters including theorem documentation, rejects warnings,
checks declaration coverage, and audits transitive axioms of every explicit public
name. Only `Classical.choice`, `Quot.sound` and `propext` are allowed. It rejects
`sorry`, `admit`, explicit custom axioms and imports outside this package/Mathlib.
Logs and receipts go into a new `verification-artifacts` directory per run; failures
are retained. It uses Python's standard library and no private verification tooling.

## Usage

```lean
import MeasureDiscrimination
-- Examples are opt-in:
import MeasureDiscriminationExamples
```

## Modules

- `MeasurableLeftInverse`: measurable decoding, density, tilting and KL transport.
- `ProductDiscrimination`: product densities, log likelihoods and common-factor cancellation.

## Checked example

`MeasureDiscriminationExamples.Basic` proves KL invariance for the duplicate encoding `x ↦ (x, x)`
on an arbitrary measurable space, without a measurable-diagonal premise. It then
attaches an independent fair Boolean auxiliary and proves absolute-continuity
preservation and actual log-likelihood cancellation.

## Provenance and license

Copyright 2026 Adam Benenson. Apache 2.0, matching the explicit notices retained in
the extracted mathematical files. See [LICENSE](LICENSE), [NOTICE](NOTICE), and
[ORIGIN.json](ORIGIN.json) for file identities and the limited extraction provenance.
No surrounding repository or unrelated source is assigned a license here.

[API and verification notes](docs/overview.md) describe the package boundary and
qualification process. These are formalizations of the scoped mathematical results;
no application-specific physical or empirical implication is claimed.
