import Foundation

struct Complex {
    var real: Float
    var image: Float
    
    init(_ real: Float, _ image: Float) {
        self.real = real
        self.image = image
    }
    
    static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real + rhs.real, lhs.image + rhs.image)
    }
    
    static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real - rhs.real, lhs.image - rhs.image)
    }
    
    static func * (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real * rhs.real - lhs.image * rhs.image, lhs.real * rhs.image + lhs.image * rhs.real)
    }
}

func fft(_ input: [Complex]) -> [Complex] {
    guard input.count > 1 else { return input }
    let n = input.count
    
    let even = fft(Array(input.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }))
    let odd = fft(Array(input.enumerated().compactMap { $0.offset % 2 != 0 ? $0.element : nil }))
    
    var result = [Complex](repeating: Complex(0, 0), count: n)
    let angle = -2.0 * Float.pi / Float(n)
    
    for k in 0..<n/2 {
        let t = Complex(cosf(angle * Float(k)), sinf(angle * Float(k))) * odd[k]
        result[k] = even[k] + t
        result[k + n/2] = even[k] - t
    }
    return result
}

func inverse_fft(_ input: [Complex]) -> [Complex] {
    let conjugated = input.map { Complex($0.real, -$0.image) }
    let transformed = fft(conjugated)
    let scaled = transformed.map { Complex($0.real / Float(input.count), -$0.image / Float(input.count)) }
    
    return scaled
}

func interpolatedFunction(input: [Float], numberOfPoints: Int) -> (Float) -> Float {
    let n = input.count
    let complexInput = input.map { Complex($0, 0) }
    
    let fft = fft(complexInput)
    
    var extended = [Complex](repeating: Complex(0, 0), count: numberOfPoints)
    for i in 0..<n/2 {
        extended[i] = fft[i]
        extended[numberOfPoints - n/2 + i] = fft[n/2 + i]
    }
    
    let interpolated = inverse_fft(extended)
    
    return { x in
        let wrappedX = x.truncatingRemainder(dividingBy: 1.0)
        let index = Int(wrappedX * Float(numberOfPoints)) % numberOfPoints
        return interpolated[index].real
    }
}

func f(_ x: Float) -> Float { x - Float(Int(x)) }

let N = 128
let inputFunctionValues = (0..<N).map { f(Float($0) / Float(N)) }

let interpFunc = interpolatedFunction(input: inputFunctionValues, numberOfPoints: N)

let middleValues = (0..<N).map { (Float($0) + 0.5) / Float(N) }
let functionMiddleValues = middleValues.map { f($0) }
let interpMiddleValues = middleValues.map { interpFunc($0) }

let inaccuracy = functionMiddleValues.enumerated().map { abs($1 - interpMiddleValues[$0]) }
print(inaccuracy.max() ?? .nan)

print(f(0.6))
print(interpFunc(0.6))
