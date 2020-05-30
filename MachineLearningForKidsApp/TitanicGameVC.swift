//
//  TitanicGameVC.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 24.04.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit
import AVFoundation
import Toast

enum TitanicGameStep {
    case entry
    case loading
    case boarding
    case passengerSelect
    case endScene
}

enum TitanicPassengerStyle {
    case state1
    case state2
    case state3
}

class TitanicGameVC: UIViewController {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var passengerInfoView: UIView!
    @IBOutlet weak var ticketFeeTextField: UITextField!
    @IBOutlet weak var portPicker: UISegmentedControl!
    @IBOutlet weak var passengerInfoViewBG: UIView!
    
    var infoData: TitanicInfoData = TitanicInfoData()
    var currentState: TitanicGameStep = .entry
    var passengerState: TitanicPassengerStyle = .state1
    
    var player: Player!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.player = Player()
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds

        self.playerView.addSubview(self.player.view)
        self.player.didMove(toParent: self)
        self.player.fillMode = .resizeAspectFill
        
        passengerInfoViewBG.layer.cornerRadius = 10
        passengerInfoViewBG.alpha = 0.7
        
        playVideo()
        playSound()
        showToast()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        player.stop()
        musicPlayer?.stop()
        self.view.hideAllToasts()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let value = UIInterfaceOrientation.portraitUpsideDown.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    var infoView: TitanicGetInfoView?
    func showGetInfoview() {

        self.view.makeToast("Senden şimdi bazı bilgiler istiyoruz, unutma bu bilgiler hayatta kalman için önemli", duration: 6)
        
        if let infoView = Bundle.main.loadNibNamed("TitanicGetInfoView", owner: nil, options: nil)?.first as? TitanicGetInfoView {
            infoView.frame.size = CGSize(width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.5)
            infoView.center.x = self.view.center.x
            infoView.center.y = (UIScreen.main.bounds.height * 0.5) / 2 + 10
            infoView.layer.cornerRadius = 10
            self.view.addSubview(infoView)
            self.infoView = infoView
            infoView.infoData = infoData
            infoView.dataSaved = {
                self.infoView?.removeFromSuperview()
                self.currentState = .loading
                self.playVideo()
            }
        }
    }
    
    func showBoardingView() {
        self.view.makeToast("Başlıyoruz, şimdi bize hangi limandan binmek istediğini ve ödeyebileceğin ücreti söyle, tekrar unutma bu bilgiler hayatta kalmana yardımcı olacak.", duration: 10)
        
    }

