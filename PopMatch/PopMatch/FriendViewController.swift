//
//  FriendViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/18/21.
//

import UIKit

class FriendViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var friendshipDoneBtn: UIButton!
    
    // Textfields
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var musicTextField: UITextField!
    @IBOutlet weak var appTextField: UITextField!
    @IBOutlet weak var jokeTextField: UITextField!
    
    let ageData = [String](arrayLiteral: "18-20 years old", "21-22 years old", "23-24 years old", "25-26 years old", "27+ years old")
    
    let agePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        //Styling
        friendshipDoneBtn.layer.cornerRadius = 15
        
        ageTextField.inputView = agePicker
        agePicker.delegate = self
        agePicker.dataSource = ageData as? UIPickerViewDataSource
        
        // Set delegates
        ageTextField.delegate = self
        hobbiesTextField.delegate = self
        musicTextField.delegate = self
        appTextField.delegate = self
        jokeTextField.delegate = self
    }
    
    // Handle all textField delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == ageTextField {
            return false
        }
        
        let currentText = textField.text ?? ""
        
        guard let range = Range(range, in: currentText) else { assertionFailure("range not defined")
            return true
        }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        textField.text = newText
        
        print("newText: \(newText)")
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Maybe switch to using a map instead?
        switch textField {
        case ageTextField:
            ageTextField.resignFirstResponder()
        case hobbiesTextField:
            hobbiesTextField.resignFirstResponder()
        case musicTextField:
            musicTextField.resignFirstResponder()
        case appTextField:
            appTextField.resignFirstResponder()
        case jokeTextField:
            jokeTextField.resignFirstResponder()
        default:
            ageTextField.resignFirstResponder()
        }
        return true
    }
    

    @IBAction func toEditQuestion(_ sender: Any) {
        
        // Make api request to store data here
        
        
        // Navigate to edit question view controller
      /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editQuestionViewController = storyboard.instantiateViewController(withIdentifier: "editQuestionVC") as? EditQuestionViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        navigationController?.pushViewController(editQuestionViewController, animated: true)
        */
        navigationController?.popViewController(animated: true)
    }
    
    // MARK - PICKER STUFF
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        ageTextField.text = ageData[row]
        
        // Hide picker
        self.view.endEditing(true)
    }
    
    
}
