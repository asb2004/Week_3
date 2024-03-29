//
//  AddContectViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 23/02/24.
//

import UIKit

class AddContectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfNumber: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    var db: DBhelper!
    var person: Person!
    var imageName: String!
    var isFromCell: Bool = false
    
    var profileSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = DBhelper()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imagePickerTapped))
        profileImage.addGestureRecognizer(imageTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        view.addGestureRecognizer(tap)
        
        tfName.delegate = self
        tfNumber.delegate = self
        
    }
    
    @objc func viewTap() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromCell {
            saveButton.titleLabel?.text = "Save Changes"
        } else {
            saveButton.titleLabel?.text = "Save"
        }
        
        if let per = person {
            tfName.text = per.name
            tfNumber.text = per.number
            profileSelected = true
            imageName = per.imageData
            do{
                let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(per.imageData).appendingPathExtension(".png")
                profileImage.image = UIImage(contentsOfFile: filePath.path)
            } catch {
                print("not found")
            }
        }
    }
    
    @IBAction func cancleTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        if tfName.text == "" { 
            showAlert("Please Enter Name")
        } else if tfNumber.text == "" {
            showAlert("Please Enter Phone Number")
        } else if tfNumber.text?.count != 10 {
            showAlert("Enter Valid Phone Number")
        } else if !profileSelected {
            showAlert("Please Select image")
        } else if let name = tfName.text, let number = tfNumber.text {
            
            if isFromCell {
                let per = Person(id: person.id, name: name, number: number, imageData: imageName, favourite: person.favourite)
                db.updateContact(person: per)
                self.dismiss(animated: true, completion: nil)
            } else {
                let per = Person(id: 0, name: name, number: number, imageData: imageName, favourite: 0)
                db.insertContact(person: per)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }

    
    func showAlert(_ message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        present(avc, animated: true)
    }
    
    @objc func imagePickerTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerView = UIImagePickerController()
            imagePickerView.delegate = self
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.allowsEditing = true
            present(imagePickerView, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            imageName = UUID().uuidString
            do {
                let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(imageName).appendingPathExtension(".png")
                if let data = image.pngData() {
                    do {
                        try data.write(to: filePath)
                    } catch {
                        print("not saved")
                    }
                }
            } catch {
                print("path not found")
            }
            
            profileImage.image = image
            profileSelected = true
        } else {
            print("No image")
        }
    }
}

extension AddContectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
