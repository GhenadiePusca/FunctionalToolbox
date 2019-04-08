//
//  Functional.swift
//  FunctionalToolbox
//
//  Created by Pusca Ghenadie on 08/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import Foundation

// MARK: - Operators
precedencegroup Group { associativity: left }

infix operator -->?: Group
infix operator -->: Group
infix operator ->>: Group
infix operator ->>?: Group

// MARK: - IMpl

func -->? <T, U, V>(left: @escaping (T) -> U?, right: @escaping (U) -> V?) -> (T) -> V? {
    return {
        guard let value = left($0) else {
            return nil
        }
        return right(value)
    }
}

func --> <T, U, V>(left: @escaping (T) -> U, right: @escaping (U) -> V) -> (T) -> V {
    return { right(left($0)) }
}

func --> <T, U>(f: @escaping (T) -> U, sideEffect: @escaping (U) -> Void) -> (T) -> U {
    return {
        let res = f($0)
        sideEffect(res)
        return res
    }
}

func ->> <T, U, V>(left: @escaping (T) throws -> U, right: @escaping (U) throws -> V) -> (T) throws -> V {
    return {
        return try right(left($0))
    }
}

func ->> <T, U, V>(left: @escaping (T) throws -> U, right: @escaping (U) -> V) -> (T) throws -> V {
    return {
        return right(try left($0))
    }
}

func ->> <T, U, V>(left: @escaping (T) -> U, right: @escaping (U) throws-> V) -> (T) throws -> V {
    return {
        return try right(left($0))
    }
}

func ->> <T, U>(f: @escaping (T) throws -> U, sideEffect: @escaping (U) -> Void) -> (T) throws -> U {
    return {
        let res = try f($0)
        sideEffect(res)
        return res
    }
}

func ->>? <T, U>(left: @escaping (T) throws -> U, err: @escaping (Error) -> ()) -> (T) -> U? {
    return {
        do {
            return try left($0)
        } catch {
            err(error)
        }
        return nil
    }
}
