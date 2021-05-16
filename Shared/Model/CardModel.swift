//
//  CardModel.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/16/21.
//

import Foundation

class CardModel: Identifiable {
    public var id: Int = 0
    public var cardSet_id: Int = 0
    public var order: Int = 0
    public var term: String = ""
    public var definition: String = ""
    public var starred: Bool = false
}
