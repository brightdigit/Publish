# Release Notes

This is a BrightDigit fork of [Publish](https://github.com/JohnSundell/Publish) by John Sundell,
maintained for the BrightDigit site toolchain. Original work © 2019 John Sundell; modifications
© 2026 BrightDigit. Distributed under the original MIT License (see `LICENSE` and `NOTICE`).

## Unreleased

Fork bring-up on the BrightDigit Swift 6.4 toolchain (from brightdigit/Publish PR #1,
"Sync subrepo branch brightdigit-com-260406").

### Library
- Raised the manifest to `// swift-tools-version:6.4` and the platform floors to
  macOS 15 / iOS 18 / tvOS 18 / watchOS 11 (required by `Synchronization.Mutex` in Files).
- Repointed the Ink, Plot, and Files dependencies at the BrightDigit forks; dropped the
  Codextended, ShellOut, Sweep, and CollectionConcurrencyKit dependencies.
- Removed the `publish-cli` executable and the `PublishCLICore` target, along with
  `DeploymentMethod` and the shell-out based deployment support — this fork generates only;
  the consuming site drives mode via ArgumentParser and deploys via Netlify.
- Made `PublishingContext` and the publishing pipeline `Sendable`, resolving every strict
  concurrency diagnostic without `@unchecked Sendable`.
- Front-matter dates now decode via `dateParseStrategy: Date.ParseStrategy` instead of
  `DateFormatter`.
- Split oversized files to satisfy the fork's lint configuration: `PublishingStep` into
  `+Content` / `+Files` / `+Generation` / `+Mutations`, `PublishingContext` into
  `PublishingContext+API`, `Website` into `Website+Publishing`, `MarkdownFileHandler` into
  `+Loading`, `MarkdownMetadataDecoder` into its keyed / unkeyed / single-value containers,
  and `Theme+Foundation` into `FoundationHTMLFactory` plus the `SiteHeader` / `SiteFooter` /
  `ItemList` / `ItemTagList` components. `PlotComponents` was likewise broken out into
  `Node+HTML`, `Node+Feed`, `VideoPlayer`, `AudioPlayer+Publish`, and the markdown-parser
  environment keys.
- John Sundell's original MIT copyright headers are preserved verbatim in every source file.

### Tests
- Reorganized `PublishTests` to match the source split, adding
  `ContentMutationTests+Pages`, `HTMLGenerationTests+Themes`, and
  `RSSFeedGenerationTests+Caching`.
- Removed `CLITests` and `DeploymentTests` along with the CLI and deployment features.
- Replaced the `Require`/`AnyError` helpers with `RequireError` and moved the temporary-folder
  helper to `Folder+Temporary`.

### CI
- Adopted the BrightDigit Swift 6.4 CI template (`.github/workflows/Publish.yml`): Ubuntu
  (nightly-6.4 container), macOS, macOS Apple-platform simulator suite, Windows, and Android
  legs, plus STRICT linting.
- Added the supporting workflows (Claude code review, unsafe-flags check, cache cleanup,
  source compatibility) and the `setup-tools` composite action.
- Added `.mise.toml`, `.swift-format`, `.swiftlint.yml`, `.periphery.yml`, `codecov.yml`,
  `.github/dependabot.yml`, and `Scripts/lint.sh` / `Scripts/header.sh` (the Sundell-fork
  variant, which preserves upstream's compact `/** */` copyright block).
- Pinned the toolchain via `.swift-version`; dev container image set to
  `swiftlang/swift:nightly-6.4.x-noble`.
- Normalized `.spi.yml` for Swift Package Index documentation builds on Swift 6.4.
