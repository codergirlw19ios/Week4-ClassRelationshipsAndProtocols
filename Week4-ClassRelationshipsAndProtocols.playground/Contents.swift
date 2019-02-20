import UIKit
//: 1.) Add another requirement to `ExampleProtocol`. Add the necessary changes do you need to make to `SimpleClass` and `SimpleStructure` so that they still conform to the protocol.
//:
protocol ExampleProtocol {
    var simpleDescription: String { get }
    var simpleType : String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var simpleType: String = "This is a Class"
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
        simpleType += " & there's nothing to write"
    }
}
let simpleClass = SimpleClass()
simpleClass.adjust()
print(simpleClass.simpleDescription)
print(simpleClass.simpleType)

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    var simpleType: String = "This is a Structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}


//: 2.) Write an extension for the Double type that adds an absoluteValue property.
//:
//:  ( an absolute value is a the magnitude of a real number without regard to its sign.)
extension Double {
    var absoluteValue : Double {
        return abs(self)
    }
}
var someDouble = -3.55
print(someDouble.absoluteValue)
