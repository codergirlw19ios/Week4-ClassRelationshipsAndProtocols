import UIKit

enum ConsumptionClassification {
    case omnivore, carnivore, herbivore
    
    func canEat(food: Food) -> Bool {
        return self == .omnivore ? true : food.consumptionType == self
    }
}

//: - add `.lettuce` as an case to `Food`
enum Food {
    case chicken, chocolate, lettuce
    
    var consumptionType: ConsumptionClassification {
        switch self {
        case .chicken: return .carnivore
        case .chocolate: return .herbivore
        case .lettuce: return .herbivore
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
class Mammal {
    var consumptionClassification: ConsumptionClassification = .omnivore
    var health: Health = .healthy
    
//    func consume(food: Food) -> Health? {
//        if consumptionClass.canEat(food: food) {
//            return health.increasedHealth
//        } else {
//            return health.decreasedHealth
//        }
//    }
    
    //the challenge
    func consume(food: Food) {
        guard let health = (consumptionClassification.canEat(food: food) ? health.increasedHealth : health.decreasedHealth) else {
            return
        }
        self.health = health //to be more swifty, change newHealth to health
    }
}

var testMammal = Mammal()
testMammal.health = .poor
testMammal.consume(food: .chocolate)

//: 2.) initialize an instance of mammal to a constant called animal and explore the various properties and the function you have created.
let animal = Mammal()
animal.consumptionClassification = .carnivore
animal.consume(food: .lettuce)
//: 3.) Write a class called `Human` that subclasses `Mammal`.
//: - Write a stored variable called `allergies` that is an array of `Food`.
//: - Write an initializer that allows you to initialize an instance of `Human` and pass in an array of `Food` for an `allergies` parameter.
//:  - - you should call the superclass's initializer after initializing the subclass's properties.
//: - Override the `consume` function so that if the `Food` is in the `allergies` array, the `decreaseHealth` property on `health` is called. You can expand the previous solution easily.
//: - Override the `health` variable and write a property listener for `didSet` that will print, if the case is `.ill`, stating that "You should see a doctor!"
//: - Prevent the `health` variable from being overridden using the `final` modifier.
class Human: Mammal {
    var allergies: [Food]
    
    init(allergies: [Food]) {
        self.allergies = allergies
        super.init()
    }
    
    override func consume(food: Food) {
        guard let health = (consumptionClassification.canEat(food: food) && !allergies.contains(food) ? health.increasedHealth : health.decreasedHealth) else {
            return
        }
        self.health = health
    }
    
    final override var health: Health {
        didSet {
            if health == .ill {
                 print("You should see a doctor!")
            }
        }
    }
}
//: 4.) Now create an instance of a `Human` in a constant named `amanda` and make her allergic to chocolate. Then force feed her chocolate three times. Use a for loop instead of duplicating code. You should see your advice print to the console. Examine amanda's `health` and you will see confirmation that the health status is `.ill`.
let amanda = Human(allergies: [.chocolate])
for _ in 1...3 {
    amanda.consume(food: .chocolate)
}
amanda.health

//: 5.) Create subclass of `Human` called `Child`.
//: - Add a stored variable called `dislikedFoods` that holds an array of `Food`.
//: - Create an initializer in a similar fashion to `Human` to initialize the `dislikedFoods` array
//: - - Note this time you need to pass `super.init` a parameter.
//: - Expand your `Child` class initializer to take an `allergies` parameter so you can pass it to the `super.init` function.
//: - Attempt to override the `health` variable from the `Human` superclass.
//: Override the `consume` class and ignore `dislikedFoods`. Do not change `health` if that food is passed to the `consume` function. Print "NO!" instead.
//: Prevent `Child` class from being subclassed using the `final` modifier.
class Child: Human {
    var dislikedFoods: [Food]
    
    init(dislikedFoods: [Food], allergies: [Food]) {
        self.dislikedFoods = dislikedFoods
        super.init(allergies: allergies)
    }
    
    //override var health
    
    override func consume(food: Food) {
       guard let health = dislikedFoods.contains(food) ? health : (consumptionClassification.canEat(food: food) && !allergies.contains(food) ? health.increasedHealth : health.decreasedHealth) else {
            return
        }
        self.health = health
    }
}

//: 6.) Create an instance of the `Child` class called `tommy` and pass an empty array for `allergies` and give a `dislikedFoods` of `.lettuce`.
//: - Feed tommy `.lettuce`
