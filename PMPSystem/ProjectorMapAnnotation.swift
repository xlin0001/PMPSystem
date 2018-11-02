//
//  ProjectorMapAnnotation.swift
//  PMPSystem
//
//  Created by Oliver Lin on 2/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import MapKit

class ProjectorMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?

    init(title: String, subtitle: String, lat: Double, long: Double, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
