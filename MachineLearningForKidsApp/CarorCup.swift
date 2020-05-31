//
//  CarorCup.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 31.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit

class CarorCup: UIViewController {

    @IBOutlet weak var trainView: UIView!
    @IBOutlet weak var testImage1: UIImageView!
    @IBOutlet weak var testImage2: UIImageView!
    
    
    
    var selectedCount = 0 {
        didSet {
            if selectedCount == 15 {
                UIView.animate(withDuration: 0.5) {
                    self.trainView.isHidden = true
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if Bool.random() {
            testImage1.image = UIImage(named: "c\(Int.random(in: 0...10))")
            testImage1.tag = 0
        } else {
            testImage1.image = UIImage(named: "cup\(Int.random(in: 0...10))")
            testImage1.tag = 1
        }
        
        if Bool.random() {
            testImage2.image = UIImage(named: "c\(Int.random(in: 0...10))")
            testImage2.tag = 0
        } else {
            testImage2.image = UIImage(named: "cup\(Int.random(in: 0...10))")
            testImage2.tag = 1
        }
    }
    
    @IBAction func tapCarButton(_ sender: UIButton) {
        selectedCount += 1
        UIView.animate(withDuration: 0.4) {
            sender.superview?.superview?.alpha = 0.001
        }
    }
    
    @IBAction func tapCupButton(_ sender: UIButton) {
        selectedCount += 1
        UIView.animate(withDuration: 0.4) {
            sender.superview?.superview?.alpha = 0.001
        }
    }
    
    @IBAction func tapTest1(_ sender: Any) {
        if testImage1.tag == 0 {
            showAlert(isCar: true)
        } else {
            showAlert(isCar: !true)
        }
    }
    @IBAction func tapTest2(_ sender: Any) {
        
        if testImage2.tag == 0 {
            showAlert(isCar: true)
        } else {
            showAlert(isCar: !true)
        }
    }
    
    func showAlert(isCar: Bool) {
        
        let alertController = UIAlertController(title: "Seçtiğiniz Görsel", message: isCar ? "Bir araba" : "Bir kupa", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Kapat", style: .cancel) { (_) in
        }
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}
