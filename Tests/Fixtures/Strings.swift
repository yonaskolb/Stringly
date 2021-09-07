// This file was auto-generated with https://github.com/yonaskolb/Stringly
// swiftlint:disable all

import Foundation

public enum Strings {
    /// Ok
    public static let ok = Strings.localized("ok")
    
    public enum auth: StringGroup {
        public static let localizationKey = "auth"
        /// Email
        public static let emailTitle = Strings.localized("emailTitle", in: localizationKey)
        /// Log In
        public static let loginButton = Strings.localized("loginButton", in: localizationKey)
        /// Password
        public static let passwordTitle = Strings.localized("passwordTitle", in: localizationKey)
        
        public enum error: StringGroup {
            public static let localizationKey = "auth.error"
            /// Incorrect email/password combination
            public static let wrongEmailPassword = Strings.localized("wrongEmailPassword", in: localizationKey)
        }
    }
    
    public enum languages: StringGroup {
        public static let localizationKey = "languages"
        /// Hello
        public static let greeting = Strings.localized("greeting", in: localizationKey)
    }
    
    public enum placeholders: StringGroup {
        public static let localizationKey = "placeholders"
        /// Text with escaped {braces}
        public static let escaped = Strings.localized("escaped", in: localizationKey)
        /// **{name}** with number **{number}**
        public static func hello(name: String, number: Int) -> String {
            Strings.localized("hello", in: localizationKey, name, number)
        }
        /// Text **{}**
        public static func unnamed(_ p0: String) -> String {
            Strings.localized("unnamed", in: localizationKey, p0)
        }
    }
    
    public enum plurals: StringGroup {
        public static let localizationKey = "plurals"
        /// There **{pluralized appleCount}** in the garden
        public static func apples(appleCount: Int) -> String {
            Strings.localized("apples", in: localizationKey, appleCount)
        }
    }
}

public protocol StringGroup {
    static var localizationKey: String { get }
}

extension StringGroup {

    public static func string(for key: String, _ args: CVarArg...) -> String {
        return Strings.localized(key: "\(localizationKey).\(key)", args: args)
    }
}

extension Strings {

    /// The bundle uses for localization
    public static var bundle: Bundle = Bundle(for: BundleToken.self)

    /// Allows overriding any particular key, for A/B tests for example. Values need to be correct for the current language
    public static var overrides: [String: String] = [:]

    fileprivate static func localized(_ key: String, in group: String, _ args: CVarArg...) -> String {
        return Strings.localized(key: "\(group).\(key)", args: args)
    }

    fileprivate static func localized(_ key: String, _ args: CVarArg...) -> String {
        return Strings.localized(key: key, args: args)
    }

    fileprivate static func localized(key: String, args: [CVarArg]) -> String {
        let format = overrides[key] ?? NSLocalizedString(key, tableName: "Strings", bundle: bundle, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}