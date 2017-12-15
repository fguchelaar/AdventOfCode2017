import Foundation

func measure(code: () -> Void) {
    let start = DispatchTime.now()
    code()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
    let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
    print("Code ran \(timeInterval) seconds")
}

