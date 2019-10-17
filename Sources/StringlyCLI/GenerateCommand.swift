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
        let yaml: String = try sourcePath.read()
        let content: Any?
        do {
            content = try Yams.load(yaml: yaml)
        } catch {
            throw GenerateError.sourceParseError(error)
        }
        guard let dictionary = content as? [String: Any] else {
            throw GenerateError.unstructuredContent
        }

        let strings = StringGroup(dictionary)
        let stringsContent = strings.toStringsFile()

        if let destinationPath = self.destinationPath.value?.normalize() {
            try destinationPath.parent().mkpath()
            try destinationPath.write(stringsContent)
            Term.stdout.write("Generated \(destinationPath)")
        } else {
            Term.stdout.write(stringsContent)
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
