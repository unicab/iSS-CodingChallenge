//
//  ViewController.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController {

    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        RequestService.fetchISSInfo { info in
//            print(info)
//        }
        
//        RequestService.fetchISSLocation { loc in
//            print(loc)
//        }
        
//        RequestService.fetchISSPassTime(atLatitutude: "6.0930", atLongitude: "115.3679") {
//            print("abc")
//        }
        
//        let mapController = MapController()
//        let navVC = UINavigationController(rootViewController: mapController)
//        self.present(mapController, animated: false, completion: nil)
    }

}

extension ViewController: CLLocationManagerDelegate {
    
}

