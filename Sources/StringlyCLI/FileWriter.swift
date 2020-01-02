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

public struct FileWriter {

    public static func write(fileType: FileType, strings: StringGroup, language: String, destinationPath: Path?) throws {
        do {
            let generator = fileType.generator
            let content = try generator.generate(stringGroup: strings, language: language)
            try write(content: content, to: destinationPath)
        } catch {
            throw GenerateError.encodingError(error)
        }
    }

    static func write(content: String, to destinationPath: Path?) throws {
        if let destinationPath = destinationPath {
            do {
                try destinationPath.parent().mkpath()
                if destinationPath.exists, try destinationPath.read() == content {
                    // same content, don't write
                } else {
                    try destinationPath.write(content)
                }
            } catch {
                throw GenerateError.writingError(error)
            }
        } else {
            Term.stdout.print(content)
        }
    }

}


