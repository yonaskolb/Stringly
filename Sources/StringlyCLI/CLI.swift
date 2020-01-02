//
//  File.swift
//  
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation
import SwiftCLI
import PathKit

public class StringlyCLI {

    let version = "0.3.0"
    let cli: CLI

    public init() {
        cli = CLI(name: "stringly", version: version, description: "Generates localization files from a spec", commands: [
            GenerateCommand(),
            GenerateFileCommand(),
            ])
    }

    public func run(arguments: [String] = []) -> Int32 {
        if arguments.isEmpty {
            return cli.go()
        } else {
            return cli.go(with: arguments)
        }
    }
}

extension Path: ConvertibleFromString {
    public static func convert(from: String) -> Path? {
        Path(from)
    }
}
