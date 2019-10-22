//
//  File.swift
//  
//
//  Created by Yonas Kolb on 26/10/19.
//

import Foundation

public struct SwiftGenerator {

    let namespace = "Strings"

    public init() {}

    public func getSwiftFile(group: StringGroup, language: String) -> String {


        let content = parseGroup(group, language: language).replacingOccurrences(of: "\n", with: "\n    ")

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

        /*
         /// Report Conversation
         static let title = Strings.tr("Strings", "messages.reportConversation.title")

         static func intro(_ p1: Int, _ p2: String) -> String {
         return Strings.tr("Strings", "profile.intro", p1, p2)
         }
         */
        var content = ""
        let strings = group.strings.sorted { $0.key < $1.key }
        for (key, localizedString) in strings {
            let placeholders: [(name: String, type: String)] = localizedString.placeholders.map { placeholder in
                let name = placeholder.name
                let type = PlaceholderType(string: placeholder.type ?? "@")?.rawValue ?? "CVarArg"
                return (name, type)
            }

            let name = key
            let key = "\(group.pathString)\(group.path.isEmpty ? "" : ".")\(key)"
            let line: String
            if placeholders.isEmpty {
                line = "static let \(name) = \(namespace).localized(\"\(key)\")"
            } else {
                line  = """
                static func \(name)(\(placeholders.map { "\($0.name): \($0.type)" }.joined(separator: ", "))) -> String {
                    \(namespace).localized(\"\(key)\", \( placeholders.map { $0.name }.joined(separator: ", ")))
                }
                """
            }
            let languageString = localizedString.languages[language]!
            let comment = localizedString.replacePlaceholders(languageString.string) { "{**\(languageString.plurals.isEmpty ? "" : "pluralized ")\($0.name)**}"}
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
