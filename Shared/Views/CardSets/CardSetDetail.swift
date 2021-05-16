//
//  CardSetDetail.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/15/21.
//

import SwiftUI

struct CardSetDetail: View {
    
    @State var chosenCardEditor: Int? = nil
    @State var cardSet: CardSetModel
    @State var cards: [CardModel] = []
    
    var body: some View {
        Form {
            
            Section(header: Text("CARD SET")) {
                
                ZStack {
                    // https://stackoverflow.com/a/65932011
                    Button("") {}
                    
                    NavigationLink(destination: CardSetTitleEditor(cardSet: $cardSet, onUpdateTitle: updateCardSetTitle)) {
                        HStack {
                            Text("About")
                            Spacer()
                            Text(cardSet.title)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                Text("Browse")
                Text("Review")
                Text("Play")
            }
            
            Section(header: Text("CARDS")) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.green)
                    Button("New Card") {
                        let id = DB.createCard(
                            setId: cardSet.id,
                            term: "",
                            definition: "",
                            starred: false
                        )
                        updateCards()
                        if (id != nil) {
                            openCardEditor(cardId: id!)
                        }
                    }
                }
                
                List() {
                    ForEach(cards) { card in
                        ZStack {
                            Button("") {}
                            NavigationLink(destination: CardEditor(card: card, updateCard: updateCard), tag: card.id, selection: $chosenCardEditor) {
                                HStack {
                                    Text(card.term)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteCard)
                    .onMove(perform: moveCard)

                }
            }
        }
        .onAppear(perform: updateCards)
        .navigationTitle(cardSet.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
    
    func updateCardSetTitle(newTitle: String) {
        DB.updateCardSetTitle(id: cardSet.id, title: newTitle)
        cardSet = DB.getCardSetById(id: cardSet.id)!
    }
    
    func updateCards() {
        self.cards = DB.getCardsForSetId(setId: cardSet.id)
        print(self.cards.map({$0.id}))
    }
    
    func updateCard(model: CardModel) {
        DB.updateCardContent(model: model)
        updateCards()
    }
    
    func openCardEditor(cardId: Int) {
        chosenCardEditor = cardId
    }
    
    func deleteCard(at offsets: IndexSet) {
        let cardIds = offsets.map { cards[$0].id }
        DB.deleteCard(id: cardIds[0])
        updateCards()
    }
    
    func moveCard(source: IndexSet, destination: Int) {
        cards.move(fromOffsets: source, toOffset: destination)
        DB.updateCardOrdering(models: cards)
        updateCards()
    }
}

struct CardSetDetail_Previews: PreviewProvider {
    
    static let model = MockData().cardSet
    
    static var previews: some View {
        CardSetDetail(cardSet: model, cards: [])
    }
}
