//
//  CreatNewSightUICollectionViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import CoreData

class CreatNewSightUICollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var fullDesTextField: UITextField!
    @IBOutlet weak var shortDesTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var images = [UIImage]()
    var icons = [Icons]()
    
    
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let itemsPerRow: CGFloat = 3
   
    var imagePathList = [String]()
    var managedObjectContext: NSManagedObjectContext?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        
        self.view.addSubview(iconCollectionView)
        self.view.addSubview(imageCollectionView)
        createDefaultIcons()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let imageDataList = try managedObjectContext!.fetch(Images.fetchRequest()) as [Images]
            if(images.count > 0) {
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
        } catch {
            print("Unable to fetch list of parties")
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
        return sectionInsets.left
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
    }
    @IBAction func saveNewSight(_ sender: Any) {
    }
    
    
}
