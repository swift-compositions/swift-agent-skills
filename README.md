# swift-agent-skills

Use this package when you need to check that an agent-skill document meets the canonical contract before you load or publish it. Start from `Skill.Document`, and pass the skill's directory name as `expectedName` when you have one.

## Laws

- The document must open with a `---` line and close its frontmatter with another `---` line. Inside, every line is a field that starts in the first column. Blank or indented lines there are refused.
- The frontmatter holds exactly `name` and `description`, each once. Any other field is refused, so routing or dependency metadata can't be added.
- A value is either written on the field's line or given as a `|` block. A block's lines are indented by two spaces, which are removed, and the lines are joined with newlines. A block runs until the closing `---`, so it must be the last field.
- A name is 1 to 64 bytes of lowercase ASCII letters, digits and hyphens, and doesn't start or end with a hyphen. When `expectedName` is given, the name must equal it exactly.
- The description has surrounding whitespace trimmed before it is checked and stored. It must then be non-empty, at most 1024 UTF-8 bytes, and contain no `<` or `>`.
- The body is everything after the closing `---` line. It must contain something other than whitespace, and is otherwise kept as written.
- A document is at most 500 lines. A final newline doesn't start an extra line, so 500 lines followed by a newline is accepted.
- CRLF and lone CR line endings count as line breaks. The body comes back with LF line endings.
