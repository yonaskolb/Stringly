import XCTest
import class Foundation.Bundle
import StringlyCLI
import PathKit

final class StringlyTests: XCTestCase {

    static let fixturePath = Path(#file).parent().parent() + "Fixtures"
    static let yamlPath = fixturePath + "Strings.yml"
    static let stringsPath = fixturePath + "Strings.strings"

    func testGeneration() throws {

        let stringsFile: String = try Self.stringsPath.read()

        let cli = StringlyCLI()
        let status = cli.run(arguments: [Self.yamlPath.string, Self.stringsPath.string])
        XCTAssertEqual(status, 0)

        let newStringsFile: String = try Self.stringsPath.read()
        XCTAssertEqual(stringsFile, newStringsFile)
    }
}
