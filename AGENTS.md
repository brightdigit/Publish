# AGENTS.md — Publish

This is the canonical agent instruction file for this repository. `CLAUDE.md` is a symlink
to this file.

**This repository is a BrightDigit fork of [Publish](https://github.com/JohnSundell/Publish)
by John Sundell**, maintained for the BrightDigit site toolchain. Original work © 2019 John
Sundell; modifications © 2026 BrightDigit. Distributed under the original MIT License — see
`LICENSE` and `NOTICE`.

Vendored package in the BrightDigit Publish stack (`Packages/Publish/Publish`),
maintained in-tree on plain Swift 6.4 (`// swift-tools-version:6.4`), macOS 15+.

- **Never rewrite John Sundell's copyright headers into BrightDigit ones.** `Scripts/lint.sh`
  invokes `Scripts/header.sh` with `-c "John Sundell" -o "John Sundell" -p "Publish" -y 2021`,
  and `Scripts/header.sh` is the Sundell-fork variant that emits his compact `/** */` block.
  Preserving upstream attribution is an MIT license obligation.
- Strict concurrency is mandatory. Resolve every diagnostic properly
  (Sendable / isolation / `Synchronization.Mutex`); never use
  `@unchecked Sendable` — a SwiftLint `no_unchecked_sendable` rule enforces this.
- Lint: `LINT_MODE=STRICT ./Scripts/lint.sh` — full BrightDigit house style
  (swift-format + SwiftLint + build) gates; periphery is local-only (skipped
  when `$CI` is set).
- `PublishingContext` is fully `Sendable`. Front-matter dates use
  `dateParseStrategy: Date.ParseStrategy` (not `DateFormatter`). HTML
  generation is serial; parallelism is a separate follow-up (#153).
- Command-line / `DeploymentMethod` support was removed — generation only;
  first-party drives mode via ArgumentParser and deploys via Netlify.
- Syntax highlighting is client-side (highlight.js in the site `Styling`
  bundle); Splash / SplashPublishPlugin are not part of this stack.
- Tests use XCTest (kept as-is).

## Memory & Corrections Convention

`.claude/agent-notes.md` is the canonical, versioned corrections log for this repository — an
append-only record of the maintainer's corrections and standing **always/never** directives.

- **Read `.claude/agent-notes.md` at the start of every work session, before doing any work.** It
  is the source of truth for *how* to work in this repo.
- **Whenever the maintainer makes a correction or gives an always/never instruction, append one
  line to `.claude/agent-notes.md` proactively (without being asked).** One line per directive,
  newest at the bottom. If a directive supersedes an earlier one, update or remove the stale line
  rather than leaving both.
