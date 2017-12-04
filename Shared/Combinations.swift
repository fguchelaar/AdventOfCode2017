extension Collection {

    /**
     Returns an array of all combinations with *n* elements, **without repetition**
     
     - Parameter n: number of elements in one combination
     
     - Returns: array of combinations with *n* elements
     */
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
