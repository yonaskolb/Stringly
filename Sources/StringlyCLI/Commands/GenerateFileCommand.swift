//
//  File.swift
//
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation
import SwiftCLI
import StringlyKit
import PathKit
import Yams
import TOMLDeserializer
import Rainbow

class GenerateFileCommand: Command {

    let name: String = "generate-file"
    let shortDescription: String = "Generates a specific file for a language"
    let longDescription: String = """
    Generates a single localization file in a single language from a source file. If no destination path is passed the file content will be written to stdout
    """

    let language = Key<String>("--language", "-l", description: "The language to generate. Defaults to en")
    let baseLanguage = Key<String>("--base", "-b", description: "The base language to use. Defaults to en")

    let type = Key<FileType>("--type", "-t", description: "The file type to generate. Defaults to inferring from the destination file extension")

    @Param
    var sourcePath: Path
    @Param
    var destinationPath: Path?

    func execute() throws {
        let sourcePath = self.sourcePath.normalize()
        let destinationPath = self.destinationPath?.normalize()
        let language = self.language.value ?? "en"
        let baseLanguage = self.baseLanguage.value ?? "en"

        let strings = try Loader.loadStrings(from: sourcePath, baseLanguage: baseLanguage)

        let fileType: FileType
        if let type = self.type.value {
            fileType = type
        } else {
            if let destinationPath = destinationPath, let type = FileType(path: destinationPath) {
                fileType = type
            } else {
                throw GenerateError.unknownFileType(destinationPath?.extension ?? "")
            }
        }

        try FileWriter.write(fileType: fileType, strings: strings, language: language, destinationPath: destinationPath)
    }
}
