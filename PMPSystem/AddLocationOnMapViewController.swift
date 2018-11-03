//
//  AddLocationOnMapViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 2/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import MapKit

protocol AddALocationOnMapDelegate {
    func addCoordinate(locCoord: CLLocationCoordinate2D)
    
}

class AddLocationOnMapViewController: UIViewController {

    @IBOutlet weak var selectLocationMapView: MKMapView!
    var delegate: AddALocationOnMapDelegate?
    var locCoord: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFocus(animation: true)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTapSelection"))
        self.view.addGestureRecognizer(tapGesture)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // this function response when the screen is long touched (about 0.5 sec)
    @objc func handleTapSelection() {
        guard self.view.gestureRecognizers?.first != nil else {
            return
        }
        
        // get where the screen is tapped
        let screenLocation = self.view.gestureRecognizers?.first!.location(in: self.selectLocationMapView)
        
        locCoord = self.selectLocationMapView.convert(screenLocation!, toCoordinateFrom: self.selectLocationMapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locCoord!
        annotation.title = "Choose here"
        annotation.subtitle = "Selected location"
        
        selectLocationMapView.removeAnnotations(selectLocationMapView.annotations)
        selectLocationMapView.addAnnotation(annotation)
        selectLocationMapView.reloadInputViews()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleSelected))
        
    }
    
    // the the default centre location to Monash Caulfield campus.
    func setFocus(animation: Bool){
        selectLocationMapView.centerCoordinate = CLLocationCoordinate2D(latitude: -37.8770, longitude: 145.0443)
        selectLocationMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8770, longitude: 145.0443), latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
    }
    
    @objc func handleSelected() {
        self.delegate?.addCoordinate(locCoord: locCoord!)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
