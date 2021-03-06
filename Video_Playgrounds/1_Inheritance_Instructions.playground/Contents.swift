import UIKit

enum ConsumptionClassification {
    case omnivore, carnivore, herbivore
    
    func canEat(food: Food) -> Bool {
        return self == .omnivore ? true : food.consumptionType == self
    }
}

//: - add `.lettuce` as an case to `Food`
enum Food {
    case chicken, chocolate
    
    var consumptionType: ConsumptionClassification {
        switch self {
        case .chicken: return .carnivore
        case .chocolate: return .herbivore
        }
    }
}

enum Health {
    case dead, ill, poor, well, healthy
    
    var decreasedHealth: Health? {
        switch self {
        case .dead: return nil
        case .ill: return .dead
        case .poor: return .ill
        case .well: return .poor
        case .healthy: return .well
        }
    }
    
    var increasedHealth: Health? {
        switch self {
        case .dead, .healthy: return nil
        case .ill: return .poor
        case .poor: return .well
        case .well: return .healthy
        }
    }
}

//: ## Inheritance
//: 1.) Write a base class called `Mammal`.
//: - Create a stored property with a `ConsumptionClassification` type, that has a default type of .omnivore
//: - Create a stored variable for `Health` with a default value of .healthy
//:  - Write a function called `consume` which takes a parameter of `Food`. Inside this function, if the `consumptionClassification` `canEat` function returns a boolean value of `true`, call the `increaseHealth` property on the stored `Health` variable. If the `canEat` function returns a `false` value, call the `decreaseHealth` property. If the return value is not nil, set the `Health` variable to the new value.
//: - - Challenge: See if you can write this with a combination of a guard statement and a ternary :D instead of an if else statement.

//: 2.) initialize an instance of mammal to a constant called animal and explore the various properties and the function you have created.

//: 3.) Write a class called `Human` that subclasses `Mammal`.
//: - Write a stored variable called `allergies` that is an array of `Food`.
//: - Write an initializer that allows you to initialize an instance of `Human` and pass in an array of `Food` for an `allergies` parameter.
//:  - - you should call the superclass's initializer after initializing the subclass's properties.
//: - Override the `consume` function so that if the `Food` is in the `allergies` array, the `decreaseHealth` property on `health` is called. You can expand the previous solution easily.
//: - Override the `health` variable and write a property listener for `didSet` that will print, if the case is `.ill`, stating that "You should see a doctor!"
//: - Prevent the `health` variable from being overridden using the `final` modifier.

//: 4.) Now create an instance of a `Human` in a constant named `amanda` and make her allergic to chocolate. Then force feed her chocolate three times. Use a for loop instead of duplicating code. You should see your advice print to the console. Examine amanda's `health` and you will see confirmation that the health status is `.ill`.

//: 5.) Create subclass of `Human` called `Child`.
//: - Add a stored variable called `dislikedFoods` that holds an array of `Food`.
//: - Create an initializer in a similar fashion to `Human` to initialize the `dislikedFoods` array
//: - - Note this time you need to pass `super.init` a parameter.
//: - Expand your `Child` class initializer to take an `allergies` parameter so you can pass it to the `super.init` function.
//: - Attempt to override the `health` variable from the `Human` superclass.
//: Override the `consume` class and ignore `dislikedFoods`. Do not change `health` if that food is passed to the `consume` function. Print "NO!" instead.
//: Prevent `Child` class from being subclassed using the `final` modifier.


//: 6.) Create an instance of the `Child` class called `tommy` and pass an empty array for `allergies` and give a `dislikedFoods` of `.lettuce`.
//: - Feed tommy `.lettuce`
