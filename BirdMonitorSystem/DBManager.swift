//
//  DBManager.swift
//  SqliteTest
//
//  Created by 白云松 on 4/5/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit
//表的属性
let field_UserID = "UserID"
let field_UserName = "UserName"
let field_UserEmail = "UserEmail"





let createTableQuery = ""

//let field_MovieWatched = "watched"
//let field_MovieLikes = "likes"
class DBManager: NSObject {

    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "birdMonitoringSystemDB.sqlite"
    var pathToDatabase: String!
    var database:FMDatabase!
    
    override init(){
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        print(pathToDatabase)

    }
    
    func deleteDataFromTable(table:String) -> Bool {
        var isSuccess: Bool = false
        if openDatabase(){
            let sql = "DELETE FROM \(table)"
            do {
                try database.executeUpdate(sql, values: nil)
                
                isSuccess = true
            }
            catch {
                print("Could not delete data.")
                print(error.localizedDescription)
            }
        }
        database.close()
        return isSuccess
    }
    
    
 
    
    //建立数据库方法
    func createTableDatabase() -> Bool{
    //func createTableDatabase() -> Bool{
        var created = false
        var createTableQuery : Array<String> = []
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    //let startForeignKey = "PRAGMA foreign_keys = ON;"
                   
                    let createUserTable1:String = "create table if not exists userdata (\(field_UserID) integer primary key autoincrement not null, \(field_UserName) text not null, date text not null, location text not null,feedingNumber text not null, eatingNumber text not null, flyingNumber text not null, drinkingNumber text not null)"
                    
                    //let createQuestionTable1:String = "create table if not exists section1 (\(field_UserID) integer not null, S1Q1 text, S1Q2 text, S1Q3 text, S1Q4 text, FOREIGN KEY (\(field_UserID)) REFERENCES (\(field_UserID)))"
                    
                    createTableQuery.append(createUserTable1)
                    
                    
                    do {
                        for query in createTableQuery {
                            
                            try database.executeUpdate(query, values: nil)
                            
                            created = true
                        }
                      
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    // 最后关闭数据库
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
    
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    // 插入数据方法
    
    func insertData(insertQuery:String) -> Bool {
        
        var isSuccess:Bool = true
        if openDatabase(){
            /*
            var query = ""
            var dataArray : Array<String>
            dataArray = ["baiyunsong"]
            //添加数组
            dataArray.append("Thriller")
            dataArray.append("190")
            dataArray.append("tianjinshi")
            dataArray.append("tianjinshi")
            
            //删除数组
            //dataArray.remove(at: 1)
            //修改数组
            //dataArray[1] = "yun!"
            //print array
            */
            /*for quest in questions{
                
                print(item)
            }*/
            //query = "insert into users (\(field_UserID), \(field_UserName), \(field_UserEmail), \(field_S1Q1), \(field_S1Q2), \(field_S1Q3), \(field_S1Q4)) values (null, '\(userName)', '\(userEmail)',\(question1), '\(question2)', '\(question3)','\(question4)');"
            if !database.executeStatements(insertQuery){
                print("Failed to insert initial data into the database")
                print(database.lastError(),database.lastErrorMessage())
                isSuccess = false
            }
        }
        
        database.close()
        return isSuccess
        
    }
 
    
    //查询数据方法
    func loadMovies(IDqueryOrDatequery:String, certainMonth:String) -> [HistoryRecordInfo]! {
        var movies: [HistoryRecordInfo]!
        
        /*按照电影名称和指定电影类型进行查询
        let query = "select * from movies where \(field_MovieCategory)=? order by \(field_MovieYear) desc"
        //问号为占位符，为下面制定类型做准备
        let results = try database.executeQuery(query, values: ["Crime"])  //value 可以制定 ？ 为 Crime
        
        */
        
        /* 按照某种电影类型 和 年份大于特定数值 降序 进行查询
         
         let query = "select * from movies where \(field_MovieCategory)=? and \(field_MovieYear)>? order by \(field_MovieID) desc"
         let results = try database.executeQuery(query, values: ["Crime", 1990]) //两个参数 类型及年份
         */
       if openDatabase(){
        
        var query:String = ""
        switch IDqueryOrDatequery {
        case "ID":
            query = "select * from userdata order by UserID asc"
        default:
            
            if certainMonth == " "{
                query = "select * from userdata order by date(date) asc"
            }else{ query = "select * from userdata WHERE date LIKE '\(certainMonth)%' order by date(date) asc"
}
        }
         //  按照电影年份升序排列
        
        
        do{
            
            let results = try database.executeQuery(query, values: nil)
            while results.next() {
//                let movie = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
//                                      title: results.string(forColumn: field_MovieTitle),
//                                      category: results.string(forColumn: field_MovieCategory),
//                                      year: Int(results.int(forColumn: field_MovieYear)),
//                                      movieURL: results.string(forColumn: field_MovieURL),
//                                      coverURL: results.string(forColumn: field_MovieCoverURL),
//                                      watched: results.bool(forColumn: field_MovieWatched),
//                                      likes: Int(results.int(forColumn: field_MovieLikes))
                
                    
                let movie = HistoryRecordInfo(recordID: Int(results.int(forColumn: "UserID")), name: results.string(forColumn: "UserName")!, locationInfo: results.string(forColumn: "Location")!, date: results.string(forColumn: "date")!, feedNum: results.string(forColumn: "feedingNumber")!, flyNum: results.string(forColumn: "flyingNumber")!, eatNum: results.string(forColumn: "eatingNumber")!, drinkNum: results.string(forColumn: "drinkingNumber")!)
                
                if movies == nil {
                    movies = [HistoryRecordInfo]()
                }
                
                movies.append(movie)
            }
        }
        catch{
            print(error.localizedDescription)
        }
          database.close()
        }
        return movies
    }
 
}
