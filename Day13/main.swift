import Foundation

let input = try! String(contentsOfFile: "day13-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)
let lines = input.components(separatedBy: .newlines)
let tuples = lines.map { (line) -> (Int, Int) in
    let parts = line.components(separatedBy: ": ")
    return (Int(parts[0])!, Int(parts[1])!)
}

let firewall = Dictionary(uniqueKeysWithValues: tuples)

// function to 'oscillate' between 0..<max
func wave(position: Int, max: Int) -> Int {
    return (abs(abs( position % (max*2) - max) - max));
}

func penetrate(withDelay delay: Int) -> (caught: Bool, severity: Int) {
    var severity = 0
    var caught = false
    // use the .max in case the list is not ordered
    for step in 0...firewall.keys.max()! {
        if let range = firewall[step] {
            if wave(position: step + delay, max: range-1) == 0 {
                caught = true
                severity += step * range
            }
        }
    }
    return (caught, severity)
}

print ("Part one: \(penetrate(withDelay: 0).severity)")

var delay = -1
repeat {
    delay += 1
} while penetrate(withDelay: delay).caught
print ("Part two: \(delay)")
