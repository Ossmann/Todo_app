//
//  AddTasksEditView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 05.04.23.
//

import SwiftUI
struct AddTasksEditView: View {
    @ObservedObject var checklist: Checklist
    
    @State var newTaskforList: String = ""
    @State var newDueDay: WeekDays = .Select
    @State var displayItem: String = ""
    @Environment(\.editMode) var editMode

    //add Tasks to the List
    var body: some View {
            if(editMode?.wrappedValue == .active) {
                VStack {
                    
                    Picker(selection: $newDueDay, label: Text("Due Date")) {
                        Text("Select a Day").tag(WeekDays.Mon)
                        Text("Mon").tag(WeekDays.Mon)
                        Text("Tue").tag(WeekDays.Tue)
                        Text("Wed").tag(WeekDays.Wed)
                        Text("Thu").tag(WeekDays.Thu)
                        Text("Fri").tag(WeekDays.Fri)
                    }
    
                                TextField("Write new task here", text: $newTaskforList)
                        .multilineTextAlignment(.center) // Center the text within the TextField
                    
                    
                    // Button to add item to the checklist
                    Button("Add Item") {
                        checklist.tasks.append(ListItem(day: Day(weekDays: newDueDay), name: newTaskforList, checkedStatus: false))
                        saveData()
                        newTaskforList = "" // Clear the Text inside the Button
                    }
                }
            
            }
            
    }
}
