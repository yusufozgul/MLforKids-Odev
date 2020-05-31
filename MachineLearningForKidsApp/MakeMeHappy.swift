//
//  MakeMeHappy.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 31.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit

class MakeMeHappy: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func happyButtons(_ sender: UIButton) {
        
        UIView.transition(with: imageView,
        duration: 0.75,
        options: .transitionCrossDissolve,
        animations: { self.imageView.image = UIImage(named: "gulenYuz") },
        completion: nil)
    }
    
    
    @IBAction func sadButtons(_ sender: Any) {
        
        UIView.transition(with: imageView,
        duration: 0.75,
        options: .transitionCrossDissolve,
        animations: { self.imageView.image = UIImage(named: "uzgunYuz") },
        completion: nil)
        
    }
}
