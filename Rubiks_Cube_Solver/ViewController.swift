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
    var colorArr1 = [[CGFloat]]()     //what positions are this color
    var colorArr2 = [[CGFloat]]()
    var colorArr3 = [[CGFloat]]()
    var colorArr4 = [[CGFloat]]()
    var colorArr5 = [[CGFloat]]()
    var colorArr6 = [[CGFloat]]()
    var blockIndex : CGFloat = 1
    var rgbAvg = [[CGFloat]]()
    //var rgbArr = [[CGFloat]]()
    var posArr : NSMutableArray = []
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
        var rgbDelta = [[CGFloat]]()
        var rgbDeltaAvg = [CGFloat]()
        var rgbTempDeltaAvg : CGFloat = 0
        var color : CGFloat = 0
        
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
                
                if isFirstBlock {
                    appendtocolorArr(color: 1, red: redVal, green: greenVal, blue: blueVal)
                    isFirstBlock = false
                } else {
                    print("DERKA")
                    averageRGB()
                    print("LMAO")

                    for i in 0...(rgbAvg.count/3 - 1) {
                        rgbDelta.insert([abs(redVal - rgbAvg[i][0])], at: [i][0])
                        rgbDelta.insert([abs(greenVal - rgbAvg[i][1])], at: [i][1])
                        rgbDelta.insert([abs(blueVal - rgbAvg[i][2])], at: [i][2])
                    }
                    for j in 0...(rgbDelta.count/3 - 1) {
                        rgbTempDeltaAvg = (rgbDelta[j][0] + rgbDelta[j][1] + rgbDelta[j][2]) / 3
                        rgbDeltaAvg.insert(rgbTempDeltaAvg, at: j)
                    }
                    
                    let minDelta = rgbDeltaAvg.min()
                    
                    for k in 0...(rgbDeltaAvg.count - 1) {
                        if rgbDeltaAvg[k] == minDelta {
                            color = CGFloat(k + 1)
                        }
                    }
                    
                    appendtocolorArr(color: color, red: redVal, green: greenVal, blue: blueVal)
                    
                }
                
                
