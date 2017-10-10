//
//  SecondViewController.swift
//  BirdMonitorSystem
//
//  Created by 白云松 on 28/8/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class SecondViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var labelFeeding: UITextField!
    @IBOutlet weak var labelEating: UITextField!
    @IBOutlet weak var labelFlying: UITextField!
    @IBOutlet weak var labelDrinking: UITextField!

    @IBOutlet weak var dateLabel: UITextField!
    
    @IBOutlet weak var userNameLabel: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    var locationLabel1 = ""
    let locationManger = CLLocationManager()
    
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        labelFeeding.delegate = self
        labelDrinking.delegate = self
        labelFlying.delegate = self
        labelEating.delegate = self
        userNameLabel.delegate = self

        dateLabel.delegate = self
        
        //data table inital
        var isCreateDataBase: Bool = false
        isCreateDataBase = DBManager.shared.createTableDatabase()
        print("Create table sucessfully:(\(isCreateDataBase))")
        
        //location 
        self.locationManger.requestAlwaysAuthorization()
        
        self.locationManger.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.startUpdatingLocation()
        
            
        //map 
            
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
            let location:CLLocationCoordinate2D = (locationManger.location?.coordinate)!
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = "Your current location"
            annotation.subtitle = "I'm here!"
            
            
            
            mapView.addAnnotation(annotation)
            
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        //let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude , location.coordinate.longitude)
        //var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        //let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        //map.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil
            {
                print("There was an error")
            }else{
                if let place = placemark?[0]
                {
                    if place.subThoroughfare != nil
                    {
                        print(place.country!)
                        print(place.thoroughfare!)
                        print(place.subThoroughfare!)
                        print(place.locality!)
                        print(place.administrativeArea!)
                        
                        //self.locationLabel1 = "\(place.subThoroughfare!) \n \(place.thoroughfare!) \n \(place.country!)"
                        self.locationLabel.text = "\(place.subThoroughfare!) ,\(place.thoroughfare!),\(place.locality!), \(place.administrativeArea!),\(place.country!)"


                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func feedingStepper(_ sender: UIStepper) {
        labelFeeding.text = String(Int(sender.value))
        
    }
    @IBAction func eatingStepper(_ sender: UIStepper) {
        labelEating.text = String(Int(sender.value))
    }
    @IBAction func flyingStepper(_ sender: UIStepper) {
        labelFlying.text = String(Int(sender.value))
    }

    @IBAction func drinkingStepper(_ sender: UIStepper) {
        labelDrinking.text = String(Int(sender.value))
    }
    
 
    
    func createDatePicker() {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bur button item
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateLabel.inputAccessoryView = toolbar
        
        dateLabel.inputView = datePicker
    }
    
    func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.dateStyle = .short
        //dateFormatter.timeStyle = .medium
        dateLabel.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    //move view when editing
    func moveTextView(textView:UITextView, moveDistance:Int, up:Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    func textFieldDidBeginEditing(_ textView: UITextView) {
        
        if textView.tag == labelFlying.tag || textView.tag == labelDrinking.tag{
            moveTextView(textView: textView, moveDistance: -270, up: true)
        }
        
        labelFeeding.selectedTextRange = labelFeeding.textRange(from: labelFeeding.beginningOfDocument, to: labelFeeding.endOfDocument)
        labelDrinking.selectedTextRange = labelDrinking.textRange(from: labelDrinking.beginningOfDocument, to: labelDrinking.endOfDocument)
        labelFlying.selectedTextRange = labelFlying.textRange(from: labelFlying.beginningOfDocument, to: labelFlying.endOfDocument)
        labelEating.selectedTextRange = labelEating.textRange(from: labelEating.beginningOfDocument, to: labelEating.endOfDocument)
        
        
    }
    
    func textFieldDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == labelFlying.tag || textView.tag == labelDrinking.tag{
            moveTextView(textView: textView, moveDistance: -270, up: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        labelEating.resignFirstResponder()
        labelFlying.resignFirstResponder()
        labelDrinking.resignFirstResponder()
        labelFeeding.resignFirstResponder()
        
        dateLabel.resignFirstResponder()
        userNameLabel.resignFirstResponder()
        return true
    }
    
    //insert data into database
    
    @IBAction func insertTheUserData(_ sender: Any) {
        //save data alert
        let dataSaveAlert = UIAlertController(title: "Save data", message: "Save the recording?", preferredStyle: .alert)
        
        dataSaveAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in print("save was tapped")
            self.saveToDatabase()}))
        dataSaveAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("cancel the action")}))
        
        self.present(dataSaveAlert, animated: true, completion: nil)
     
    }
    
    func saveToDatabase() {
        let query:String = "insert into userdata (\(field_UserID), UserName, date, location, feedingNumber, eatingNumber, flyingNumber, drinkingNumber) values (null,'\(userNameLabel.text!)','\(dateLabel.text!)','\(locationLabel.text!)',  '\(labelFeeding.text!)', '\(labelEating.text!)', '\(labelFlying.text!)', '\(labelDrinking.text!)');"
        let isSuccess = DBManager.shared.insertData(insertQuery: query)
        
        let alertIsSuccess = UIAlertController(title: "Success", message: "Save successed", preferredStyle: .alert)
        let alertIsUnSuccess = UIAlertController(title: "UnSuccess", message: "Save unsuccessed", preferredStyle: .alert)
        if isSuccess{
            alertIsSuccess.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in print("successed")}))
            self.present(alertIsSuccess, animated: true, completion: nil)
            
        }else{
            alertIsUnSuccess.addAction(UIAlertAction(title: "Save unsuccessed", style: .default, handler: {action in print("unsuccessed")}))
            self.present(alertIsUnSuccess, animated: true, completion: nil)
        }
        //
        
    }
    

    
}

