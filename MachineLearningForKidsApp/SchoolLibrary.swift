//
//  SchoolLibrary.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 31.05.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit

class SchoolLibrary: UIViewController {

    
    @IBOutlet weak var pageCount: UITextField!
    @IBOutlet weak var lineCount: UITextField!
    @IBOutlet weak var imageCount: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func findButtons(_ sender: Any) {
        
        self.view.endEditing(true)
        var urlString = "https://bookpred.herokuapp.com/"
        
        urlString += pageCount.text!
        urlString += "/"
        urlString += lineCount.text!
        urlString += "/"
        urlString += imageCount.text!
        
        
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let result = try? JSONDecoder().decode(TitanicApiResponse.self, from: data)
            
            DispatchQueue.main.async {
                
                if result?.result == "0" {
                    self.image.image = UIImage(named: "yetiskinKitap")
                } else {
                    self.image.image = UIImage(named: "cocukKitap")
                }
                
                let alertController = UIAlertController(title: "Sonuç", message: result?.result == "0" ? "Bu kitap yetişkin kitabı" : "Bu kitap Çocuk kitabı", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Kapat", style: .cancel) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
            }
        }

        task.resume()
    }
    
}
