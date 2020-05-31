//
//  RockPaperScissors.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 31.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit

class RockPaperScissors: UIViewController {

    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var segment0: UISegmentedControl!
    @IBOutlet weak var segment1: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testView.isHidden = true
    }
    

    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "Seçtiğiniz Görsel", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Kapat", style: .cancel) { (_) in
        }
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        
        if sender.tag == 0 {
            segment1.setEnabled(false, forSegmentAt: sender.selectedSegmentIndex)
            segment2.setEnabled(false, forSegmentAt: sender.selectedSegmentIndex)
            
        } else if sender.tag == 1 {
            
            segment0.setEnabled(false, forSegmentAt: sender.selectedSegmentIndex)
            segment2.setEnabled(false, forSegmentAt: sender.selectedSegmentIndex)
            
        } else if sender.tag == 2 {
            
            segment0.setEnabled(false, forSegmentAt: sender.selectedSegmentIndex)
            segment1.setEnabled(false, forSegmentAt: sender.selectedSegmentIndex)
            
            self.testView.isHidden = false
        }
    }
    
    @IBAction func tapRock(_ sender: Any) {
        showAlert(message: "Seçilen: Taş")
    }
    
    @IBAction func tapScissors(_ sender: Any) {
        showAlert(message: "Seçilen: Makas")
    }
    @IBAction func tapPaper(_ sender: Any) {
        showAlert(message: "Seçilen: Kağıt")
    }
}
