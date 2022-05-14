//
//  SettingsView.swift
//  TODO
//
//  Created by Zeyad Badawy on 14/05/2022.
//

import SwiftUI

struct SettingsView: View {
    //MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings:IconNames
    
    //MARK: Theme
    var themes:[Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared


    
    //MARK: BODY
    var body: some View {
        NavigationView {
            VStack {
                //MARK: FORM
                Form {
                    //MARK: SECTION 1
                    Section {
                        Picker(selection: $iconSettings.currentIndex) {
                            ForEach(0..<iconSettings.iconNames.count, id:\.self) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44, alignment: .center)
                                        .cornerRadius(8)
                                    
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                }
                            }
                        } label: {
                            HStack {
                              ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                  .strokeBorder(Color.primary, lineWidth: 2)
                                
                                Image(systemName: "paintbrush")
                                  .font(.system(size: 28, weight: .regular, design: .default))
                                  .foregroundColor(Color.primary)
                              }
                              .frame(width: 44, height: 44)
                              
                              Text("App Icons".uppercased())
                                .fontWeight(.bold)
                                .foregroundColor(Color.primary)
                            } //: LABEL
                        }//:Picker
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if value != index {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value])
                            }
                        }

                    } header: {
                        Text("Choose the app icon")
                    }//:SECTION 1

                    //MARK: SECTION 2
                    
                    Section {
                        List {
                            ForEach(themes , id:\.id) { item in
                                Button {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                } label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }//: HStack
                                }//: Button
                                .accentColor(.primary)
                            }//: ForEach
                        }//: List
                    } header: {
                        HStack {
                            Text("Choose app theme.")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10, alignment: .center)
                                .foregroundColor(self.themes[self.theme.themeSettings].themeColor)
                        }
                    }//: SECTION 2

                    //MARK: SECTION 3
                    Section {
                        FormRowLinkView(icon: "globe", color: .pink, text: "LinkedIn", link: "https://www.linkedin.com/in/zeyadbadawy/")
                        FormRowLinkView(icon: "link", color: .pink, text: "Twitter", link: "https://mobile.twitter.com/zeyadtaher5")
                    } header: {
                        Text("Let's Connect")
                    }//:SECTION 3
                    
                    //MARK: SECTION 4
                    Section {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "TODO")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Zeyad Badawy")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.5.0")
                    } header: {
                        Text("About the application")
                    }//:SECTION 4
                    
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                //MARK: FOOTER
                
                Text("Copyright © All rights reserved. \n Zeyad Badawy 🖤")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top , 6)
                    .padding(.bottom , 8)
                    .foregroundColor(.secondary)
            }//: VStack
            .navigationBarTitle("Settings" , displayMode: .inline)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            })
            )
        }//: NavigationView
        .accentColor(self.themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
//MARK: PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
