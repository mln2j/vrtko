//
//  LocationManager.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 01.06.2025..
//


import Foundationimport CoreLocationimport Combineclass LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {    @Published var userLocation: CLLocationCoordinate2D?    private let manager = CLLocationManager()    override init() {        super.init()        manager.delegate = self        manager.desiredAccuracy = kCLLocationAccuracyBest        manager.requestWhenInUseAuthorization()        manager.startUpdatingLocation()    }    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        userLocation = locations.last?.coordinate    }    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {        print("Location error: \(error.localizedDescription)")    }}