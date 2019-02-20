import UIKit

enum ConsumptionClassification {
    case omnivore, carnivore, herbivore
    
    func canEat(food: Food) -> Bool {
        return self == .omnivore ? true : food.consumptionType == self
    }
}

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

class Mammal {
        let ConsumptionClassification: ConsumptionClassification = .omnivore
        var health: Health = .healthy

        func consume(food: Food) {
            guard let health = ConsumptionClassification.canEat(food: food) ? health.increasedHealth : health.decreasedHealth else { return }

            self.health = health
        }
    }

    let animal = Mammal()
    animal.ConsumptionClassification
    animal.health
    animal.consume(food: .chicken)

class Human: Mammal {
    var allergies: [Food]
    override init() {
        allergies = []
        super.init()
        }
    override func consume(food: Food) {
        guard let health = ConsumptionClassification.canEat(food: food) && !allergies.contains(food) ? health.increasedHealth : health.decreasedHealth else { return }
        self.health = health
    }
    final override var health: Health {
        didSet {
            if health == .ill {
                print("You should see a doctor")
            }
        }
    }
}

//: 4.) Now create an instance of a `Human` in a constant named `amanda` and make her allergic to chocolate. Then force feed her chocolate three times. Use a for loop instead of duplicating code. You should see your advice print to the console. Examine amanda's `health` and you will see confirmation that the health status is `.ill`.
let amanda = Human()
amanda.allergies = [Food.chocolate]
for _ in 1...3 {
    amanda.consume(food: Food.chocolate)
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


//: 6.) Create an instance of the `Child` class called `tommy` and pass an empty array for `allergies` and give a `dislikedFoods` of `.lettuce`.
//: - Feed tommy `.lettuce`
