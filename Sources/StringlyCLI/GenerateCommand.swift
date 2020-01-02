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
import Rainbow

class GenerateCommand: Command {

    let name: String = "generate"
    let shortDescription: String = "Generates all required localization files for a given platform"
    let platform = Key<PlatformType>("--platform", "-p", description: "The platform to generate files for. Defaults to apple")

    let sourcePath = Param.Required<Path>()
    let directoryPath = Key<Path>("--directory", "-d", description: "The directory to generate the files in. Defaults to the directory the source path is in")
    let baseLanguage = Key<String>("--base", "-b", description: "The base language to use. Defaults to en")

    func execute() throws {
        let sourcePath = self.sourcePath.value.normalize()
        let directoryPath = self.directoryPath.value ?? sourcePath.parent()
        let baseLanguage = self.baseLanguage.value ?? "en"
        let platform = self.platform.value ?? .apple

        let strings = try Loader.loadStrings(from: sourcePath, baseLanguage: baseLanguage)
        let languages = strings.getLanguages()

        switch platform {
        case .apple:
            for language in languages {
                try FileWriter.write(fileType: .strings, strings: strings, language: language, destinationPath: directoryPath + "\(language).lproj/Strings.strings")

                if strings.languageHasPlurals(language) {
                    try FileWriter.write(fileType: .stringsDict, strings: strings, language: language, destinationPath: directoryPath + "\(language).lproj/Strings.stringsdict")
                }
            }
            try FileWriter.write(fileType: .swift, strings: strings, language: baseLanguage, destinationPath: directoryPath + "Strings.swift")
        case .android:
            fatalError("Android not yet supported".red)
        }

    }
}


