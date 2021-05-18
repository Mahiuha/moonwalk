//
//  Browser.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/16/21.
//

import SwiftUI

struct Browser: View {
    
    var cardSet: CardSetModel
    var cards: [CardModel]
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        if (cards.count == 0) {
            Text("No cards to browse.")
        } else {
            
            BrowserCard(
                term: cards[currentIndex].term,
                definition: cards[currentIndex].definition
            )
            
        }
    }
}

struct Browser_Previews: PreviewProvider {
    static var previews: some View {
        Browser(cardSet: MockData().cardSet, cards: [MockData().card])
    }
}
