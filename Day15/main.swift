import Foundation

func measure(code: () -> Void) {
    
    let start = DispatchTime.now()
    code()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
    let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
    print("Code ran \(timeInterval) seconds")
}

measure {
    var generatorA =  512
    var generatorB = 191
    
    let factorA = 16807
    let factorB = 48271
    
    let divisor = 2147483647
    
    let check = Int(pow(Double(2), Double(16))) - 1
    
    var triedPairs = 0
    var numberOfPairs = 0
    //    for _ in 0..<40000000 {
    while triedPairs < 5000000 {
        
        repeat {
            generatorA *= factorA
            generatorA %= divisor
        } while (generatorA & 3 != 0)
        
        repeat {
            generatorB *= factorB
            generatorB %= divisor
        } while (generatorB & 7 != 0)
        
        triedPairs += 1

        if (generatorA & check) == (generatorB & check) {
            numberOfPairs += 1
        }
    }
    
    print (numberOfPairs)
}
