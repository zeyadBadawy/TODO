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
    @State private var isAnimating:Bool = false
    @State private var animationAmount: CGFloat = 1

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
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
                //MARK: ADD BUTTON
                ZStack {
                    Group {
                        Circle().fill(.blue)
                            .opacity(self.isAnimating ? 0.2 : 0)
                            .scaleEffect(animationAmount )
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle().fill(.blue)
                            .scaleEffect(animationAmount )
                            .opacity(self.isAnimating ?  0.15 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }//: Group
                    .animation(
                        .linear(duration: 1)
                                        .delay(0.2)
                                        .repeatForever(autoreverses: true),
                                    value: animationAmount)
                    
                    Button {
                        self.showAddTodoView.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }//: Button
                    .onAppear {
                        animationAmount = 1.2
                        isAnimating.toggle()
                    }
                }//: ZStack
                .offset(x:UIScreen.main.bounds.width/2 - 64 ,
                        y:UIScreen.main.bounds.height/2 - 80 - safeAreaInsets.bottom)
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


private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
