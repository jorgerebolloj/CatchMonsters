//
//  CollectionViewController.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var collectionTableView: UITableView!
    
    var caughtMonsters: [Monster] = []
    var uncaughtMonsters: [Monster] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        caughtMonsters = getAllCaughtMonsters()
        uncaughtMonsters = getAllUncaughtMonsters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMapLocationAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        } else {
            return "No atrapados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtMonsters.count
        } else {
            return uncaughtMonsters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonsterCell", for: indexPath) as! MonsterTableViewCell
        var monster: Monster
        if indexPath.section == 0 {
            monster = caughtMonsters[indexPath.row]
            cell.monsterTimesCaught.text = "Atrapados: \(monster.timesCaught)"
        } else {
            monster = uncaughtMonsters[indexPath.row]
            cell.monsterTimesCaught.text = ""
        }
        cell.monsterNameLabel?.text = monster.name
        cell.monsterImageView?.image = UIImage(named: monster.imageFileName!)
        cell.monsterLevel?.text =  "Nivel: \(String(monster.level))"
        return cell
    }

}
