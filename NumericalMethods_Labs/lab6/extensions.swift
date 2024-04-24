
infix operator **: MultiplicationPrecedence

extension Float {
    
    static func **(value: Float, factor: Int) -> Float {
        var result: Float = 1.0
        
        if factor < 0 {
            for _ in 0..<abs(factor) {
                result /= value
            }
            
        } else {
            for _ in 0..<factor {
                result *= value
            }
        }
        
        return result
    }
}
