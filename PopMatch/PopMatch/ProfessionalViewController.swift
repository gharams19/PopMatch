//
//  ProfessionalViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/18/21.
//

import UIKit

class ProfessionalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var professionalDoneBtn: UIButton!
    
    @IBOutlet weak var industryTextField: UITextField!
    
    @IBOutlet weak var employmentTextField: UITextField!
    @IBOutlet weak var skillsTextField: UITextField!
    @IBOutlet weak var interestFieldTextField: UITextField!
    @IBOutlet weak var careerGoalTextField: UITextField!
    
    
    let industryData = [String] (arrayLiteral: "Technology", "Business", "Healthcare", "Education", "Engineering", "Agriculture", "Legal", "Entertainment/Media")
    
    let employmentData = [String] (arrayLiteral: "Unemployed", "Currently job searching", "Employed Part-time", "Employed Full-time", "Decline to answer")
    
    let industryPicker = UIPickerView()
    let employmentPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Styling
        professionalDoneBtn.layer.cornerRadius = 15
        
 
        // Set pickers to textfield
        industryTextField.inputView = industryPicker
        industryPicker.delegate = self
        industryPicker.dataSource = industryData as? UIPickerViewDataSource
        
        employmentTextField.inputView = employmentPicker
        employmentPicker.delegate = self
        employmentPicker.dataSource = employmentData as? UIPickerViewDataSource
        
        industryTextField.delegate = self
        employmentTextField.delegate = self
        careerGoalTextField.delegate = self
        skillsTextField.delegate = self
        interestFieldTextField.delegate = self
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == industryTextField || textField == employmentTextField {
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
        switch textField {
        case industryTextField:
            industryTextField.resignFirstResponder()
        case employmentTextField:
            employmentTextField.resignFirstResponder()
        case skillsTextField:
            skillsTextField.resignFirstResponder()
        case interestFieldTextField:
            interestFieldTextField.resignFirstResponder()
        case careerGoalTextField:
            careerGoalTextField.resignFirstResponder()
        default:
            industryTextField.resignFirstResponder()
        }
        return true
    }
    
    // When Done Pressed - store data & return to edit question view
    @IBAction func toEditQuestion(_ sender: Any) {
        
        // Store into database here
        
        // Navigate to edit question vc
       /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editQuestionViewController = storyboard.instantiateViewController(withIdentifier: "editQuestionVC") as? EditQuestionViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        navigationController?.pushViewController(editQuestionViewController, animated: true)*/
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK - PICKER STUFF
    // 1 picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // # Items in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        
        if pickerView == industryPicker { count = industryData.count } else { count = employmentData.count }
        
        return count
    }
    // To display the selection
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title = ""
        
        if pickerView == industryPicker {
            title = industryData[row]
        } else {
            title = employmentData[row]
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == industryPicker {
            print("industry selected: \(industryData[row])")
            industryTextField.text = industryData[row]
        } else {
            print("employment selected: \(employmentData[row])")
            employmentTextField.text = employmentData[row]
        }
        
        // Hide picker
        self.view.endEditing(true)
    }
    
    
}

