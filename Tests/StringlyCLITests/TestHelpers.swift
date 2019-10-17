//
//  File.swift
//  
//
//  Created by Yonas Kolb on 17/10/19.
//

import Foundation
import SwiftCLI

extension CLI {

    static func capture(_ block: () -> ()) -> (String, String) {
        let out = CaptureStream()
        let err = CaptureStream()

        Term.stdout = out
        Term.stderr = err
        block()
        Term.stdout = WriteStream.stdout
        Term.stderr = WriteStream.stderr

        out.closeWrite()
        err.closeWrite()

        return (out.readAll(), err.readAll())
    }

}
