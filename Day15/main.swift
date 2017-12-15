import Foundation

class Generator {
    let divisor = 2147483647
    
    var value: Int
    var factor: Int
    
    init(startValue value: Int, factor: Int) {
        self.value = value
        self.factor = factor
    }
    
    func next() -> Int {
        value = (value * factor) % divisor
        return value
    }
    
    func next(with: Int) -> Int {
        repeat {
            _ = self.next()
        } while (value & (with-1) != 0)
        return value
    }
}

let check = Int(pow(Double(2), Double(16))) - 1

measure {
    let generatorA =  Generator(startValue: 512, factor: 16807)
    let generatorB = Generator(startValue: 191, factor: 48271)
    
    var numberOfPairs = 0
    for _ in 0..<40000000 {
        if (generatorA.next() & check) == (generatorB.next() & check) {
            numberOfPairs += 1
        }
    }
    print ("Part one: \(numberOfPairs)")
}

measure {
    let generatorA =  Generator(startValue: 512, factor: 16807)
    let generatorB = Generator(startValue: 191, factor: 48271)
    
    var numberOfPairs = 0
    for _ in 0..<5000000 {
        if (generatorA.next(with: 4) & check) == (generatorB.next(with: 8) & check) {
            numberOfPairs += 1
        }
    }
    print ("Part two: \(numberOfPairs)")
}
