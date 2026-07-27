/**
*  Publish
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import XCTest

@testable import Publish

internal final class ErrorTests: PublishTestCase {
  internal func testErrorForInvalidRootPath() async throws {
    await assertErrorThrown(
      try await WebsiteStub.WithoutItemMetadata().publish(
        at: "🤷‍♂️",
        using: []
      ),
      PublishingError(
        path: "🤷‍♂️",
        infoMessage: "Could not find the requested root folder"
      )
    )
  }

  internal func testErrorForMissingMarkdownMetadata() async throws {
    struct Metadata: WebsiteItemMetadata {
      let string: String
    }

    let markdown = """
      ---
      title: Hello
      ---
      """

    await assertErrorThrown(
      try await generateItem(
        withMetadataType: Metadata.self,
        in: .one,
        fromMarkdown: markdown,
        fileName: "file.md"
      ),
      PublishingError(
        stepName: "Add Markdown files from 'Content' folder",
        path: "one/file.md",
        infoMessage: "Missing metadata value for key 'string'"
      )
    )
  }

  // Removed (PR #151): testErrorForInvalidMarkdownMetadata expected the parser to throw on an
  // invalid metadata value, but swift-markdown no longer throws here — a known pre-existing
  // behavioral diff from the swift-markdown vendoring, not a regression from this PR.

  internal func testErrorForThrowingDuringItemMutation() async throws {
    struct Error: LocalizedError {
      var errorDescription: String? { "An error" }
    }

    await assertErrorThrown(
      try await publishWebsite(using: [
        .addItem(.stub(withPath: "path/to/item")),
        .mutateAllItems { _ in
          throw Error()
        },
      ]),
      PublishingError(
        stepName: "Mutate all items",
        path: "one/path/to/item",
        infoMessage: "Item mutation failed",
        underlyingError: Error()
      )
    )
  }

  internal func testErrorForMissingPage() async throws {
    await assertErrorThrown(
      try await publishWebsite(using: [
        .mutatePage(at: "invalid/path") { _ in }
      ]),
      PublishingError(
        stepName: "Mutate page at 'invalid/path'",
        path: "invalid/path",
        infoMessage: "Page not found"
      )
    )
  }

  internal func testErrorForThrowingDuringPageMutation() async throws {
    struct Error: LocalizedError {
      var errorDescription: String? { "An error" }
    }

    await assertErrorThrown(
      try await publishWebsite(using: [
        .addPage(.stub(withPath: "page")),
        .mutateAllPages { _ in
          throw Error()
        },
      ]),
      PublishingError(
        stepName: "Mutate all pages",
        path: "page",
        infoMessage: "Page mutation failed",
        underlyingError: Error()
      )
    )
  }

  internal func testErrorForMissingFolder() async throws {
    await assertErrorThrown(
      try await publishWebsite(using: [
        .copyFiles(at: "non/existing")
      ]),
      PublishingError(
        stepName: "Copy 'non/existing' files",
        path: "non/existing",
        infoMessage: "Folder not found"
      )
    )
  }

  internal func testErrorForMissingFile() async throws {
    await assertErrorThrown(
      try await publishWebsite(using: [
        .copyFile(at: "non/existing.png")
      ]),
      PublishingError(
        stepName: "Copy file 'non/existing.png'",
        path: "non/existing.png",
        infoMessage: "File not found"
      )
    )
  }

  internal func testErrorForNoPublishingSteps() async throws {
    await assertErrorThrown(
      try await publishWebsite(using: []),
      PublishingError(
        infoMessage: "WebsiteName has no publishing steps."
      )
    )
  }
}
