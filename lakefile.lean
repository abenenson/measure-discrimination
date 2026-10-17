/-
Copyright (c) 2026 Adam Benenson. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Adam Benenson
-/
import Lake
open Lake DSL

/-! # Build configuration for measure-discrimination -/

package «measure-discrimination» where
  leanOptions := #[⟨`autoImplicit, false⟩]
  weakLeanArgs := #["-j2"]
  moreGlobalServerArgs := #["-j2"]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @
    "d13f23b723b8a846827a245b89c10fc7d3f11612"

@[default_target]
lean_lib MeasureDiscrimination

@[default_target]
lean_lib MeasureDiscriminationExamples
