//
//  Converter.swift
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 11/25/23.
//

import Foundation

struct Converter {
    let patterns: [String]
    
    func process(_ input: String) -> String {
        let data = input.data(using: .utf8)!
        let outputPtr = data.withUnsafeBytes { ptr in
            x_process(ptr)
        }!
        let converted = String(cString: UnsafePointer(outputPtr))
        let output = applySubstitutions(to: converted)
        return output
    }
    
    private func applySubstitutions(to text: String) -> String {
        var text = text
        for pattern in patterns.compactMap({ Pattern(pattern: $0) }) {
            do {
                text = try applyPattern(pattern, to: text)
            } catch {
                continue
            }
        }
        return text
    }
    
    private func applyPattern(_ pattern: Pattern, to text: String) throws -> String {
        var newTextComps = [String]()
        var prevMatchEndIndex = text.startIndex
        for match in text.matches(of: pattern.regex) {
            var replacement = pattern.replacement
            if match.count > 1 {
                for i in 1 ..< match.count {
                    guard let groupRange = match[i].range else {
                        continue
                    }
                    replacement = replacement.replacingOccurrences(of: "\\\(i)", with: text[groupRange])
                }
            }
            let afterPrevMatch = text.suffix(from: prevMatchEndIndex)
            let (beforeMatch, _) = dropMatch(for: match.range, in: afterPrevMatch)
            newTextComps += [String(beforeMatch), replacement]
            prevMatchEndIndex = match.range.upperBound
        }
        if newTextComps.isEmpty {
            throw Exception.notFound
        } else {
            let afterLastMatch = String(text.suffix(from: prevMatchEndIndex))
            newTextComps.append(afterLastMatch)
            return newTextComps.joined()
        }
    }
    
    private func dropMatch(for range: Range<String.Index>, in text: Substring) -> (Substring, Substring) {
        let beforeMatchText = text.prefix(upTo: range.lowerBound)
        let afterMatchText = text.suffix(from: range.upperBound)
        return (beforeMatchText, afterMatchText)
    }
}

struct Pattern {
    let regex: Regex<AnyRegexOutput>
    let replacement: String
    
    init?(pattern: String) {
        func components(of pattern: String) throws -> (Regex<AnyRegexOutput>, String) {
            guard let delimiter = pattern.first else {
                throw Exception.invalidArgument
            }
            let split = pattern.split(separator: delimiter)
            guard split.count == 2 else {
                throw Exception.invalidArgument
            }
            let inputRegex = String(split[0])
            let outputPattern = String(split[1])
            guard let regex = try? Regex(inputRegex),
                  !outputPattern.isEmpty else {
                throw Exception.invalidArgument
            }
            return (regex, outputPattern)
        }
        guard let comps = try? components(of: pattern) else {
            return nil
        }
        (regex, replacement) = comps
    }
}
