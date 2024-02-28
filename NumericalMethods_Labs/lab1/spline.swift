import Foundation

class Spline {
    
    let a: Double
    let b: Double
    let c: Double
    let d: Double
    
    var range: ClosedRange<Double>
    
    init(a: Double, b: Double, c: Double, d: Double, range: ClosedRange<Double>) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.range = range
    }
    
    func value(by param: Double) -> Double? {
        guard range.contains(param) else { return nil }
        let diff = param - range.lowerBound
        return a + b * diff + c * diff * diff + d * diff * diff * diff
    }
}
