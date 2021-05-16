//
//  CardEditor.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/16/21.
//

import SwiftUI

struct CardEditor: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var card: CardModel
    
    var updateCard: (CardModel) -> Void
    
    var body: some View {
        Form {
            TextField("Term", text: $card.term)
            TextField("Definition", text: $card.definition)
        }
        .navigationBarItems(trailing:
            Button("Save") {
                updateCard(card)
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

struct CardEditor_Previews: PreviewProvider {
    
    static let model = MockData().card
    
    static var previews: some View {
        CardEditor(card: model, updateCard: { _ in })
    }
}
