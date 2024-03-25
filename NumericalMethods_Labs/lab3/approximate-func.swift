import Foundation

enum ApproximateType: CaseIterable {
    
    case z1, z2, z3, z4, z5, z6, z7, z8, z9
    
    var function: (Float, Float, Float) -> Float {
        switch self {
        case .z1: return { a, b, x in a * x + b }
        case .z2: return { a, b, x in a * powf(x, b) }
        case .z3: return { a, b, x in a * expf(b * x) }
        case .z4: return { a, b, x in a * logf(x) + b }
        case .z5: return { a, b, x in a / x + b }
        case .z6: return { a, b, x in 1 / (a * x + b) }
        case .z7: return { a, b, x in x / (a * x + b) }
        case .z8: return { a, b, x in a * expf(b / x) }
        case .z9: return { a, b, x in 1 / (a * logf(x) + b) }
        }
    }
    
    static func getBy(type: Int) -> ApproximateType { allCases[type] }
}
