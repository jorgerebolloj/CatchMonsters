//
//  CoreDataHelper.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit
import CoreData

func createInitialMonsterDeck() {
    createMonster(name: "Monster1", imageNamed: "monster1", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster2", imageNamed: "monster2", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster3", imageNamed: "monster3", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster4", imageNamed: "monster4", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster5", imageNamed: "monster5", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster6", imageNamed: "monster6", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster7", imageNamed: "monster7", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster8", imageNamed: "monster8", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster9", imageNamed: "monster9", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster10", imageNamed: "monster10", occurrenceLevel: "common", catchingDifficulty: "easy")
    createMonster(name: "Monster11", imageNamed: "monster11", occurrenceLevel: "common", catchingDifficulty: "easy")
}

func createMonster(name: String, imageNamed: String, occurrenceLevel: String, catchingDifficulty: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let monster = Monster(context: context)
    monster.name = name
    monster.imageFileName = imageNamed
    monster.occurrenceLevel = occurrenceLevel
    monster.catchingDifficulty = catchingDifficulty
}

func getAllTheMonsters() -> [Monster] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let monsters = try context.fetch(Monster.fetchRequest()) as! [Monster]
        if monsters.count == 0 {
            createInitialMonsterDeck()
            return getAllTheMonsters()
        }
    } catch {
        print("Ha habido un error al recuperar los monstruos desde CoreData")
    }
    return []
}
