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
    @State private var showSettingsView:Bool = false
    
    @State private var isAnimating:Bool = false
    @State private var animationAmount: CGFloat = 1
    @State private var editMode = EditMode.inactive
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var iconNames:IconNames
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    enum ActiveSheet: Identifiable {
        case settings, addNewTodo
        var id: Int {
            hashValue
        }
    }
    @State var activeSheet: ActiveSheet?
    //MARK: Theme
    var themes:[Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared


    
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
    
    private func colorize(priority:String) -> Color {
        switch priority {
        case "Low":
            return .blue
        case "Normal":
            return .green
        case "High":
            return .pink
        default:
            return .gray
        }
    }
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            ZStack {
                List{
                    ForEach(todos , id: \.self ) { item in
                        HStack {
                            Circle().fill()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: item.priority ?? ""))
                                
                            Text(item.name ?? "")
                                .fontWeight(.semibold)
    
                            Spacer()
                            Text(item.priority ?? "")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth:62)
                                .overlay (
                                    Capsule().stroke(Color(UIColor.systemGray2) , lineWidth: 0.75)
                                    
                                )
                            
                        }//: HStack
                    }//: ForEach
                    .onDelete(perform: deleteTodo)
                }//: List
                .listStyle(.plain)
                .navigationBarTitle("Todo" , displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(editMode: $editMode) ,
                    trailing:
                        HStack {
                            Button(action: {
                                activeSheet = .settings
                            }, label: {
                                Image(systemName: "paintbrush")
                            })
                        }//: HStack
                )
                .environment(\.editMode, $editMode)
                .sheet(item: $activeSheet) { item in
                            switch item {
                            case .settings:
                                SettingsView().environmentObject(self.iconNames)
                            case .addNewTodo:
                                AddTodoView().environment(\.managedObjectContext, viewContext)
                            }
                        }
                
                if todos.count == 0 {
                    EmptyListView()
                }
                //MARK: ADD BUTTON
                ZStack {
                    Group {
                        Circle().fill(self.themes[self.theme.themeSettings].themeColor)
                            .opacity(self.isAnimating ? 0.2 : 0)
                            .scaleEffect(animationAmount )
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle().fill(self.themes[self.theme.themeSettings].themeColor)
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
                        activeSheet = .addNewTodo
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                            .scaledToFit()
                    }//: Button
                    .accentColor(self.themes[self.theme.themeSettings].themeColor)
                    .onAppear {
                        animationAmount = 1.2
                        isAnimating.toggle()
                    }
                }//: ZStack
                .offset(x:UIScreen.main.bounds.width/2 - 64 ,
                        y:UIScreen.main.bounds.height/2 - 80 - safeAreaInsets.bottom)
            }//: ZStack
        }//: NavigationView
        .accentColor(self.themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
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



