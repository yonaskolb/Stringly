//
//  File.swift
//  
//
//  Created by Yonas Kolb on 22/10/19.
//

import Foundation
import Codability


public struct StringsGenerator {

    public init() {}

    public func toString(stringGroup: StringGroup, language: String) -> String {
        let description = "// This file was auto-generated with https://github.com/yonaskolb/Stringly"
        return "\(description)\n\(lines(stringGroup, language: language).joined(separator: "\n"))"
    }

    func lines(_ stringGroup: StringGroup, language: String) -> [String] {
        var array: [String] = []

        array += stringGroup.strings
            .compactMap { (key, localisationString) in
                guard let language = localisationString.languages[language] else { return nil }
                let key = "\(stringGroup.pathString)\(stringGroup.path.isEmpty ? "" : ".")\(key)"
                let string = localisationString.replacePlaceholders(language.string) { $0.applePattern }
                return "\"\(key)\" = \"\(string)\";"
        }
        .sorted()

        let sortedGroups = stringGroup.groups
            .map { group -> [String] in

//                let comment = "\n/*** \(group.pathString.uppercased()) \(String(repeating: "*", count: 50 - group.pathString.count))/"
//                let commentChar = "#"
//                let lineLength = 50
//                let spacing = lineLength - group.pathString.count - 4
//                let commentLine = String(repeating: commentChar, count: lineLength)
//                let middleLine = "\(String(repeating: " ", count: Int(Double(spacing)/2 + 0.5)))\(group.pathString) \(String(repeating: " ", count: Int(Double(spacing)/2 + 0.5)))"
//                let comment = "\n\(commentLine)\n\(commentChar)\(middleLine)\(commentChar)\n\(commentLine)"
                if group.strings.values.contains(where: { $0.hasLanguage(language) }) {
                    let comment = "\n// \(group.pathString.uppercased())"
                    return [comment] + lines(group, language: language)
                } else {
                    return lines(group, language: language)
                }
        }

        let groupLines = sortedGroups.reduce([]) { $0 + $1 }
        array += groupLines
        return array
    }

}

extension StringLocalization.Placeholder {

    var applePattern: String {
        return "%" + (type ?? "@")
    }
}
