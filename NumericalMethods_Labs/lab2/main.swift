import Foundation

extension Int {
    
    static let middleRectanglesRatio: Int = 2
    static let trapezoidRatio: Int = 2
    static let simpsonRatio: Int = 4
    
    func pow(to number: Int) -> Int {
        var result = self
        (1..<number).forEach { _ in
            result *= self
        }
        
        return result
    }
}

func richardsonRatio(first: Double, second: Double, ratio: Int) -> Double {
    (first - second) / Double(2.pow(to: ratio) - 1)
}

func middleRectanglesIntegral(range: ClosedRange<Double>, step: Double, count: Int, function: (Double) -> Double) -> Double {
    let xArray: [Double] = (0...count).map { range.lowerBound + step * Double($0) }
    let sum: Double = (0..<count).reduce(into: 0) { partialResult, i in
        let parameter = xArray[i] + step / 2
        partialResult += function(parameter)
    }
    
    return step * sum
}

func trapezoidIntegral(range: ClosedRange<Double>, step: Double, count: Int, function: (Double) -> Double) -> Double {
    let xArray: [Double] = (0...count).map { range.lowerBound + step * Double($0) }
    let yArray: [Double] = (0...count).map { function(xArray[$0]) }
    let sum: Double = (1..<count).reduce(into: 0) { partialResult, i in
        partialResult += yArray[i]
    }
    
    let result = (yArray[0] + yArray[count]) / 2 + sum
    return step * result
}

func simpsonIntegral(range: ClosedRange<Double>, step: Double, count: Int, function: (Double) -> Double) -> Double {
    let xArray: [Double] = (0...count).map { range.lowerBound + step * Double($0) }
    let yArray: [Double] = (0...count).map { function(xArray[$0]) }
    
    let sumOdd = stride(from: 1, to: count, by: 2).reduce(into: 0) { partialResult, i in
        partialResult += yArray[i]
    }
    
    let sumEven = stride(from: 0, to: count, by: 2).reduce(into: 0) { partialResult, i in
        partialResult += yArray[i]
    }
    
    let result = (step / 3) * (yArray[0] + yArray[count] + 4 * sumOdd + 2 * sumEven)
    return result
}

func approximation(method: (ClosedRange<Double>, Double, Int, (Double) -> Double) -> Double,
                   range: ClosedRange<Double>,
                   ratio: Int,
                   eps: Double,
                   function: @escaping (Double) -> Double) -> (n: Int, value: Double, richardson: Double)
{
    var n: Int = 2
    var flag: Bool = false

    while !flag {
        
        let h = (range.upperBound - range.lowerBound) / Double(n)
        
        let value1 = method(range, h, n, function)
        let value2 = method(range, h / 2, 2 * n, function)
        
        let r = richardsonRatio(first: value1, second: value2, ratio: ratio)
        
        if abs(r) <= eps {
            flag = true
            return (n, value2, r)
            
        } else {
            n *= 2
        }
    }
}

func y(x: Double) -> Double {
    return x * sin(x) * sin(x)
}

let a: Double = 0
let b: Double = .pi
let eps: Double = 0.001

let middleRactanglesApproximation = approximation(method: middleRectanglesIntegral, 
                                                  range: a...b,
                                                  ratio: .middleRectanglesRatio,
                                                  eps: eps,
                                                  function: y(x:))

let trapezoidApproximation = approximation(method: trapezoidIntegral,
                                           range: a...b,
                                           ratio: .trapezoidRatio,
                                           eps: eps,
                                           function: y(x:))

let simpsonApproximation = approximation(method: simpsonIntegral,
                                         range: a...b,
                                         ratio: .simpsonRatio,
                                         eps: eps,
                                         function: y(x:))

print(middleRactanglesApproximation.n, trapezoidApproximation.n, simpsonApproximation.n)
print(middleRactanglesApproximation.value, trapezoidApproximation.value, simpsonApproximation.value)
print(middleRactanglesApproximation.richardson, trapezoidApproximation.richardson, simpsonApproximation.richardson)
print(middleRactanglesApproximation.value + middleRactanglesApproximation.richardson,
      trapezoidApproximation.value + trapezoidApproximation.richardson,
      simpsonApproximation.value + simpsonApproximation.richardson
)



