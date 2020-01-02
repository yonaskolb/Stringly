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

        enum \(namespace) {\(content)
        }

        extension \(namespace) {
            private static func localized(table: String = "Strings", _ key: String, _ args: CVarArg...) -> String {
                let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
                return String(format: format, locale: Locale.current, arguments: args)
            }
        }

        private final class BundleToken {}
        """
        return file
    }

    func parseGroup(_ group: StringGroup, language: String) -> String {

        var content = ""
        let strings = group.strings.sorted { $0.key < $1.key }
        for (key, localizedString) in strings {
            let placeholders: [(name: String, type: String, named: Bool)] = localizedString.placeholders.enumerated().map { index, placeholder in
                let name = placeholder.hasName ? placeholder.name : "p\(index)"
                let type = PlaceholderType(string: placeholder.type ?? "@")?.rawValue ?? "CVarArg"
                return (name, type, placeholder.hasName)
            }

            let name = key
            let key = "\(group.pathString)\(group.path.isEmpty ? "" : ".")\(key)"
            let line: String
            if placeholders.isEmpty {
                line = "static let \(name) = \(namespace).localized(\"\(key)\")"
            } else {
                let params = placeholders
                .map { "\($0.named ? "" : "_ ")\($0.name): \($0.type)" }
                .joined(separator: ", ")

                let callingParams = placeholders
                .map { $0.name }
                .joined(separator: ", ")

                line  = """
                static func \(name)(\(params)) -> String {
                    \(namespace).localized(\"\(key)\", \(callingParams))
                }
                """
            }
            let languageString = localizedString.languages[language]!
            let comment = localizedString.replacePlaceholders(languageString.string) { "**{\(languageString.plurals.isEmpty ? "" : "pluralized ")\($0.name)}**"}
            content += "\n/// \(comment)\n\(line)"
        }

        for group in group.groups {
            content += """

            
            enum \(group.path.last!) {
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
