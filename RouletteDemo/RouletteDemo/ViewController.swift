//
//  ViewController.swift
//  RouletteDemo
//
//  Created by Robert Muckle-Jones on 07/02/2019.
//  Copyright © 2019 Robert Muckle-Jones. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var rouletteView: RouletteView!
    @IBOutlet weak var coordinatesLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleToFitAndCenter()
        
        let trackingArea = NSTrackingArea(rect: rouletteView.visibleRect,
                                          options: [.activeAlways, .mouseMoved],
                                          owner: self, userInfo: nil)
        rouletteView.addTrackingArea(trackingArea)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(viewFrameChanged),
                         name: NSClipView.frameDidChangeNotification,
                         object: rouletteView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc override func mouseMoved(with event: NSEvent) {
        let coord = rouletteView.convert(event.locationInWindow, from: nil)
        displayMouseCoords(coord)
        rouletteView.highlightSelectable(at: coord)
    }
    
    @objc public func viewFrameChanged(_ notification: Notification) {
        scaleToFitAndCenter()
    }
    
    func scaleToFitAndCenter() {
        let width = rouletteView.bounds.width
        let height = rouletteView.bounds.height
        let targetWidth: CGFloat
        let targetHeight: CGFloat
        if width < height {
            targetWidth = 2.1 * rouletteView.rouletteWheel.outerRad
            targetHeight = (height / width) * targetWidth
        } else {
            targetHeight = 2.1 * rouletteView.rouletteWheel.outerRad
            targetWidth = (width / height) * targetHeight
        }
        
        rouletteView.setBoundsSize(NSSize(width: targetWidth, height: targetHeight))
        rouletteView.setBoundsOrigin(CGPoint(x: -targetWidth / 2, y: -targetHeight / 2))
    }
    
    func displayMouseCoords(_ coord: NSPoint) {
        let xString = NumberFormatter.coordinate.string(from: coord.x as NSNumber)
        let yString = NumberFormatter.coordinate.string(from: coord.y as NSNumber)
        coordinatesLabel.stringValue = "x: \(xString ?? "na"), y: \(yString ?? "na")"
    }


}

