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
    
    var majorData: [String] = ["Technology", "Business/Economics", "Healthcare", "Education", "Engineering", "Agriculture", "Legal/Politcal Science", "Entertainment/Media", "Art", "Languages/Literature", "Research"]
  
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
        
        
        displayData()
    }
    
    // MARK: - Display stored data
    func displayData() {
        let userData = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        let userQuestions = userData.collection("questions").document("friendship")
        userQuestions.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    if let major = document.get("major") {
                        self.majorTextField.text = major as? String ?? ""
                    }
                    
                    // Think of a better way to do this
                    if let hobbies = document.get("hobbies") as? [Any] {
//                        print("hobbies to display: \(hobbies)")
                        for hobby in hobbies {
//                            let hobby = hobby as? String
//                            self.hobbies = hobbies.map{ ($0.titleLabel?.text == hob ? {$0.isSelected = true;return $0} : return $0}
//                            print("hobby: \(hobby)")
                            switch hobby as? String {
                            case "Traveling":
                                self.travelingBtn.isSelected = true
                            case "Working Out":
                                self.workingOutBtn.isSelected = true
                            case "Hiking":
                                self.hikingBtn.isSelected = true
                            case "Cooking":
                                self.cookingBtn.isSelected = true
                            case "Reading":
                                self.readingBtn.isSelected = true
                            case "Crafting":
                                self.craftingBtn.isSelected = true
                            case "Music":
                                self.hobbyMusicBtn.isSelected = true
                            case "Video Game":
                                self.videoGamesBtn.isSelected = true
                            case "Photography":
                                self.photographyBtn.isSelected = true
                            case "Netflix":
                                self.netflixBtn.isSelected = true
                            case "Other":
                                self.hobbyOtherBtn.isSelected = true
                            case "Don't Know":
                                self.dontKnowBtn.isSelected = true
                            default:
                                print("None selected")
                            }
                        }
                    }
                    
                    if let water = document.get("water") {
                        if self.yesWaterBtn.titleLabel?.text == water as? String {
                            self.yesWaterBtn.isSelected = true
                        } else if self.noWaterBtn.titleLabel?.text == water as? String {
                            self.noWaterBtn.isSelected = true
                        } else {
                            self.yesWaterBtn.isSelected = false
                            self.noWaterBtn.isSelected = false
                        }
                    }
                    
                    // Note - Try to do with map instead
                    if let music = document.get("music") as? [Any] {
//                        print("genres to display: \(music)")
                        for genre in music {
                            switch genre as? String {
                            case "Pop":
                                self.popBtn.isSelected = true
                            case "EDM":
                                self.edmBtn.isSelected = true
                            case "Hip Hop":
                                self.hiphopBtn.isSelected = true
                            case "Rap":
                                self.rapBtn.isSelected = true
                            case "Rock":
                                self.rockBtn.isSelected = true
                            case "R&B":
                                self.rnbBtn.isSelected = true
                            case "Country":
                                self.countryBtn.isSelected = true
                            case "Indie":
                                self.indieBtn.isSelected = true
                            case "Classical":
                                self.classicalBtn.isSelected = true
                            case "Other":
                                self.musicOtherBtn.isSelected = true
                            case "No preference":
                                self.noPreferenceBtn.isSelected = true
                            default:
                                print("None selected")
                                
                            }
                        }
                    }
                    
                    if let pizza = document.get("pizza") {
                        if self.yesPizzaBtn.titleLabel?.text == pizza as? String {
                            self.yesPizzaBtn.isSelected = true
                        } else if self.noPizzaBtn.titleLabel?.text == pizza as? String {
                            self.noPizzaBtn.isSelected = true
                        } else {
                            self.yesPizzaBtn.isSelected = false
                            self.noPizzaBtn.isSelected = false
                        }
                    }
                    
                } else {
                    print("User document doesn't exists")
                }
            } else {
                print ("Error in user document, error: \(String(describing: error))")
            }
        }
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
//                print("chose: \(chosen.titleLabel?.text)")
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
