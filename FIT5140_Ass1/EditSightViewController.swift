//
//  EditSightViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 6/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData

class EditSightViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var photoIMAGEview: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let motionManager: CMMotionManager = CMMotionManager()
    var lastRotation = 0.0
    var shownImageIndex = 0
    
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var oldPathList = [String]()
    var sightImages = [Images]()
    var oldIamges = [Images]()
    var sightName: String?
    weak var databaseController: DatabaseProtocol?
//    var managedObjectContext: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: handleMotion(data:error:))
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 16
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
//        managedObjectContext = appDelegate.persistentContainer.viewContext
        let sights = databaseController!.fetchSights()
        
        for sight in sights {
            if sight.name == sightName {
                descriptionTextView.text = sight.descripution
                locationTextField.text = sight.shortDesscripution
            }
        }
        
        nameTextField.text = sightName
        oldIamges = sightImages
        oldPathList = imagePathList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(sightImages.count > 0) {
            photoIMAGEview.image = imageList[0]
        }
        
    }
    
    @IBAction func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        let controller = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let date = UInt(Date().timeIntervalSince1970)
            imagePathList.append("\(date)")
            imageList.append(pickedImage)
            let imagec = databaseController!.addImage(imageName: "\(date)")
//            let imagec = NSEntityDescription.insertNewObject(forEntityName:
//                "Images", into: managedObjectContext!) as! Images
//            imagec.imageName = ("\(date)")
            sightImages.append(imagec)
            photoIMAGEview.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
        
    }
    
//    func imagePickerControllerDidCancel(_picker: UIImagePickerController){
//        displayMessage("There was an error in getting the image", "Error")}
    
    @IBAction func handleLongPress(recognizae: UILongPressGestureRecognizer) {
        let deleteAlertController = UIAlertController(title: "Delete Image", message: "Do you confirm to delete current image?", preferredStyle: .actionSheet)
        let cancelAlertAction = UIAlertAction(title: "Cancle", style: UIAlertAction.Style.cancel, handler: nil)
        deleteAlertController.addAction(cancelAlertAction)
        let sureAlertAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive, handler: deleteImage)
        deleteAlertController.addAction(sureAlertAction)
        present(deleteAlertController, animated: true, completion: nil)
        
    }
    
    func deleteImage(alerAction:UIAlertAction){
        let index = imageList.firstIndex(of: photoIMAGEview.image!)
        imageList.remove(at: index!)
        imagePathList.remove(at: index!)
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
        photoIMAGEview.image = newImage
    }
    
    func handleMotion(data: CMDeviceMotion?, error: Error?) -> Void {
        guard let data = data else{
            print("MOtion failure:\(String(describing:error))")
            return
        }
        
        let rotation = atan2(data.gravity.x, data.gravity.y) - Double.pi
        let rotationDiff = rotation - lastRotation
        photoIMAGEview.transform = photoIMAGEview.transform.rotated(by: CGFloat(rotationDiff))
        lastRotation = rotation
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        if nameTextField.text != "" && locationTextField.text != ""{
            let sight = databaseController!.updateSight(oldname: sightName!, name: nameTextField.text!, descripution: descriptionTextView.text, shortDescripution: locationTextField.text!)
                updateSIghtImage(sight: sight)
            return
        }
        var errorMsg = "Please ensure all fields are filled:\n"
        
        if nameTextField.text == "" {
            errorMsg += "- Must provide a name\n"
        }
        if locationTextField.text == "" {
            errorMsg += "- Must provide a location\n"
        }
      
        displayMessage(title: "Not all fields filled", message: errorMsg)
        
    }
    
    func updateSIghtImage(sight: Sights){
        print(oldPathList.count,oldIamges.count,imagePathList.count,sightImages.count)
        for image in oldIamges{
            print(oldPathList.count,oldIamges.count,imagePathList.count,sightImages.count)
            if !sightImages.contains(image){
                databaseController!.removeImageFromSight(sight: sight, image: image)
            }
        }
        for image in sightImages{
            if !oldIamges.contains(image){
             let _  = databaseController!.addImageToSight(sight: sight, image: image)
            }
        }
        
    }
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
