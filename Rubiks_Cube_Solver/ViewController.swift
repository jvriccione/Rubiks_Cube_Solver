//
//  ViewController.swift
//  Rubix_API
//
//  Created by Alex Bussan on 9/17/16.
//  Copyright © 2016 AlexBussan. All rights reserved.
//

import UIKit
import MobileCoreServices
import ChameleonFramework

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    let imagePicker = UIImagePickerController()
    var colorArr1 : NSMutableArray = []     //what positions are this color
    var colorArr2 : NSMutableArray = []
    var colorArr3 : NSMutableArray = []
    var colorArr4 : NSMutableArray = []
    var colorArr5 : NSMutableArray = []
    var colorArr6 : NSMutableArray = []
    var rgbArr = [[CGFloat]]()
    var tolerance : CGFloat = 0.15
    
    var isFirstBlock = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func useCamera(_ sender: AnyObject) {
       
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
            newMedia = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        // Divide image into 3 x 3 grid
        let blockSide = image.size.width/3
        var imgColor : UIColor = UIColor()
        var ct = 1
        let offset = blockSide/4
        
        for m in 0...2 {
            for n in 0...2 {
                let x = CGFloat(n) * blockSide + offset
                let y = CGFloat(m) * blockSide + offset
                let subImg = cropImage(original: image, x: x, y: y)
                print("Image\(ct) x:\(n), y\(m)")
                
                if n == 1 && m == 2 {
                    imageView.image = subImg
                }
                
                
                imgColor = UIColor(averageColorFrom: subImg)
                print(imgColor)
                
                let redVal = imgColor.cgColor.components![0]
                let greenVal = imgColor.cgColor.components![1]
                let blueVal = imgColor.cgColor.components![2]
                
                
                var minDelta : CGFloat = 1
                var currentColorIndex : Int?
                
                for i in 0...((rgbArr.capacity/3) - 1) {
                    let currentDelta = abs(redVal - rgbArr[i][0])
                    if currentDelta < minDelta {
                        minDelta = currentDelta
                        currentColorIndex = i
                    }
                }
                
                rgbArr[currentColorIndex!][0] = (rgbArr[currentColorIndex!][0] + redVal)/2
                
                
                
                
                if isFirstBlock {
                    colorArr1[0] = ct
                    
                    rgbArr[0][0] = redVal
                    rgbArr[0][1] = greenVal
                    rgbArr[0][2] = blueVal
                    
                    isFirstBlock = false
                }
                
                
                
                ct += 1
            }
        }
        
        
        //imageView.image = image
        //print(image.size.width)
        //print(image.size.height)

        
        

        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropImage(original: UIImage, x: CGFloat, y: CGFloat) -> UIImage {
        
        let width = original.size.width/6
        let height = width
        let cgImg = original.cgImage
        
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        let croppedCGImage = cgImg!.cropping(to: cropRect)
        
        let finalImg = UIImage(cgImage: croppedCGImage!)
        
        return finalImg
    }
}
