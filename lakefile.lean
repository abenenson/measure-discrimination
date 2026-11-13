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
    "56a005855ea17e0b0958f73ec801ae140b0a1679"

@[default_target]
lean_lib MeasureDiscrimination

@[default_target]
lean_lib MeasureDiscriminationExamples
