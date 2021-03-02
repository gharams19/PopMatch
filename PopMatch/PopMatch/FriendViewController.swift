//
//  FriendViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/18/21.
//

import UIKit
import Firebase
import DLRadioButton

class FriendViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,
                            UIPickerViewDataSource {
   
    
    // Variables Here
    @IBOutlet weak var majorTextField: UITextField!

    // Hobby Buttons
    @IBOutlet weak var travelingBtn: DLRadioButton!
    @IBOutlet weak var workingOutBtn: DLRadioButton!
    @IBOutlet weak var hikingBtn: DLRadioButton!
    @IBOutlet weak var cookingBtn: DLRadioButton!
    @IBOutlet weak var readingBtn: DLRadioButton!
    @IBOutlet weak var craftingBtn: DLRadioButton!
    @IBOutlet weak var hobbyMusicBtn: DLRadioButton!
    @IBOutlet weak var videoGamesBtn: DLRadioButton!
    @IBOutlet weak var photographyBtn: DLRadioButton!
    @IBOutlet weak var netflixBtn: DLRadioButton!
    @IBOutlet weak var hobbyOtherBtn: DLRadioButton!
    @IBOutlet weak var dontKnowBtn: DLRadioButton!
    var hobbies: [DLRadioButton] = []
    
    // Music Genres
    @IBOutlet weak var popBtn: DLRadioButton!
    @IBOutlet weak var edmBtn: DLRadioButton!
    @IBOutlet weak var hiphopBtn: DLRadioButton!
    @IBOutlet weak var rapBtn: DLRadioButton!
    @IBOutlet weak var rockBtn: DLRadioButton!
    @IBOutlet weak var rnbBtn: DLRadioButton!
    @IBOutlet weak var countryBtn: DLRadioButton!
    @IBOutlet weak var indieBtn: DLRadioButton!
    @IBOutlet weak var classicalBtn: DLRadioButton!
    @IBOutlet weak var musicOtherBtn: DLRadioButton!
    @IBOutlet weak var noPreferenceBtn: DLRadioButton!
    var musicGenres: [DLRadioButton] = []
    
    // Water
    @IBOutlet weak var yesWaterBtn: DLRadioButton!
    @IBOutlet weak var noWaterBtn: DLRadioButton!
    
    // Pizza
    @IBOutlet weak var yesPizzaBtn: DLRadioButton!
    @IBOutlet weak var noPizzaBtn: DLRadioButton!
    
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var db = Firestore.firestore()
    
    var majorData = [String] (arrayLiteral: "Technology", "Business/Economics", "Healthcare", "Education", "Engineering", "Agriculture", "Legal/Politcal Science", "Entertainment/Media", "Art", "Languages/Literature", "Research")
    
   // let ageData = [String](arrayLiteral: "18-20 years old", "21-22 years old", "23-24 years old", "25-26 years old", "27+ years old")
    let majorPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBtn.layer.cornerRadius = 15
        
        hobbies = [travelingBtn, workingOutBtn, hikingBtn, cookingBtn, readingBtn, craftingBtn, hobbyMusicBtn, videoGamesBtn, photographyBtn, netflixBtn, hobbyOtherBtn, dontKnowBtn]
        musicGenres = [popBtn, edmBtn, hiphopBtn, rapBtn, rockBtn, rnbBtn, countryBtn, indieBtn, classicalBtn, musicOtherBtn, noPreferenceBtn]
        hobbies = hobbies.map({$0.isMultipleSelectionEnabled = true; return $0 })
        musicGenres = musicGenres.map({$0.isMultipleSelectionEnabled = true; return $0})
        
        majorTextField.delegate = self
        majorPicker.delegate = self
        majorTextField.inputView = majorPicker
        majorPicker.dataSource = majorData as? UIPickerViewDataSource
    }
    
    
    

    // MARK: - Picker Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        majorTextField.text = majorData[row]
        
        // Hide picker
        self.view.endEditing(true)
        majorTextField.resignFirstResponder()
    }
    
    
    //MARK: - Radio Buttons Selections - Prob delete after testing
    

    @IBAction func waterBtnsClicked(_ radioButton: DLRadioButton) {

        if (radioButton.isMultipleSelectionEnabled) {
                   for button in radioButton.selectedButtons() {
                       print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
                   }
               } else {
                   print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
               }
    }
    
    // MARK: - Retrieve selected data & save to db
    func getSelection(_ selections: DLRadioButton) -> [String] {
        var selectedArray: [String] = []
        if(selections.isMultipleSelectionEnabled) {
            for chosen in selections.selectedButtons() {
                print("chose: \(chosen.titleLabel?.text)")
                selectedArray.append(chosen.titleLabel?.text ?? "")
            }
        }
        return selectedArray
    }
    
    func sendToDatabase() {
        
        let major = majorTextField.text ?? ""
        
        let hobbies = getSelection(travelingBtn)
        
        let water = yesWaterBtn.selected()?.titleLabel?.text ?? noWaterBtn.selected()?.titleLabel?.text ?? ""
        
        let music = getSelection(popBtn)
        
        let pizza = yesPizzaBtn.selected()?.titleLabel?.text ?? noPizzaBtn.selected()?.titleLabel?.text ?? ""
        
        let userDoc = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        let friendshipDoc = userDoc.collection("questions").document("friendship")
        
        friendshipDoc.setData([
            "major" : major,
            "hobbies" : hobbies,
            "water" : water,
            "music" : music,
            "pizza" : pizza
        ])
    }
    
    // MARK: - Navigation
    
    @IBAction func toProfile() {
        // Pop off the friend VC that was pushed from profile
        sendToDatabase()
        navigationController?.popViewController(animated: true)
    }
    
}
