//
//  TaskRowView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 14.04.23.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var task: ListItem
    @ObservedObject var checklist: Checklist
    
    
     var body: some View {
         HStack {
             // add the Weekday the task is due and style it
             Text(String(describing: task.day.weekDays))
                 .font(.title2)
                 .frame(width: 60)
                 .foregroundColor(.white)
                 .background(Capsule().fill(.gray))
             
             TextEditor(text: $task.name)
             if task.checkedStatus {
             Image(systemName: "checkmark")
                 .foregroundColor(.green)
             }
             
         }.onTapGesture {
             task.checkedStatus.toggle()
             checklist.upDatecanReset()
     }
  }
}
