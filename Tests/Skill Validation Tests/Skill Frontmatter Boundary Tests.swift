import Testing

@testable import Skill_Validation

@Suite
struct `Skill frontmatter boundaries` {
    private func parse(_ source: String) throws(Skill.Error) -> Skill.Document {
        try Skill.Document(source: source, expectedName: "example-skill")
    }

    @Test
    func `a description of exactly 1024 bytes is accepted`() throws {
        let description = String(repeating: "x", count: 1_024)
        let document = try parse("---\nname: example-skill\ndescription: \(description)\n---\n# Example")
        #expect(document.description.utf8.count == 1_024)
    }

    @Test
    func `a whitespace-only description is empty`() {
        #expect(throws: Skill.Error.descriptionIsEmpty) {
            _ = try parse("---\nname: example-skill\ndescription: |\n   \n---\n# Example")
        }
    }

    @Test(arguments: [
        "name: example-skill\ndescription: d\n---\n# Example",
        "---\nname example-skill\ndescription: d\n---\n# Example",
        "---\n name: example-skill\ndescription: d\n---\n# Example",
        "---\nname:\ndescription: d\n---\n# Example",
        "---\nname: example-skill\ndescription: d\n# Example",
    ])
    func `malformed frontmatter is rejected`(_ source: String) {
        #expect(throws: Skill.Error.invalidFrontmatter) { _ = try parse(source) }
    }

    @Test
    func `five hundred lines are accepted and five hundred and one are not`() throws {
        let header = "---\nname: example-skill\ndescription: d\n---\n# Example\n"
        let fits = header + String(repeating: "line\n", count: 495)
        let over = header + String(repeating: "line\n", count: 496)
        _ = try parse(fits)
        #expect(throws: Skill.Error.tooManyLines(actual: 501, maximum: 500)) { _ = try parse(over) }
    }
}
