//
//  CameraViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 3/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import CoreData

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate?.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
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
    
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = imageView.image else {
            displayMessage("Cannot save until a photo has been taken!", "Error")
            return
        }
        let date = UInt(Date().timeIntervalSince1970)
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent("\(date)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data,
                                   attributes: nil)
            let newImage = NSEntityDescription.insertNewObject(forEntityName:
                "Images", into: managedObjectContext!) as! Images
            newImage.imageName = "\(date)"
            
            do{
                try self.managedObjectContext?.save()
                displayMessage("Image has been saved!", "Success!")
            } catch {
                displayMessage("Could not save to database", "Error")
                
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_picker: UIImagePickerController){
        displayMessage("There was an error in getting the image", "Error")
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
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
