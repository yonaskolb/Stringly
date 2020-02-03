// This file was auto-generated with https://github.com/yonaskolb/Stringly
// swiftlint:disable all

import Foundation

public enum Strings {
    
    public enum auth {
        
        /// Email
        public static let emailTitle = Strings.localized("auth.emailTitle")
        /// Log In
        public static let loginButton = Strings.localized("auth.loginButton")
        /// Password
        public static let passwordTitle = Strings.localized("auth.passwordTitle")
        
        public enum error {
            
            /// Incorrect email/password combination
            public static let wrongEmailPassword = Strings.localized("auth.error.wrongEmailPassword")
        }
    }
    
    public enum languages {
        
        /// Hello
        public static let greeting = Strings.localized("languages.greeting")
    }
    
    public enum placeholders {
        
        /// Text with escaped {braces}
        public static let escaped = Strings.localized("placeholders.escaped")
        /// **{name}** with number **{number}**
        public static func hello(name: String, number: Int) -> String {
            Strings.localized("placeholders.hello", name, number)
        }
        /// Text **{}**
        public static func unnamed(_ p0: String) -> String {
            Strings.localized("placeholders.unnamed", p0)
        }
    }
    
    public enum plurals {
        
        /// There **{pluralized appleCount}** in the garden
        public static func apples(appleCount: Int) -> String {
            Strings.localized("plurals.apples", appleCount)
        }
    }
}

extension Strings {

    public static var bundle: Bundle = Bundle(for: BundleToken.self)

    private static func localized(table: String = "Strings", _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}