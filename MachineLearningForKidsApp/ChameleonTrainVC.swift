//
//  ChameleonTrainVC.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 11.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit

class ChameleonTrainVC: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.setImageColor(color: .white)
    }
    @IBAction func tapButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.image.setImageColor(color: sender.backgroundColor!)
        }
    }
}
