import UIKit

//: 1.) Add another requirement to `ExampleProtocol`. Add the necessary changes do you need to make to `SimpleClass` and `SimpleStructure` so that they still conform to the protocol.
//:
protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
    var describe: Void { get }
}

// implement default behavior for describe computed variable
extension ExampleProtocol {
    var describe: Void {
        return print(simpleDescription)
    }
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }

}


struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}

let structure = SimpleStructure()
structure.describe
//: 2.) Write an extension for the Double type that adds an absoluteValue property.
//:
//:  ( an absolute value is a the magnitude of a real number without regard to its sign.)
extension Double {
    var absoluteValue: Double {
        return abs(self)
    }
}

let negativeDouble = -3.14
let absPie = negativeDouble.absoluteValue
