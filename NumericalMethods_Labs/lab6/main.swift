import Foundation

func f1(_ point: (x: Float, y: Float)) -> Float { sinf(point.x + 2) - point.y - 1.5 }
func f2(_ point: (x: Float, y: Float)) -> Float { point.x + cosf(point.y - 2) - 0.5 }

func f1_x(_ point: (x: Float, y: Float)) -> Float { cosf(point.x + 2) }
func f1_y(_ point: (x: Float, y: Float)) -> Float { -1 }

func f2_x(_ point: (x: Float, y: Float)) -> Float { 1 }
func f2_y(_ point: (x: Float, y: Float)) -> Float { -sinf(point.y - 2) }

func f(_ point: (x: Float, y: Float)) -> (v0: Float, v1: Float) { (f1(point), f2(point)) }
func f_derivative(_ point: (x: Float, y: Float)) -> (m00: Float, m01: Float, m10: Float, m11: Float) {
    (f1_x(point), f1_y(point), f2_x(point), f2_y(point))
}

func inverse(_ matrix: (m00: Float, m01: Float, m10: Float, m11: Float)) -> (m00: Float, m01: Float, m10: Float, m11: Float) {
    let det = matrix.m00 * matrix.m11 - matrix.m01 * matrix.m10
    guard det != 0 else { fatalError("can't get inverse matrix") }
    
    return (matrix.m11 / det, -matrix.m01 / det, -matrix.m10 / det, matrix.m00 / det)
}

func solution(matrix: (m00: Float, m01: Float, m10: Float, m11: Float), vector: (v0: Float, v1: Float)) -> (v0: Float, v1: Float) {
    let det = matrix.m00 * matrix.m11 - matrix.m01 * matrix.m10
    let v0 = (vector.v0 * matrix.m11 - vector.v1 * matrix.m01) / det
    let v1 = (vector.v1 * matrix.m00 - vector.v0 * matrix.m10) / det
    
    return (v0, v1)
}

func approximation(of point: (x: Float, y: Float),
                   by function: ((Float, Float)) -> (Float, Float),
                   and derivative: ((Float, Float)) -> (Float, Float, Float, Float)) -> (x: Float, y: Float)
{
    let matrix = derivative(point)
    let funcPoint = function(point)
    let vector = (-funcPoint.0, -funcPoint.1)
    let solution = solution(matrix: matrix, vector: vector)
    
    return (point.x + solution.v0, point.y + solution.v1)
}

var point: (last: (x: Float, y: Float), current: (x: Float, y: Float)) = (
    (1, -1),
    approximation(of: (1, -1), by: f, and: f_derivative)
)
var diff: Float { max(abs(point.current.x - point.last.x), abs(point.current.y - point.last.y)) }
let eps: Float = 0.001

while diff >= eps {
    point.last = point.current
    point.current = approximation(of: point.current, by: f, and: f_derivative)
}

print(point.current)
print(diff)
