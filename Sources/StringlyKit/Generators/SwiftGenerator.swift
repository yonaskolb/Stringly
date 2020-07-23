//
//  File.swift
//  
//
//  Created by Yonas Kolb on 26/10/19.
//

import Foundation

public struct SwiftGenerator: Generator {

    let namespace = "Strings"

    public init() {}

    public func generate(stringGroup: StringGroup, language: String) -> String {


        let content = parseGroup(stringGroup, language: language).replacingOccurrences(of: "\n", with: "\n    ")

        let file = """
        // This file was auto-generated with https://github.com/yonaskolb/Stringly
        // swiftlint:disable all

        import Foundation

        public enum \(namespace) {\(content)
        }

        public protocol StringGroup {
            static var localizationKey: String { get }
        }

        extension StringGroup {

            public static func string(for key: String, _ args: CVarArg...) -> String {
                return Strings.localized(key: "\\(localizationKey).\\(key)", args: args)
            }
        }

        extension Strings {

            public static var bundle: Bundle = Bundle(for: BundleToken.self)

            fileprivate static func localized(_ key: String, in group: String, _ args: CVarArg...) -> String {
                return Strings.localized(key: "\\(group).\\(key)", args: args)
            }

            fileprivate static func localized(_ key: String, _ args: CVarArg...) -> String {
                return Strings.localized(key: key, args: args)
            }

            fileprivate static func localized(key: String, args: [CVarArg]) -> String {
                let format = NSLocalizedString(key, tableName: "String", bundle: bundle, comment: "")
                return String(format: format, locale: Locale.current, arguments: args)
            }
        }

        private final class BundleToken {}
        """
        return file
    }

    func parseGroup(_ group: StringGroup, language: String) -> String {

        var content = ""
        if !group.path.isEmpty {
            content += "public static let localizationKey = \"\(group.pathString)\""
        }
        let strings = group.strings.sorted { $0.key < $1.key }
        for (key, localizedString) in strings {
            let placeholders: [(name: String, type: String, named: Bool)] = localizedString.placeholders.enumerated().map { index, placeholder in
                let name = placeholder.hasName ? placeholder.name : "p\(index)"
                let type = PlaceholderType(string: placeholder.type ?? "@")?.rawValue ?? "CVarArg"
                return (name, type, placeholder.hasName)
            }

            let name = key
            var key = "\"\(name)\""
            if !group.path.isEmpty {
                key += ", in: localizationKey"
            }

            let line: String
            if placeholders.isEmpty {
                line = "public static let \(name) = \(namespace).localized(\(key))"
            } else {
                let params = placeholders
                .map { "\($0.named ? "" : "_ ")\($0.name): \($0.type)" }
                .joined(separator: ", ")

                let callingParams = placeholders
                .map { $0.name }
                .joined(separator: ", ")

                line  = """
                public static func \(name)(\(params)) -> String {
                    \(namespace).localized(\(key), \(callingParams))
                }
                """
            }
            let languageString = localizedString.languages[language]!
            let comment = localizedString.replacePlaceholders(languageString.string) { "**{\(languageString.plurals.isEmpty ? "" : "pluralized ")\($0.name)}**"}
            content += "\n/// \(comment)\n\(line)"
        }

        for group in group.groups {
            content += """

            
            public enum \(group.path.last!): StringGroup {
                \(parseGroup(group, language: language).replacingOccurrences(of: "\n", with: "\n    "))
            }
            """
        }
        return content
    }

}

fileprivate enum PlaceholderType: String {
    case object = "String"
    case float = "Float"
    case int = "Int"
    case char = "CChar"
    case cString = "UnsafePointer<CChar>"
    case pointer = "UnsafeRawPointer"

    static let unknown = pointer

    init?(string: String) {
        guard let firstChar = string.lowercased().first else {
            return nil
        }
        switch firstChar {
        case "@":
            self = .object
        case "a", "e", "f", "g":
            self = .float
        case "d", "i", "o", "u", "x":
            self = .int
        case "c":
            self = .char
        case "s":
            self = .cString
        case "p":
            self = .pointer
        default:
            return nil
        }
    }
}
