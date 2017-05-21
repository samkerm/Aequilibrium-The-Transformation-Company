//: Playground - noun: a place where people can play

import UIKit

var inputFighter = ["Jzhupa, D, 8,9,2,6,9,5,6,10",
                    "Soundwave, D, 7,9,7,9,5,2,9,7",
                    "Bluestreak, A, 7,7,7,9,5,2,9,7",
                    "Hubcap, A, 4,4,4,4,4, 4,4,4", // Im going to assume "Hubcap: A, 4,4,4,4,4,4,4,4" has a ":" typo
                    "Optimus Prime, A, 6,6,7,9,10,2,9,7"]


// The qualities that a Transformer should have. Unfortunately link in the instructions was broken at the time, so I could only extract these qualities

struct Transformer {
    var name = ""
    var group = ""
    var strength = 0
    var intelligence = 0
    var speed = 0
    var endurance = 0
    var rank = 0
    var courage = 0
    var firepower = 0
    var skill = 0
}


// Function where all the fighters are sorted by their ranking. Highest ranking comes first in the list

func sortFighters(transformers: [Transformer]) -> [Transformer] {
    return transformers.sorted(by: { (lhs, rhs) -> Bool in
        return lhs.rank > rhs.rank
    })
}


// We take in a String with the fighters information and convert it to a struc which we can access its individual parts more easily

func createTransformer(details: String) -> Transformer {
    var components = details.components(separatedBy: ",")
    
    var transformer = Transformer()
    
    transformer.name = components[0]
    transformer.group = components[1]
    transformer.strength = Int(components[2])!
    transformer.intelligence = Int(components[3])!
    transformer.speed = Int(components[4])!
    transformer.endurance = Int(components[5])!
    transformer.rank = Int(components[6])!
    transformer.courage = Int(components[7])!
    transformer.firepower = Int(components[8])!
    transformer.skill = Int(components[9])!
    
    return transformer
}



// Fighters are extracted from an array of Strings and after conversion to a Transformer struct are put back together in an array of Transformers

func createFighters() -> [Transformer] {
    var fighters = [Transformer]()
    
    for fighter in inputFighter {
        let trimmedString = fighter.replacingOccurrences(of: " ", with: "")
        fighters.append(createTransformer(details: trimmedString))
    }
    
    return fighters
}


// We are going to sort fighters by the ranking then split them to the group they belong to

func setUpBattle(completion: @escaping (_ autobots: [Transformer], _ decepticons: [Transformer]) -> Void) {
    
    var fighters = createFighters()
    fighters = sortFighters(transformers: fighters)
    
    var autobots = [Transformer]()
    var decepticons = [Transformer]()
    
    for fighter in fighters {
        if fighter.group == "A" {
            autobots.append(fighter)
        } else {
            decepticons.append(fighter)
        }
    }
    
    completion(autobots, decepticons)
}



// All qualities of the Transformer is added up

func overalRating(transformer: Transformer) -> Int {
    var overalRating = 0
    overalRating = transformer.strength + transformer.intelligence + transformer.speed + transformer.endurance + transformer.firepower
    
    return overalRating
}


// Two transformers are passed in and then the comparison begins to find the wiiner

func battle(t1:Transformer, t2:Transformer) -> Transformer? {
    
    var winner: Transformer? // Can pass a nil in case of a tie
    
    if t1.name == "OptimusPrime" || t1.name == "Predaking"{
        winner = t1
        return winner
    }
    if t2.name == "OptimusPrime" || t2.name == "Predaking"{
        winner = t2
        return winner
    }
    if t1.courage - t2.courage >= 4 && t1.strength - t2.strength >= 3 {
        winner = t1
        return winner
    } else if t2.courage - t1.courage >= 4 && t2.strength - t1.strength >= 3 {
        winner = t2
        return winner
    } else if abs(t1.skill - t2.skill) >= 3 {
        winner = (t1.skill - t2.skill) >= 3 ? t1 : t2
        return winner
    } else {
        var t1Rating = overalRating(transformer: t1)
        var t2Rating = overalRating(transformer: t2)
        
        if t1Rating > t2Rating {
            winner = t1
        } else if t1Rating < t2Rating {
            winner = t2
        }
    }
    
    return winner
}


// This comparison is a fight breaker so its done outside and before the normal comparison

func isMajorDestroction(t1:Transformer, t2:Transformer) -> Bool {
    if t1.name == "OptimusPrime" && t2.name == "Predaking" || t2.name == "OptimusPrime" && t1.name == "Predaking"{
        return true
    }
    return false
}



// Knowing the number of battles we can simply ignore the names of the ones that batteled and return the names of the remaining Transformers

func surviorNames(autobots: [Transformer], decepticons: [Transformer], numberOfBattles: Int) -> String {
    
    var unbattled = ""
    
    if autobots.count > numberOfBattles {
        let unbattledTransformer = autobots.count - numberOfBattles
        
        for i in 0..<unbattledTransformer {
            unbattled = autobots.reversed()[i].name + " "
        }
    } else if decepticons.count > numberOfBattles {
        let unbattledTransformer = decepticons.count - numberOfBattles
        
        for i in 0..<unbattledTransformer {
            unbattled = decepticons.reversed()[i].name + " "
        }
    }
    
    return unbattled
}


// Main battle where all the outcomes are assssed and printed to the console

func war() {
    setUpBattle { (autobots, decepticons) in
        let numberOfBattles = min(autobots.count, decepticons.count)
        
        var autobotWins = [Transformer]()
        var decepticonWins = [Transformer]()
        var winners = ""
        
        for i in 0..<numberOfBattles {
            if isMajorDestroction(t1: autobots[i], t2: decepticons[i]) {
                print("Everyone is dead!!") // War ends
                return
            }
            let outcome = battle(t1: autobots[i], t2: decepticons[i])
            if let outcome = outcome { // We dont care about a tie
                if outcome.group == "A" {
                    autobotWins.append(outcome)
                } else {
                    decepticonWins.append(outcome)
                }
            }
        }
        
        
        print("Number of battles: \(numberOfBattles)\nAutobots won: \(autobotWins.count)\nDecepticons won: \(decepticonWins.count)")
        
        let survivorNames = surviorNames(autobots: autobots,
                                         decepticons: decepticons,
                                         numberOfBattles: numberOfBattles)
        
        if autobotWins.count > decepticonWins.count {
            for winner in autobotWins {
                winners += winner.name + " "
            }
            
            print("Winning team (Autobots): \(winners)")
            if autobots.count < decepticons.count {
                print("Survivors from the losing team (Decepticons): \(survivorNames)")
            }
            
        } else if autobotWins.count < decepticonWins.count {
            
            for winner in decepticonWins {
                winners += winner.name + " "
            }
            
            print("Winning team (Decepticons): \(winners)")
            if decepticons.count < autobots.count {
                print("Survivors from the losing team (Autobots): \(survivorNames)")
            }
            
        } else {
            print("Its a draw")
        }
        
    }
}

war()