    func playVideo() {
        
        var fileURL = Bundle.main.url(forResource: "entryVideo", withExtension: "mp4")
        self.passengerInfoView.isHidden = true
        switch currentState {
        case .entry:
            fileURL = Bundle.main.url(forResource: "entryVideo", withExtension: "mp4")
        case .loading:
            self.view.makeToast("Titanic hazırlanıyor, birazdan gemiye biniş için gerekli adımları göreceğiz.", duration: 6)
             fileURL = Bundle.main.url(forResource: "titanic_loading", withExtension: "mp4")
        case .boarding:
            self.view.makeToast("Ve ordayız, Titanic sahibi olan White Star Line şirketinin önündeyiz. Büyük bir kalabalık Titanic'in ilk kez sefere çıkışını görmek için burada. Umarım her şey yolunda gider.", duration: 15)
             fileURL = Bundle.main.url(forResource: "titanic_boarding", withExtension: "mp4")
        case .passengerSelect:
            self.passengerInfoView.isHidden = false
            switch passengerState {
            case .state1:
                fileURL = Bundle.main.url(forResource: "titanic_passenger1", withExtension: "mp4")
            case .state2:
                print("2")
                fileURL = Bundle.main.url(forResource: "titanic_passenger2", withExtension: "mp4")
            case .state3:
                print("3")
                fileURL = Bundle.main.url(forResource: "titanic_passenger3", withExtension: "mp4")
            }
             
        case .endScene:
             fileURL = Bundle.main.url(forResource: "titanic_end_scene", withExtension: "mp4")
        }
        
        self.player.url = fileURL
        self.player.playFromBeginning()
    }
    
    
    var musicPlayer: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "titanic_background_music", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let musicPlayer = musicPlayer else { return }
            musicPlayer.play()
            musicPlayer.numberOfLoops = 5
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func showToast() {
        self.view.makeToast("Titanik Olympic sınıfı bir transatlantik yolcu gemisiydi.", duration: 4) { (_) in
            
            self.view.makeToast("15 Nisan 1912 gecesi daha ilk seferinde bir buz dağına çarpmış ve yaklaşık üç saatte Atlantik'in buzlu sularına gömülmüştü.", duration: 4.5) { (_) in
                
                self.view.makeToast("1912'de yapımı tamamlandığında dünyanın en büyük buharlı yolcu gemisiydi. Batışı 1.514 kişinin ölümüyle sonuçlanmış ve en büyük deniz felaketlerinden biri olarak tarihe geçmişti.", duration: 7) { (_) in
                    
                    
                    self.view.makeToast("Titanic`te zamanında mevcut olan en ileri teknolojiler kullanıldı. Birçok insan tarafından batmaz gemi olduğuna inanılıyordu ve bu inanış batmadan önce bu şekilde tanımlanmış ve lanse edildi.", duration: 6.5) { (_) in
                        
                        
                        self.view.makeToast("Titanic'in yapımı üzerinde 26 ay boyunca 11.300 kişi çalıştı. Geminin inşası 2 Nisan 1912'de tamamlandı.", duration: 5) { (_) in
                            
                            
                            self.view.makeToast("Titanic ilk seferine Southampton, İngiltere'den, New York'a doğru 10 Nisan 1912'de hareket edecekti. O gün ilk olarak mürettebat ve ardından yolcular gemiye yerel saat ile 09.30'da alınmaya başlandı.", duration: 9) { (_) in
                                
                                
                                self.view.makeToast("Titanic bulunduğu iskeleden ayrılır iken, gittiği yolu üzerinde buzdağları olduğuna dair bir çok uyarı aldı.", duration: 5) { (_) in
                                    
                                    self.view.makeToast("Ancak zaafler sebebiyle asla bu haberler köprüye ulaşamadı ve kaçınılmaz gerçekleşmişti", duration: 5) { (_) in
                                       
                                        self.view.makeToast("Bakalım bu oyunda biz hayatta kalabilecek miyiz?", duration: 4) { (_) in
                                           
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func selectPassengerStates(_ sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == 0 { self.passengerState = .state1 }
        if sender.selectedSegmentIndex == 1 { self.passengerState = .state2 }
        if sender.selectedSegmentIndex == 2 { self.passengerState = .state3 }
        
        self.playVideo()
    }
    
    
    @IBAction func startRoute(_ sender: Any) {
        self.currentState = .endScene
        self.playVideo()
    }
    
}

extension TitanicGameVC: PlayerPlaybackDelegate, PlayerDelegate {
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    func playerReady(_ player: Player) {
        print("Ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print(error?.localizedDescription ?? "")
    }
    

    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }

    public func playerPlaybackDidEnd(_ player: Player) {
        switch currentState {
            case .entry:
            showGetInfoview()
            case .loading:
                currentState = .boarding
                self.playVideo()
            case .boarding:
                showBoardingView()
                currentState = .passengerSelect
                self.playVideo()
            case .passengerSelect:
                self.playVideo()
            case .endScene:
            break
        }
        
    }

    public func playerCurrentTimeDidChange(_ player: Player) {
        
    }

    public func playerPlaybackWillLoop(_ player: Player) {
    }

}

class TitanicInfoData {
    var gender: Int = 0
    var age: Int = 0
    var childCount: Int = 0
    var parentCount: Int = 0
    var partnerCount: Int = 0
    var siblingCount: Int = 0
    var ticketFee: Double = 0
    var passengerState: Int = 0
    
}
