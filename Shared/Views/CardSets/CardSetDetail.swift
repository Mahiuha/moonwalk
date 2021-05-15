//
//  CardSetDetail.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/15/21.
//

import SwiftUI

struct CardSetDetail: View {
    
    var cardSet: CardSetModel
    
    var body: some View {
        Text(cardSet.title)
    }
}

struct CardSetDetail_Previews: PreviewProvider {
    
    static let model = MockData().cardSet
    
    static var previews: some View {
        CardSetDetail(cardSet: model)
    }
}
