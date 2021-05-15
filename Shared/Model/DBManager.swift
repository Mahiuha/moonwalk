//
//  DBManager.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/14/21.
//

import Foundation

// Import SQLite pod
import SQLite

struct DBManager {
    private var db: Connection!
    
    // Card set table
    private var cardSets: Table!
    private var cardSet_id: Expression<Int64>!
    private var cardSet_title: Expression<String>!
    private var cardSet_description: Expression<String?>!
    
    private let defaults_db_created_key: String = "is_db_created"
    
    init() {
        createTables()
    }
    
    mutating func createTables() {
        do {
            let documentsDirectory = getDocumentsDirectory()
            db = try Connection("\(documentsDirectory)/moonwalk.sqlite3")
            
            // Create card sets table
            cardSets = Table("cardSets")
            cardSet_id = Expression<Int64>("id")
            cardSet_title = Expression<String>("title")
            cardSet_description = Expression<String?>("description")
            
            if (!UserDefaults.standard.bool(forKey: defaults_db_created_key)) {
                try db.run(cardSets.create { t in
                    t.column(cardSet_id, primaryKey: true)
                    t.column(cardSet_title)
                    t.column(cardSet_description)
                })
                print("Creating...")
                
                UserDefaults.standard.set(true, forKey: defaults_db_created_key)
            } else {
                print("Already created...")
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // https://www.hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func dropAllTables() {
        let tables: [Table] = [cardSets]
        for table in tables {
            do {
                try db.run(table.drop())
            } catch let error {
                print(error)
            }
        }
        UserDefaults.standard.set(false, forKey: defaults_db_created_key)
    }
    
    func getCardSets() -> [CardSetModel] {
        var models: [CardSetModel] = []
        do {
            for cardSet in try db.prepare(cardSets.order(cardSet_id.asc)) {
                let model: CardSetModel = CardSetModel()
                model.id = Int(cardSet[cardSet_id])
                model.title = cardSet[cardSet_title]
                model.description = cardSet[cardSet_description] ?? ""
                models.append(model)
            }
        } catch {
            print(error.localizedDescription)
        }
        return models
    }
    
    func createCardSet(named title: String) {
        do {
            try db.run(cardSets.insert(cardSet_title <- title))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteCardSets(cardSetIds: [Int]) {
        do {
            let objects = cardSets.filter(cardSetIds.map{ Int64($0) }.contains(cardSet_id))
            try db.run(objects.delete())
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

var DB = DBManager()
