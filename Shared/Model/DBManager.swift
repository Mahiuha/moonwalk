//
//  DBManager.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/14/21.
//

import Foundation

// Import SQLite pod
import SQLite

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}

struct DBManager {
    private var db: Connection!
    
    // Card set table
    private var cardSetsTable: Table!
    private var cardSet_id: Expression<Int>!
    private var cardSet_order: Expression<Int>!
    private var cardSet_title: Expression<String>!
    private var cardSet_description: Expression<String?>!
    
    // Cards table
    private var cardsTable: Table!
    private var card_id: Expression<Int>!
    private var card_cardSet_id: Expression<Int>!
    private var card_order: Expression<Int>!
    private var card_term: Expression<String>!
    private var card_definition: Expression<String>!
    private var card_starred: Expression<Bool>!
    
    private let defaults_db_created_key: String = "is_db_created"
    
    init() {
        createTables()
    }
    
    mutating func createTables() {
        do {
            
            
            let documentsDirectory = getDocumentsDirectory()
            db = try Connection("\(documentsDirectory)/moonwalk.sqlite3")
            
            // Create card sets table
            cardSetsTable = Table("cardSets")
            cardSet_id = Expression<Int>("id")
            cardSet_order = Expression<Int>("order")
            cardSet_title = Expression<String>("title")
            cardSet_description = Expression<String?>("description")
            
            cardsTable = Table("cards")
            card_id = Expression<Int>("id")
            card_cardSet_id = Expression<Int>("cardSet_id")
            card_order = Expression<Int>("order")
            card_term = Expression<String>("term")
            card_definition = Expression<String>("definition")
            card_starred = Expression<Bool>("starred")
            
            // Database migrations
            if db.userVersion == 0 {
                try db.run(cardSetsTable.create { t in
                    t.column(cardSet_id, primaryKey: true)
                    t.column(cardSet_order)
                    t.column(cardSet_title)
                    t.column(cardSet_description)
                })
                
                try db.run(cardsTable.create { t in
                    t.column(card_id, primaryKey: true)
                    t.column(card_cardSet_id)
                    t.column(card_order)
                    t.column(card_term, defaultValue: "")
                    t.column(card_definition, defaultValue: "")
                    t.column(card_starred, defaultValue: false)
                })

                db.userVersion = 1
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
        let tables: [Table] = [cardSetsTable, cardsTable]
        for table in tables {
            do {
                try db.run(table.drop(ifExists: true))
            } catch let error {
                print(error)
            }
        }
        db.userVersion = 0
    }
    
    // Model Functions: Card Sets

    func cardSetModel(_ row: Row) -> CardSetModel {
        let model = CardSetModel()
        model.id = row[cardSet_id]
        model.order = row[cardSet_order]
        model.title = row[cardSet_title]
        model.description = row[cardSet_description] ?? ""
        return model
    }
    
    func getCardSets() -> [CardSetModel] {
        var models: [CardSetModel] = []
        do {
            for cardSet in try db.prepare(cardSetsTable.order(cardSet_order.asc)) {
                models.append(cardSetModel(cardSet))
            }
        } catch {
            print(error.localizedDescription)
        }
        return models
    }
    
    func getCardSetById(id: Int) -> CardSetModel? {
        do {
            for cardSet in try db.prepare(cardSetsTable.filter(cardSet_id == id)) {
                return cardSetModel(cardSet)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func createCardSet(named title: String) -> Int? {
        do {
            let max = (try db.scalar(cardSetsTable.select(cardSet_order.max))) ?? 0
            try db.run(cardSetsTable.insert(
                cardSet_title <- title,
                cardSet_order <- max + 1
            ))
            return Int(db.lastInsertRowid)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func updateCardSetTitle(id: Int, title: String) {
        let cardSet = cardSetsTable.filter(cardSet_id == id)
        do {
            try db.run(cardSet.update(cardSet_title <- title))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func updateCardSetOrdering(models: [CardSetModel]) {
        do {
            for (index, model) in models.enumerated() {
                try db.run(
                    cardSetsTable.filter(cardSet_id == model.id)
                            .update(cardSet_order <- index + 1)
                )
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteCardSet(id: Int) {
        do {
            
            // Delete current card set
            let objects = cardSetsTable.filter(cardSet_id == id)

            let object = try db.pluck(objects)!
            let order = object[cardSet_order]
            
            // Delete existing object
            try db.run(objects.delete())
            
            // Update existing orders
            try db.run(
                cardSetsTable.filter(cardSet_order > order)
                        .update(cardSet_order--)
            )
            
            // Delete cards for this card set
            try db.run(
                cardsTable.filter(card_cardSet_id == id)
                    .delete()
            )
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Model Functions: Cards

    func cardModel(_ row: Row) -> CardModel {
        let model = CardModel()
        model.id = row[card_id]
        model.cardSet_id = row[card_cardSet_id]
        model.order = row[card_order]
        model.term = row[card_term]
        model.definition = row[card_definition]
        model.starred = row[card_starred]
        return model
    }
    
    func getCardsForSetId(setId: Int) -> [CardModel] {
        var models: [CardModel] = []
        do {
            for cardSet in try db.prepare(
                cardsTable
                    .filter(card_cardSet_id == setId)
                    .order(card_order.asc)
            ) {
                models.append(cardModel(cardSet))
            }
        } catch {
            print(error)
        }
        return models
    }
    
    func getCardById(id: Int) -> CardModel? {
        do {
            for card in try db.prepare(
                cardsTable.filter(card_id == id)
            ) {
                return cardModel(card)
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func createCard(setId: Int, term: String, definition: String, starred: Bool) -> Int? {
        do {
            let max = (try db.scalar(
                cardsTable
                    .filter(card_cardSet_id == setId)
                    .select(card_order.max)
            )) ?? 0
            try db.run(cardsTable.insert(
                card_cardSet_id <- setId,
                card_order <- max + 1,
                card_term <- term,
                card_definition <- definition,
                card_starred <- starred
            ))
            return Int(db.lastInsertRowid)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func updateCardContent(model: CardModel) {
        let card = cardsTable.filter(card_id == model.id)
        do {
            try db.run(
                card.update(
                    card_term <- model.term,
                    card_definition <- model.definition,
                    card_starred <- model.starred
                )
            )
        } catch let error {
            print(error)
        }
    }
    
    func deleteCard(id: Int) {
        do {
            
            // Delete current card set
            let objects = cardsTable.filter(card_id == id)

            let object = try db.pluck(objects)!
            let order = object[card_order]
            
            // Delete existing card
            try db.run(objects.delete())
            
            // Update other cards
            try db.run(
                cardsTable.filter(card_order > order)
                        .update(card_order--)
            )
        } catch let error {
            print(error)
        }
    }
    
    func updateCardOrdering(models: [CardModel]) {
        do {
            for (index, model) in models.enumerated() {
                try db.run(
                    cardsTable.filter(card_id == model.id)
                              .update(card_order <- index + 1)
                )
            }
        } catch let error {
            print(error)
        }
    }
}
var DB = DBManager()
