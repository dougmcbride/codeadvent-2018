import Foundation

func main(inputPath: String) -> Int {
    var world = try! World(string: String(contentsOfFile: inputPath))

    var round = 0

    repeat {
        print("round \(round)")
        print(world)
        print()

        for creature in world.creatures.sorted(by: Comparison.dictionaryOrder) {
            guard creature.isAlive else { continue }

            let enemies = world.creatures
                .filter { $0.type != creature.type } // Yay bigotry!
            
            if enemies.isEmpty {
                return round * world.creatures.reduce(into: 0, { $0 += $1.hitPoints })
            }

            let attackPositions = enemies
                .flatMap { $0.position.adjacentPositions }

            if !attackPositions.contains(creature.position) {
                let possibleTargetPositions = attackPositions.filter { world[$0].isTraversable }

                if let path = creature.position.shortestPath(to: possibleTargetPositions, in: world) {
                    world.move(creature: creature, on: path)
                }
            }

            if let enemyInRange = enemies
                .filter({ $0.inRange(of: creature) })
                .sorted(by: Comparison.targetDesirability)
                .first {

                enemyInRange.hitPoints -= creature.attackDamage

                if enemyInRange.hitPoints < 1 {
                    print("\(enemyInRange) has died.")
                    world.remove(creature: enemyInRange)
                }
            }
        }

        round += 1
    } while true
}

// Don't buffer print() output
setbuf(__stdoutp, nil)

guard CommandLine.arguments.count == 2 else {
    print("Usage: codeadvent <input-file>")
    exit(1)
}

print(main(inputPath: CommandLine.arguments.last!))
