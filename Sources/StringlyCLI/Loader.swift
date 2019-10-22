//
//  File.swift
//  
//
//  Created by Yonas Kolb on 27/10/19.
//

import Foundation
import StringlyKit
import TOMLDeserializer
import PathKit
import Yams

public struct Loader {

    public static func loadStrings(from sourcePath: Path, baseLanguage: String) throws -> StringGroup {
        if !sourcePath.exists {
            throw GenerateError.missingSource
        }
        let sourceString: String = try sourcePath.read()
        let dictionary: [String: Any]
        do {
            switch sourcePath.extension {
            case "toml", "tml":
                dictionary = try TOMLDeserializer.tomlTable(with: sourceString)
            default:
                let yaml = try Yams.load(yaml: sourceString)
                guard let dict = yaml as? [String: Any] else {
                    throw GenerateError.unstructuredContent
                }
                dictionary = dict
            }
        } catch {
            throw GenerateError.sourceParseError(error)
        }

        let strings = StringGroup(dictionary, baseLanguage: baseLanguage)
        return strings
    }
}
