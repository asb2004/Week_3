//
//  FavouriteContactsViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 29/02/24.
//

import UIKit

class FavouriteContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var noContactView: UIView!
    @IBOutlet var tableView: UITableView!
    var db: DBhelper!
    var contacts: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        db = DBhelper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = db.getFavouriteContacts()
        tableView.reloadData()
        noContact()
        
    }
    
    func noContact() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! CustomFavouriteTableViewCell
        cell.name.text = contacts[indexPath.row].name
        
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(contacts[indexPath.row].imageData).appendingPathExtension(".png")
            cell.profileImage.image = UIImage(contentsOfFile: filePath.path)
        } catch {
            print("image path not found")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .normal, title: "Unfavourite", handler: { (action, view, completionHandler) in
            self.db.updateFavourie(id: self.contacts[indexPath.row].id, favourite: 0)
            self.contacts.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.noContact()
        })
        favouriteAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddContectViewController") as! AddContectViewController
        vc.person = contacts[indexPath.row]
        vc.isFromCell = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

}