//                var minDelta : CGFloat = 1
//                var currentColorIndex : Int?
//                
//                for i in 0...((rgbArr.capacity/3) - 1) {
//                    let currentDelta = abs(redVal - rgbArr[i][0])
//                    if currentDelta < minDelta {
//                        minDelta = currentDelta
//                        currentColorIndex = i
//                    }
//                }
//                
//                rgbArr[currentColorIndex!][0] = (rgbArr[currentColorIndex!][0] + redVal)/2
//                
//                
//                
//                
//                if isFirstBlock {
//                    colorArr1[0] = ct
//                    
//                    rgbArr[0][0] = redVal
//                    rgbArr[0][1] = greenVal
//                    rgbArr[0][2] = blueVal
//                    
//                    isFirstBlock = false
//                }
                
                
                
                ct += 1
            }
        }
        
        
        //imageView.image = image
        //print(image.size.width)
        //print(image.size.height)

        print(colorArr1)
        print(colorArr2)
        print(colorArr3)
        print(colorArr4)
        print(colorArr5)
        print(colorArr6)
        
        

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
    
    func appendtocolorArr(color: CGFloat, red: CGFloat, green: CGFloat, blue: CGFloat) {
        var nextAvailableCol = 0
        
        if color == 1 {
            nextAvailableCol = colorArr1.count/4
            print("INDEX is \(nextAvailableCol)")
            
            colorArr1.insert([blockIndex], at: [0][nextAvailableCol])
            colorArr1.insert([red], at: [1][nextAvailableCol])
            colorArr1.insert([green], at: [2][nextAvailableCol])
            colorArr1.insert([blue], at: [3][nextAvailableCol])
            print("success")

            
            blockIndex += 1
        }
        if color == 2 {
            nextAvailableCol = colorArr2.count/4
            
            colorArr2.insert([blockIndex], at: [0][nextAvailableCol])
            colorArr2.insert([red], at: [1][nextAvailableCol])
            colorArr2.insert([green], at: [2][nextAvailableCol])
            colorArr2.insert([blue], at: [3][nextAvailableCol])
            
            blockIndex += 1
        }
        if color == 3 {
            nextAvailableCol = colorArr3.count/4
            
            colorArr3.insert([blockIndex], at: [0][nextAvailableCol])
            colorArr3.insert([red], at: [1][nextAvailableCol])
            colorArr3.insert([green], at: [2][nextAvailableCol])
            colorArr3.insert([blue], at: [3][nextAvailableCol])
            
            blockIndex += 1
        }
        if color == 4 {
            nextAvailableCol = colorArr4.count/4
            
            colorArr4.insert([blockIndex], at: [0][nextAvailableCol])
            colorArr4.insert([red], at: [1][nextAvailableCol])
            colorArr4.insert([green], at: [2][nextAvailableCol])
            colorArr4.insert([blue], at: [3][nextAvailableCol])
            
            blockIndex += 1
        }
        if color == 5 {
            nextAvailableCol = colorArr5.count/4
            
            colorArr5.insert([blockIndex], at: [0][nextAvailableCol])
            colorArr5.insert([red], at: [1][nextAvailableCol])
            colorArr5.insert([green], at: [2][nextAvailableCol])
            colorArr5.insert([blue], at: [3][nextAvailableCol])
            
            blockIndex += 1
        }
        if color == 6 {
            nextAvailableCol = colorArr6.count/4
            
            colorArr6.insert([blockIndex], at: [0][nextAvailableCol])
            colorArr6.insert([red], at: [1][nextAvailableCol])
            colorArr6.insert([green], at: [2][nextAvailableCol])
            colorArr6.insert([blue], at: [3][nextAvailableCol])
            
            blockIndex += 1
        }
    }
    
    func averageRGB() {
        var rSum : CGFloat = 0
        var gSum : CGFloat = 0
        var bSum : CGFloat = 0
        var rAvg : CGFloat = 0
        var gAvg : CGFloat = 0
        var bAvg : CGFloat = 0
        
        if colorArr1.count > 0 {
            for col in 0...(colorArr1.count/4 - 1) {
                print("colorArr1.count/4 - 1 is equal to \(colorArr1.count/4 - 1)")
                rSum += colorArr1[1][col]
                gSum += colorArr1[2][col]
                bSum += colorArr1[3][col]
            }
            print("lelmeister")
            rAvg = rSum / CGFloat(colorArr1.count/4)
            gAvg = gSum / CGFloat(colorArr1.count/4)
            bAvg = bSum / CGFloat(colorArr1.count/4)
            
            rgbAvg.insert([rAvg], at: [0][0])           // ERROR IN THIS LINE..................................
            rgbAvg.insert([gAvg], at: [0][1])
            rgbAvg.insert([bAvg], at: [0][2])
            print("CHECK")

            rSum = 0
            gSum = 0
            bSum = 0
        } else {
            rgbAvg.insert([0], at: [0][0])
            rgbAvg.insert([0], at: [0][1])
            rgbAvg.insert([0], at: [0][2])
        }
        if colorArr2.count > 0 {
            for col in 0...(colorArr2.count/4 - 1) {
                rSum += colorArr2[1][col]
                gSum += colorArr2[2][col]
                bSum += colorArr2[3][col]
            }
            rAvg = rSum / CGFloat(colorArr2.count/4)
            gAvg = gSum / CGFloat(colorArr2.count/4)
            bAvg = bSum / CGFloat(colorArr2.count/4)
            
            rgbAvg.insert([rAvg], at: [1][0])
            rgbAvg.insert([gAvg], at: [1][1])
            rgbAvg.insert([bAvg], at: [1][2])
            
            rSum = 0
            gSum = 0
            bSum = 0
        } else {
            rgbAvg.insert([0], at: [1][0])
            rgbAvg.insert([0], at: [1][1])
            rgbAvg.insert([0], at: [1][2])
        }
        if colorArr3.count > 0 {
            for col in 0...(colorArr3.count/4 - 1) {
                rSum += colorArr3[1][col]
                gSum += colorArr3[2][col]
                bSum += colorArr3[3][col]
            }
            rAvg = rSum / CGFloat(colorArr3.count/4)
            gAvg = gSum / CGFloat(colorArr3.count/4)
            bAvg = bSum / CGFloat(colorArr3.count/4)
            
            rgbAvg.insert([rAvg], at: [2][0])
            rgbAvg.insert([gAvg], at: [2][1])
            rgbAvg.insert([bAvg], at: [2][2])
            
            rSum = 0
            gSum = 0
            bSum = 0
        } else {
            rgbAvg.insert([0], at: [2][0])
            rgbAvg.insert([0], at: [2][1])
            rgbAvg.insert([0], at: [2][2])
        }
        if colorArr4.count > 0 {
            for col in 0...(colorArr4.count/4 - 1) {
                rSum += colorArr4[1][col]
                gSum += colorArr4[2][col]
                bSum += colorArr4[3][col]
            }
            rAvg = rSum / CGFloat(colorArr4.count/4)
            gAvg = gSum / CGFloat(colorArr4.count/4)
            bAvg = bSum / CGFloat(colorArr4.count/4)
            
            rgbAvg.insert([rAvg], at: [3][0])
            rgbAvg.insert([gAvg], at: [3][1])
            rgbAvg.insert([bAvg], at: [3][2])
            
            rSum = 0
            gSum = 0
            bSum = 0
        } else {
            rgbAvg.insert([0], at: [3][0])
            rgbAvg.insert([0], at: [3][1])
            rgbAvg.insert([0], at: [3][2])
        }
        if colorArr5.count > 0 {
            for col in 0...(colorArr5.count/4 - 1) {
                rSum += colorArr5[1][col]
                gSum += colorArr5[2][col]
                bSum += colorArr5[3][col]
            }
            rAvg = rSum / CGFloat(colorArr5.count/4)
            gAvg = gSum / CGFloat(colorArr5.count/4)
            bAvg = bSum / CGFloat(colorArr5.count/4)
            
            rgbAvg.insert([rAvg], at: [4][0])
            rgbAvg.insert([gAvg], at: [4][1])
            rgbAvg.insert([bAvg], at: [4][2])
            
            rSum = 0
            gSum = 0
            bSum = 0
        } else {
            rgbAvg.insert([0], at: [4][0])
            rgbAvg.insert([0], at: [4][1])
            rgbAvg.insert([0], at: [4][2])
        }
        if colorArr6.count > 0 {
            for col in 0...(colorArr6.count/4 - 1) {
                rSum += colorArr6[1][col]
                gSum += colorArr6[2][col]
                bSum += colorArr6[3][col]
            }
            rAvg = rSum / CGFloat(colorArr6.count/4)
            gAvg = gSum / CGFloat(colorArr6.count/4)
            bAvg = bSum / CGFloat(colorArr6.count/4)
            
            rgbAvg.insert([rAvg], at: [5][0])
            rgbAvg.insert([gAvg], at: [5][1])
            rgbAvg.insert([bAvg], at: [5][2])
        } else {
            rgbAvg.insert([0], at: [5][0])
            rgbAvg.insert([0], at: [5][1])
            rgbAvg.insert([0], at: [5][2])
        }
    }
}
