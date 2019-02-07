//
//  SelectionRegion.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 17/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//
import Foundation

class SelectionRegion: Selectable {

    let representedEntity: EntityId
    let bounds: CGRect
    let path: CGPath
    
    init(representing entity: EntityId, path: CGPath) {
        representedEntity = entity
        bounds = path.boundingBoxOfPath
        self.path = path
    }
    
    func hitTest(point: CGPoint) -> Bool {
        return path.contains(point)
    }
    
    func hoverDraw(in context: CGContext, within dirtyRect: CGRect) {
        context.protectGState {
            context.addPath(path)
            context.setFillColor(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 0.5))
            context.fillPath()
            context.addPath(path)
            context.setStrokeColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
            context.strokePath()
        }
    }
}
