//
//  ObjcConverterApp.swift
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 11/24/23.
//

import SwiftUI

@main
struct ObjcConverterApp: App {
    
    init() {
        x_caml_startup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationTitle("Objective-C Converter")
        }
        .windowResizability(.contentSize)
    }
}
