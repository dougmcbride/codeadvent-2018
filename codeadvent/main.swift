import Foundation

func main(inputPath: String) -> Int {
    var world = try! World(string: String(contentsOfFile: inputPath))

    var round = -1

    // Go until there's only one creature type left.
    while Dictionary(grouping: world.creatures, by: { $0.type }).keys.count > 1 {
        print("round \(round)")
        print(world)
        print()

        round += 1

        for creature in world.creatures.sorted(by: Comparison.dictionaryOrder) {
            guard creature.isAlive else { continue }

            let enemies = world.creatures
                .filter { $0.type != creature.type } // Yay bigotry!

            let attackPositions = enemies
                .flatMap { $0.position.adjacentPositions }

            if !attackPositions.contains(creature.position) {
                let reachablePositions = attackPositions.filter { world[$0].isTraversable }

                if let path = creature.position.shortestPath(to: reachablePositions, in: world) {
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
    }

    return round * world.creatures.reduce(into: 0, { $0 += $1.hitPoints })
}

setbuf(__stdoutp, nil)

guard CommandLine.arguments.count == 2 else {
    print("Usage: codeadvent <input-file>")
    exit(1)
}

print(main(inputPath: CommandLine.arguments.last!))
