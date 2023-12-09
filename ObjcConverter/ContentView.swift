//
//  ContentView.swift
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 11/24/23.
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    let cursorPublisher = NotificationCenter.default
        .publisher(for: NSTextView.didChangeSelectionNotification)
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 3) {
                VStack(spacing: 12) {
                    TextEditor(text: $viewModel.input)
                        .introspect(.textEditor, on: (.macOS(.v14, .v13))) { nsTextView in
                            viewModel.introspectTextView = nsTextView
                        }
                        .fontDesign(.monospaced)
                        .onReceive(cursorPublisher) { obj in
                            viewModel.updateCursorPosition()
                        }
                    
                    LeftToolbarView(viewModel: viewModel)
                        .padding(.horizontal)
                }
                VStack(spacing: 12) {
                    TextEditor(text: .constant(viewModel.output))
                        .fontDesign(.monospaced)
                    
                    RightToolbarView(viewModel: viewModel)
                        .padding(.trailing)
                }
            }
        }
        .padding(.bottom)
    }
}

struct LeftToolbarView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        HStack {
            Button {
                viewModel.convert()
            } label: {
                Text("Convert ⌘S")
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .fontWeight(.semibold)
            .keyboardShortcut("s")
            
            Spacer()
            
            Text(viewModel.cursorPositionString)
                .fontDesign(.monospaced)
                .fontWeight(.bold)
        }
    }
}

struct RightToolbarView: View {
    @ObservedObject var viewModel: ContentViewModel

    var isCopyDisabled: Bool {
        !(viewModel.output.count > 0)
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.copyToClipboard()
            } label: {
                Text("Copy")
            }
            .buttonStyle(.borderedProminent)
            .tint(.gray)
            .fontWeight(.semibold)
            .disabled(isCopyDisabled)
        }
    }
}
