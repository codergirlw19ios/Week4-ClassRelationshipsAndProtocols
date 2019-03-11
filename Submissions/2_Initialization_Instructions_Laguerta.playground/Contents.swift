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
    var consumptionClassification: ConsumptionClassification = .omnivore
    var health: Health = .healthy
    
    func consume(food: Food) {
        guard let health = consumptionClassification.canEat(food: food) ? health.increasedHealth : health.decreasedHealth else { return }
        
        self.health = health
    }
}

let animal = Mammal()
animal.consumptionClassification
animal.health
animal.consume(food: .chicken)

//: ## Initialization
//: 1.) Expand the `Human` class:
//: - Allow `Human` to change the default `consumptionClassification` with a new initializer:
//: -  Changing the variable has two possibilities. Try both:
//: - - 1. Allow the `consumptionClassification` on the superclass to be variable so we can change it after the superclass has finished initializing.
//: - - - note changing any variables on the superclass must happen after initialization is completed. What is the other negative consequence to this solution?
//: - - 2. Write an initializer on the superclass. Write a default parameter in the init function on the `Mammal` class and remove the default parameter on the stored property.
//:
//: 2.) Write a `convenience` initializer that takes a `Bool` parameter called `vegetarian`. If `vegetarian` is true, call the your new init function with a default allergy of `.chicken` and a default `consumptionClassification` of `.herbivore` and return from the function early. Otherwise call the simplest initializer of `Human` with an empty allergies array.

class Human: Mammal {
    var allergies: [Food]
    
    init(allergies: [Food], consumptionClassification: ConsumptionClassification = .omnivore){
        self.allergies = allergies
        super.init()
        self.consumptionClassification = consumptionClassification
       
    }
    
    override func consume(food: Food) {
        guard let health = consumptionClassification.canEat(food: food) && !allergies.contains(food) ? health.increasedHealth : health.decreasedHealth else { return }
        
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

let amanda = Human(allergies: [.chocolate])
for _ in 0..<3 {
    amanda.consume(food: .chocolate)
}
amanda.health

//: 3.) Create a human named debbie that is allergic to chicken and change her consumption classification to herbivore

//: 4.) Change the consume(food:) function to consume(_ food:) so it's easier to read and write.


//: 5.) Write an initializer on 'Child' that takes in the parameters 'dislikedFoods', a `Food` array, and 'vegetarian', a `Bool`.
//:  - - Notice you cannot call the convenience initializer of the superclass. You must call a designated initializer of the superclass 'Human'

//: 6.) Write an failable initializer on `Child` that checks to see if between `dislikedFoods` and `allergies` if there are any known foods left to eat. If there are no foods left to eat, return nil.
//:  - - You will need to make `Food` conform to the `CaseIterable` protocol to access `allCases`

class Child: Human {
    var dislikedFoods: [Food]
    
    init(dislikedFoods: [Food], allergies: [Food]){
        self.dislikedFoods = dislikedFoods
        super.init(allergies: allergies)
    }
    
    override func consume(food: Food) {
        guard !dislikedFoods.contains(food) else { print("NO!"); return }
        
        super.consume(food: food)
    }
}

let tommy = Child(dislikedFoods: [.lettuce], allergies: [])
tommy.health
tommy.consume(food: .lettuce)

//: ## Deinitialization
//: We'll cover automatic reference counting next week and deinitialization in more detail with ARC and when we work with views in the coming weeks.

