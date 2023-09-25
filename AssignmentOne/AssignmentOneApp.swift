//
//  AssignmentOneApp.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 13.03.23.
//

import SwiftUI

@main
struct AssignmentOneApp: App {
    @State var data:DataModel = DataModel.getDataModel()
    var body: some Scene {
        WindowGroup {
            ContentView(data: data)
        }
    }
}

