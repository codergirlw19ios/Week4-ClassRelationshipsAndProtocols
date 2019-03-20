import UIKit
//: 1.) Add another requirement to `ExampleProtocol`. Add the necessary changes do you need to make to `SimpleClass` and `SimpleStructure` so that they still conform to the protocol.
//:
    protocol ExampleProtocol {
        var simpleDescription: String {get}
        mutating func adjust()
        var purpose: String {get}
    }

    class SimpleClass: ExampleProtocol {
        var simpleDescription: String = "A very simple class"
        var anotherProperty: Int = 69105
        func adjust() {
            simpleDescription += " Now 100% adjusted"
        }
        var purpose: String = "To be a class"
    }

    var a = SimpleClass()
    a.adjust()
    let aDescription = a.simpleDescription
    let aPurpose = a.purpose

    struct SimpleStructure: ExampleProtocol {
        var simpleDescription: String = "A simple structure"
        mutating func adjust() {
            simpleDescription += " (adjusted)"
        }
        var purpose: String = "To be a struct"
    }
    var b = SimpleStructure()
    b.adjust()
    let bDescription = b.simpleDescription
    let bPurpose = b.purpose
//: 2.) Write an extension for the Double type that adds an absoluteValue property.
//:
//:  ( an absolute value is a the magnitude of a real number without regard to its sign.)

extension Double {
    mutating func absoluteValue() {
        self = abs(self)
    }
    
}
var someDouble = -71.2
someDouble.absoluteValue()
// Prints "The number 71.2"

