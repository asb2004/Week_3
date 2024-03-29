//
//  TopicListViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 05/03/24.
//

import UIKit

class TopicListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Topics"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController?.pushViewController(vc, animated: true)
            
        case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: "GestureListViewController") as! GestureListViewController
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("not valid")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
