import Foundation

extension String {
   
    func knotHash() -> [Int] {

        let lengths = self
            .map { Int($0.unicodeScalars.filter({ $0.isASCII }).first!.value) } + [17, 31, 73, 47, 23]
        
        var list = Array(0...255)
        var skipSize = 0
        var currentPosition = 0
        
        for _ in 0..<64 {
            for length in lengths {
                var endIndex = currentPosition+length - 1
                // Reverse positions, cycling back to the start
                for p in currentPosition..<(currentPosition+length / 2) {
                    let t = list[p % list.count]
                    list[p % list.count] = list[endIndex % list.count]
                    list[endIndex % list.count] = t
                    endIndex -= 1
                }
                currentPosition += length + skipSize
                skipSize += 1
            }
        }
        
        let sparseHash = list
        
        return (0..<16).map {
            let start = $0 * 16
            let range = sparseHash[start..<start+16]
            
            return range.reduce(0) { $0 ^ $1 }
        }
    }
}
