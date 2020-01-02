//
//  File.swift
//  
//
//  Created by Yonas Kolb on 2/1/20.
//

import Foundation

public protocol Generator {

    func generate(stringGroup: StringGroup, language: String) throws -> String
}
