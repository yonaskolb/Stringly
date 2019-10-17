//
//  File.swift
//  
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation
import SwiftCLI
import PathKit
import Yams
import TOMLDeserializer

class GenerateCommand: Command {

    let name: String = "generate"
    let shortDescription: String = "Generates a .strings file from a yaml/json file."
    let longDescription: String = """
    Generates a .strings file from a yaml file. If no destination path is passed the file content will be written to stdout
    """

    let sourcePath = Param.Required<Path>()
    let destinationPath = Param.Optional<Path>()

    func execute() throws {
        let sourcePath = self.sourcePath.value.normalize()
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

        let strings = StringGroup(dictionary)
        let stringsContent = strings.toStringsFile()

        if let destinationPath = self.destinationPath.value?.normalize() {
            try destinationPath.parent().mkpath()
            try destinationPath.write(stringsContent)
        } else {
            Term.stdout.print(stringsContent)
        }
    }
}

enum GenerateError: ProcessError {

    case sourceParseError(Error)
    case unstructuredContent
    case missingSource

    var exitStatus: Int32 { 1 }

    var message: String? {
        switch self {
        case .sourceParseError: return "Failed to parse source"
        case .unstructuredContent: return "Source file has unstructured content"
        case .missingSource: return "Source file does not exist"
        }
    }
}

extension Path: ConvertibleFromString {
    public static func convert(from: String) -> Path? {
        Path(from)
    }
}
