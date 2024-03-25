import Foundation

struct Polynom {
    
    private let factors: [Float]
    
    init(factors: [Float]) {
        self.factors = factors
    }
    
    func value(by x: Float) -> Float {
        return factors.enumerated().map { degree, factor in
            factor * x.pow(degree)
        }.sum()
    }
}
