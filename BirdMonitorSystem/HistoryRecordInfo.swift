//
//  HistoryRecordInfo.swift
//  BirdMonitorSystem
//
//  Created by 白云松 on 19/9/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit

class HistoryRecordInfo {
    
    var recordID: Int
    var username: String
    var locationInfo: String
    var date: String
    var feedNum: String
    var flyNum: String
    var eatNum: String
    var drinkNum: String
    
    init(recordID: Int, name: String, locationInfo: String, date: String, feedNum: String, flyNum: String, eatNum: String, drinkNum: String ) {
        self.recordID = recordID
        self.username = name
        self.locationInfo = locationInfo
        self.date = date
        self.feedNum = feedNum
        self.flyNum = flyNum
        self.eatNum = eatNum
        self.drinkNum = drinkNum
        
    }
}
