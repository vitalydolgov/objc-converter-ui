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
            let viewModel = ContentViewModel(substitutionData: dataController.substitutionData)
            ContentView(viewModel: viewModel)
        }
        
        Window("Substitutions", id: "substitutions") {
            SubstitutionView(data: dataController.substitutionData)
        }
    }
}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    let substitutionData: SubstitutionData
    
    init() {
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError()
            }
        }
        substitutionData = SubstitutionData(managedContext: container.viewContext)
    }
}
