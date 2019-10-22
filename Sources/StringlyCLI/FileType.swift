//
//  File.swift
//  
//
//  Created by Yonas Kolb on 27/10/19.
//

import Foundation
import SwiftCLI
import PathKit

public enum FileType: String, ConvertibleFromString {
    case strings
    case stringsDict
    case swift

    init?(path: Path) {
        switch path.extension?.lowercased() {
        case "strings": self = .strings
        case "stringsdict": self = .stringsDict
        case "swift": self = .swift
        default: return nil
        }
    }
}
