//
//  CheckListView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 05.04.23.
//

import SwiftUI

struct CheckListView: View {
    @ObservedObject var checklist: Checklist

    //functions to reset and undo
    func resetItms() {
        checklist.doReset()
    }
    func undoItms () {
        checklist.doUndo()
    }
    
    var body: some View {
        VStack{
            //edit title of List
            EditView(editItem: $checklist.name)
            List {
            //List the Tasks
                ForEach(checklist.tasks, id:\.id) {
                    tsk in
                    TaskRowView(task: tsk, checklist: checklist)
                    
                //delete in edit and on swipe
                }.onDelete { idx in
                    checklist.tasks.remove(atOffsets: idx)
                    saveData()
                }.onMove { idx, p in
                    checklist.tasks.move(fromOffsets: idx, toOffset: p)
                    saveData()
                }
                //Show reset and undo Button
                HStack{
                    if checklist.canReset {
                                    Button("Reset") {
                                        checklist.doReset()
                                    }
                    }
                    Spacer()
                    if checklist.canUndo {
                        Button("Undo") {
                            undoItms()
                        }
                    }
                }

            }.navigationTitle(checklist.name)
            
            //Show the View to add a new Task
            AddTasksEditView(checklist: checklist)
            
            
        }.navigationBarItems(trailing: EditButton())
    }
}

