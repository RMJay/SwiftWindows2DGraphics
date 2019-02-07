//
//  Highlightable.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 16/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//

import Foundation

public protocol Selectable{
    
    var bounds: CGRect { get }
    
    var representedEntity: EntityId { get }
    
    func hitTest(point: CGPoint) -> Bool
    
    func hoverDraw(in: CGContext, within: CGRect)
    
}
