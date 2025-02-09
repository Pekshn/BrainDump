//
//  ContentView.swift
//  BrainDump
//
//  Created by Petar  on 8.2.25..
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var priority: String = "Medium"
    @State private var taskBody: String = ""
    @State private var selectedTask: BrainTask?
    @FetchRequest(fetchRequest: BrainTask.allBrainTasksRequest()) private var allTasks: FetchedResults<BrainTask>
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter task title", text: $title)
                    .textFieldStyle(.plain)
                    .accessibilityIdentifier("titleField")
                TextField("Enter task description", text: $taskBody)
                    .textFieldStyle(.plain)
                    .accessibilityIdentifier("descriptionField")
                
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                } //: Picker
                .pickerStyle(.segmented)
                
                Button("Submit") {
                    saveTask()
                } //: Button
                .padding(10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .accessibilityIdentifier("submitButton")
                
                Text(message)
                    .accessibilityIdentifier("messageText")
                
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Text(task.title ?? "")
                            Spacer()
                            
                            if task.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }

                            Text(task.priority ?? "")
                                .frame(maxWidth: 100)
                        } //: HStack
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedTask = task
                        } //: onTapGesture
                        .sheet(item: $selectedTask) {
                            
                        } content: { task in
                            BrainTaskView(brainTask: task)
                        } //: sheet
                    } //: ForEach
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let brainTask = allTasks[index]
                            viewContext.delete(brainTask)
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                        } //: forEach
                    } //: onDelete
                } //: List
                .accessibilityIdentifier("brainTaskList")
                Spacer()
            } //: VStack
            .padding()
            .navigationTitle("Brain Tasks")
        } //: NavigationView
    }
}

//MARK: - Private API
extension ContentView {
    
    private func saveTask() {
        if title.isEmpty { return }
        do {
            if let _ = BrainTask.getBrainTaskBy(title: title) {
                message = "Brain Task already exists"
            } else {
                let task = BrainTask(context: viewContext)
                task.title = title
                task.priority = priority
                task.body = taskBody
                try viewContext.save()
            }
        } catch {
            print(error)
        }
        title = ""
        priority = "Medium"
        taskBody = ""
    }
}

//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
    }
}
