import Foundation

extension Collection {
    func combinations(n: Int) -> [[Element]] {
        
        if n == 0 {
            return [[]]
        }
        if self.isEmpty {
            return []
        }
        
        let x = self.first!
        let xs = Array(self.dropFirst())
        
        return xs.combinations(n: n-1).map { [x] + $0 } + xs.combinations(n: n)
    }
}

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
    
    let combinations = passphrase.components(separatedBy: " ").combinations(n: 2)
    return combinations.contains { $0[0].sorted() == $0[1].sorted() }
}

let validPartOne = validPassphrases(phrases: rows).count
print("Part one: \(validPartOne)")

let validPartTwo = validPassphrases(phrases: rows).filter{ !containsAnagram(passphrase: $0) }.count
print("Part one: \(validPartTwo)")
