//
//  EditView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 05.04.23.
//

import SwiftUI

struct EditView: View {
    @Binding var editItem: String
     @Environment(\.editMode) var editMode
     var body: some View {
         HStack{
             if(editMode?.wrappedValue == .active) {
             //Icon edit Title
             Image(systemName: "rectangle.and.pencil.and.ellipsis")
                 .renderingMode(.template)
                     .foregroundColor(.green)
                     .padding()
                     .shadow(color: Color.green.opacity(0.4), radius: 1, x: 4, y: 1)
                 TextField("Change the title:", text: $editItem).onDisappear{
                     saveData()
                 }
             }
        }
    }
}

