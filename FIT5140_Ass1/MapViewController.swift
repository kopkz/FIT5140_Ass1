//
//  MapViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//


import UIKit
import MapKit
import UserNotifications
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, MapFocusDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    weak var databaseController: DatabaseProtocol?
    var locations = [LocationAnnotation]()
    var geoLocations = [CLCircularRegion]()
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        // Do any additional setup after loading the view.
        let defaultZoomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), latitudinalMeters: 3500, longitudinalMeters: 3500)
        //Melbourne location: 37.8136° S, 144.9631° E
        mapView.setRegion(mapView.regionThatFits(defaultZoomRegion), animated: true)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let sights = databaseController!.fetchSights()
        
        for sight in sights {
             let location = LocationAnnotation(newTitle: sight.name!, newSubtitle: sight.shortDesscripution!, lat: sight.latitude, long: sight.longitude, iconName: sight.iconName!)
            locations.append(location)
            mapView.addAnnotation(location)
            
            let geoLocation = CLCircularRegion(center: location.coordinate, radius: 50, identifier: location.title!)
            geoLocation.notifyOnEntry = true
            geoLocations.append(geoLocation)
            
        }
        
        createDefaultPhotos()
        
//        let testAnn = LocationAnnotation(newTitle: "test", newSubtitle: "eee", lat: -37.814337, long: 144.965357, iconName: "camera-150.png")
//        mapView.addAnnotation(testAnn)
     
        let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
        center.requestAuthorization(options: [.alert]) { (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }}
        
       
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        for geo in geoLocations{
        locationManager.startMonitoring(for: geo)
            
            let notification = UNMutableNotificationContent()
            notification.title = "Sights Entry Notification"
            notification.subtitle = "from Melbourne Exploring"
            notification.body = "You have entered \(geo.identifier)"
            let trigger = UNLocationNotificationTrigger(region: geo, repeats: true)
            let identifier = geo.identifier
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
                    currentLocation = location.coordinate
    
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            let location = locations.last!
//            currentLocation = location.coordinate
//        print(currentLocation as Any)
//        }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        let alert = UIAlertController(title: "Movement Detected!", message: "You have entered \(region.identifier)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
//
        

    }
    
    func addAnnotation(sight: Sights){
        var ifContain = false
        for lo in locations {
            if lo.title == sight.name {
                ifContain = true
            }
        }
        if ifContain {
            return
        }
         let location = LocationAnnotation(newTitle: sight.name!, newSubtitle: sight.shortDesscripution!, lat: sight.latitude, long: sight.longitude, iconName: sight.iconName!)
        locations.append(location)
        mapView.addAnnotation(location)
        let geoLocation = CLCircularRegion(center: location.coordinate, radius: 200, identifier: location.title!)
        geoLocation.notifyOnEntry = true
        geoLocations.append(geoLocation)
    }
    
    func focusOn(name: String) {
        for location in locations {
            if location.title == name {
                mapView.selectAnnotation(location,animated: true)
                let zoomRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
                mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
                return
            }
        }
        
            print(currentLocation?.latitude as Any)
        
    }
    
    func removeAnnotation(name: String) {
        for location in locations {
            if location.title == name {
                mapView.removeAnnotation(location)
                return
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "sightAnnotation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            var imageName: String
            
            let sights = databaseController!.fetchSights()
            
    
            for sight in sights {
                
                //load the image but cantnot fix the size problem
//               if sight.sightImages!.count > 0 {
//                let imageName = (sight.sightImages?.anyObject() as! Images).imageName
//                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
//                                                               .userDomainMask, true)[0] as String
//                let url = NSURL(fileURLWithPath: path)
//                var image: UIImage?
//                if let pathComponent = url.appendingPathComponent(imageName!) {
//                    let filePath = pathComponent.path
//                    let fileManager = FileManager.default
//                    guard let fileData = fileManager.contents(atPath: filePath) else {return nil}
//                    image = UIImage(data: fileData)
//                    annotationView?.image = image.
//                   // let size  = CGSize(width: 10, height: 10)
//                    annotationView?.sizeToFit()
//                    //annotationView?.sizeThatFits(CGSize.init(width: 0.1, height: 0.1))
//                    break
//                    }
//                } else
                if sight.name == annotation.title {
                    imageName = sight.iconName!
                    annotationView?.image = UIImage(named: imageName)
                }
            }
            

            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)

            annotationView!.rightCalloutAccessoryView = rightButton as? UIView
        }
//        else {
//            annotationView?.annotation = annotation
//        }

        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "getSightDetail", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getSightDetail"{
            let destination = segue.destination as! SightInfoViewController
            destination.sightName = (sender as! MKAnnotationView).annotation!.title!
        }
        else if segue.identifier == "sightsListSegue"{
            let destination = segue.destination as! SightsListTableViewController
            destination.mapFoucusDelegate = self
            destination.mapViewController = self
        }
    }
    // create default local stroage photos for Carlton Gardens
    func createDefaultPhotos(){
        let photoNames = ["CarltonGardens1.jpg", "CarltonGardens2.jpg", "CarltonGardens3.jpg", "CarltonGardens4.jpg"]
        for photoName in photoNames{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            let data = UIImage(named: photoName)!.jpegData(compressionQuality: 0.8)!
            if let pathComponent = url.appendingPathComponent("\(photoName)") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                fileManager.createFile(atPath: filePath, contents: data,
                                       attributes: nil)
                print("succeed")
            }
        }
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



//extension ViewController: MKMapViewDelegate {
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
//        
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//        }
//        
//        if  annotation !== mapView.userLocation {
//            annotationView?.image = UIImage(named: "camera-150.png")
//            
//        }
//        
//        annotationView?.canShowCallout = true
//        
//        return annotationView
//    }
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        print("The annotation was selected: \(String(describing: view.annotation?.title))")
//    }
//}
