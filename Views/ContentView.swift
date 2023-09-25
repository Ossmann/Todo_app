//
//  MasterView.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 05.04.23.
//

import SwiftUI

// main View
struct ContentView: View {
    @ObservedObject var data: DataModel
    var body: some View {
        NavigationView {
            //loading Screen
            if(data.loadingCompleted) {
                VStack{
                    // Edit the title
                    EditView(editItem: $data.title)
                    // List the Checklists from the data
                    List {
                        ForEach(data.checklists, id:\.id) {
                            ckl in
                            //Links to each Lists View
                            NavigationLink(destination: CheckListView(checklist: ckl)) {
                                ChecklistRowView(checklist: ckl)
                            }
                        //Delete Lists in edit Mode and on Swipe
                        }.onDelete { idx in
                            data.checklists.remove(atOffsets: idx)
                            saveData()
                        }.onMove { idx, p in
                            data.checklists.move(fromOffsets: idx, toOffset: p)
                            saveData()
                        }
                    //title of the first View
                    }.navigationTitle(data.title)
                       
                //plus and edit Button
                }.navigationBarItems(leading: EditButton(), trailing: Button("+"){
                    data.checklists.append(Checklist(name: "New Checklist", tasks: [ ListItem(day: Day(weekDays: .Mon), name: "toDo1", checkedStatus: false), ListItem(day: Day(weekDays: .Mon), name: "toDo2", checkedStatus: false)]))
                    saveData()
                
                    
        //Loading Screen else Claise
                } )
          }else {
                            VStack{
                                ProgressView()
                                Spacer()
                            }.navigationTitle("Loading...")
                        }
        }
    }
}
