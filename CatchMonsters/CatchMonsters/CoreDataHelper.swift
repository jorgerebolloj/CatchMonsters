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
    createMonster(name: "Gommy", imageNamed: "monster1", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Greenny", imageNamed: "monster2", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Bluemmy", imageNamed: "monster3", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Blakky", imageNamed: "monster4", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Snownny", imageNamed: "monster5", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Oranggy", imageNamed: "monster6", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Lizzy", imageNamed: "monster7", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Gatty", imageNamed: "monster8", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Snakky", imageNamed: "monster9", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Octty", imageNamed: "monster10", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    createMonster(name: "Sukky", imageNamed: "monster11", occurrenceLevel: "Común", catchingDifficulty: "Fácil", level: 1)
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createMonster(name: String, imageNamed: String, occurrenceLevel: String, catchingDifficulty: String, level: Int) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let monster = Monster(context: context)
    monster.name = name
    monster.imageFileName = imageNamed
    monster.occurrenceLevel = occurrenceLevel
    monster.catchingDifficulty = catchingDifficulty
    monster.level = Int16(level)
}

func getAllTheMonsters() -> [Monster] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let monsters = try context.fetch(Monster.fetchRequest()) as! [Monster]
        if monsters.count == 0 {
            createInitialMonsterDeck()
            return getAllTheMonsters()
        }
        return monsters
    } catch {
        print("Ha habido un error al recuperar los monstruos desde CoreData")
    }
    return []
}

func getAllCaughtMonsters() -> [Monster] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Monster.fetchRequest() as NSFetchRequest<Monster>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d", 0)
    do {
        let monsters = try context.fetch(fetchRequest) as [Monster]
        return monsters
    } catch {
        print("Ha habido un error al recuperar los monstruos desde CoreData")
    }
    return []
}

func getAllUncaughtMonsters() -> [Monster] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Monster.fetchRequest() as NSFetchRequest<Monster>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d", 0)
    do {
        let monsters = try context.fetch(fetchRequest) as [Monster]
        return monsters
    } catch {
        print("Ha habido un error al recuperar los monstruos desde CoreData")
    }
    return []
}
