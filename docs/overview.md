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
