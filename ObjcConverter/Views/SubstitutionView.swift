//
//  SubstitutionView.swift
//  ObjC Converter
//
//  Created by Vitaly Dolgov on 12/9/23.
//

import SwiftUI

struct SubstitutionItem: View {
    @State private var inputRegex: String
    @State private var inputOrder: String
    @State private var inputDisabled: Bool
    @Environment(\.managedObjectContext) var dataContext
    @ObservedObject var substitution: Substitution
    
    init(substitution: Substitution) {
        self.inputRegex = substitution.regex ?? ""
        self.inputOrder = String(substitution.order)
        self.inputDisabled = substitution.disabled
        self.substitution = substitution
    }
    
    var body: some View {
        HStack(spacing: 16) {
            TextField("", text: $inputOrder) {
                substitution.order = Int16(inputOrder) ?? 0
                try? dataContext.save()
            }
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 30)
            
            TextField("", text: $inputRegex) {
                substitution.regex = inputRegex
                try? dataContext.save()
            }
            
            Spacer()
            
            Toggle(isOn: $inputDisabled, label: {
                
            })
            .onChange(of: inputDisabled) { oldValue, newValue in
                substitution.disabled = newValue
                try? dataContext.save()
            }
        }
        .fontDesign(.monospaced)
    }
}

struct SubstitutionView: View {
    @State private var selectedItem: Substitution?
    @Environment(\.managedObjectContext) var dataContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Substitution.order, ascending: true)
    ]) var substitutions: FetchedResults<Substitution>
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(spacing: 16) {
                Text("#")
                    .frame(minWidth: 30)
                
                Text("Regular expression")
                
                Spacer()
                
                Text("Disable")
            }
            .fontWeight(.semibold)
            .padding(.horizontal)
            
            List(substitutions, id: \.self, selection: $selectedItem) { substitution in
                SubstitutionItem(substitution: substitution)
            }
            
            HStack {
                Button {
                    let substitution = Substitution(context: dataContext)
                    substitution.regex = "/<regex>/<replac>/"
                    try? dataContext.save()
                } label: {
                    Image(systemName: "plus")
                }
                
                Button {
                    guard let selectedItem else {
                        return
                    }
                    dataContext.delete(selectedItem)
                    if let _ = try? dataContext.save() {
                        self.selectedItem = nil
                    }
                } label: {
                    Image(systemName: "minus")
                }
                .disabled(selectedItem == nil)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
