//
//  CreateFileViewController.swift
//  iOS_012_File
//
//  Created by DREAMWORLD on 01/03/24.
//

import UIKit

class CreateFileViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tvDescription: UITextView!
    @IBOutlet var tfTitle: UITextField!
    
    var filePath: URL!
    var isFromCell: Bool = false
    var fileURLforEditing: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Notes"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        view.addGestureRecognizer(tap)

        saveButton.layer.cornerRadius = 20.0
        saveButton.clipsToBounds = true
        
        tvDescription.layer.cornerRadius = 20.0
        tvDescription.delegate = self
        tvDescription.text = "Write Description Here..."
        tvDescription.textColor = UIColor.lightGray
        
        filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        filePath.appendPathComponent("UserNotes")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(at: filePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Directory not created")
            }
        }
        
    }
    
    @objc func viewTap() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromCell {
            title = "Edit File"
            saveButton.titleLabel?.text = "Save Changes"
            let fileTitle = fileNames[fileURLforEditing]
            tfTitle.text = fileTitle.components(separatedBy: ["."])[0]
            do {
                let data = try Data(contentsOf: filePath.appendingPathComponent(fileTitle))
                if let dataString = String(data: data, encoding: .utf8) {
                    tvDescription.text = nil
                    tvDescription.textColor = UIColor.black
                    tvDescription.text = dataString
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if var fileTitle = tfTitle.text {
            if fileTitle != "" {
                
                fileTitle = fileTitle.filter {!$0.isWhitespace}
                let strData = tvDescription.text ?? ""
                
                var fileURL = filePath.appendingPathComponent("\(fileTitle).txt")
                
                if isFromCell {
                    let oldFileURL = filePath.appendingPathComponent("\(fileNames[fileURLforEditing])")
                    do {
                        try FileManager.default.removeItem(atPath: oldFileURL.path)
                        fileNames.remove(at: fileURLforEditing)
                    } catch {
                        print(error)
                    }
                }
                
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    
                    if !isFromCell {
                        let avc = UIAlertController(title: "File is Already exists, Are you want to repalce the old file with new file", message: nil, preferredStyle: .alert)
                        avc.addAction(UIAlertAction(title: "Replace", style: .destructive) { _ in
                            do {
                                try FileManager.default.removeItem(atPath: fileURL.path)
                                fileURL = self.filePath.appendingPathComponent("\(fileTitle).txt")
                                if let index = fileNames.firstIndex(of: "\(fileTitle).txt") {
                                    fileNames.remove(at: index)
                                }
                                if let data = strData.data(using: .utf8) {
                                    do {
                                        try data.write(to: fileURL)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        })
                        avc.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        self.present(avc, animated: true, completion: nil)
                    }
                }
                
                if let data = strData.data(using: .utf8) {
                    do {
                        try data.write(to: fileURL)
                        fileNames.append("\(fileTitle).txt")
                        navigationController?.popViewController(animated: true)
                    } catch {
                        print("not added \(error)")
                    }
                }
            } else {
                let avc = UIAlertController(title: "Enter File Title", message: nil, preferredStyle: .alert)
                avc.addAction(UIAlertAction(title: "okey", style: .default, handler: nil))
                present(avc, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancleButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvDescription.textColor == UIColor.lightGray {
            tvDescription.text = nil
            tvDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvDescription.text.isEmpty {
            tvDescription.text = "Write Description Here..."
            tvDescription.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
