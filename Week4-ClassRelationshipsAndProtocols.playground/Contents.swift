import UIKit
//: 1.) Add another requirement to `ExampleProtocol`. Add the necessary changes do you need to make to `SimpleClass` and `SimpleStructure` so that they still conform to the protocol.
//:
protocol ExampleProtocol{
    var simpleDescription: String{get}
    var anotherSimpleDescription: String{get}
    mutating func adjust()
    
}
class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherSimpleDescription: String = "My Description"
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
        anotherSimpleDescription += "Adjusting this description"
    }
}
var classVar = SimpleClass()
classVar.adjust()
let DescVar1 = classVar.simpleDescription
let DescVar2 = classVar.anotherSimpleDescription


struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    var anotherSimpleDescription: String = "My Structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
        anotherSimpleDescription += "(I'am Adjusting this)"
    }
}
var structVar = SimpleStructure()
structVar.adjust()
let DescVar3 = structVar.simpleDescription
let DescVar4 = structVar.anotherSimpleDescription
//: 2.) Write an extension for the Double type that adds an absoluteValue property.
//:
//:  ( an absolute value is a the magnitude of a real number without regard to its sign.)
extension Double{
    var absoluteValue : Double{
        if self > 0.0{
            return self
        }
        else{
            return -1 * self
        }
    }
}
var extensionTest = -6.0
print(extensionTest.absoluteValue)
