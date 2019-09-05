//
//  SightInfoViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 4/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit

class SightInfoViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var sightDesTextView: UITextView!
    @IBOutlet weak var sightLocationLabel: UILabel!
    @IBOutlet weak var sightNameLabel: UILabel!
    var sightName: String?
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let sights = databaseController!.fetchSights()
        
        for sight in sights {
            if sight.name == sightName {
                sightDesTextView.text = sight.descripution
                sightLocationLabel.text = sight.shortDesscripution
            }
        }
        
        sightNameLabel.text = sightName
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
