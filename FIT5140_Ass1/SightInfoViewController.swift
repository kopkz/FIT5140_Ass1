//
//  SightInfoViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 4/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import CoreMotion

class SightInfoViewController: UIViewController {
    
    @IBOutlet weak var photosImageView: UIImageView!
    
    @IBOutlet weak var sightDesTextView: UITextView!
    @IBOutlet weak var sightLocationLabel: UILabel!
    @IBOutlet weak var sightNameLabel: UILabel!
    var sightName: String?
    weak var databaseController: DatabaseProtocol?
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var sightImages = [Images]()

    let motionManager: CMMotionManager = CMMotionManager()
    var lastRotation = 0.0
    var shownImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: handleMotion(data:error:))
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let sights = databaseController!.fetchSights()
        
        for sight in sights {
            if sight.name == sightName {
                sightDesTextView.text = sight.descripution
                sightLocationLabel.text = sight.shortDesscripution
                sightImages = sight.sightImages?.allObjects as! [Images]
            }
        }
        
        sightNameLabel.text = sightName
        sightDesTextView.isEditable = false
        sightDesTextView.layer.borderWidth = 0.5
        sightDesTextView.layer.borderColor = UIColor.lightGray.cgColor
        sightDesTextView.layer.cornerRadius = 16
    }
    
    @IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        var newImageIndex = shownImageIndex
        if recognizer.direction == .left{
            newImageIndex += 1
        }else if recognizer.direction == .right{
            newImageIndex -= 1
        }
        showImageWithIndex(_index: newImageIndex)
    }
    
    func showImageWithIndex(_index:Int){
        shownImageIndex = (_index + imageList.count) % imageList.count
         let newImage = imageList[shownImageIndex]
         photosImageView.image = newImage
        }
    
    func handleMotion(data: CMDeviceMotion?, error: Error?) -> Void {
        guard let data = data else{
            print("MOtion failure:\(String(describing:error))")
            return
        }
        
        let rotation = atan2(data.gravity.x, data.gravity.y) - Double.pi
        let rotationDiff = rotation - lastRotation
        photosImageView.transform = photosImageView.transform.rotated(by: CGFloat(rotationDiff))
        lastRotation = rotation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            if(sightImages.count > 0) {
                for data in sightImages {
                    let fileName = data.imageName!
                    
                    if(imagePathList.contains(fileName)) {
                        print("Image already loaded in. Skipping image")
                        continue
                    }
                    
                    if let image = loadImageData(fileName: fileName) {
                        self.imageList.append(image)
                        self.imagePathList.append(fileName)
                    }
                }
                //print(imageList.count)
                photosImageView.image = imageList[0]
            }
       
    }

    func loadImageData(fileName: String) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            guard let fileData = fileManager.contents(atPath: filePath) else {return image}
            image = UIImage(data: fileData)
        }
        return image
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editSightSegue" {
            let destination = segue.destination as! EditSightViewController
            destination.imageList = imageList
            destination.imagePathList = imagePathList
            destination.sightName = sightName
            destination.sightImages = sightImages
        }
    }
    

}
