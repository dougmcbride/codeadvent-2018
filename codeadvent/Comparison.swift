import Foundation

struct Comparison {
    static func dictionaryOrder(lhs: Positioned, rhs: Positioned) -> Bool {
        return lhs.position < rhs.position
    }

    static func targetDesirability(lhs: Creature, rhs: Creature) -> Bool {
        return lhs.hitPoints != rhs.hitPoints ?
            lhs.hitPoints < rhs.hitPoints :
            lhs.position < rhs.position
    }
}

