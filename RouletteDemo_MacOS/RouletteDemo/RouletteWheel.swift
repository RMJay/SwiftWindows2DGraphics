//
//  RouletteWheel.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 16/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//

import AppKit

struct RouletteWheel: Drawable  {
    let numSlots: Int
    let outerRad: CGFloat
    let ballAreaRad: CGFloat
    let innerPocketRad: CGFloat
    let innerLabelRad: CGFloat
    let outerLabelRad: CGFloat
    let hubRad: CGFloat
    let spinnerBarRad: CGFloat
    let spinnerBarLength: CGFloat
    let spinnerBarEndKnobRad: CGFloat
    let spinnerPath: CGPath
    let selectables: [Selectable]
    
    init(numSlots: Int, outerRad: CGFloat, ballAreaRad: CGFloat, innerPocketRad: CGFloat,
         innerLabelRad: CGFloat, outerLabelRad: CGFloat, hubRad: CGFloat, spinnerBarRad: CGFloat,
         spinnerBarLength: CGFloat, spinnerBarEndKnobRad: CGFloat) {
        
        self.numSlots = numSlots
        self.outerRad = outerRad
        self.ballAreaRad = ballAreaRad
        self.innerPocketRad = innerPocketRad
        self.innerLabelRad = innerLabelRad
        self.outerLabelRad = outerLabelRad
        self.hubRad = hubRad
        self.spinnerBarRad = spinnerBarRad
        self.spinnerBarLength = spinnerBarLength
        self.spinnerBarEndKnobRad = spinnerBarEndKnobRad
        self.spinnerPath = RouletteWheel.makeSpinnerPath(spinnerBarRad: spinnerBarRad,
                                                         spinnerBarLength: spinnerBarLength,
                                                         spinnerBarEndKnobRad: spinnerBarEndKnobRad)
        var selectables = [Selectable]()
        for i in 0..<numSlots {
            let path = RouletteWheel.makePocketPath(slot: i, numSlots: numSlots,
                                                    innerPocketRad: innerPocketRad,
                                                    outerLabelRad: outerLabelRad)
            selectables.append(SelectionRegion(representing: EntityId.assignNew(), path: path))
        }
        selectables.append(SelectionRegion(representing: EntityId.assignNew(), path: spinnerPath))
        self.selectables = selectables
    }
    
    func draw(in context: CGContext, within dirtyRect: NSRect) {
        context.protectGState {
            context.setFillColor(#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1))
            context.fillEllipse(in: CGRect(x: -outerRad, y: -outerRad, width: 2*outerRad, height:2*outerRad))
            
            context.setFillColor(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1))
            context.fillEllipse(in: CGRect(x: -ballAreaRad, y: -ballAreaRad, width: 2*ballAreaRad, height:2*ballAreaRad))
            
            context.setFillColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
            context.fillEllipse(in: CGRect(x: -hubRad, y: -hubRad, width: 2*hubRad, height: 2*hubRad))
            
            context.rotate(by: .pi / 2)
            drawPockets(in: context)
            drawLabelBackgrounds(in: context)
            drawLabelText(in: context)
            drawSpinner(in: context)
        }
    }
    
    func drawPockets(in context: CGContext) {
        context.protectGState {
            context.setFillColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
            context.addArc(center: .zero,
                           radius: innerLabelRad,
                           startAngle: 0.0,
                           endAngle: 2 * .pi,
                           clockwise: true)
            context.addArc(center: .zero,
                           radius: innerPocketRad,
                           startAngle: 0.0,
                           endAngle: 2 * .pi,
                           clockwise: false)
            context.fillPath()
            
            let slotAngle = 2 * .pi / CGFloat(numSlots)
            context.setStrokeColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            context.rotate(by: -slotAngle / 2)
            
            for _ in 0..<numSlots {
                context.move(to: CGPoint(x: innerPocketRad, y: 0.0))
                context.addLine(to: CGPoint(x: innerLabelRad, y: 0.0))
                context.strokePath()
                context.rotate(by: slotAngle)
            }
        }
    }
    
