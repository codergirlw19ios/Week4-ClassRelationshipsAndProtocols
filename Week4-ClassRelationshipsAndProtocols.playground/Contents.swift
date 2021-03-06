import UIKit
//: 1.) Add another requirement to `ExampleProtocol`. Add the necessary changes do you need to make to `SimpleClass` and `SimpleStructure` so that they still conform to the protocol.
//:
protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
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


//: 2.) Write an extension for the Double type that adds an absoluteValue property.
//:
//:  ( an absolute value is a the magnitude of a real number without regard to its sign.)

