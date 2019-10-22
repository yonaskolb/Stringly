//
//  File.swift
//  
//
//  Created by Yonas Kolb on 27/10/19.
//

import Foundation
import SwiftCLI

enum GenerateError: ProcessError {

    case sourceParseError(Error)
    case unstructuredContent
    case missingSource
    case encodingError(Error)
    case writingError(Error)
    case unknownFileType(String)

    var exitStatus: Int32 { 1 }

    var message: String? {
        return description.red
    }

    var description: String {
        switch self {
        case .sourceParseError: return "Failed to parse source file"
        case .unstructuredContent: return "Source file has unstructured content"
        case .missingSource: return "Source file does not exist"
        case .encodingError: return "Failed to encode file"
        case .writingError: return "Failed to write file"
        case .unknownFileType(let type): return "Unknown file type \"\(type)\""
        }
    }
}
