//
//  MapViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaultZoomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), latitudinalMeters: 3500, longitudinalMeters: 3500)
        //Melbourne location: 37.8136° S, 144.9631° E
        mapView.setRegion(mapView.regionThatFits(defaultZoomRegion), animated: true)
        
        mapView.delegate = self
        
//        let testAnn = LocationAnnotation(newTitle: "test", newSubtitle: "eee", lat: -37.814337, long: 144.965357, iconName: "camera-150.png")
//        mapView.addAnnotation(testAnn)
        
    }
   
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation,animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
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

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if  annotation !== mapView.userLocation {
            annotationView?.image = UIImage(named: "camera-150.png")
            
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
    }
}
