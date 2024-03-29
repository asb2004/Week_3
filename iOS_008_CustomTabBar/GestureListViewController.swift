//
//  GestureListViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 05/03/24.
//

import UIKit

class GestureListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Gesture List"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gestureButtonTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GestureViewController") as! GestureViewController
        vc.tagValue = sender.tag
        navigationController?.pushViewController(vc, animated: true)
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
