//
//  ViewController.swift
//  ImageInOut
//
//  Created by g.sousa.de.paiva on 12/12/2018.
//  Copyright © 2018 g.sousa.de.paiva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var colorGrade: UIButton?
    @IBOutlet weak var reverseButton: UIButton?
    
    // MARK: Constants
    let image = UIImage(named: "img")
    
    // MARK: Variables
    var rgbaImage: RGBAImage!
    
    private func setup() {
        guard let img = image else {
            return
        }
        
        self.imageView?.image = img
        rgbaImage = RGBAImage(image: img)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeColor(fromIndex id: Int = 0, toIndex: Int, byAdding param: Int) {
        for index in id..<toIndex {
            var r = Int(rgbaImage.pixels[index].red)
            var g = Int(rgbaImage.pixels[index].green)
            var b = Int(rgbaImage.pixels[index].blue)
            
            r = (r + param) % 256
            g = (g + param) % 256
            b = (b + param) % 256
            
            rgbaImage.pixels[index].red = UInt8(r)
            rgbaImage.pixels[index].green = UInt8(g)
            rgbaImage.pixels[index].blue = UInt8(b)
        }
    }
    
    func processImage() {
        print("Processing...")

        let imgSize: Int = rgbaImage.pixels.count
        let segmentSize: Int = imgSize / 4
        let random: Int = Int.random(in: 0..<999)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let processGroupOne: DispatchGroup = DispatchGroup()
            let processGroupTwo: DispatchGroup = DispatchGroup()
            let processGroupThree: DispatchGroup = DispatchGroup()
            let processGroupFour: DispatchGroup = DispatchGroup()

            processGroupOne.enter()
            self.changeColor(toIndex: segmentSize, byAdding: random)
            processGroupOne.leave()
            processGroupOne.wait()

            processGroupTwo.enter()
            self.changeColor(fromIndex: segmentSize, toIndex: segmentSize * 2, byAdding: random)
            processGroupTwo.leave()
            processGroupTwo.wait()
            
            processGroupThree.enter()
            self.changeColor(fromIndex: segmentSize * 2, toIndex: segmentSize * 3, byAdding: random)
            processGroupThree.leave()
            processGroupThree.wait()
            
            processGroupFour.enter()
            self.changeColor(fromIndex: segmentSize * 3, toIndex: imgSize, byAdding: random)
            processGroupFour.leave()
            processGroupFour.wait()

            DispatchQueue.main.async {
                self.convertImage()
            }
        }
    }
    
    func convertImage() {
        guard let newImage = self.rgbaImage.toUIImage() else {
            print("Failed to process!")
            return
        }
        
        print("Converted!")
        self.colorGrade?.isEnabled = true
        self.reverseButton?.isEnabled = true
        self.imageView?.image = newImage
    }
    
    @IBAction func processImage(_ sender: UIButton) {
        self.colorGrade?.isEnabled = false
        self.reverseButton?.isEnabled = false
        self.processImage()
    }
    
    @IBAction func reverseImage(_ sender: UIButton) {
        self.imageView?.image = image
    }
}
