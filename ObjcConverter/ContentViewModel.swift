//
//  ContentViewModel.swift
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 12/9/23.
//

import AppKit

protocol ContentViewModelPr {
    var cursorPositionString: String { get }
    func updateCursorPosition()
    func convert()
    func copyToClipboard()
}

class ContentViewModel: ObservableObject, ContentViewModelPr {
    @Published var currentPosition = (0, 0)
    @Published var input = ""
    @Published var output = ""
    var introspectTextView: NSTextView?
    
    let converter = Converter()
    
    func updateCursorPosition() {
        currentPosition = (getCurrentLine(), getCurrentColumn())
    }
    
    func convert() {
        output = converter.process(input)
    }
    
    var cursorPositionString: String {
        "\(currentPosition.0):\(currentPosition.1)"
    }
    
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(output, forType: .string)
    }
    
    var cursorPosition: Int {
        guard let textView = introspectTextView,
              let selectedRange = textView.selectedRanges.first else {
            return 0
        }
        return selectedRange.rangeValue.location
    }
    
    func getCurrentLine() -> Int {
        guard let textView = introspectTextView,
              let text = textView.textStorage?.string else {
            return 0
        }
        let cursorIndex = text.index(text.startIndex, offsetBy: cursorPosition)
        let beforeCursor = text.prefix(upTo: cursorIndex)
        var numLines = 1
        for char in beforeCursor where char == "\n" {
            numLines += 1
        }
        return numLines
    }
    
    func getCurrentColumn() -> Int {
        guard let textView = introspectTextView,
              let text = textView.textStorage?.string else {
            return 0
        }
        let cursorIndex = text.index(text.startIndex, offsetBy: cursorPosition)
        let beforeCursor = String(text.prefix(upTo: cursorIndex).reversed())
        let startOfLineIndex = beforeCursor.firstIndex(of: "\n") ?? beforeCursor.endIndex
        return beforeCursor.distance(from: beforeCursor.startIndex, to: startOfLineIndex)
    }
}
