//
//  SubstitutionView.swift
//  ObjC Converter
//
//  Created by Vitaly Dolgov on 12/9/23.
//

import SwiftUI
import BindingKit

struct SubstitutionView: View {
    @State private var selection = Set<ObjectIdentifier>()
    @State private var sortOrder: [KeyPathComparator<Substitution>] = [.init(\.order)]
    @FocusState var orderInputIsFocused: Bool
    @ObservedObject var data: SubstitutionData
    
    var body: some View {
        VStack(spacing: 8) {
            Table(data.substitutions, selection: $selection, sortOrder: $sortOrder) {
                TableColumn("#") { row in
                    TextField("", value: $data[row.id].order, format: .number)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: orderInputIsFocused) {
                            if !orderInputIsFocused {
                                data.reload()
                            }
                        }
                        .focused($orderInputIsFocused)
                }
                .alignment(.numeric)
                
                TableColumn("Regular expression") { row in
                    TextField("", text: $data[row.id].regex ?? "")
                        .fontDesign(.monospaced)
                }
                .width(ideal: 200)

                TableColumn("Disabled") { row in
                    Toggle("", isOn: $data[row.id].disabled)
                }
                .alignment(.center)
            }
            .environment(\.defaultMinListRowHeight, 28)
            
            HStack {
                Button {
                    data.addNew()
                } label: {
                    Image(systemName: "plus")
                }
                
                Button {
                    data.remove(with: selection)
                    selection = Set()
                } label: {
                    Image(systemName: "minus")
                }
                .disabled(selection.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}
