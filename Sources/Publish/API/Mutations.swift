/**
*  Publish
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE file for details
*/

/// Closure type used to implement content mutations.
public typealias Mutations<T> = @Sendable (inout T) throws -> Void
