//
//  FruitsViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 20/03/24.
//

import UIKit

class FruitsViewController: UIViewController {

    @IBOutlet weak var appleImage: UIImageView!
    @IBOutlet weak var bananaImage: UIImageView!
    @IBOutlet weak var grapesImage: UIImageView!
    
    @IBOutlet weak var grapesBox: UIView!
    @IBOutlet weak var bananaBox: UIView!
    @IBOutlet weak var appleBox: UIView!
    
    var appleCenter: CGRect!
    var bananaCenter: CGRect!
    var grapesCenter: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let applePanGesture = UIPanGestureRecognizer(target: self, action: #selector(applePan(_:)))
        let bananaPanGesture = UIPanGestureRecognizer(target: self, action: #selector(bananaPan(_:)))
        let grapesPanGesture = UIPanGestureRecognizer(target: self, action: #selector(grapesPan(_:)))
        appleImage.addGestureRecognizer(applePanGesture)
        bananaImage.addGestureRecognizer(bananaPanGesture)
        grapesImage.addGestureRecognizer(grapesPanGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appleCenter = CGRect(x: 20, y: 54, width: 70, height: 70)
        bananaCenter = CGRect(x: 172, y: 54, width: 70, height: 70)
        grapesCenter = CGRect(x: 334, y: 54, width: 70, height: 70)
    }
    
    @objc func applePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            appleImage.center = CGPoint(x: appleImage.center.x + sender.translation(in: self.view).x, y: appleImage.center.y + sender.translation(in: self.view).y)
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            if appleBox.frame.contains(appleImage.frame) {
                UIView.animate(withDuration: 0.5) {
                    self.appleImage.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.appleImage.frame = self.appleCenter
                }
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc func bananaPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            bananaImage.center = CGPoint(x: bananaImage.center.x + sender.translation(in: self.view).x, y: bananaImage.center.y + sender.translation(in: self.view).y)
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            print("end")
            if bananaBox.frame.contains(bananaImage.frame) {
                print("remove")
                UIView.animate(withDuration: 0.5) {
                    self.bananaImage.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.bananaImage.frame = self.bananaCenter
                }
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc func grapesPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            grapesImage.center = CGPoint(x: grapesImage.center.x + sender.translation(in: self.view).x, y: grapesImage.center.y + sender.translation(in: self.view).y)
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            print("end")
            if grapesBox.frame.contains(grapesImage.frame) {
                print("remove")
                UIView.animate(withDuration: 0.5) {
                    self.grapesImage.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.grapesImage.frame = self.grapesCenter
                }
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }

}
