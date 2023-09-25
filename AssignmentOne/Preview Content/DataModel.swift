//
//  DataModel.swift
//  AssignmentOne
//
//  Created by Jakob Ossmann on 13.03.23.
//

import Foundation


// object to have Data on first Dummy use
var firstloadData =
[
    Checklist(
        name: "Groceries",
        tasks: [
            ListItem(
                day: Day(weekDays: .Mon),
                name: "Salad",
                checkedStatus: false
            ),
            ListItem(
                day: Day(weekDays: .Mon),
                name: "Chicken",
                checkedStatus: false
            )
        ]
        ),
    Checklist(
        name: "Homework",
        tasks: [
            ListItem(
                day: Day(weekDays: .Mon),
                name: "Mobile AppDev",
                checkedStatus: false
            ),
            ListItem(
                day: Day(weekDays: .Mon),
                name: "Big Data Analytics",
                checkedStatus: false
            )
        ]
        )
]

// weekDays to choose in the task list
enum WeekDays : Encodable, Decodable {
    case Select
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
}

class Day: Codable,ObservableObject, Identifiable {
    @Published var weekDays : WeekDays
    var id = UUID()
    enum CodingKeys: CodingKey {
        case weekDays
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weekDays, forKey: .weekDays)
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weekDays = try container.decode(WeekDays.self, forKey: .weekDays)
        
    }
    init(weekDays: WeekDays) {
            self.weekDays = weekDays
    }
}

//This is the class for each Item in each todolist
class ListItem: Codable,ObservableObject {
    @Published var day:Day
    @Published var name:String
    @Published var checkedStatus:Bool
    var previousStatus:Bool = false
    var id = UUID()
    enum CodingKeys: CodingKey {
        case day
        case name
        case checkedStatus
        
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(day, forKey: .day)
        try container.encode(name, forKey: .name)
        try container.encode(checkedStatus, forKey: .checkedStatus)
        
        
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Day.self, forKey: .day)
        name = try container.decode(String.self, forKey: .name)
        checkedStatus = try container.decode(Bool.self, forKey: .checkedStatus)
        
     
        
    }
    init(day: Day, name: String, checkedStatus: Bool) {
        self.day = day
        self.name = name
        self.checkedStatus = checkedStatus
            
            
    }
}

//This is the class for each Checklist
class Checklist: Codable,ObservableObject {
    @Published var name:String
    @Published var tasks: [ListItem] = []
    var id = UUID()
    @Published var canUndo = false
    @Published var canReset = false
    
    
    func upDatecanReset() {
        canReset = tasks.filter{$0.checkedStatus}.count > 0
    }
    
    
    enum CodingKeys: CodingKey {
        case name
        case tasks
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(tasks, forKey: .tasks)
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        tasks = try container.decode([ListItem].self, forKey: .tasks)
        
    }
    init(name: String, tasks: [ListItem] = []) {
            self.name = name
            self.tasks = tasks
    }
    
    
    func doReset() {
        if(!canReset) {return}
        for i in tasks.indices {
            tasks[i].previousStatus = tasks[i].checkedStatus
            tasks[i].checkedStatus = false
        }
        upDatecanReset()
        self.canUndo  = true
    }
    func doUndo() {
        if(!canUndo) {return}
        for i in tasks.indices {
            tasks[i].checkedStatus = tasks[i].previousStatus
        }
        self.canUndo  = false
        upDatecanReset()
    }
    
}

//This is the overall Datamodel of the App
class DataModel: Codable, ObservableObject {
    @Published var title:String
    @Published var checklists:[Checklist]
    @Published var loadingCompleted = false
    static var model: DataModel?
    
    enum CodingKeys: CodingKey {
        case title
        case checklists
    }
    private init() {
        title = "Jakob's Lists"
        checklists = firstloadData
        load()
    }
    
    /// guarantee there is only one DataModel created.
    static func getDataModel()->DataModel {
        guard let md = DataModel.model else {
            let m = DataModel()
            DataModel.model = m
            return m
        }
        return md
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(checklists, forKey: .checklists)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        checklists = try container.decode([Checklist].self, forKey: .checklists)
    }
    
    func getFile()->URL {
        let fname = "assignmentOne.json"
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        return url.appendingPathComponent(fname)
    }
    func save() {
        do{
            let url = getFile()
            let data = try JSONEncoder().encode(self)
            try data.write(to: url)
        } catch {
            print("save failed with error: \(error)")
        }
    }
    
    private func asyLoad() async ->DataModel? {
        do{
            let url = getFile()
            let datastr = try Data(contentsOf: url)
            let data = try JSONDecoder().decode(DataModel.self, from: datastr)
            return data
        }
        catch {
            print("load failed with error: \(error)")
        }
        return nil
    }
    
    func load() {
        Task {
            guard let data = await asyLoad() else {return}
/// withouth sleep, you can't observe the loading page...
            try? await Task.sleep(nanoseconds: 1000_000_000)
            DispatchQueue.main.async {
                self.title = data.title
                self.checklists = data.checklists
                self.loadingCompleted = true
            }
        }
    }
}


func saveData() {
    let model = DataModel.getDataModel()
    model.save()
}

