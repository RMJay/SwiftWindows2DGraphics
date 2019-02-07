//
//  Drawable.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 16/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//
import Foundation

public protocol Drawable {
    
    func draw(in: CGContext, within: CGRect)
    
}
