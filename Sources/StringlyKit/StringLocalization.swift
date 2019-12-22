//
//  File.swift
//  
//
//  Created by Yonas Kolb on 27/10/19.
//

import Foundation

public struct StringLocalization: Equatable {
    public let languages: [String: Language]
    public let placeholders: [Placeholder]

    var defaultLanguage: Language {
        languages["base"] ?? languages["en"]!
    }

    var hasPlurals: Bool {
        languages.values.contains { !$0.plurals.isEmpty }
    }

    var hasPlaceholders: Bool {
        !placeholders.isEmpty
    }

    func hasLanguage(_ language: String) -> Bool {
        languages[language] != nil
    }

    func languageHasPlurals(_ language: String) -> Bool {
        if let language = languages[language] {
            return !language.plurals.isEmpty
        } else {
            return false
        }
    }

    func getLanguages() -> Set<String> {
        Set(languages.keys)
    }

    public init(language: String, string: String) {
        self.languages = [language: Language(code: language, string: string, plurals: [:])]
        self.placeholders = Self.parsePlaceholders(string)
    }

    public init(languages: [String: Language], placeholders: [Placeholder] = []) {
        self.languages = languages
        self.placeholders = placeholders
    }

    public init(language: String, string: String, placeholders: [Placeholder]) {
        self.languages = [language: Language(code: language, string: string, plurals: [:])]
        self.placeholders = placeholders
    }

    public struct Language: Equatable {
        public let code: String
        public var string: String
        public var plurals: [String: [Plural: String]]

        public init(code: String, string: String, plurals: [String: [Plural: String]] = [:]) {
            self.code = code
            self.string = string
            self.plurals = plurals
        }
    }

    public struct Placeholder: Equatable {
        public var name: String
        public var type: String?

        public var originalPlaceholder: String {
            "{\(name)\(type.map { ":\($0)" } ?? "")}"
        }

        public init(name: String, type: String? = nil) {
            self.name = name
            self.type = type
        }
    }

    public enum Plural: String, CaseIterable {
        case zero
        case one
        case two
        case few
        case many
        case other
    }

    static let regex = try! NSRegularExpression(pattern: #"[^\\]\{(\S+)\}"#, options: [])

    static func parsePlaceholders(_ string: String) -> [Placeholder] {
        guard string.contains("{") else { return [] }
        let range = NSRange(string.startIndex..<string.endIndex, in: string)
        let matches = Self.regex.matches(in: string, options: [], range: range)
        var placeholders: [Placeholder] = []
        for match in matches {
            if let placeholderRange = Range(match.range(at: 1), in: string) {
                let placeholder = String(string[placeholderRange])
                let placeholderParts = placeholder.split(separator: ":").map(String.init)
                switch placeholderParts.count {
                case 1:
                    placeholders.append(Placeholder(name: placeholder))
                case 2:
                    placeholders.append(Placeholder(name: placeholderParts[0], type: placeholderParts[1]))
                default:
                    fatalError("Placeholder cannot contain more than one \":\"")
                }
            }
        }
        return placeholders
    }

    public static func en(_ string: String) -> StringLocalization {
        StringLocalization(language: "en", string: string)
    }

    public static func base(_ string: String) -> StringLocalization {
        StringLocalization(language: "base", string: string)
    }

    public func getPlaceholder(name: String) -> Placeholder? {
        placeholders.first { $0.name == name }
    }

    public func replacePlaceholders(_ string: String, pattern: (Placeholder) -> String) -> String {
        guard string.contains("{") else { return string }
        var string = string
        for placeholder in placeholders {
            string = string.replacingOccurrences(of: placeholder.originalPlaceholder, with: pattern(placeholder))
        }
        string = string.replacingOccurrences(of: #"\\\{(\S+)\}"#, with: "{$1}", options: .regularExpression)
        return string
    }

}

extension StringLocalization {
    init(_ dictionary: [String: Any]) {
        var placeholders: [Placeholder] = []

        var languages: [String: Language] = [:]
        for (key, value) in dictionary {

            let keyParts = key.components(separatedBy: ".")
            let code = keyParts[0]
            var language = languages[code] ?? Language(code: code, string: "", plurals: [:])
            switch keyParts.count {
            case 1:
                if let string = value as? String {
                    language.string = string
                    let stringPlaceholders = Self.parsePlaceholders(string)
                    for placeholder in stringPlaceholders {
                        if !placeholders.contains { $0.name == placeholder.name } {
                            placeholders.append(placeholder)
                        }
                    }
                }
            case 2:
                let placeholder = keyParts[1]
                if let pluralDictionary = value as? [String: String] {
                    for (pluralString, pluralValue) in pluralDictionary {
                        if let plural = Plural(rawValue: pluralString) {
                            language.plurals[placeholder, default: [:]][plural] = pluralValue
                        }
                    }
                }

            default:
                break
            }
            languages[code] = language
        }
        self.placeholders = placeholders
        self.languages = languages
    }
}
