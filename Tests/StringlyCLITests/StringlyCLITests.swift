import XCTest
import class Foundation.Bundle
import StringlyCLI
import PathKit

final class StringlyTests: XCTestCase {

    static let fixturePath = Path(#file).parent().parent() + "Fixtures"
    static let yamlPath = fixturePath + "Strings.yml"
    static let tomlPath = fixturePath + "Strings.toml"
    static let stringsPath = fixturePath + "Strings.strings"

    func testGeneration() throws {

        let stringsFile: String = try Self.stringsPath.read()

        let cli = StringlyCLI()

        XCTAssertEqual(0, cli.run(arguments: [Self.yamlPath.string, Self.stringsPath.string]))
        let yamlStringsFile: String = try Self.stringsPath.read()
        XCTAssertEqual(stringsFile, yamlStringsFile)

        XCTAssertEqual(0, cli.run(arguments: [Self.tomlPath.string, Self.stringsPath.string]))
        let tomlStringsFile: String = try Self.stringsPath.read()
        XCTAssertEqual(stringsFile, tomlStringsFile)
    }
}
