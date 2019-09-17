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
    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?
    
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
        self.startTime = CFAbsoluteTimeGetCurrent()

        let imgSize: Int = rgbaImage.pixels.count
        let segmentSize: Int = imgSize / 8
        let random: Int = Int.random(in: 0..<999)
        
        let concurrentQueue1 = DispatchQueue(label: "concurrentQueue1", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue2 = DispatchQueue(label: "concurrentQueue2", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue3 = DispatchQueue(label: "concurrentQueue3", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue4 = DispatchQueue(label: "concurrentQueue4", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue5 = DispatchQueue(label: "concurrentQueue5", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue6 = DispatchQueue(label: "concurrentQueue6", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue7 = DispatchQueue(label: "concurrentQueue7", qos: .userInitiated, attributes: .concurrent)
        let concurrentQueue8 = DispatchQueue(label: "concurrentQueue8", qos: .userInitiated, attributes: .concurrent)
        
        let processingGroup = DispatchGroup()
        
////////////////////////////////////////////////////////////////////////////
        processingGroup.enter()
        concurrentQueue1.async(group: processingGroup) {
            self.changeColor(toIndex: segmentSize, byAdding: random)
            print("1 terminou")
            processingGroup.leave()
        }

        processingGroup.enter()
        concurrentQueue2.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize, toIndex: segmentSize * 2, byAdding: random)
            print("2 terminou")
            processingGroup.leave()
        }

        processingGroup.enter()
        concurrentQueue3.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize * 2, toIndex: segmentSize * 3, byAdding: random)
            print("3 terminou")
            processingGroup.leave()
        }

        processingGroup.enter()
        concurrentQueue4.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize * 3, toIndex: segmentSize * 4, byAdding: random)
            print("4 terminou")
            processingGroup.leave()
        }
        
        processingGroup.enter()
        concurrentQueue5.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize * 4, toIndex: segmentSize * 5, byAdding: random)
            print("5 terminou")
            processingGroup.leave()
        }
        
        processingGroup.enter()
        concurrentQueue6.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize * 5, toIndex: segmentSize * 6, byAdding: random)
            print("6 terminou")
            processingGroup.leave()
        }
        
        processingGroup.enter()
        concurrentQueue7.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize * 6, toIndex: segmentSize * 7, byAdding: random)
            print("7 terminou")
            processingGroup.leave()
        }
        
        processingGroup.enter()
        concurrentQueue8.async(group: processingGroup) {
            self.changeColor(fromIndex: segmentSize * 7, toIndex: imgSize, byAdding: random)
            print("8 terminou")
            processingGroup.leave()
        }

        processingGroup.notify(queue: .main) {
            print("Foi geral!!")
            self.convertImage()
        }
////////////////////////////////////////////////////////////////////////////
    }
    
    func convertImage() {
        guard let newImage = self.rgbaImage.toUIImage() else {
            print("Failed to process!")
            return
        }
        
        self.endTime = CFAbsoluteTimeGetCurrent()
        print("Converted!")
        let elapsedTime = Double(endTime ?? 0) - Double(startTime ?? 0)
        print("In \(elapsedTime) seconds")
        self.imageView?.image = newImage
        self.colorGrade?.isEnabled = true
        self.reverseButton?.isEnabled = true
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