    func drawLabelBackgrounds(in context: CGContext) {
        context.protectGState {
            let slotAngle = 2 * .pi / CGFloat(numSlots)
            context.rotate(by: -slotAngle / 2)
            for i in 0..<numSlots {
                if i % (numSlots / 2) == 0 {
                    context.setFillColor(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
                } else if i % 2 == 0 {
                    context.setFillColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
                } else {
                    context.setFillColor(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))
                }
                context.move(to: CGPoint(x: innerLabelRad, y: 0.0))
                context.addArc(center: .zero,
                               radius: outerLabelRad,
                               startAngle: 0,
                               endAngle: slotAngle,
                               clockwise: false)
                context.addArc(center: .zero,
                               radius: innerLabelRad,
                               startAngle: slotAngle,
                               endAngle:  0,
                               clockwise: true)
                context.fillPath()
                context.rotate(by: slotAngle)
            }
        }
    }
    
    func drawLabelText(in context: CGContext) {
        context.protectGState {
            let slotAngle = 2 * .pi / CGFloat(numSlots)
            let labelMidRad: CGFloat = (innerLabelRad + outerLabelRad) / 2.0
            
            let labelAttributes: [NSAttributedString.Key: Any] = [
                .font : NSFont(name: "Georgia-Bold", size: outerRad / 16)!,
                .foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ]
            
            for i in 0..<numSlots {
                let labelValue = String(i)
                let attributedString = NSAttributedString(string: labelValue, attributes: labelAttributes)
                let text = CTLineCreateWithAttributedString(attributedString)
                let textBounds = CTLineGetBoundsWithOptions(text, .useGlyphPathBounds)
                let tx = -textBounds.width / 2
                let ty = -textBounds.height / 2
                
                context.protectGState {
                    context.textMatrix = CGAffineTransform.identity.translatedBy(x: tx, y: ty)
                    context.translateBy(x: labelMidRad, y: 0)
                    context.rotate(by: -2 * .pi / 4.0)
                    CTLineDraw(text, context)
                }
                context.rotate(by: slotAngle)
            }
        }
    }
    
    func drawSpinner(in context: CGContext) {
        context.protectGState {
            context.setFillColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
            context.setStrokeColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            context.addPath(spinnerPath)
            context.fillPath()
            context.addPath(spinnerPath)
            context.strokePath()
        }
    }
    
    static func makeSpinnerPath(spinnerBarRad: CGFloat, spinnerBarLength: CGFloat,
                                spinnerBarEndKnobRad: CGFloat) -> CGPath {
        let pathBuilder = CGMutablePath()
        let a1 = .pi - asin(spinnerBarRad / spinnerBarEndKnobRad)
        
        let p1 = CGPoint(x: spinnerBarRad, y: spinnerBarRad)
        let p2 = CGPoint(x: spinnerBarLength, y: 0.0)
        let p3 = CGPoint(x: spinnerBarRad, y: -spinnerBarRad)
        
        pathBuilder.move(to: p1)
        var t = CGAffineTransform.identity
        for _ in 0..<4 {
            pathBuilder.addArc(center: p2,
                               radius: spinnerBarEndKnobRad,
                               startAngle: a1,
                               endAngle: -a1,
                               clockwise: true,
                               transform: t)
            pathBuilder.addLine(to: p3, transform: t)
            t = t.rotated(by: -.pi / 2.0)
        }
        pathBuilder.closeSubpath()
        
        return pathBuilder
    }
    
    static func makePocketPath(slot: Int, numSlots: Int, innerPocketRad: CGFloat, outerLabelRad: CGFloat) -> CGPath {
        let slotAngle = 2 * .pi / CGFloat(numSlots)
        let pathBuilder = CGMutablePath()
        pathBuilder.addArc(center: CGPoint.zero,
                    radius: outerLabelRad,
                    startAngle: 0, endAngle: slotAngle,
                    clockwise: false)
        pathBuilder.addArc(center: CGPoint.zero,
                    radius: innerPocketRad,
                    startAngle: slotAngle,
                    endAngle: 0,
                    clockwise: true)
        pathBuilder.closeSubpath()
        var transform = CGAffineTransform.init(rotationAngle: CGFloat(slot) * slotAngle)
        return pathBuilder.copy(using: &transform)!
    }

}
