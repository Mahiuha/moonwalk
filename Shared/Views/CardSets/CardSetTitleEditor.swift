//
//  CardSetTitleEditor.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/15/21.
//

import SwiftUI

struct CardSetTitleEditor: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var cardSet: CardSetModel
    
    var onUpdateTitle: (String) -> Void
    
    var body: some View {
        Form {
            TextField("Card Set Title", text: $cardSet.title)
        }
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Button("Save") {
                onUpdateTitle(cardSet.title)
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

struct CardSetTitleEditor_Previews: PreviewProvider {
    
    static let model = MockData().cardSet
    
    static var previews: some View {
        CardSetTitleEditor(cardSet: .constant(model), onUpdateTitle: { _ in })
    }
}
