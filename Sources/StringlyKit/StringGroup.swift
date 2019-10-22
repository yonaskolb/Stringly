//
//  File.swift
//  
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation

public struct StringGroup: Equatable {
    public var path: [String] = []
    public var groups: [StringGroup] = []
    public var strings: [String: StringLocalization] = [:]

    public var pathString: String { path.joined(separator: ".") }

    public init(_ dictionary: [String: Any], baseLanguage: String) {
        self.init(dictionary: dictionary, depth: [], baseLanguage: baseLanguage)
    }

    init(dictionary: [String: Any], depth: [String], baseLanguage: String) {
        path = depth
        for (key, value) in dictionary {
            if let dictionary = value as? [String: Any] {
                if dictionary.keys.contains(baseLanguage) {
                    let localization = StringLocalization(dictionary)
                    strings[key] = localization
                } else {
                    let group = StringGroup(dictionary: dictionary, depth: depth + [key], baseLanguage: baseLanguage)
                    groups.append(group)
                }
            } else if let string = value as? String {
                strings[key] = StringLocalization(language: baseLanguage, string: string)
            }
        }
        self.groups.sort { $0.pathString < $1.pathString }
    }

    public init(path: [String] = [], groups: [StringGroup] = [], strings: [String: StringLocalization] = [:]) {
        self.path = path
        self.groups = groups
        self.strings = strings
    }

    public var hasPlurals: Bool {
        strings.values.contains { $0.hasPlurals } || groups.contains { $0.hasPlurals }
    }

    public var hasPlaceholders: Bool {
        strings.values.contains { $0.hasPlaceholders } || groups.contains { $0.hasPlaceholders }
    }

    public func languageHasPlurals(_ language: String) -> Bool {
        strings.values.contains { $0.languageHasPlurals(language) } || groups.contains { $0.languageHasPlurals(language) }
    }

    public func hasLanguage(_ language: String) -> Bool {
        strings.values.contains { $0.hasLanguage(language) } || groups.contains { $0.hasLanguage(language) }
    }

    public func getLanguages() -> Set<String> {
        Set(
            strings.values.reduce([]) { $0 + $1.languages.keys } +
            groups.reduce([]) { $0 + Array($1.getLanguages()) }
        )
    }
}
