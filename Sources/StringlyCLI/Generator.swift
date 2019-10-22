//
//  File.swift
//  
//
//  Created by Yonas Kolb on 27/10/19.
//

import Foundation
import PathKit
import SwiftCLI
import StringlyKit

public struct Generator {

    public static func generate(fileType: FileType, strings: StringGroup, language: String, destinationPath: Path?) throws {
        switch fileType {
        case .strings:
            let generator = StringsGenerator()
            let content = generator.toString(stringGroup: strings, language: language)
            try write(content: content, to: destinationPath)
        case .stringsDict:
            do {
                let generator = StringsDictGenerator()
                let content = try generator.toStringsDict(stringGroup: strings, language: language)
                try write(content: content, to: destinationPath)
            } catch {
                throw GenerateError.encodingError(error)
            }
        case .swift:
            let swiftGenerator = SwiftGenerator()
            let content = swiftGenerator.getSwiftFile(group: strings, language: language)
            try write(content: content, to: destinationPath)
        }
    }

    static func write(content: String, to destinationPath: Path?) throws {
        if let destinationPath = destinationPath {
            do {
                try destinationPath.parent().mkpath()
                try destinationPath.write(content)
            } catch {
                throw GenerateError.writingError(error)
            }
        } else {
            Term.stdout.print(content)
        }
    }

}


