//
//  ViewController.swift
//  12-RouteTutorial
//
//  Created by daixianglong on 2017/5/3.
//  Copyright © 2017年 daixianglong. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        setupRouteInfo()
        
    }

    
    
    private func setupRouteInfo() {
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Squre"
        sourceAnnotation.coordinate = sourceLocation
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        destinationAnnotation.coordinate = destinationLocation
        
        mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
        
        let sourcePM = MKPlacemark(coordinate: sourceLocation)
        let destinationPM = MKPlacemark(coordinate: destinationLocation)
        
        let sourceMapItem = MKMapItem(placemark: sourcePM)
        let destinationMapItem = MKMapItem(placemark: destinationPM)
        
        // draw stuff
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            //draw line
            if let response = response {
                let route = response.routes[0]
                self.mapView.add(route.polyline, level: .aboveRoads)
                let distance = route.distance / 1000
                let result = String(format: "%.1f", distance)
                self.distanceLabel.text = "Distance = \(result) KM"
                let routeRect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(routeRect), animated: true)
            }
        }
        
        
    }

}

//MARK: - MapView Delegate
extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth = 4.0
        render.strokeColor = UIColor.red
        return render
    }
}

