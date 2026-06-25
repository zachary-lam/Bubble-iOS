//
//  WelcomeViewController.swift
//  Bubble
//
//  Created by Zachary Lam on 2026-06-22.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: CLTypingLabel!
    @IBOutlet weak var titleLabelSecondary: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        animateText(label: titleLabelSecondary, text: String(K.appName.prefix(5)), interval: 0.25)

        titleLabel.charInterval = 0.25
        titleLabel.text = K.appName
    }
}

func animateText(label: CLTypingLabel, text: String, interval: Double) {
    // Source - https://stackoverflow.com/a/50154107
    // Posted by Arnab, modified by community. See post 'Timeline' for change history
    // Retrieved 2026-06-25, License - CC BY-SA 4.0
    let attrString = NSAttributedString(
        string: text,
        attributes: [
            NSAttributedString.Key.strokeColor: UIColor.customBlue,
            NSAttributedString.Key.foregroundColor: UIColor.customLightBlue,
            NSAttributedString.Key.strokeWidth: -2.0,
            NSAttributedString.Key.font: UIFont(name: "Chalkboard SE Bold", size: 50)!
        ]
    )
    
    label.charInterval = interval
    label.attributedText = attrString
}

