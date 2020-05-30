//
//  TitanicGetInfoView.swift
//  MachineLearningForKidsApp
//
//  Created by Yusuf Özgül on 24.04.2020.
//  Copyright © 2020 Hızlı ve Buglı. All rights reserved.
//

import UIKit

class TitanicGetInfoView: UIView {
    
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var childTextField: UITextField!
    @IBOutlet weak var parentTextField: UITextField!
    @IBOutlet weak var partnerTextField: UITextField!
    @IBOutlet weak var siblingTextField: UITextField!
    

    var infoData: TitanicInfoData!
    var dataSaved: () -> Void = { }

    @IBAction func saveDate(_ sender: Any) {
        
        infoData.gender = genderPicker.selectedSegmentIndex
        infoData.age = Int(ageTextField.text!) ?? 0
        infoData.childCount = Int(childTextField.text!) ?? 0
        infoData.parentCount = Int(parentTextField.text!) ?? 0
        infoData.partnerCount = Int(partnerTextField.text!) ?? 0
        infoData.siblingCount = Int(siblingTextField.text!) ?? 0
        dataSaved()
    }
    
}
