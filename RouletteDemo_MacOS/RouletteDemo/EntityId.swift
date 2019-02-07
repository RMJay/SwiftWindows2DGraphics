//
//  EntityId.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 16/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//

import Foundation

public struct EntityId: CustomStringConvertible, Equatable, Hashable {

    public let value: Int
    public let description: String
    public let hashValue: Int

    public init(_ i: Int) {
        value = i
        description = "e\(i)"
        hashValue = description.hashValue
    }
    
    public static func ==(lhs: EntityId, rhs: EntityId) -> Bool {
        return lhs.description == rhs.description
    }
    
    private static var highestAssigned: Int = 0
    
    public static func assignNew() -> EntityId {
        let num = highestAssigned + 1
        highestAssigned = num
        return EntityId(num)
    }
    
}
