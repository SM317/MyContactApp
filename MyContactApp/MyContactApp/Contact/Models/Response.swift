//
//  Result.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation

/// Enum type which encapsulates the result of an operation which can either succeed or fail
///
/// - success: Success case, with associated value of type Value
/// - failure: Failure case, with associated value of type Error
public enum Response<Value> {
    case success(Value)
    case failure(Error)
}
