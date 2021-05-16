//
//  MockData.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/15/21.
//

struct MockData {
    
    var cardSet: CardSetModel {
        let model: CardSetModel = CardSetModel()
        model.id = 1
        model.title = "My Card Set"
        model.description = "Description of card set."
        return model
    }
    
    var card: CardModel {
        let model: CardModel = CardModel()
        model.id = 1
        model.term = "Term Name"
        model.definition = "Definition of term."
        return model
    }
}
