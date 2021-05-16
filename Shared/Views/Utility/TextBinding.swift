//
//  TextBinding.swift
//  Moonwalk (iOS)
//
//  Created by Brian Yu on 5/15/21.
//

import SwiftUI

struct TextBinding: View {
    
    @Binding var content: String
    
    var body: some View {
        Text(content)
    }
}

struct TextBinding_Previews: PreviewProvider {
    static var previews: some View {
        TextBinding(content: .constant("foo"))
    }
}
