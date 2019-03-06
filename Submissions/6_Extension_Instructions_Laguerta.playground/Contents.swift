import UIKit

enum ConsumptionClassification {
    case omnivore, carnivore, herbivore
    
    func canEat(_ food: Food) -> Bool {
        return self == .omnivore ? true : food.consumptionType == self
    }
}

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

enum Health: Int {
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

enum FamilyMember {
    case parent, child, sibling, pet
}

class Mammal {
    private var family = [FamilyMember: [Mammal]]()
    
    subscript(_ familyMember: FamilyMember) -> [Mammal] {
        get {
            return family[familyMember] ?? []
        }
        set (newFamily){
            family[familyMember] = family[familyMember] != nil ? family[familyMember]! + newFamily : newFamily
        }
    }
    
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


protocol Pet: class {
    var owner: Human { get }
    func beg()
    func consume(_ food: Food)
}

//: ## Extensions
//: 1.) Move the conformance to `Pet` into an `extension`
//: - Note you cannot have stored properties in extensions
class Dog: Mammal, Pet {
    var owner: Human
    
    init(owner: Human){
        self.owner = owner
    }
    
    func beg() {
        owner.feedPet(self)
    }
    
    override var health: Health {
        didSet {
            print("health of dog: \(health)")
            if health.rawValue < Health.healthy.rawValue && health != .dead {
                beg()
            }
        }
    }
    
    override func consume(_ food: Food) {
        print("Dog's consume")
        guard let health = consumptionClassification.canEat(food) && food != .chocolate ? health.increasedHealth : health.decreasedHealth else { return }
        
        self.health = health
    }
    
}

class Human: Mammal {
    var allergies: [Food]
    
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
    
    func feedPet(_ pet: Pet) {
        switch(pet){
        case let dog where dog is Dog: pet.consume(.kibble)
        default: pet.consume(.chocolate)
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
    
    func adoptDog() -> Dog {
        let dog = Dog(owner: self)
        self[.pet] = [dog]
        return dog
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

let dog = abby.adoptDog()
dog.health = .well

//: 2.) Write an `extension` on the `Int` struct that will allow you simplify the use case of initializing an `Int` from a `Character` (default Swift implementation is Int(String(Character) as we discussed in class). The function will take a `Character` parameter and return an optional `Int`.

//: 3.) Now use your new init function.

//: 4.) Write an extension on the `Dog` class that has a computed variable of an optional `Human` type named `bestFriend`. The return value is the `owner`'s first `.child`.
