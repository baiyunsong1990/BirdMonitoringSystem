//
//  HistoryReocrdCollectionView.swift
//  BirdMonitorSystem
//
//  Created by 白云松 on 19/9/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit

let reuseIdentifierH = "HistoryCell"


class HistoryReocrdCollectionView: UICollectionViewController {
    var historys: [HistoryRecordInfo]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historys = DBManager.shared.loadMovies(IDqueryOrDatequery: "DATE", certainMonth: " ")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of items
        return self.historys.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierH, for: indexPath) as! HistoryRecordCollectionViewCell
        
        
        
//        let dateString:[String] = historys[indexPath.row].date.components(separatedBy: ",")
//        let date:String = dateString[0] + "," + dateString[1]
//        let time:String = dateString[2]
        
        cell.historyLabel.text = "name:\(historys[indexPath.row].username) ,date:\(historys[indexPath.row].date),time:\(time),location:\(historys[indexPath.row].locationInfo) , feedingNumbers:\(historys[indexPath.row].feedNum) ,eatingNumbers:\(historys[indexPath.row].eatNum) ,flyingNumbers:\(historys[indexPath.row].flyNum) ,drinkingNumbers:\(historys[indexPath.row].drinkNum)"
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
 
    

}
