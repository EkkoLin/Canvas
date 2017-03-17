//
//  ViewController.swift
//  Canvas
//
//  Created by Ekko Lin on 3/16/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    var emojiOriginalCenter: CGPoint!
    private var newlyCreatedFace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayCenterWhenOpen = trayView.center
        trayCenterWhenClosed = CGPoint(x: trayView.center.x, y: trayView.center.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func UIPanGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        
       let location = sender.location(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            NSLog("Gesture began at: %@", NSStringFromCGPoint(location));
            trayOriginalCenter = location
        } else if sender.state == UIGestureRecognizerState.changed {
            NSLog("Gesture changed at: %@", NSStringFromCGPoint(location));
            let translation = sender.translation(in: view)
            trayView.center = CGPoint(x: trayCenterWhenOpen.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.5, animations: { 
                let velocityY = sender.velocity(in: self.trayView).y
                if (velocityY > 0) {
                    self.trayView.center = self.trayCenterWhenClosed
                } else if (velocityY < 0) {
                    self.trayView.center = self.trayCenterWhenOpen
                }
            }, completion: nil)
            NSLog("Gesture ended at: %@", NSStringFromCGPoint(location));
        }
    }
    
    
    @IBAction func emoji(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            emojiOriginalCenter = location
            
            // Gesture recognizers know the view they are attached to
            let imageView = sender.view as! UIImageView
            // Create a new image view that has the same image as the one currently panning
            self.newlyCreatedFace = UIImageView(image: imageView.image)
            // Add the new face to the tray's parent view
            self.view.addSubview(self.newlyCreatedFace)
            // Initialize the position of the new face
            self.newlyCreatedFace.center = imageView.center
            // Since the original face is the tray, but the new face is in the main view, you have to offset the coordinates
            let faceCenter = self.newlyCreatedFace.center
            self.newlyCreatedFace.center = CGPoint(x: faceCenter.x, y: faceCenter.y + trayView.frame.origin.y)
        } else if sender.state == UIGestureRecognizerState.changed {
            let translation = sender.translation(in: view)
            self.newlyCreatedFace.center = CGPoint(x: emojiOriginalCenter.x + translation.x, y: emojiOriginalCenter.y + translation.y)
            
        }
    }
}

