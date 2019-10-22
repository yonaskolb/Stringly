import XCTest
import StringlyKit
import PathKit

final class StringlyTests: XCTestCase {

    static let fixturePath = Path(#file).parent().parent() + "Fixtures"
    static let yamlPath = fixturePath + "Strings.yml"
    static let tomlPath = fixturePath + "Strings.toml"
    static let stringsPath = fixturePath + "Strings.strings"

    func testParsing() throws {
        let dictionary: [String: Any] = [
            "group": [
                "simple": "value",
                "group2": [
                    "simple2": "value"
                ]
            ],
            "placeholders": [
                "string": "Hello ${name} how many ${numbers:u}"
            ]
        ]
        let strings = StringGroup(dictionary, baseLanguage: "en")
        let expectedString = StringGroup(groups: [
            StringGroup(
                path: ["group"],
                groups: [
                    StringGroup(
                        path: ["group", "group2"],
                        strings: ["simple2" : .en("value")]
                    )
                ],
                strings: ["simple": .en("value")]
            ),
            StringGroup(
                path: ["placeholders"],
                strings: [
                    "string": StringLocalization(
                        language: "en",
                        string: "Hello ${name} how many ${numbers:u}",
                        placeholders: [
                            StringLocalization.Placeholder(name: "name"),
                            StringLocalization.Placeholder(name: "numbers", type: "u")
                        ])
                ])
        ])
        XCTAssertEqual(strings, expectedString)
    }
}
