//
//  MapController.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var annotation: MKPointAnnotation?
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var satelliteButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "MapController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func navigationButtonTapped(_ sender: Any) {
        self.locationDidUpdate = { [weak self] lat, lon in
            let coor = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self?.mapView.setCenter(coor, animated: true)
            self?.locationManager.stopUpdatingLocation()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func satelliteButtonTapped(_ sender: Any) {
        if let removingAnno = annotation { self.mapView.removeAnnotation(removingAnno) }
        
        RequestService.fetchISSLocation { [weak self] loc in
            guard let loc = loc, let latDbl = Double(loc.latitude), let lonDbl = Double(loc.longitude) else { return }
            self?.annotation = MKPointAnnotation()
            let coor = CLLocationCoordinate2D(latitude: CLLocationDegrees(latDbl), longitude: CLLocationDegrees(lonDbl))
            self?.annotation?.coordinate = coor
            if let ann = self?.annotation { self?.mapView.addAnnotation(ann) }
            self?.mapView.setCenter(coor, animated: true)
        }
    }
    
    @IBAction func getPassTimeButtonTapped(_ sender: Any) {
        let passtimeVC = PassTimeController()
        
        passtimeVC.didLoadBlock = { [weak self] in
            self?.locationDidUpdate = { lat, lon in
                RequestService.fetchISSPassTime(atLatitutude: "\(lat)", atLongitude: "\(lon)") { passtime in passtimeVC.setModel(passtime) }
                self?.locationManager.stopUpdatingLocation()
            }
        }
        
        locationManager.startUpdatingLocation()
        self.navigationController?.pushViewController(passtimeVC, animated: true)
    }
    
    @IBAction func showAstronautsButtonTapped(_ sender: Any) {
        let astronautVC = AstronautsController()
        astronautVC.didLoadBlock = { RequestService.fetchISSInfo { info in astronautVC.setModel(info) } }
        self.navigationController?.pushViewController(astronautVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ISS Tracker"

        mapView.delegate = self
        navigationButton.imageView?.contentMode = .scaleAspectFit
        satelliteButton.imageView?.contentMode = .scaleAspectFit
        navigationButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        satelliteButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var locationDidUpdate: ((_ lat: CLLocationDegrees, _ lon: CLLocationDegrees)->Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
    }
}

extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = manager.location?.coordinate else { return }
        locationDidUpdate?(loc.latitude, loc.longitude)
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "annotation"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        } else {
            anView?.annotation = annotation
        }
        
        anView?.image = #imageLiteral(resourceName: "satellite").resize(CGSize(width: 50, height: 50))
        return anView
    }
}

extension UIImage {
    func resize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
