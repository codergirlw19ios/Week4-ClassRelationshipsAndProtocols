import UIKit

enum ConsumptionClassification {
    case omnivore, carnivore, herbivore
    
    func canEat(_ food: Food) -> Bool {
        return self == .omnivore ? true : food.consumptionType == self
    }
}

enum Food: CaseIterable {
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
        print("Human wants to consume \(food)")
        
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
        print("Child wants to consume \(food)")
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

//: ## Typecasting and Downcasting
//: Notice how the subscript on the human class can accept Child and Adult when setting with the subscript although the definition uses the Human class, and when you get the array back from the subscript the objects are Human class.

//: Add a print statement to each the `Human` and `Child` class's consume function.

//: 1.) Create a constant called `children` and set it equal to `abby`'s `.child` subscript.
//: - Print the result of passing `children` to the `type(of:)` function.
let children = abby[.child]
print(type(of:children))
//: Add a print statement to each the `Human` and `Child` class's consume function.

//: 2.) Write a if let statement to unwrap children.first into a child constant.
//: - Inside the if let statement do the following:
//: - Try type checking children.first as a Child, and then as an Adult.
if let child = children.first {
    child is Child
    child is Adult
//: - use the consume method and option+click on `child` - observe the class of `child` and the class whose consume method that was called.
child.consume(.chicken)
//: - Try casting `child` to an `Adult`
//: - Try force casting and running the playground.
//: - Try optionally casting to an `Adult`.
    // child as Adult asks you to force it with as!
    //child as! Adult passes compile but crashes at execution with a SIG ABORT error
    //safely fails
    child as? Adult
}
