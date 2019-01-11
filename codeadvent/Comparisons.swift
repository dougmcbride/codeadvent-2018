// Created by McBride, Doug on 2019-01-10.
// Copyright (c) 2019 The Sneaky Frog. All rights reserved.

import Foundation

struct Comparisons {
    static func dictionaryOrder(lhs: Positioned, rhs: Positioned) -> Bool {
        return lhs.position < rhs.position
    }

    static func targetDesirability(lhs: Creature, rhs: Creature) -> Bool {
        return lhs.hitPoints != rhs.hitPoints ?
            lhs.hitPoints < rhs.hitPoints :
            lhs.position < rhs.position
    }
}
