//
//  ViewController.swift
//  iOS_012_File
//
//  Created by DREAMWORLD on 29/02/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

var fileNames: [String] = []

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
    
    @IBOutlet var noFileView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var filePath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        filePath.appendPathComponent("UserNotes")

        fileNames = []
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: filePath.path)
                for file in files {
                    fileNames.append(file)
                }
            } catch {
                print("files not loaded")
            }
        }
        
//        filePath.appendPathComponent("UserNotes")
//        print(filePath)
//
//        do {
//            try FileManager.default.createDirectory(at: filePath, withIntermediateDirectories: true, attributes: nil)
//        } catch {
//            fatalError("Directory not created")
//        }
        
//        filePath.appendPathComponent("first.txt")
//        print(filePath.path)
        
//        for _ in 1...10 {
//            let str = UUID().uuidString
//            let fileURL = filePath.appendingPathComponent("\(str).txt")
//
//            let strData = "Hello"
//            if let data = strData.data(using: .utf8) {
//                do {
//                    try data.write(to: fileURL)
//                } catch {
//                    print("not added \(error)")
//                }
//            }
//
//        }
        
        
//        let fileURL = filePath.appendingPathComponent("remove.txt")
//
//        FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: .none)
//        print(fileURL.path)
//
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                try FileManager.default.removeItem(atPath: fileURL.path)
//            } catch {
//                print(error)
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        title = "Files"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        filePath.appendPathComponent("UserNotes")
        
        fileNames = []
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: filePath.path)
                for file in files {
                    fileNames.append(file)
                }
            } catch {
                print("files not loaded")
            }
        }
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let documentPicker = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(documentPickerButtonTapped))
        
        navigationItem.rightBarButtonItems = [addButton, documentPicker]
        
        tableView.reloadData()
        noFile()
    }
    
    @objc func addButtonTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateFileViewController") as! CreateFileViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func downloadTapped() {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeButton = UIContextualAction(style: .destructive, title: "Remove") { (action, view, handler)  in
            do {
                let fileURL = self.filePath.appendingPathComponent(fileNames[indexPath.row])
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileURL.path)
                        fileNames.remove(at: indexPath.row)
                        tableView.reloadData()
                        self.noFile()
                    }
                }
            } catch {
                print(error)
            }
        }
        
        let downloadButton = UIContextualAction(style: .normal, title: "Download") { action, view, handler in
            let newFilePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileNames[indexPath.row])
            let data = try? Data(contentsOf: self.filePath.appendingPathComponent(fileNames[indexPath.row]))
            try? data!.write(to: newFilePath, options: .atomic)
            print(newFilePath)
            let activityViewController = UIActivityViewController(activityItems: [newFilePath], applicationActivities: [])
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [removeButton, downloadButton])
    }
    
    func noFile() {
        if fileNames.count == 0 {
            noFileView.isHidden = false
            tableView.isHidden = true
        } else {
            noFileView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileExtension = fileNames[indexPath.row].components(separatedBy: ["."])[1]
        if fileExtension == "pdf" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
            let pdfFileURL = filePath.appendingPathComponent(fileNames[indexPath.row])
            vc.pdfFileURL = pdfFileURL
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CreateFileViewController") as! CreateFileViewController
            vc.isFromCell = true
            vc.fileURLforEditing = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    @objc func documentPickerButtonTapped() {
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        docPicker.delegate = self
        self.present(docPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("dfgd")
        if let fileURL = urls.first {
            
            guard fileURL.startAccessingSecurityScopedResource() else { return }
            
            let destinationPath = filePath.appendingPathComponent(fileURL.lastPathComponent)
            do {
                try FileManager.default.copyItem(at: fileURL, to: destinationPath)
                fileNames.append(fileURL.lastPathComponent)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }

}

