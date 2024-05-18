import Foundation

struct Complex {
    var real: Float
    var imag: Float
    
    init(_ real: Float, _ imag: Float) {
        self.real = real
        self.imag = imag
    }
    
    static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real + rhs.real, lhs.imag + rhs.imag)
    }
    
    static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real - rhs.real, lhs.imag - rhs.imag)
    }
    
    static func * (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real * rhs.real - lhs.imag * rhs.imag, lhs.real * rhs.imag + lhs.imag * rhs.real)
    }
}

func fft(_ input: [Complex]) -> [Complex] {
    let n = input.count
    guard n > 1 else { return input }
    
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

func ifft(_ input: [Complex]) -> [Complex] {
    let conjugated = input.map { Complex($0.real, -$0.imag) }
    let transformed = fft(conjugated)
    let scaled = transformed.map { Complex($0.real / Float(input.count), -$0.imag / Float(input.count)) }
    return scaled
}

func interpolatedFunction(input: [Float], numberOfPoints: Int) -> (Float) -> Float {
    let n = input.count
    let complexInput = input.map { Complex($0, 0) }
    
    let fftResult = fft(complexInput)
    
    var extendedFFT = [Complex](repeating: Complex(0, 0), count: numberOfPoints)
    for i in 0..<n/2 {
        extendedFFT[i] = fftResult[i]
        extendedFFT[numberOfPoints - n/2 + i] = fftResult[n/2 + i]
    }
    
    let interpolatedComplex = ifft(extendedFFT)
    
    return { x in
        let wrappedX = x.truncatingRemainder(dividingBy: 1.0)
        let index = Int(wrappedX * Float(numberOfPoints)) % numberOfPoints
        return interpolatedComplex[index].real
    }
}

func f(_ x: Float) -> Float { x - Float(Int(x)) }

let N = 128
let inputFunctionValues = (0..<N).map { f(Float($0) / Float(N)) }

let interpFunc = interpolatedFunction(input: inputFunctionValues, numberOfPoints: N)

let functionMiddleValues = (0..<N).map { f((Float($0) + 0.5) / Float(N)) }
let interpMiddleValues = (0..<N).map { interpFunc((Float($0) + 0.5) / Float(N)) }

let inaccuracy = functionMiddleValues.enumerated().map { abs($1 - interpMiddleValues[$0]) }
print(inaccuracy.max() ?? .nan)
