//
//  FirstViewController.swift
//  BirdMonitorSystem
//
//  Created by 白云松 on 28/8/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MapKit
class FirstViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    //@IBOutlet weak var playBtn: UIButton!
    
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var fileName = "audioFile.m4a"
    var soundFileURL:URL!
    var meterTimer:Timer!
    
    //location service
    let locationManger = CLLocationManager()
    
    
//    
//    init(locationInfo:String){
//        self.locationInfo = locationInfo
//        
//        print(locationInfo)
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        statusLabel.isHidden = true
        stopBtn.isEnabled = false
        //location service
        
        self.locationManger.requestAlwaysAuthorization()
        
        self.locationManger.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.startUpdatingLocation()
            
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
                        //print(place.country!)
                        //print(place.thoroughfare!)
                        //print(place.subThoroughfare!)
                        
                        
                        self.locationLabel.text = "\(place.subThoroughfare!) \n \(place.thoroughfare!) \n \(place.country!)"
                        
                       
                    }
                }
            }
        }
        
        
        //print("locations = \(myLocation.latitude) \(myLocation.longitude)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        recorder = nil
        player = nil
        // Dispose of any resources that can be recreated.
    }
    
    //clock updating
    func updateDate() {
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium,timeStyle: DateFormatter.Style.none)
    }
    func updateTime() {
          timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.none,timeStyle: DateFormatter.Style.medium)
    }
    
    @IBAction func removeAll(_ sender: Any) {
        deleteAllRecordings()
    }
    //stop button方法
    @IBAction func stop(_ sender: Any) {
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        recordBtn.setTitle("Record", for: .normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            //playBtn.isEnabled = true
            stopBtn.isEnabled = false
            recordBtn.isEnabled = true
        } catch  {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    //recording functions
    
    func recordWithPermission(_ setup:Bool) {
        print("\(#function)")
        
       // AVAudioSession.sharedInstance().requestRecordPermission() {
         //   [unowned self] granted in
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioMeter(_:)), userInfo: nil, repeats: true)
                    
                }
            }else {
                print("Permission to record not granted")
            }
        })
    }
    
    func updateAudioMeter(_ timer:Timer) {
        if let recorder = self.recorder{
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min,sec)
                statusLabel.text = s
                recorder.updateMeters()
            }
        }
    }
    //创建session for recording
    
    func setSessionPlayback() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)// the different session category will implement the different function
            
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    //创建session for play and record
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            // the different session category will implement the different function

        } catch{
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch{
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    //创建一个新的录音文件
    func setupRecorder() {
        print("\(#function)")
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url:soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true // 不是调音量的，而是显示录音时间哒：）
            recorder.prepareToRecord()
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    @IBAction func Record(_ sender: Any) {
        print("\(#function)")
        statusLabel.isHidden = false
        stopBtn.isEnabled = true
        //如果player不为空同时player在播放，就让player停止 因为要recording了
        if player != nil && player.isPlaying {
            print("STOPING")
            player.stop()
        }
        
        //是否需要新建一个 record,全新的文件
        if recorder == nil {
            print("recording. recorder nil")
            recordBtn.setTitle("Pause", for: .normal)
            
            recordBtn.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            //playBtn.isEnabled = false
            stopBtn.isEnabled = true
            recordWithPermission(true) //需要setup一个新的recording文件
            return
        }
        //正在录音的时候，当前button的title 为 pause,点击之后变为continue， 表示暂停了，continue摁钮准备
        if recorder != nil && recorder.isRecording {
            print("Pausing")
            recorder.pause()
            recordBtn.setTitle("Continue", for: .normal)
            
            recordBtn.setImage(#imageLiteral(resourceName: "record-1"), for: .normal)
        }else {
            print("recording")
            recordBtn.setTitle("Pause", for: .normal)
            
            recordBtn.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            //playBtn.isEnabled = false
            stopBtn.isEnabled = true
            recordWithPermission(false)
        }
    }
    
    func deleteAllRecordings(){
        print("\(#function)")
        
        let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileManager = FileManager.default
        
        do {
            //找出根目录下所有文件
            let files = try fileManager.contentsOfDirectory(atPath: docsDir)
            //取出所有后缀为m4a 的文件
            var recordings = files.filter({(name: String) -> Bool in
            
            return name.hasSuffix("m4a")
            })
            
            for i in 0 ..< recordings.count{
                let path = docsDir + "/" + recordings[i]
                
                print("removing \(path)")
                do {
                    try fileManager.removeItem(atPath: path)
                } catch  {
                    NSLog("Cannot remove")
                    print(error.localizedDescription)
                }
            }
            
        } catch  {
            print("could not get contents of directory at \(docsDir)")
            print(error.localizedDescription)
        }
    }
    
    //notifications 
    
    func askForNotifications(){
        print("\(#function))")
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.background(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.foreground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.routeChange(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    
    func background(_ notification:Notification) {
        print("\(#function)")
        
    }
    
    func foreground(_ notification:Notification) {
        print("\(#function)")
        
    }
    
    
    func routeChange(_ notification:Notification) {
        print("\(#function)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            print("routeChange \(userInfo)")
            
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
        
        // this cast fails. that's why I do that goofy thing above.
        //        if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? AVAudioSessionRouteChangeReason {
        //        }
        
        /*
         AVAudioSessionRouteChangeReasonUnknown = 0,
         AVAudioSessionRouteChangeReasonNewDeviceAvailable = 1,
         AVAudioSessionRouteChangeReasonOldDeviceUnavailable = 2,
         AVAudioSessionRouteChangeReasonCategoryChange = 3,
         AVAudioSessionRouteChangeReasonOverride = 4,
         AVAudioSessionRouteChangeReasonWakeFromSleep = 6,
         AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory = 7,
         AVAudioSessionRouteChangeReasonRouteConfigurationChange NS_ENUM_AVAILABLE_IOS(7_0) = 8
         
         routeChange Optional([AVAudioSessionRouteChangeReasonKey: 1, AVAudioSessionRouteChangePreviousRouteKey: <AVAudioSessionRouteDescription: 0x17557350,
         inputs = (
         "<AVAudioSessionPortDescription: 0x17557760, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Bottom>"
         );
         outputs = (
         "<AVAudioSessionPortDescription: 0x17557f20, type = Speaker; name = Speaker; UID = Built-In Speaker; selectedDataSource = (null)>"
         )>])
         routeChange Optional([AVAudioSessionRouteChangeReasonKey: 2, AVAudioSessionRouteChangePreviousRouteKey: <AVAudioSessionRouteDescription: 0x175562f0,
         inputs = (
         "<AVAudioSessionPortDescription: 0x1750c560, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Bottom>"
         );
         outputs = (
         "<AVAudioSessionPortDescription: 0x17557de0, type = Headphones; name = Headphones; UID = Wired Headphones; selectedDataSource = (null)>"
         )>])
         */
    }
    
    
    //check head phones
    
    func checkHeadphones() {
        print("\(#function)")
        
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
    
    
    //play function
    @IBAction func playSound(_ sender: Any) {
        
        play()
    }
    
    func play() {
        print("\(#function)")
        
        var url:URL?
        if self.recorder != nil{
            url = recorder.url
        }else{
            url = soundFileURL!
        }
        
        print("playing \(String(describing: url))")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
            stopBtn.isEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch  {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
}
// player delegate
extension FirstViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        
        print("finished playing \(flag)")
        recordBtn.isEnabled = true
        stopBtn.isEnabled = false
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}

// recorder delegate
extension FirstViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("\(#function)")
        print("finish recording\(flag)")
        
        stopBtn.isEnabled = false
        //playBtn.isEnabled = true
        recordBtn.setTitle("Record", for: UIControlState())
        recordBtn.setImage(#imageLiteral(resourceName: "record-1"), for: .normal)
        statusLabel.isHidden = true
        // ios8 and later
        
        //增加alert提示信息
        let alert = UIAlertController(title: "Recorder", message: "Finished Recording", preferredStyle: .alert)
        //增加alert的摁钮 和 function
        alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: {action in print("keep was tapped")
        self.recorder = nil}))
        
        alert.addAction(UIAlertAction(title: "Delete" ,style: .default, handler: {action in print("delete was tappped")
        self.recorder.deleteRecording()}))
        
        //添加alert在视图中
        self.present(alert, animated: true, completion: nil)
        
        
    }
}


