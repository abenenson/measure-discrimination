# Lossless measurable encodings and product discrimination

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

## Mathematical dependency

The finite-measure KL invariance theorem is a corollary of the pinned Mathlib
`InformationTheory.klDiv_map_le`, applied to a measurable encoder and its measurable decoder.
The [pinned-source audit](overlap-audit.md) records its exact assumptions, maps each utility
API to the existing foundations, and identifies bounded candidates for upstream discussion.
The density and tilting transport lemmas do not depend on deriving KL through densities.

`ORIGIN.json` is historical extraction evidence: its transformations and hashes describe the
initial extracted files, not a claim that current source bytes remain identical. The original
license and notices are retained; subsequent changes, including the DPI proof refactoring,
are recorded in Git history.

## Hypotheses and interpretation

All left-inverse results assume measurable `f` and `g` and `Function.LeftInverse g f`.
Density transport only adds a measurable nonnegative extended-real density, with no
finiteness hypothesis on its base measure. Absolute-continuity transport also needs no
finiteness assumption. Radon–Nikodym transport assumes both measures finite and `μ ≪ ν`;
its equality holds almost everywhere under `ν.map f`. KL invariance only assumes finite
measures and takes values in `ℝ≥0∞`.

Tilting transport assumes a finite base measure and a measurable real potential. It does
not assume exponential integrability: it uses Mathlib's total definition of `Measure.tilted`,
which yields the zero measure when the exponential is not integrable. Thus this theorem
alone does not assert that the tilted measure is a probability law.

Product density factorization assumes all four measures sigma-finite and both marginal
absolute-continuity relations; its equality is almost everywhere under the reference product.
General product log-likelihood addition assumes all four measures are probability measures
and the same absolute-continuity relations; its equality is under the law product. The
common-right-factor density and log-likelihood results only assume sigma-finiteness of the
three measures and `μ ≪ ν`. The projection conveniences retain the explicit s-finiteness
and probability hypotheses in their source signatures.

## Organization

- `MeasurableLeftInverse`: measurable decoding, density, tilting and KL transport.
- `ProductDiscrimination`: product densities, log likelihoods and common-factor cancellation.

The top-level import exports the mathematical modules. `MeasureDiscriminationExamples` is a separate
library target: it is built by the default build but is not imported by the public
root. Every source has a module description and documented public declarations.
The only external package requirement is pinned Mathlib and its public dependencies.

## Qualification contract

A fresh authored-artifact build must pass with warnings fatal. Full lint recompiles
the original source contents under the same module identity, rather than linting
only an import of cached declarations. All explicit public declaration names are
listed in `verification.json`, checked against the source and audited transitively.
Private/generated declarations are not individually listed; the public audit follows
their transitive use. The lexical custom-axiom and proof-hole screen is an additional
source check, not a substitute for the transitive audit.

The CI workflow runs the same verification program with immutable action references
and read-only repository permissions. It contains no release, Pages deployment,
automatic dependency update or publishing step. A workflow definition is not a hosted
execution receipt.

## Packaging benchmark

The comparison used actual checked-out versions of the author's five public libraries:

- `cencov-petz` at `f6cf035a4c2882ae1fbc0a83416ab8142aceb676` (leanprover/lean4:v4.29.1).
- `channel-capacity` at `fdb4d1d18dba3e408fbe1969e09a4da3da2e313e` (leanprover/lean4:v4.29.1).
- `compact-spectral` at `72cd62dbdd4c397d26fc0c5777d60fea2211e938` (leanprover/lean4:v4.29.1).
- `godel-loeb` at `60a7a1098c34dbd0ee0833dde94ef5315f22d472` (leanprover/lean4:v4.29.1).
- `rellich-kondrachov` at `70f85d4c1bf99c6e7d61e8be4daa6f3664d08d23` (leanprover/lean4:v4.29.1).

The baseline practices retained here are a small public root, Mathlib-only dependencies,
explicit mathematical scope, per-file authorship/license notices and usage documentation.
The additional gates are built examples, immutable Mathlib/action revisions, explicit
warning-fatal source/full-lint execution and a complete named public axiom ledger.
This compares observable packaging and verification practice; it does not assert that
one library's mathematics is superior to another's or that the older projects failed.

## Refreshed comparison, 2026-10-22

All five precedent remote heads were rechecked and equal the commits listed above. This is an
audit of actual source/configuration, not an inference that every earlier project ran every
present check. All five lock nine public dependencies and pin Lean4.29.1. Cencov-Petz,
compact-spectral and Rellich-Kondrachov use Lean lakefiles and retain root LICENSE files;
channel-capacity and godel-loeb use TOML lakefiles and retain root `LICENSE-APACHE` and
`LICENSE-MIT` texts; their READMEs specify dual MIT OR Apache 2.0 licensing. Authored file
notices and repository license declarations must be read together.
Channel-capacity has concrete positive/counterexample modules; the other projects have their own
scoped APIs, source checks and documentation rather than the same example layout.

This package keeps a small public root, opt-in example imports, Mathlib-only dependencies,
per-file Apache notices and ORIGIN hashes. Its additional implemented gates are exact-source
builds, all16 source linters, the explicit transitive axiom ledger, durable verifier rejection
controls and always-retained CI evidence configuration. No precedent was modified or requalified.
The supported pair remains Lean4.34.1/d13f23b; earlier-pair compatibility is not inferred.

## Local evidence and private preparation

The historical qualification receipts are [the October 17 qualification](qualification.json)
and [the October 22 private-release qualification](private-release-qualification.json), with
retained logs beside them. They describe their recorded source identities and do not certify
later edits. A fresh run writes a separate evidence directory and keeps failures.

The verifier's seven Python regression controls reject native panics and malformed/error JSON
on exit zero, check import parsing, and reject optimized Python that disables assertions.
Run them with `python3 -m unittest discover -s scripts -p 'test_*.py'`. The full verification
command is `python3 scripts/verify.py`; it writes source hashes, stage results, and the named
axiom audit. This existing machinery is retained without additional release gates.
