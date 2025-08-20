//
//  TaskPresenterTests.swift
//  ToDoTrackerTests
//
//  Created by Max on 20.08.2025.
//

import XCTest
@testable import ToDoTracker

final class TasksPresenterTests: XCTestCase {
    
    var presenter: TasksPresenter!
    var view: MockTasksView!
    var interactor: MockTasksInteractor!
    var router: MockTasksRouter!
    
    override func setUp() {
        super.setUp()
        presenter = TasksPresenter()
        view = MockTasksView()
        interactor = MockTasksInteractor()
        router = MockTasksRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }
    
    func test_viewDidLoad_loadsTasks() {
        interactor.tasks = [TaskModel(id: 1, title: "Test", details: nil, createdAt: Date(), completed: false)]
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(view.shownTasks.count, 1)
        XCTAssertEqual(view.shownTasks.first?.title, "Test")
    }
    
    func test_didToggleComplete_updatesTask() {
        let task = TaskModel(id: 1, title: "Test", details: nil, createdAt: Date(), completed: false)
        interactor.tasks = [task]
        presenter.search(query: "")
        
        presenter.didToggleComplete(id: 1)
        
        XCTAssertEqual(interactor.updateCalledWith?.id, 1)
        XCTAssertTrue(interactor.updateCalledWith?.completed ?? false)
        XCTAssertEqual(view.reloadedIds, [1])
    }
    
    func test_didDeleteTask_removesFromViewAndInteractor() {
        let task = TaskModel(id: 1, title: "DeleteMe", details: nil, createdAt: Date(), completed: false)
        interactor.tasks = [task]
        presenter.search(query: "")
        
        presenter.didDeleteTask(id: 1)
        
        XCTAssertEqual(view.deletedIds, [1])
        XCTAssertEqual(interactor.deleteCalledWith, 1)
    }
    
    func test_didSelectTask_navigatesToDetail() {
        let task = TaskModel(id: 1, title: "GoDetail", details: "Some", createdAt: Date(), completed: false)
        interactor.tasks = [task]
        presenter.search(query: "")
        
        presenter.didSelectTask(id: 1)
        
        XCTAssertEqual(router.navigatedTask?.id, 1)
        XCTAssertEqual(router.navigatedTask?.title, "GoDetail")
    }
    
    func test_didShareTask_sendsCorrectText() {
        let taskVM = TaskViewModel(from: TaskModel(id: 1, title: "ShareTest", details: "Описание", createdAt: Date(), completed: true))
        
        presenter.didShareTask(taskVM)
        
        XCTAssertNotNil(router.sharedText)
        XCTAssertTrue(router.sharedText!.contains("ShareTest"))
        XCTAssertTrue(router.sharedText!.contains("Описание"))
    }
}
