//
//  File.swift
//  
//
//  Created by Yonas Kolb on 10/4/21.
//

import Foundation

/// https://developer.android.com/guide/topics/resources/string-resource
public struct ResourceXMLGenerator: Generator {

    public init() {
        
    }

    public func generate(stringGroup: StringGroup, language: String) throws -> String {
        """
        <!-- This file was generated with https://github.com/yonaskolb/Stringly -->"
        <resources>
            \(lines(stringGroup, language: language).joined(separator: "\n    "))
        </resources>
        """
    }

    func lines(_ stringGroup: StringGroup, language: String) -> [String] {
        var array: [String] = []

        array += stringGroup.strings
            .compactMap { (key, localisationString) in
                guard let language = localisationString.languages[language] else { return nil }
                let key = "\(stringGroup.path.joined(separator: "_"))\(stringGroup.path.isEmpty ? "" : "_")\(key)"
                let string = localisationString.replacePlaceholders(language.string) { index, placeholder in
                    placeholder.androidPattern(index: index) }
                return "<string name=\"\(key)\">\(string)</string>"
            }
            .sorted()

        let sortedGroups = stringGroup.groups
            .map { group -> [String] in

                if group.strings.values.contains(where: { $0.hasLanguage(language) }) {
                    let comment = "\n    <!-- \(group.pathString.uppercased()) -->"
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

    func androidPattern(index: Int) -> String {
        let typeString = type == "u" ? "d" : type ?? "s"
        return "%\(index + 1)$\(typeString)"
    }
}
