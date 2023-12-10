//
//  ObjcConverterApp.swift
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 11/24/23.
//

import SwiftUI

@main
struct ObjcConverterApp: App {
    @StateObject var dataController = DataController()
    
    init() {
        x_caml_startup()
    }
    
    var body: some Scene {
        Window("Objective-C Converter", id: "main") {
            ContentView()
        }
        
        Window("Substitutions", id: "substitutions") {
            SubstitutionView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError()
            }
        }
    }
}
