import UIKit

enum ConsumptionClassification {
    case omnivore, carnivore, herbivore
    
    func canEat(_ food: Food) -> Bool {
        return self == .omnivore ? true : food.consumptionType == self
    }
}

//: ## PROTOCOLS
//: 1.) add `kibble` as a case
enum Food: CaseIterable {
    case chicken, chocolate, lettuce, kibble
    
    var consumptionType: ConsumptionClassification {
        switch self {
        case .chicken: return .carnivore
        case .chocolate: return .herbivore
        case .lettuce: return .herbivore
        case .kibble: return .carnivore
        }
    }
}

//: 2.) change the enum to be of type `Int`
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

//: 3.) add the `pet` case to the enum
enum FamilyMember {
    case parent, child, sibling
}

class Mammal {
    let consumptionClassification: ConsumptionClassification
    var health: Health = .healthy
    
    init(consumptionClassification: ConsumptionClassification = .omnivore) {
        self.consumptionClassification = consumptionClassification
    }
    
    func consume(_ food: Food) {
        guard let health = consumptionClassification.canEat(food) ? health.increasedHealth : health.decreasedHealth else { return }
        
        self.health = health
    }
}

let animal = Mammal()
animal.consumptionClassification
animal.health
animal.consume(.chicken)


//: 4.) Write a protocol called Pet that can only be used by classes.
//: - Write a function called `beg` that takes no parameters and returns no parameters.
//: - Write a function called `consume` that takes a `Food` parameter with no argument label.
//: - Write a read-only `Human` type var called `owner`.


//: 5.) Write a subclass of `Mammal` called `Dog`, that adheres to the `Pet` protocol
//: - Write an initializer that takes in an `owner` parameter.
//: - Write the `beg` function that calls a `feedPet` function on the `owner`. the `feedPet` takes a `Pet` parameter with no argument label, so pass `self`.
//: - Override the `health` variable to call `beg` in the `didSet` propertyObserver when `health` is less than `healthy` (except for .dead!)
//: - Override the `consume` function to be able to eat anything (`increaseHealth`) except .chocolate (`decreaseHealth`).


//: 6.) Write a function called `feedPet` that takes a `Pet` parameter with no external argument label.
//: - Switch on `pet`. Typecast `pet` to `Dog` in a case; if it is a `Dog`, feed it `.kibble`. Otherwise feed the `pet` `.chocolate`.
//: - Change the `family` dictionary to class of `Mammal` instead of `Human`, and move the `family` and `subscript` code to the `Mammal` class
class Human: Mammal {
    var allergies: [Food]
    
    private var family = [FamilyMember: [Human]]()
    
    subscript(_ familyMember: FamilyMember) -> [Human] {
        get {
            return family[familyMember] ?? []
        }
        set (newFamily){
            family[familyMember] = family[familyMember] != nil ? family[familyMember]! + newFamily : newFamily
        }
    }
    
    init(allergies: [Food], consumptionClassification: ConsumptionClassification = .omnivore){
        self.allergies = allergies
        super.init(consumptionClassification: consumptionClassification)
    }
    
    convenience init(vegetarian: Bool) {
        guard vegetarian else { self.init(allergies: []); return }
        
        self.init(allergies: [.chicken], consumptionClassification: .herbivore)
        
    }
    
    override func consume(_ food: Food) {
        print("Human's consume")
        guard let health = consumptionClassification.canEat(food) && !allergies.contains(food) ? health.increasedHealth : health.decreasedHealth else { return }
        
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
    amanda.consume(.chocolate)
}
amanda.health

let debbie = Human(allergies: [.chicken], consumptionClassification: .herbivore)
let sarah = Human(vegetarian: true)

//: 7.) Write a function on the `Adult` class called `adoptDog` that creates a `Dog` instance, adds it to the `family` dictionary only for self, and returns the `Dog` instance.
class Adult: Human {
    func addChild() -> Child {
        let child = Child(dislikedFoods: [], allergies: [])
        
        self[.child].forEach { sibling in
            sibling[.sibling] = [child]
        }
        
        child[.sibling] = self[.child]
        
        self[.child] = [child]
        child[.parent] = [self]
        return child
    }
}

class Child: Human {
    var dislikedFoods: [Food]
    
    init(dislikedFoods: [Food], allergies: [Food]){
        self.dislikedFoods = dislikedFoods
        super.init(allergies: allergies)
    }

    init(dislikedFoods: [Food], vegetarian: Bool){
        self.dislikedFoods = dislikedFoods
        super.init(allergies: [.chicken], consumptionClassification: .herbivore)
    }
    
    init?(dislikedFoods: [Food], allergies: [Food], consumptionClassification: ConsumptionClassification) {
        
        let badFoods = Set(dislikedFoods).union(Set(allergies))
        let allFoods = Set(Food.allCases)
        let edibleFoods = allFoods.subtracting(badFoods)
        
        guard !edibleFoods.isEmpty else { return nil}
        
        self.dislikedFoods = dislikedFoods
        super.init(allergies: allergies, consumptionClassification: consumptionClassification)
    }
    
    override func consume(_ food: Food) {
        print("Child's consume")
        guard !dislikedFoods.contains(food) else { print("NO!"); return }
        
        super.consume(food)
    }
}

let tommy = Child(dislikedFoods: [.lettuce], allergies: [])
tommy.health
tommy.consume(.lettuce)


let abby = Adult(allergies: [])
let hayden = abby.addChild()
abby[.child].first?[.parent].first === abby

let vivian = abby.addChild()
abby[.child].count
hayden[.sibling].count

let children = abby[.child]
print(type(of: children))

if let child = children.first {
    child is Child
    child is Adult
    child.consume(.chocolate)
    child as? Adult
    child as! Child
}

//: 8.) Create a constant named `dog` and let `abby` adopt a dog.
//: - Set the `dog`'s `health` to `.well`
