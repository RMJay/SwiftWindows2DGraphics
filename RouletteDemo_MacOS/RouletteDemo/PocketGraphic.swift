//
//  PocketGraphic.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 16/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//
import AppKit

struct PocketGraphic: Drawable, Selectable {

    let number: Int
    let color: CGColor
    let innerPocketRad: CGFloat
    let innerLabelRad: CGFloat
    let outerLabelRad: CGFloat
    let slotAngle: CGFloat
    let angle: CGFloat
    let text: CTLine
    let textNudge: CGVector
    let hitTestRegion: CGPath
    let bounds: CGRect
    var representedEntity: EntityId
    
    init(numSlots: Int, number: Int, innerPocketRad: CGFloat, innerLabelRad: CGFloat, outerLabelRad: CGFloat, outerRad: CGFloat) {
        self.number = number
        representedEntity = EntityId(number)
        if number % (numSlots / 2) == 0 {
            color = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        } else if number % 2 == 0 {
            color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        }
        self.innerPocketRad = innerPocketRad
        self.innerLabelRad = innerLabelRad
        self.outerLabelRad = outerLabelRad
        slotAngle = (2 * .pi) / CGFloat(numSlots)
        angle = slotAngle * (CGFloat(number) - 0.5)
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font : NSFont(name: "Georgia-Bold", size: outerRad / 16)!,
            .foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ]
        let textString = String(number)
        let attributedString = NSAttributedString(string: textString, attributes: textAttributes)
        text = CTLineCreateWithAttributedString(attributedString)
        let textBounds = CTLineGetBoundsWithOptions(text, .useGlyphPathBounds)
        textNudge = CGVector(dx: -textBounds.width / 2, dy: -textBounds.height / 2)
        
        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: innerPocketRad, y: 0.0))
        mutablePath.addArc(center: .zero,
                       radius: innerPocketRad,
                       startAngle: 0,
                       endAngle: slotAngle,
                       clockwise: false)
        let tr = CGAffineTransform(rotationAngle: slotAngle)
        mutablePath.addLine(to: CGPoint(x: outerLabelRad, y: 0.0), transform: tr)
        mutablePath.addArc(center: .zero,
                       radius: outerLabelRad,
                       startAngle: 0,
                       endAngle:  -slotAngle,
                       clockwise: true,
                       transform: tr)
        mutablePath.closeSubpath()
        hitTestRegion = mutablePath
        bounds = hitTestRegion.boundingBoxOfPath
    }
    
    func draw(in context: CGContext, within dirtyRect: CGRect) {
        context.protectGState {
            context.rotate(by: angle)
            context.move(to: CGPoint(x: innerPocketRad, y: 0.0))
            context.addLine(to: CGPoint(x: innerLabelRad, y: 0.0))
            context.setStrokeColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            context.strokePath()
            
            context.move(to: CGPoint(x: innerLabelRad, y: 0.0))
            context.addArc(center: .zero,
                           radius: innerLabelRad,
                           startAngle: 0,
                           endAngle: slotAngle,
                           clockwise: false)
            context.rotate(by: slotAngle)
            context.addLine(to: CGPoint(x: outerLabelRad, y: 0.0))
            context.addArc(center: .zero,
                           radius: outerLabelRad,
                           startAngle: 0,
                           endAngle:  -slotAngle,
                           clockwise: true)
            context.rotate(by: -slotAngle)
            context.closePath()
            context.setFillColor(color)
            context.fillPath()
            
            context.protectGState {
                context.rotate(by: slotAngle / 2.0)
                context.textMatrix = CGAffineTransform.identity.translatedBy(x: textNudge.dx, y: textNudge.dy)
                let textRad = (innerLabelRad + outerLabelRad) / 2.0
                context.translateBy(x: textRad, y: 0)
                context.rotate(by: -.pi / 2.0)
                CTLineDraw(text, context)
            }
        }
    }
    
    func hoverDraw(in context: CGContext, within dirtyRect: CGRect) {
        context.protectGState {
            context.setFillColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.751689513))
            context.addPath(hitTestRegion)
            context.fillPath()
            context.addPath(hitTestRegion)
            context.setStrokeColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
            context.strokePath()
        }
    }
    
    func selectDraw(in context: CGContext, within dirtyRect: CGRect) {
        context.protectGState {
            context.setFillColor(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.7479869632))
            context.addPath(hitTestRegion)
            context.fillPath()
            context.addPath(hitTestRegion)
            context.setStrokeColor(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
            context.strokePath()
        }
    }
    
    func hitTest(point: CGPoint) -> Bool {
        return hitTestRegion.contains(point)
    }
    
}
