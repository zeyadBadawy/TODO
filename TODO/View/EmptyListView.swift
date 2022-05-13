//
//  EmptyListView.swift
//  TODO
//
//  Created by Zeyad Badawy on 13/05/2022.
//

import SwiftUI

struct EmptyListView: View {
    //MARK: PROPERTIES
    @State private var isAnimated:Bool = false
    
    let images: [String] = [
      "illustration-no1",
      "illustration-no2",
      "illustration-no3"
    ]
    
    let tips: [String] = [
      "Use your time wisely.",
      "Slow and steady wins the race.",
      "Keep it short and sweet.",
      "Put hard tasks first.",
      "Reward yourself after work.",
      "Collect tasks ahead of time.",
      "Each night schedule for tomorrow."
    ]
    
    //MARK: BODY
    var body: some View {
        ZStack {
            VStack {
                Image("\(images.randomElement() ?? self.images[0])")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                
                Text("\(tips.randomElement() ?? self.tips[0])")
                    .font(.system(.headline, design: .rounded))
            }//: VStack
            .opacity(isAnimated ? 1 : 0 )
            .offset(y: isAnimated ? 1 : -5)
            .animation(.easeOut(duration: 1.5), value: isAnimated)
            .onAppear(perform: {
                isAnimated.toggle()
            })
            .padding(.horizontal)
        }//:ZStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    
    }
}
//MARK: PREVIEW
struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
