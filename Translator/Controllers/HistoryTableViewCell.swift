//
//  HistoryTableViewCell.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 25.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceTextLabel: UILabel!
    @IBOutlet weak var translationTextLabel: UILabel!
    
    func configure(with history: History) {
        self.sourceTextLabel.text = history.originalText
        self.translationTextLabel.text = history.translationText
    }
    
}
