//
//  DBhelper.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 27/02/24.
//

import Foundation
import SQLite3
import UIKit

struct Person {
    var id: Int
    var name: String
    var number: String
    var imageData: String
    var favourite: Int
}

class DBhelper {
    var db:OpaquePointer?
    var dbPath: String = "myDB.sqlite"
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        
        if sqlite3_open(filePath?.path, &db) != SQLITE_OK {
            print("Database not connected")
            return nil
        } else {
            print("Database connected")
            return db
        }
    }
    
    func createTable() {
        let createTableQuery = "create table if not exists tblcontacts(id integer primary key autoincrement, name text, number text, profile text, favourite integer)"
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("table created")
            } else {
                print("table not created")
            }
        } else {
            print("create table statement not prepared")
        }
    }
    
    func insertContact(person: Person) {
        let insertQuery = "insert into tblcontacts(name, number, profile, favourite) values(?,?,?,?)"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            
            sqlite3_bind_text(insertStatement, 1, (person.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (person.number as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (person.imageData as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(person.favourite))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("inserted")
            } else {
                print("not inserted")
            }
        } else {
            print("insert Statement not prepared")
        }
    }
    
    func updateContact(person: Person) {
        let updateQuery = "update tblcontacts set name=?, number=?, profile=? where id=?"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK{
            
            sqlite3_bind_text(updateStatement, 1, (person.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (person.number as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (person.imageData as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 4, Int32(person.id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("updated")
            } else {
                print("not updated")
            }
        } else {
            print("update Statement not prepared")
        }
    }
    
    func updateFavourie(id: Int, favourite: Int) {
        let updateQuery = "update tblcontacts set favourite=? where id=?"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK{
            
            sqlite3_bind_int(updateStatement, 1, Int32(favourite))
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("added to favourite")
            } else {
                print("not added to favourite")
            }
        } else {
            print("update Statement not prepared")
        }
    }
    
    func getContacts() -> [Person] {
        let selectQuery = "select * from tblcontacts"
        var selectStatement: OpaquePointer?
        
        var persons: [Person] = []
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(selectStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(selectStatement, 1)))
                let number = String(describing: String(cString: sqlite3_column_text(selectStatement, 2)))
                let imageURL = String(describing: String(cString: sqlite3_column_text(selectStatement, 3)))
                let favourite = Int(sqlite3_column_int(selectStatement, 4))
                persons.append(Person(id: Int(id), name: name, number: number, imageData: imageURL, favourite: favourite))
            }
        } else {
            print("select statement not prepared")
        }
        
        return persons
    }
    
    func getFavouriteContacts() -> [Person] {
        let selectQuery = "select * from tblcontacts where favourite=1"
        var selectStatement: OpaquePointer?
        
        var persons: [Person] = []
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(selectStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(selectStatement, 1)))
                let number = String(describing: String(cString: sqlite3_column_text(selectStatement, 2)))
                let imageURL = String(describing: String(cString: sqlite3_column_text(selectStatement, 3)))
                let favourite = Int(sqlite3_column_int(selectStatement, 4))
                persons.append(Person(id: Int(id), name: name, number: number, imageData: imageURL, favourite: favourite))
            }
        } else {
            print("select statement not prepared")
        }
        
        return persons
    }
    
    func deleteContact(id: Int) {
        let deleteQuery = "delete from tblcontacts where id=?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("record deleted")
            } else {
                print("not deleted")
            }
        } else {
            print("delete statement not prepared")
        }
    }
}
