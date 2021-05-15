//
//  CardSetList.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/14/21.
//

import SwiftUI

struct CardSetList: View {
    
    @State var shouldShowSettings: Bool = false
    @State var cardSets: [CardSetModel] = []
    
    var body: some View {
        
        NavigationView {
            
            HStack {
                
                NavigationLink(destination: SettingsView(), isActive: $shouldShowSettings) {
                    EmptyView()
                }
                
                List(self.cardSets) { cardSet in
                    Text(cardSet.title)
                }.onAppear(perform: {
                    self.cardSets = DB.getCardSets()
                })
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
                    }
                }
                .overlay(Group {
                    if self.cardSets.isEmpty {
                        Text("No card sets to study.")
                        Text("Click ")
                            + Text(Image(systemName: "plus")).foregroundColor(.blue)
                            + Text(" to create a new set.")
                    }
                })

            }

        }
        
    }
    
    func showSettings() {
        shouldShowSettings = true
    }
    
    func createNewCardSet() {
        
    }
}

struct CardSetList_Previews: PreviewProvider {
    static var previews: some View {
        CardSetList()
    }
}

