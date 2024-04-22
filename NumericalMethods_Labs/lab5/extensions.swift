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
