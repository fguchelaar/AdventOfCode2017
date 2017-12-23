import Foundation

let b = 81 * 100 + 100000
let c = b + 17000
let z = 17
var h = 0

outerLoop: for i in stride(from: b, to: c + z, by: z) {

    for e in 2..<i {
        if i % e == 0 {
            h += 1
            continue outerLoop
        }
    }
}

print ("Part two: \(h)")
