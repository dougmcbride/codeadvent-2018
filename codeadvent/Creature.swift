//
//  Creature.swift
//  codeadvent
//
//  Created by McBride, Doug on 1/10/19.
//  Copyright © 2019 The Sneaky Frog. All rights reserved.
//

import Foundation

enum CreatureType {
    case elf, goblin
}

class Creature: Hashable, Positioned {
    static private var nextId = 1

    let id: Int
    let type: CreatureType
    var position: Position
    var hitPoints = 200

    var attackDamage: Int {
        switch type {
            case .elf: return 3
            case .goblin: return 3
        }
    }

    var isAlive: Bool {
        return hitPoints > 0
    }

    var representation: String {
        return WorldContent.creature(type: type).representation
    }

    init(type: CreatureType, position: Position) {
        self.type = type
        self.position = position
        self.id = Creature.nextId
        Creature.nextId += 1
    }

    func inRange(of enemy: Creature) -> Bool {
        return position.adjacentPositions.contains(enemy.position)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Creature, rhs: Creature) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Creature: CustomStringConvertible {
    public var description: String {
        return "\(representation)(\(hitPoints))"
    }
}

extension Creature: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "[\(id)]\(representation)\(position)\(hitPoints)"
    }
}
