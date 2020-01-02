//
//  File.swift
//
//
//  Created by Yonas Kolb on 22/10/19.
//

import Foundation
import Codability

struct StringsDict: Encodable {
    var keys: [String: FormatKey]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RawCodingKey.self)

        for (key, format) in keys {
            try container.encode(format, forKey: .init(string: key))
        }
    }

    struct FormatKey: Encodable {
        var format: String
        var rules: [String: Rule]

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RawCodingKey.self)
            try container.encode(format, forKey: "NSStringLocalizedFormatKey")
            for (name, variable) in rules {
                try container.encode(variable, forKey: .init(string: name))
            }
        }
    }

    struct Rule: Encodable {
        var format: String
        var plurals: [StringLocalization.Plural: String]
        var ruleType = "NSStringPluralRuleType"

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RawCodingKey.self)
            try container.encode(ruleType, forKey: "NSStringFormatSpecTypeKey")
            try container.encode(format, forKey: "NSStringFormatValueTypeKey")
            for (plural, value) in plurals {
                try container.encode(value, forKey: .init(string: plural.rawValue))
            }
        }
    }
}

public struct StringsDictGenerator: Generator {

    public init() {}

    public func generate(stringGroup: StringGroup, language: String) throws -> String {

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        var keys: [String: StringsDict.FormatKey] = [:]

        func handleGroup(_ group: StringGroup) {
            for (key, string) in group.strings {
                guard let language = string.languages[language], !language.plurals.isEmpty else { continue }
                var formatString = language.string
                for placeholder in string.placeholders {
                    formatString = formatString.replacingOccurrences(of: placeholder.originalPlaceholder, with: "%#@\(placeholder.name)@")
                }
                var format = StringsDict.FormatKey(format: formatString, rules: [:])
                for (placeholderString, plurals) in language.plurals {
                    guard let placeholder = string.getPlaceholder(name: placeholderString),
                        let placeholderType = placeholder.type else { continue }
                    let plurals = plurals.mapValues {
                        string.replacePlaceholders($0) { $0.applePattern }
                    }
                    let rule = StringsDict.Rule(format: placeholderType, plurals: plurals)
                    format.rules[placeholderString] = rule
                }
                let stringKey = "\(group.pathString)\(group.path.isEmpty ? "" : ".")\(key)"
                keys[stringKey] = format
            }

            for group in group.groups {
                handleGroup(group)
            }
        }
        handleGroup(stringGroup)

        let stringsDict = StringsDict(keys: keys)

        let data = try encoder.encode(stringsDict)
        return String(data: data, encoding: .utf8) ?? ""
    }

}
