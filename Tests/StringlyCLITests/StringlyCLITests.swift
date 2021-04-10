import XCTest
import StringlyCLI
import PathKit

final class StringlyTests: XCTestCase {

    static let fixturePath = Path(#file).parent().parent() + "Fixtures"

    static let stringsYamlPath = fixturePath + "Strings.yml"

    func generateFileDiff(destination: Path, language: String = "en", file: StaticString = #file, line: UInt = #line) throws {
        let previousFile: String = try destination.read()

        let cli = StringlyCLI()
        let output = cli.run(arguments: ["generate-file", Self.stringsYamlPath.string, destination.string, "--language", language])
        XCTAssertEqual(0, output, file: file, line: line)

        let newFile: String = try destination.read()
        if newFile != previousFile {
            let message = prettyFirstDifferenceBetweenStrings(newFile, previousFile)
            XCTFail("\(destination.lastComponent) has changed:\n\(message)", file: file, line: line)
        }
    }

    func testStringsGeneration() throws {
        try generateFileDiff(destination: Self.fixturePath + "Apple/en.lproj/Strings.strings")
    }

    func testStringsDictGeneration() throws {
        try generateFileDiff(destination: Self.fixturePath + "Apple/en.lproj/Strings.stringsdict")
    }

    func testSwiftGeneration() throws {
        try generateFileDiff(destination: Self.fixturePath + "Apple/Strings.swift")
    }

    func testResourceXMLGeneration() throws {
        try generateFileDiff(destination: Self.fixturePath + "Android/res/values-en/strings.xml")
    }

    func testTomlParsing() throws {
        let strings = try Loader.loadStrings(from: Self.fixturePath + "Strings.toml", baseLanguage: "en")
        XCTAssertNotNil(strings)
    }

    func testAppleGenerate() throws {
        let cli = StringlyCLI()
        let output = cli.run(arguments: ["generate", Self.stringsYamlPath.string, "--directory", (Self.fixturePath + "Apple").string, "--platform", "apple"])
        XCTAssertEqual(0, output)
    }

    func testAndroidGenerate() throws {
        let cli = StringlyCLI()
        let output = cli.run(arguments: ["generate", Self.stringsYamlPath.string, "--directory", (Self.fixturePath + "Android").string, "--platform", "android"])
        XCTAssertEqual(0, output)
    }
}
