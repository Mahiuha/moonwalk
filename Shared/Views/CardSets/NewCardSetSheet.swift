//
//  NewCardSetSheet.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/15/21.
//

import SwiftUI

struct NewCardSetSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var newCardSetTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $newCardSetTitle)
                }
            }
            .navigationTitle("New Card Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        DB.createCardSet(named: newCardSetTitle)
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }
            }
        }
        
    }
}

struct NewCardSetSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewCardSetSheet()
    }
}
