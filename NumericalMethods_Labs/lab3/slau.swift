import Foundation

struct SLAU {
    
    private let a1: Float
    private let b1: Float
    private let c1: Float
    private let a2: Float
    private let b2: Float
    private let c2: Float
    
    private let approximateType: ApproximateType
    
    init(forType type: ApproximateType, xArray: [Float], yArray: [Float]) {
        let n: Float = Float(xArray.count)
        approximateType = type
        
        switch type {
            
        case .z1:
            a1 = xArray.map { $0.pow(2) }.sum()
            b1 = xArray.sum()
            c1 = xArray.enumerated().map { index, x in x * yArray[index] }.sum()
            a2 = b1
            b2 = n
            c2 = yArray.sum()
            
        case .z2:
            a1 = n
            b1 = xArray.map { logf($0) }.sum()
            c1 = yArray.map { logf($0) }.sum()
            a2 = b1
            b2 = xArray.map { logf($0).pow(2) }.sum()
            c2 = xArray.enumerated().map { index, x in logf(x) * logf(yArray[index]) }.sum()
            
        case .z3:
            a1 = n
            b1 = xArray.sum()
            c1 = yArray.map { logf($0) }.sum()
            a2 = b1
            b2 = xArray.map { $0.pow(2) }.sum()
            c2 = xArray.enumerated().map { index, x in x * logf(yArray[index]) }.sum()
            
        case .z4:
            a1 = xArray.map { logf($0).pow(2) }.sum()
            b1 = xArray.map { logf($0) }.sum()
            c1 = xArray.enumerated().map { index, x in logf(x) * yArray[index] }.sum()
            a2 = b1
            b2 = n
            c2 = yArray.sum()
            
        case .z5:
            a1 = xArray.map { (1 / $0).pow(2) }.sum()
            b1 = xArray.map { 1 / $0 }.sum()
            c1 = xArray.enumerated().map { index, x in (1 / x) * yArray[index] }.sum()
            a2 = b1
            b2 = n
            c2 = yArray.sum()
            
        case .z6:
            a1 = xArray.map { $0.pow(2) }.sum()
            b1 = xArray.sum()
            c1 = xArray.enumerated().map { index, x in x * (1 / yArray[index]) }.sum()
            a2 = b1
            b2 = n
            c2 = yArray.map { 1 / $0 }.sum()
            
        case .z7:
            a1 = n
            b1 = xArray.map { 1 / $0 }.sum()
            c1 = yArray.map { 1 / $0 }.sum()
            a2 = b1
            b2 = xArray.map { (1 / $0).pow(2) }.sum()
            c2 = xArray.enumerated().map { index, x in (1 / x) * (1 / yArray[index]) }.sum()
            
        case .z8:
            a1 = n
            b1 = xArray.map { 1 / $0 }.sum()
            c1 = yArray.map { logf($0) }.sum()
            a2 = b1
            b2 = xArray.map { (1 / $0).pow(2) }.sum()
            c2 = xArray.enumerated().map { index, x in (1 / x) * logf(yArray[index]) }.sum()
            
        case .z9:
            a1 = xArray.map { logf($0).pow(2) }.sum()
            b1 = xArray.map { logf($0) }.sum()
            c1 = xArray.enumerated().map { index, x in logf(x) * (1 / yArray[index]) }.sum()
            a2 = b1
            b2 = n
            c2 = yArray.map { 1 / $0 }.sum()
        }
    }
    
    func solution() -> (alpha: Float, betta: Float) {
        let divisor: Float = a1 * b2 - a2 * b1
        let alpha: Float = (c1 * b2 - c2 * b1) / divisor
        let betta: Float = (a1 * c2 - a2 * c1) / divisor
        
        switch approximateType {
        case .z1, .z4, .z5, .z6, .z7, .z9: return (alpha, betta)
        case .z2, .z3, .z8: return (expf(alpha), betta)
        }
    }
}
