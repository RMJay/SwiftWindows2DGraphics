//
//  RouletteView.swift
//  RouletteDemo
//
//  Created by Robert Muckle-Jones on 07/02/2019.
//  Copyright © 2019 Robert Muckle-Jones. All rights reserved.
//
import AppKit

class RouletteView: NSView {
    
    let rouletteWheel: RouletteWheel
    var currentHovered: Selectable?
    
    required init(coder: NSCoder) {
        rouletteWheel = RouletteWheel(
            numSlots: 38,
            outerRad: 100.0,
            ballAreaRad: 90.0,
            innerPocketRad: 50.0,
            innerLabelRad: 60.0,
            outerLabelRad: 75.0,
            hubRad: 20.0,
            spinnerBarRad: 4.0,
            spinnerBarLength: 35.0,
            spinnerBarEndKnobRad: 5.5
        )
        currentHovered = nil
        super.init(coder: coder)!
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current!.cgContext
        
        context.setFillColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        context.fill(dirtyRect)
        
        rouletteWheel.draw(in: context, within: dirtyRect)
        
        if let currentHovered = currentHovered {
            currentHovered.hoverDraw(in: context, within: dirtyRect)
        }
    }
    
    func getSelectableEntity(at location: CGPoint) -> Selectable? {
        for selectable in rouletteWheel.selectables {
            if selectable.hitTest(point: location) {
                return selectable
            }
        }
        return nil
    }
    
    func highlightSelectable(at location: CGPoint) {
        let hovered = getSelectableEntity(at: location)
        switch (currentHovered, hovered) {
        case (.none, .none): break
        case (.some, .none):
            setNeedsDisplay(currentHovered!.bounds.inflated(by: 5.0))
            currentHovered = nil
        case (.none, .some):
            setNeedsDisplay(hovered!.bounds.inflated(by: 5.0))
            currentHovered = hovered
        case (.some, .some):
            if hovered!.representedEntity != currentHovered!.representedEntity {
                let invalidRect = hovered!.bounds.union(currentHovered!.bounds).inflated(by: 5.0)
                setNeedsDisplay(invalidRect)
                currentHovered = hovered
            }
        }
    }
}

extension CGContext {
    
    func protectGState(_ drawStuff : () -> Void) {
        saveGState()
        drawStuff()
        restoreGState()
    }
    
}

