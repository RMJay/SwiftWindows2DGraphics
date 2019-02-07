//
//  NumberFormatterExtension.swift
//  Interactive
//
//  Created by Robert Muckle-Jones on 17/07/2018.
//  Copyright © 2018 Robert Muckle-Jones. All rights reserved.
//
import Foundation

extension NumberFormatter {
    
    static let coordinate = makeCoordinateFormatter() //singleton
    static let dimension = makeDimensionFormatter() //singleton
    
    private static func makeDimensionFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumIntegerDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        return formatter
    }
    
    private static func makeCoordinateFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumIntegerDigits = 6
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
