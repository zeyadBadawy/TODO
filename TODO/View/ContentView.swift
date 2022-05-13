//
//  ContentView.swift
//  TODO
//
//  Created by Zeyad Badawy on 13/05/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: PROPERTIES
    @State private var showAddTodoView:Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    
    //MARK: Functions
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            viewContext.delete(todo)
            do {
                try viewContext.save()
            }catch {
                print(error)
            }
        }
    }
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            ZStack {
                List{
                    ForEach(todos , id: \.self ) { item in
                        HStack {
                            Text(item.name ?? "")
                            Spacer()
                            Text(item.priority ?? "")
                        }//: HStack
                    }//: ForEach
                    .onDelete(perform: deleteTodo)
                }//: List
                .listStyle(.plain)
                .sheet(isPresented: $showAddTodoView, content: {
                    AddTodoView()
                })
                .navigationBarTitle("Todo" , displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton() ,
                    trailing: Button(action: {
                        self.showAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                )
                if todos.count == 0 {
                    EmptyListView()
                }
            }//: ZStack
        }//: NavigationView
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//MARK: PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
        
    }
}
