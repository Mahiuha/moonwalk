//
//  SettingsView.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/14/21.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showConfirmDeleteData = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List {

            Button("Delete All Card Set Data") {
                showConfirmDeleteData = true
            }
            .foregroundColor(Color.red)
            .alert(isPresented: $showConfirmDeleteData) {
                Alert(
                    title: Text("Are you sure you want to delete all card set data?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Confirm Delete")) {
                        DB.dropAllTables()
                        DB.createTables()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
