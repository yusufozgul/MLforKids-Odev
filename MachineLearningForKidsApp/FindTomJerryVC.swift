//
//  FindTomJerryVC.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 25.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit
import Toast

enum Mode {
    case train
    case test
}

class FindTomJerryVC: UIViewController {

    @IBOutlet weak var jerryLabel: UILabel!
    @IBOutlet weak var spikeLabel: UILabel!
    @IBOutlet weak var tomLabel: UILabel!
    
    
    
    let titleArray: [String] = ["Tom'u bul", "Jerry'i bul", "Spike'ı bul"]
    let chracterName = ["Tom", "Jerry", "Spike"]
    var chracterArray = ["Tom", "Jerry", "Spike"]
    var currentChracter: Int = 0
    
    var mode: Mode = .train
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.makeToast("Şimdi senden bize karakterleri tanıtmanı istiyoruz. Makine öğrenmesi için veri gereklidir. Bu verilerin doğru şekilde etiketlenmesiyle gelecek yeni verileri ayrıt edebiliriz.", duration: 8) { (_) in
           
            self.view.makeToast("Bize sırasıyla Tom, Jerry ve Spike'ı seçebilir misin?", duration: 4) { (_) in
               
            }
        }

            }
    
    func randomSelector() {
        self.mode = .test
        currentChracter = Int.random(in: 0...2)
        self.view.makeToast(titleArray[currentChracter])
    }
    
    func showConfetti() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.type = .confetti
        confettiView.startConfetti()
        
        self.view.makeToast("Tebrikler başardın, bu oyunu bitirdin.")
    }

    @IBAction func tapJerry(_ sender: Any) {
        
        if mode == .train {
            jerryLabel.text = chracterArray.removeFirst()
            if chracterArray.isEmpty { randomSelector() }
        } else if jerryLabel.text == chracterName[currentChracter] {
            showConfetti()
        }
    }
    @IBAction func tapSpike(_ sender: Any) {
        if mode == .train {
            spikeLabel.text = chracterArray.removeFirst()
            if chracterArray.isEmpty { randomSelector() }
        } else if spikeLabel.text == chracterName[currentChracter] {
            showConfetti()
        }
    }
    @IBAction func tapTom(_ sender: Any) {
        if mode == .train {
            tomLabel.text = chracterArray.removeFirst()
            if chracterArray.isEmpty { randomSelector() }
        } else if tomLabel.text == chracterName[currentChracter] {
            showConfetti()
        }
    }
}
