import Foundation

func sgn(_ x: Float) -> Float {
    guard x != 0 else { return 0 }
    return x / abs(x)
}

func dividingRootEquation(of function: (Float) -> Float, in section: (a: Float, b: Float),
                          with inaccuracy: Float) -> (root: Float, approximationCount: Int)
{
    var currentSection: (a: Float, b: Float) = section
    var approximationCount: Int = 0
    
    while currentSection.b - currentSection.a > inaccuracy {
        let middle = (currentSection.b + currentSection.a) / 2
        
        if function(currentSection.a) * function(middle) < 0 {
            currentSection.b = middle
            
        } else if function(currentSection.b) * function(middle) < 0 {
            currentSection.a = middle
            
        } else { fatalError("function does not have the root between section: \(section)") }
        
        approximationCount += 1
    }
    
    let root = (currentSection.a + currentSection.b) / 2
    return (root, approximationCount)
}

func tangentRootEquation(of function: (Float) -> Float, and derivative: (first: (Float) -> Float, second: (Float) -> Float),
                         in section: (a: Float, b: Float), with inaccuracy: Float) -> (root: Float, approximationCount: Int)
{
    var root: (current: Float, last: Float) = (.zero, .zero)
    
    if function(section.a) * derivative.second(section.a) >= 0 {
        root.last = section.a
        root.current = section.a - function(section.a) / derivative.first(section.a)
        
    } else if function(section.b) * derivative.second(section.b) >= 0 {
        root.last = section.b
        root.current = section.b - function(section.b) / derivative.first(section.b)
        
    } else { fatalError("function does not have the root between section: \(section)") }
    
    var approximationCount: Int = 1
    
    while function(root.current) * function(root.current + sgn(root.current - root.last) * inaccuracy) >= 0 {
        let last = root.current
        root.current = root.last - function(root.last) / derivative.first(root.last)
        root.last = last
        
        approximationCount += 1
    }
    
    return (root.current, approximationCount)
}

func f(_ x: Float) -> Float { x ** 3 - 12 * x - 5 }
func f_x(_ x: Float) -> Float { 3 * (x ** 2) - 12 }
func f_xx(_ x: Float) -> Float { 6 * x }

let sections: [(a: Float, b: Float)] = [(-4, -3), (-1, 0), (3, 4)]
let eps: Float = 0.001

sections.forEach { section in
    let (root1, count1) = dividingRootEquation(of: f, in: section, with: eps)
    let (root2, count2) = tangentRootEquation(of: f, and: (f_x, f_xx), in: section, with: eps)
    print(root1, count1, root2, count2, abs(root1 - root2))
}
