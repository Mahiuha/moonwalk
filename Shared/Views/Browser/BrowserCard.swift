//
//  BrowserCard.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/16/21.
//

import SwiftUI

struct BrowserCard: View {
    
    var term: String
    var definition: String
    @State var flipped: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(term)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.blue)
                            .frame(width: geometry.size.width, height: 300, alignment: .center)
                    )
            }
        }
    }
}

struct BrowserCard_Previews: PreviewProvider {
    static var previews: some View {
        BrowserCard(term: "Foo", definition: "Bar")
    }
}
