// This file was auto-generated with https://github.com/yonaskolb/Stringly
// swiftlint:disable all

import Foundation

enum Strings {
    
    enum auth {
        
        /// Email
        static let emailTitle = Strings.localized("auth.emailTitle")
        /// Log In
        static let loginButton = Strings.localized("auth.loginButton")
        /// Password
        static let passwordTitle = Strings.localized("auth.passwordTitle")
        
        enum error {
            
            /// Incorrect email/password combination
            static let wrongEmailPassword = Strings.localized("auth.error.wrongEmailPassword")
        }
    }
    
    enum languages {
        
        /// Hello
        static let greeting = Strings.localized("languages.greeting")
    }
    
    enum placeholders {
        
        /// Text with escaped {braces}
        static let escaped = Strings.localized("placeholders.escaped")
        /// {**name**} with number {**number**}
        static func hello(name: String, number: Int) -> String {
            Strings.localized("placeholders.hello", name, number)
        }
    }
    
    enum plurals {
        
        /// There {**pluralized appleCount**} in the garden
        static func apples(appleCount: Int) -> String {
            Strings.localized("plurals.apples", appleCount)
        }
    }
}

extension Strings {
    private static func localized(table: String = "Strings", _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}