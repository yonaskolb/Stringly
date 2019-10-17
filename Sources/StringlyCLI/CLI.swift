//
//  File.swift
//  
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation
import SwiftCLI

public class StringlyCLI {

    let version = "0.1.0"
    let cli: CLI

    public init() {
        let generateCommand = GenerateCommand()
        cli = CLI(name: "swiftgen", version: version, description: "Generates .string files from yaml files", commands: [generateCommand])
        cli.parser.routeBehavior = .searchWithFallback(generateCommand)
    }

    public func run(arguments: [String] = []) -> Int32 {
        if arguments.isEmpty {
            return cli.go()
        } else {
            return cli.go(with: arguments)
        }
    }
}
