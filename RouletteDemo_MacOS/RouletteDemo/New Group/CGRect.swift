//
//  CGRectExtension.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 17/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//
import Foundation

extension CGRect {
    
    func inflated(by margin: CGFloat) -> CGRect {
        return CGRect(x: self.minX - margin, y: self.minY - margin,
                      width: self.width + 2 * margin, height: self.height + 2 * margin)
    }
    
}
