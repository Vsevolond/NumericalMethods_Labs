import Foundation

extension Float {
    
    func pow(_ value: Int) -> Float {
        var result: Float = 1.0
        
        if value < 0 {
            for _ in 0..<abs(value) {
                result /= self
            }
            
        } else {
            for _ in 0..<value {
                result *= self
            }
        }
        
        return result
    }
}

extension Array where Element == Float {
    
    func sum() -> Float {
        reduce(into: 0) { $0 += $1 }
    }
    
    func pairs() -> [(Float, Float)] {
        (1..<count).map { (self[$0 - 1], self[$0]) }
    }
    
    var minAll: (element: Float, indexes: [Int]) {
        var min: (element: Float, indexes: [Int]) = (self[0], [0])
        for i in 1..<count {
            
            if self[i] < min.element {
                min = (self[i], [i])
                
            } else if self[i] == min.element {
                min.indexes.append(i)
            }
        }
        
        return min
    }
}
