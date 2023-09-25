//
//  TaskView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 06.04.23.
//

import SwiftUI


struct ChecklistRowView: View {
    @ObservedObject var checklist: Checklist
    var body: some View {
        HStack{
            Image(systemName: "list.bullet")
                .foregroundColor(.gray)
            
        Text(checklist.name)
                

        }
    }
}
