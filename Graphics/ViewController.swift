//
//  ViewController.swift
//  VK_PlusHW7
//
//  Created by Eduard on 19.04.2021.
//

import UIKit

@IBDesignable class ViewController2: UIView {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    

        @IBOutlet weak var imageOfFriendOrGroup: UIImageView!
        @IBOutlet weak var nameOfFriendOrGroup: UILabel!
        
        override static var layerClass: AnyClass {
            return CAGradientLayer.self
        }
        
        var gradientLayer : CAGradientLayer {
            return self.layer as! CAGradientLayer
        }
        
        @IBInspectable var startColor : UIColor = .systemBlue {
            didSet {
                updateColors()
            }
        }
        @IBInspectable var endColor : UIColor = .white {
            didSet {
                updateColors()
            }
        }
        @IBInspectable var startLocation : CGFloat = 0 {
            didSet {
                updateLocations()
            }
        }
        @IBInspectable var endLocation : CGFloat = 1 {
            didSet {
                updateLocations()
            }
        }
        @IBInspectable var startPoint : CGPoint = .zero {
            didSet {
                updateStartPoint()
            }
        }
        @IBInspectable var endPoint : CGPoint = CGPoint(x: 1, y: 0) {
            didSet {
                updateEndPoint()
            }
        }
        
        func updateLocations() {
            self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
        }
        
        func updateColors() {
            self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        }
        
        func updateStartPoint() {
            self.gradientLayer.startPoint = startPoint
        }
        
        func updateEndPoint() {
            self.gradientLayer.endPoint = endPoint
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
