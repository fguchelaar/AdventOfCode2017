import Foundation

let input = try! String(contentsOfFile: "day4-input.txt")
let rows = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

func check(passphrase: String) -> Bool {
    let words = passphrase.components(separatedBy: " ")
    let setOfWords = Set(words)
    return words.count > 1 && words.count == setOfWords.count
}

func validPassphrases(phrases: [String]) -> [String] {
    return phrases.filter { check(passphrase: $0) }
}

func containsAnagram(passphrase: String) -> Bool {
    let sortedByCharacters = passphrase.components(separatedBy: " ").map { String($0.sorted()) }
    return !check(passphrase: sortedByCharacters.joined(separator: " "))
}

let validPartOne = validPassphrases(phrases: rows).count
print("Part one: \(validPartOne)")

let validPartTwo = validPassphrases(phrases: rows).filter{ !containsAnagram(passphrase: $0) }.count
print("Part one: \(validPartTwo)")
