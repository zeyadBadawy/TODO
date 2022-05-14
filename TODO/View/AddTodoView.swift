//
//  AddTodoView.swift
//  TODO
//
//  Created by Zeyad Badawy on 13/05/2022.
//

import SwiftUI

enum Priority {
    case Low
    case Normal
    case High
}
extension Priority:CustomStringConvertible  {
    var description : String {
        switch self {
        case .Low: return "Low"
        case .Normal: return "Normal"
        case .High: return "High"
        }
      }
}

struct AddTodoView: View {
    //MARK: PROPERTIES
    @State private var name:String = ""
    @State private var priority:Priority = .Normal
    @State private var showError:Bool = false
    @State private var errorTitle:String = ""
    @State private var errorMessage:String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    let priorities:[Priority] = [.Low , .Normal , .High]
    
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    //MARK: Todo Name
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(12)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    //MARK: Priority Picker
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities , id: \.self){
                            Text($0.description)
                        }
                    }//: Picker
                    .pickerStyle(.segmented)
                    .padding(.vertical)
                    //MARK: Save Button
                    Button {
                        let todo = Todo(context: viewContext)
                        todo.name = self.name
                        todo.priority = self.priority.description
                        do {
                            try viewContext.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print(error)
                        }
                        
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(9)
                            
                    }//: Button
                    .disabled(name.isEmpty)
                }//: VStack
                .padding(.horizontal)
                .padding(.vertical , 30 )
                
                Spacer()
            }//: VStack
            .alert(isPresented: $showError, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
            .navigationBarTitle(Text("New Todo"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
        }//: NavigationView
    }
}
//MARK: PREVIEW
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
