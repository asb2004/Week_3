//
//  ContactViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 27/02/24.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var noContactView: UIView!
    @IBOutlet var tableView: UITableView!
    var db: DBhelper!
    var contacts: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(sender:)))
//        tableView.addGestureRecognizer(longPress)
        
        db = DBhelper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = db.getContacts()
        tableView.reloadData()
        
        noContacts()
    }
    
    func noContacts() {
        if contacts.count == 0 {
            tableView.isHidden = true
            noContactView.isHidden = false
        } else {
            tableView.isHidden = false
            noContactView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! CustomTableViewCell
        cell.nameText.text = contacts[indexPath.row].name
        
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(contacts[indexPath.row].imageData).appendingPathExtension(".png")
            cell.profileImage.image = UIImage(contentsOfFile: filePath.path)
        } catch {
            print("image path not found")
        }
        
        if contacts[indexPath.row].favourite == 1 {
            cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.favButton.tag = indexPath.row
        cell.id = contacts[indexPath.row].id
        cell.isFav = contacts[indexPath.row].favourite
        cell.db = self.db
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
            let avc = UIAlertController(title: "Delete Contact", message: "Are you sure! you want to delete \(self.contacts[indexPath.row].name) contatc details?", preferredStyle: .alert)
            avc.addAction(UIAlertAction(title: "Cancle", style: .cancel))
            avc.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.db.deleteContact(id: self.contacts[indexPath.row].id)
                self.contacts.remove(at: indexPath.row)
                self.tableView.reloadData()
                self.noContacts()
            }))
            self.present(avc, animated: true, completion: nil)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddContectViewController") as! AddContectViewController
        vc.person = contacts[indexPath.row]
        vc.isFromCell = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
//    @objc func cellLongPress(sender: UILongPressGestureRecognizer) {
//        if sender.state == .began {
//            let touchPoint = sender.location(in: tableView)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//                let avc = UIAlertController(title: "Delete Contact", message: "Are you sure! you want to delete \(contacts[indexPath.row].name) contatc details?", preferredStyle: .alert)
//                avc.addAction(UIAlertAction(title: "Cancle", style: .cancel))
//                avc.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
//                    self.db.deleteContact(id: self.contacts[indexPath.row].id)
//                    self.contacts.remove(at: indexPath.row)
//                    self.tableView.reloadData()
//                }))
//                present(avc, animated: true, completion: nil)
//            }
//        }
//    }

}
