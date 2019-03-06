import UIKit
//: ## SETUP
//: 1.)  Write an enum called `ConsumptionClassification` with three cases: `omnivore`, `carnivore`, `herbivore`.

//: 2.) Write an enum called `Food` with at least two cases, such as `chicken` and `chocolate`
//: - Write a computed variable called `consumptionType` on the `Food` enum that returns a `ConsumptionClassification` type for each food type appropriate to the food. Use `.herbivore` or `.carnivore` instead of `.omnivore`. Use a switch statement that takes `self` as a parameter to switch over the cases of the enum.
//: - Write a function on the `ConsumptionClassification` enum called `canEat` which takes a parameter of `Food` and returns a `Bool`. The `Food`'s `consumptionType` and `self` must match to return `true`. Exception: If the `Food`'s `consumptionType` is for a `.carnivore` or `.herbivore`, allow the `.omnivore` to return true.
//: - - Challenge: This can be achieved by returning a single ternary statement.

//:  3.) Write one more enum called `Health` and give it the following cases: `dead`, `ill`, `poor`, `well`, `healthy`.
//: - Write two computed variables on `Health`. One called `decreasedHealth`, one called `increasedHealth`. Return an optional `Health` enum type if it is possible to decrease or increase in health status beyond the current state. (for instance, if the current state is `ill`, in `decreaseHealth` return `.dead`, in `increaseHealth` return `.poor`. You cannot increase health from `.dead`.)
