import Foundation

typealias Guard = Int
typealias Minute = Int

func main(lines: [String]) {
    var allNaps = [Guard: [Range<Minute>]]()

    var whichGuard: Guard!
    var napStart: Minute!
    var napEnd: Minute!

    for line in lines.sorted() {
        let minuteStart = line.index(line.startIndex, offsetBy: 15)
        let minuteEnd = line.index(minuteStart, offsetBy: 2)
        let minute = Minute(line[minuteStart..<minuteEnd])!

        let typeIndex = line.index(line.startIndex, offsetBy: 26)

        switch line[typeIndex] {
        case "s":
            napStart = minute
        case "p":
            napEnd = minute
            allNaps[whichGuard]!.append(napStart..<napEnd)
        default:
            let endGuardIdIndex = line.range(of: " ", range: typeIndex..<line.endIndex)!
            whichGuard = Guard(line[typeIndex..<endGuardIdIndex.lowerBound])!
            if !allNaps.keys.contains(whichGuard) {
                allNaps[whichGuard] = [Range<Minute>]()
            }
        }
    }

    var sleepiestGuard: Guard?
    var sleepiestMinute: Minute?
    var maxTimes = 0
    var napMinuteCounts = [Guard: [Int]]()

    for (whichGuard, naps) in allNaps {
        var minuteCounts: [Int] = Array(repeating: 0, count: 60)

        for nap in naps {
            for minute in nap.lowerBound..<nap.upperBound {
                minuteCounts[minute] += 1
            }
        }

        napMinuteCounts[whichGuard] = minuteCounts
//        
//        let minutesSlept = naps.reduce(into: 0) { (result, range) in result += range.upperBound - range.lowerBound }
//        if minutesSlept > maxMinutesSlept {
//            maxMinutesSlept = minutesSlept
//            sleepiestGuard = whichGuard
//        }
    }

    for (whichGuard, minuteCounts) in napMinuteCounts {
        for minute in minuteCounts.indices {
            if minuteCounts[minute] > maxTimes {
                maxTimes = minuteCounts[minute]
                sleepiestGuard = whichGuard
                sleepiestMinute = minute
            }
        }
    }

    print("sleepiest: \(sleepiestGuard!)")
    print("sleepiest: \(sleepiestMinute!)")

    print(sleepiestMinute! * sleepiestGuard!)
}

//var lines = [
//    "[1518-11-01 00:00] Guard #10 begins shift",
//    "[1518-11-01 00:05] falls asleep",
//    "[1518-11-01 00:25] wakes up",
//    "[1518-11-01 00:30] falls asleep",
//    "[1518-11-01 23:58] Guard #99 begins shift",
//    "[1518-11-02 00:40] falls asleep",
//    "[1518-11-02 00:50] wakes up",
//    "[1518-11-03 00:05] Guard #10 begins shift",
//    "[1518-11-03 00:24] falls asleep",
//    "[1518-11-03 00:29] wakes up",
//    "[1518-11-04 00:02] Guard #99 begins shift",
//    "[1518-11-04 00:36] falls asleep",
//    "[1518-11-04 00:46] wakes up",
//    "[1518-11-05 00:03] Guard #99 begins shift",
//    "[1518-11-05 00:45] falls asleep",
//    "[1518-11-05 00:55] wakes up",
//    "[1518-11-01 00:55] wakes up",
//]

var lines = [String]()

while let claimString = readLine(strippingNewline: true) {
    lines.append(claimString)
}

main(lines: lines)
