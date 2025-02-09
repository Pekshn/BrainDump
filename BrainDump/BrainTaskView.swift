//
//  BrainTaskView.swift
//  BrainDump
//
//  Created by Petar  on 8.2.25..
//

import SwiftUI
import CoreData

struct BrainTaskView: View {
    
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    @State private var isFavorite: Bool = false
    var fetchRequest: FetchRequest<BrainTask>
    let brainTask: BrainTask
    
    //MARK: - Init
    init(brainTask: BrainTask) {
        self.brainTask = brainTask
        fetchRequest = FetchRequest(entity: BrainTask.entity(), sortDescriptors: [], predicate: NSPredicate(format: "SELF = %@", brainTask), animation: nil)
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let brainTask = fetchRequest.wrappedValue.first {
                    Text(brainTask.title ?? "")
                    Image(systemName: brainTask.isFavorite ? "heart.fill": "heart")
                        .accessibilityIdentifier("favoriteImg")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
                        .font(.largeTitle)
                        .onTapGesture {
                            isFavorite = !brainTask.isFavorite
                            updateBrainTask()
                        }
                }
                
                Spacer()
            } //: VStack
            .onAppear(perform: {
                
            })
            .padding()
            .navigationTitle(brainTask.title ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                            .accessibilityIdentifier("dismissButton")
                    } //: Button
                } //: ToolbarItem
            } //: toolbar
        } //: NavigationView
    }
}

//MARK: - Private API
extension BrainTaskView {
    
    private func updateBrainTask() {
        do {
            let brainTask = try viewContext.existingObject(with: brainTask.objectID) as! BrainTask
            brainTask.isFavorite = isFavorite
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}

//MARK: - Preview
struct UpdateBrainTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext
        let brainTask = BrainTask(context: viewContext)
        brainTask.title = "Brain task 1"
        brainTask.priority = "Medium"
        brainTask.isFavorite = false
        brainTask.body = "Resolve the brain task 1"
        return BrainTaskView(brainTask: brainTask)
    }
}
