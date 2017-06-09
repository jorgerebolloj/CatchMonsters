//
//  MonsterTableViewCell.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit

class MonsterTableViewCell: UITableViewCell {
    @IBOutlet weak var monsterImageView: UIImageView!
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterTimesCaughtLabel: UILabel!
    @IBOutlet weak var monsterLevelLabel: UILabel!
    @IBOutlet weak var monsterOccurrenceLevelLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
