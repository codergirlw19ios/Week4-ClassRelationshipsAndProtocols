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

//: ## SUBSCRIPT
//: 1.) Write an enum called `FamilyMember` with a few family members as cases: such as `parent`, `child`, `sibling`

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

//: 2.) Add a `private` dictionary as a stored variable called `family` that takes a `FamilyMember` enum as a key and a `Human` array as the value, to the `Human` class. Initialize the dictionary to empty.
//: - Write a `subscript` that takes a `familyMember` as a parameter and returns a `Human` array, returning the appropriate value from the `family` dictionary in the `get` method, and adds family members to the appropriate existing type (or starts a new key value pair if one doesn't already exist) in the `set` method.

class Human: Mammal {
    var allergies: [Food]
    
    private var family = [FamilyMember: [Human]]()
    subscript(familyMember: FamilyMember) -> [Human]{
        get {
            return family[familyMember] ?? []
        }
        set(newValue){
            // does this family member already exist?  Then assign the array values to currentFamily
            if let currentFamily = family[familyMember] {
                // add the currentFamily members in array to any new array elements for this key
                family[familyMember] = currentFamily + newValue
            } else {
                family[familyMember] = newValue
            }
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

//: 3.) Create a subclass of `Human` called `Adult` that cannot be subclassed.
//: - Create a function called `addChild` that will initialize a `Child` instance with no `dislikedFoods` or `allergies`, add the `Child` to the `Adult`'s dictionary as a `.child` and add the `Adult` to the `Child`'s dictionary as a `.parent`. If there are already children, make sure each `.child` is added to each other's dictionary as a `.sibling`.

final class Adult: Human {
    
    // Ask Amanda about this -- did not follow --
    func addChild() -> Child {
        let child = Child(dislikedFoods: [], allergies: [])
        
        // Human has a dictionary of Family members - key = family member type - has list of humans
        // iterate the list of humans associated with the child, for each human(sibling) in the list
        self[.child].forEach{ sibling in
            sibling[.child] = [child]
        }
        
        // let child know that they have siblings
        child[.sibling] = self[.child]
        
        // add new child to child array
        self[.child] = [child]
        // let them know they have a parent by putting ourselves in the array
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
        guard !dislikedFoods.contains(food) else { print("NO!"); return }
        
        super.consume(food)
    }
}

let tommy = Child(dislikedFoods: [.lettuce], allergies: [])
tommy.health
tommy.consume(.lettuce)


//: 4.) Create a Human named `abby`
//: - Give her a Child named `hayden`
//: - Check that `abby`'s first `.child`'s first `.parent` is deeply equal to `abby`. (they are the same object in memory)

// This is very odd syntax for me.   addChild returns a child??  it should take a child and add it to it's own list.
let abby = Adult(allergies: [])
let hayden = abby.addChild()
let children = abby[.child]
/// === is checking if objects memory address is the same
abby[.child].first?[.parent].first === abby

//: 5.) give abby another child named `vivian`
//: - Check that abby now has two children and `hayden` now has a `.sibling`

let vivian = abby.addChild()
abby[.child].count   // should = 2
hayden[.sibling].count



