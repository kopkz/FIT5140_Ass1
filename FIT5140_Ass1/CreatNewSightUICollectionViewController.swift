//
//  CreatNewSightUICollectionViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import CoreData

class CreatNewSightUICollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var fullDesTextView: UITextView!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var images = [UIImage]()
    var icons = [Icons]()
    var iconName: String?
    
    
    private let sectionInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
    private let itemsPerRow: CGFloat = 3
   
    var imagePathList = [String]()
    var imageDataList = [Images]()
    var managedObjectContext: NSManagedObjectContext?
    weak var databaseController: DatabaseProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate?.persistentContainer.viewContext
        databaseController = appDelegate!.databaseController

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        
        self.view.addSubview(iconCollectionView)
        self.view.addSubview(imageCollectionView)
        createDefaultIcons()
        
        fullDesTextView.adjustsFontForContentSizeCategory = true
        fullDesTextView.layer.borderColor = UIColor.black.cgColor
        fullDesTextView.layer.cornerRadius = 16
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            imageDataList =  databaseController!.fetchUnLInkedIamges() as [Images]
            if(imageDataList.count > 0) {
                for data in imageDataList {
                    let fileName = data.imageName!
                    
                    if(imagePathList.contains(fileName)) {
                        print("Image already loaded in. Skipping image")
                        continue
                    }
                    
                    if let image = loadImageData(fileName: fileName) {
                        self.images.append(image)
                        self.imagePathList.append(fileName)
                        self.imageCollectionView!.reloadSections([0])
                    }
                }
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
            let fileData = fileManager.contents(atPath: filePath)
            image = UIImage(data: fileData!)
        }
        return image
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
//        switch collectionView.tag {
//        case 0:
//            return 10
//        case 1:
//            return images.count
//
//        default:
//            return 10
//        }
        
        

        if collectionView == self.iconCollectionView {
            return 10
        }
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Access

//        switch collectionView.tag {
//        case 0:
//            let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
//            let icon = icons[indexPath.row]
//            iconCell.iconImageView.image = UIImage(named: icon.imageName)
//            iconCell.iconNameLabel.text = icon.iconName
//            return iconCell
//        case 1:
//            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
//
//            imageCell.backgroundColor = UIColor.lightGray
//            imageCell.imageView.image = images[indexPath.row]
//
//            return imageCell
//
//        default:
//            let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
//            let icon = icons[indexPath.row]
//            iconCell.iconImageView.image = UIImage(named: icon.imageName)
//            iconCell.iconNameLabel.text = icon.iconName
//            return iconCell
//        }



        if collectionView == self.iconCollectionView{
            let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
            let icon = icons[indexPath.row]
            iconCell.iconImageView.image = UIImage(named: icon.imageName)
            iconCell.iconNameLabel.text = icon.iconName
            return iconCell
        }
        else {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell

        imageCell.backgroundColor = UIColor.lightGray
        imageCell.imageView.image = images[indexPath.row]

        return imageCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if collectionView == self.iconCollectionView {
            let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
            iconCell.isHighlighted = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.iconCollectionView {
           let iconCell = collectionView.cellForItem(at: indexPath) as! IconCollectionViewCell
           iconCell.isSelected = true
            
            iconName = icons[indexPath.row].imageName
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        
        
//        switch collectionView.tag {
//        case 0:
//            return CGSize(width: 60, height: 60)
//        case 1:
//            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//            let availableWidth = view.frame.width - paddingSpace
//            let widthPerItem = availableWidth / itemsPerRow
//            return CGSize(width: widthPerItem, height: widthPerItem)
//
//        default:
//            return CGSize(width: 60, height: 60)
//        }
        

        if collectionView == self.iconCollectionView{
            return CGSize(width: 60, height: 60)
        }
        else{
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAt
        section: Int) -> UIEdgeInsets {
        
        
//        switch collectionView.tag {
//        case 0:
//            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        case 1:
//            return sectionInsets
//
//        default:
//            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        }
        
        
        
        if collectionView == self.iconCollectionView{
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return sectionInsets
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
//        switch collectionView.tag {
//        case 0:
//           return 10
//        case 1:
//            return sectionInsets.left
//
//        default:
//            return 10
//        }
        
        if collectionView == self.iconCollectionView{
            return 10}
        return 0
    }


    
    func createDefaultIcons(){
        icons.append(Icons(imageName: "baseline_train_black_18dp.png", iconName: "Transport"))
        icons.append(Icons(imageName: "baseline_restaurant_menu_black_18dp.png", iconName: "Restaurant"))
        icons.append(Icons(imageName: "baseline_hotel_black_18dp.png", iconName: "Hotel"))
        icons.append(Icons(imageName: "baseline_local_atm_black_18dp.png", iconName: "Bank"))
        icons.append(Icons(imageName: "baseline_local_bar_black_18dp.png", iconName: "Bar"))
        icons.append(Icons(imageName: "baseline_local_grocery_store_black_18dp.png", iconName: "Shopping"))
        icons.append(Icons(imageName: "baseline_fitness_center_black_18dp.png", iconName: "Sports"))
        icons.append(Icons(imageName: "baseline_free_breakfast_black_18dp.png", iconName: "Cafee"))
        icons.append(Icons(imageName: "baseline_party_mode_black_18dp.png", iconName: "Attractions"))
        icons.append(Icons(imageName: "baseline_menu_book_black_18dp.png", iconName: "Education"))
    }
    
//    func createDefaultImages() {
//        images.append(UIImage(named: "camera-150.png")!)
//    }
    
    @IBAction func addNewPhoto(_ sender: Any) {
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
    @IBAction func saveNewSight(_ sender: Any) {
        if nameTextField.text != "" && locationTextField.text != "" && (iconName != nil) {
            let name = nameTextField.text!
            let shortDes = locationTextField.text!
            let description = fullDesTextView.text!
            let lat = Double(locationTextField.text!.split(separator: ",")[0])
            let long = Double(locationTextField.text!.split(separator: ",")[1])
            if lat != nil && long != nil {
                guard let newSight = databaseController?.addSight(name: name, descripution: description, shortDescripution: shortDes, iconName: iconName!, latitude: lat!, longitude: long!) else {
                    let errorMsg = "New sight creating fail, please try again"
                    displayMessage(title: "Unkown error", message: errorMsg)
                    return }
          
                for image in imageDataList {
                    databaseController?.addImageToSight(sight: newSight, image: image)
                }
                navigationController?.popViewController(animated: true)
                return
            
            } else {
                let errorMsg = "Location should be 'latitude,longitude', eg: 33.33,22.22"
                displayMessage(title: "Unaccepted Location", message: errorMsg)
                return
            }
        }
        
         var errorMsg = "Please ensure all fields are filled:\n"
        
        if nameTextField.text == "" {
            errorMsg += "- Must provide a name\n"
        }
        if locationTextField.text == "" {
            errorMsg += "- Must provide a location\n"
        }
        if iconName == nil  {
            errorMsg += "- Must select a icon"
        }
        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
}
