//
//  GestureViewController.swift
//  iOS_013
//
//  Created by DREAMWORLD on 04/03/24.
//

import UIKit

class GestureViewController: UIViewController {

    @IBOutlet var sampleView: UIView!
    @IBOutlet var lblText: UILabel!
    
    var tagValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sampleView.isUserInteractionEnabled = true
        
        switch tagValue {
        case 1:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            sampleView.addGestureRecognizer(tapGesture)
            
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            sampleView.addGestureRecognizer(doubleTapGesture)
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
            longPressGesture.minimumPressDuration = 1.0
            sampleView.addGestureRecognizer(longPressGesture)
            
        case 2:
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateView(_:)))
            sampleView.addGestureRecognizer(rotationGesture)
            
        case 3:
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchView(_:)))
            sampleView.addGestureRecognizer(pinchGesture)
            
        case 4:
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(_:)))
            sampleView.addGestureRecognizer(panGesture)
            
        case 5:
            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
            leftSwipeGesture.direction = .left
            sampleView.addGestureRecognizer(leftSwipeGesture)
            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
            rightSwipeGesture.direction = .right
            sampleView.addGestureRecognizer(rightSwipeGesture)
            let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
            upSwipeGesture.direction = .up
            sampleView.addGestureRecognizer(upSwipeGesture)
            let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
            downSwipeGesture.direction = .down
            sampleView.addGestureRecognizer(downSwipeGesture)
            
        case 6:
            sampleView.isHidden = true
            let screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanGesture(_:)))
            screenEdgePanGesture.edges = .right
            self.view.addGestureRecognizer(screenEdgePanGesture)
            
        default:
            lblText.text = "tag not provided"
        }
        
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        lblText.text = "Tapped"
    }
    
    @objc func doubleTapped(_ sender: UITapGestureRecognizer) {
        lblText.text = "Double Tapped"
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        lblText.text = "Long Pressed"
    }
    
    @objc func rotateView(_ sender: UIRotationGestureRecognizer) {
        lblText.text = "Rotate View"
        
        sampleView.transform = sampleView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @objc func pinchView(_ sender: UIPinchGestureRecognizer) {
        lblText.text = "Pinch View"
        
        sampleView.transform = sampleView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
    @objc func swipe(_ sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        
        switch direction {
        case .left:
            lblText.text = "Swipe Left"
        
        case .right:
            lblText.text = "Swipe Right"
            
        case .up:
            lblText.text = "Swipe Up"
            
        case .down:
            lblText.text = "Swipe Down"
            
        default:
            lblText.text = "Swipe"
        }
    }
    
    @objc func moveView(_ sender: UIPanGestureRecognizer) {
        lblText.text = "Move View"
        sampleView.center = CGPoint(x: sampleView.center.x + sender.translation(in: self.view).x, y: sampleView.center.y + sender.translation(in: self.view).y)
        sender.setTranslation(.zero, in: self.view)
        
    }
    
    @objc func screenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fruitsTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FruitsViewController") as! FruitsViewController
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
