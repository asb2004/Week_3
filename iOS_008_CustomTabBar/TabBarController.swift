//
//  TabBarController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 23/02/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupMiddelButton()
        title = "Contacts"
    }
    
    func setupMiddelButton() {
        let middelButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 25, y: -20, width: 50, height: 50))
        
        middelButton.backgroundColor = UIColor.systemBlue
        middelButton.setImage(UIImage(systemName: "plus"), for: .normal)
        middelButton.tintColor = .white
        middelButton.layer.cornerRadius = middelButton.layer.frame.width / 2
        
        self.tabBar.addSubview(middelButton)
        middelButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "addContactPage", sender: sender)
    }
    

}
