//
//  File.swift
//  
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation

public struct StringGroup {
    public var path: [String] = []
    public var groups: [StringGroup] = []
    public var strings: [String: String] = [:]

    public var pathString: String { path.joined(separator: ".") }

    public init(_ dictionary: [String: Any]) {
        self.init(dictionary: dictionary, depth: [])
    }

    init(dictionary: [String: Any], depth: [String]) {
        path = depth
        for (key, value) in dictionary {
            if let dictionary = value as? [String: Any] {
                let group = StringGroup(dictionary: dictionary, depth: depth + [key])
                groups.append(group)
            } else if let string = value as? String {
                strings[key] = string
            }
        }
    }
}

extension StringGroup {

    public func toStringsFile() -> String {
        let description = "// This file was auto-generated with https://github.com/yonaskolb/Stringly"
        return "\(description)\n\(lines.joined(separator: "\n"))"
    }

    private var lines: [String] {
        var array: [String] = []

        array += strings
            .map { "\"\(pathString)\(path.isEmpty ? "" : ".")\($0.key)\" = \"\($0.value)\";"}
            .sorted()
        let sortedGroups = groups
            .sorted { $0.pathString < $1.pathString }
            .map { group -> [String] in
                let comment = "\n/*** \(group.pathString.uppercased()) \(String(repeating: "*", count: 50 - group.pathString.count))/"
                return [comment] + group.lines
            }
        let groupLines = sortedGroups.reduce([]) { $0 + $1 }
        array += groupLines
        return array
    }
}
