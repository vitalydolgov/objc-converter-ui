//
//  Converter.swift
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 11/25/23.
//

import Foundation

struct Converter {
    func process(_ input: String) -> String {
        let data = input.data(using: .utf8)!
        let outputPtr = data.withUnsafeBytes { ptr in
            x_process(ptr)
        }!
        let output = String(cString: UnsafePointer(outputPtr))
        return output
    }
}
