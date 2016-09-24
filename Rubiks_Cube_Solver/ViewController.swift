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
    
    //    let urlImg = "https://c1.staticflickr.com/5/4034/4544827697_6f73866999_b.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    let imagePicker = UIImagePickerController()
    var imgColor : UIColor = UIColor()
    var jpgPath : NSString = NSHomeDirectory() as NSString
    
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
        imageView.image = image
        
        // Divide image into 3 x 3 grid
        
        
        
        imgColor = UIColor(averageColorFrom: image)
        print(imgColor)
        
        
        //        currentImg = UIImageJPEGRepresentation(image, 0.8)!
        //        currentImg.write(to: jpgPath)
        //let imageString = jpeg?.base64EncodedString()
        //currentImg = NSURL(string: imageString!)!
        
        
        //        findMainColorOfImageWithURL()
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*    func findMainColorOfImageWithURL() {
     
     
     let headers: HTTPHeaders = [
     "X-Mashape-Key": "7y2as4tWCBmshfUT7x8ymCW1h37ip1fnQ7jjsnMpCwqgvOsstZ",
     "Accept": "application/json"
     ]
     let parameters: Parameters = [
     "image": currentImg,
     "palette": "simple",
     "sort":"weight"
     ]
     
     Alamofire.request("https://apicloud-colortag.p.mashape.com/tag-file.json", parameters: parameters, headers: headers).responseJSON { response in
     
     print(response.debugDescription)
     
     if let result = response.result.value {
     if let resultDict = result as? NSDictionary {
     if let colorsArr = resultDict["tags"] as? [[String : AnyObject]] {
     
     let firstColorDict = colorsArr[0]
     if let firstColor = firstColorDict["label"] as? String {
     print("Main Color Identified: \(firstColor)")
     }
     }
     }
     }
     }
     }
     */
}
