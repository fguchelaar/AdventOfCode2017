import Foundation

let input = try! String(contentsOfFile: "day2-input.txt")

let rows = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

let checksum1 = rows.map { $0.components(separatedBy: "\t").map { Int($0)! } }
                    .map { $0.max()! - $0.min()!}
                    .reduce(0, +)

print ("Part one: \(checksum1)")



let checksum2 = rows.reduce(0) { (sum, row) in
    
    let values = row.components(separatedBy: "\t")
        .map { Double($0)! }

    for i in 0..<values.count {
        for j in 0..<values.count {
            if i == j { continue }
            
            let result = values[i] / values[j]
            if (result.truncatingRemainder(dividingBy: 1.0) == 0.0) { return sum + Int(result) }
        }
    }
    return sum
}

print ("Part two \(checksum2)")
