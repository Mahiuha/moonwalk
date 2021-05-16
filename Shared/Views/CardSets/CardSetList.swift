//
//  CardSetList.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/14/21.
//

import SwiftUI

struct CardSetList: View {
    
    @State var showingSettings: Bool = false
    @State var showingNewCardSet : Bool = false
    
    @State var cardSets: [CardSetModel] = []
    
    var body: some View {
        
        NavigationView {
            
            VStack {

                NavigationLink(destination: SettingsView(), isActive: $showingSettings) {
                    EmptyView()
                }
                
                List() {
                    ForEach(cardSets) { cardSet in
                        NavigationLink(destination: CardSetDetail(cardSet: cardSet)) {
                            HStack {
                                Image(systemName: "rectangle.on.rectangle.angled")
                                    .foregroundColor(.blue)
                                Text(cardSet.title)
                            }
                        }
                    }
                    .onDelete(perform: deleteCardSet)
                    .onMove(perform: moveCardSet)
                }
                .onAppear(perform: updateCardSets)
                .navigationTitle("Card Sets")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: showSettings) {
                            Image(systemName: "gearshape")
                        }
                        Spacer()
                        Button(action: createNewCardSet) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showingNewCardSet, onDismiss: updateCardSets) {
                            NewCardSetSheet()
                        }
                    }
                }
                .toolbar {
                    EditButton()
                }
                .overlay(Group {
                    if self.cardSets.isEmpty {
                        Text("No card sets to study.")
                        Text("Tap ")
                            + Text(Image(systemName: "plus")).foregroundColor(.blue)
                            + Text(" to create a new set.")
                    }
                })

            }

        }
    }
    
    func showSettings() {
        showingSettings = true
    }
    
    func createNewCardSet() {
        showingNewCardSet.toggle()
    }
    
    func updateCardSets() {
        self.cardSets = DB.getCardSets()
    }
    
    func deleteCardSet(at offsets: IndexSet) {
        let cardSetIds = offsets.map { cardSets[$0].id }
        DB.deleteCardSet(id: cardSetIds[0])
        updateCardSets()
    }
    
    func moveCardSet(source: IndexSet, destination: Int) {
        cardSets.move(fromOffsets: source, toOffset: destination)
        DB.updateCardSetOrdering(models: cardSets)
        updateCardSets()
    }
}

struct CardSetList_Previews: PreviewProvider {
    static var previews: some View {
        CardSetList()
    }
}

