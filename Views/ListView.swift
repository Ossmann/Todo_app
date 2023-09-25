//
//  ListView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 05.04.23.
//

import SwiftUI

struct ListView: View {
    @State var list : String
    var item = ["Mon","Surfing", "checkmark.circle"]

    var body: some View {
        HStack{
            Text(item[0])
            Text(item[1])
            Spacer()
            Image(systemName: item[2])
                .foregroundColor(item[2] == "checkmark.circle" ? .green : item[2] == "xmark.circle" ? .red : .black)
        }
        .navigationTitle(list)
            
        }
        
    }
