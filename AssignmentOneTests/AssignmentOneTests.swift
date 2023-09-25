//
//  AssignmentOneTests.swift
//  AssignmentOneTests
//
//  Created by Jakob Ossmann on 13.03.23.
//

import XCTest
@testable import AssignmentOne

class AssignmentOneTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //test ListItems

    func testCreateListItem() {
        let day = Day(weekDays: .Mon)
        let listItem = ListItem(day: day, name: "Buy Bread", checkedStatus: false)
        XCTAssertEqual(listItem.name, "Buy Bread")
        XCTAssertFalse(listItem.checkedStatus)
    }
    
    //test AddItems
    func testAddItem() {
        let checklist = Checklist(name: "Groceries")
        let item = ListItem(day: Day(weekDays: .Select), name: "Oranges", checkedStatus: false)
        checklist.tasks.append(item)
        assert(checklist.tasks.count == 1, "Item wasnt added to list")
    }
    
    // test the updates of the checklist
    func testUpdateChecklist() {
        let day = Day(weekDays: .Tue)
        let listItem1 = ListItem(day: day, name: "Do Pushups", checkedStatus: false)
        let listItem2 = ListItem(day: day, name: "Do Pullups", checkedStatus: false)
        let checklist = Checklist(name: "Workout List", tasks: [listItem1, listItem2])
        XCTAssertEqual(checklist.tasks.count, 2)
        XCTAssertEqual(checklist.tasks[0].name, "Do Pushups")
        XCTAssertEqual(checklist.tasks[1].name, "Do Pullups")
    }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
