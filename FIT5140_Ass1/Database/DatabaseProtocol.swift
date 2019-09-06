//
//  DatabaseProtocol.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 1/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case sights
    case images
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onSightsChange(change: DatabaseChange, sights: [Sights])
    func onImagesChange(change: DatabaseChange, images: [Images])
}

protocol DatabaseProtocol: AnyObject {
    
    
    //Feel confuse, should included??????
    //var defaultSight: [Sights] {get}
    
    func addSight(name: String, descripution: String, shortDescripution: String, iconName: String, latitude: Double, longitude: Double) -> Sights
    func addImage(imageName: String) -> Images
    func addImageToSight(sight: Sights, image: Images) -> Bool
    func deleteSight(sight: Sights)
    func deleteImahe(image: Images)
    func removeImageFromSight(sight: Sights, image: Images)
    func addListener(listenr: DatabaseListener)
    func removeListener(listenr: DatabaseListener)
    func fetchSights() -> [Sights]
    func fetchImages() -> [Images]
    func fetchSightsDescending() -> [Sights]
    func fetchUnLInkedIamges() -> [Images]
    func fetchSightImages(sightName: String) -> [Images]
    func updateSight(oldname: String, name: String, descripution: String, shortDescripution: String) -> Sights
}
