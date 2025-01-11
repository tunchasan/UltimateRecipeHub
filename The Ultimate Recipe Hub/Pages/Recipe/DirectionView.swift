//
//  DirectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct DirectionView: View {
    var directions: [String]
    var imageName: String
    var title: String
    var action: () -> Void
    
    @State private var currentStep: Int = 0
    @State private var progress: CGFloat = 0
    @State private var imageHeight: CGFloat = 0.3
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * imageHeight)
                    .clipped()
                    .opacity(0.2)
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * imageHeight)
                    .clipped()
                    .mask(
                        GeometryReader { geometry in
                            Rectangle()
                                .frame(width: geometry.size.width * progress) // Mask width based on progress
                        }
                    )
            }
            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
            
            HStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.green)
                
                if currentStep < directions.count - 1 {
                    Text("\(currentStep + 1)/\(directions.count)")
                        .font(.system(size: 20).bold())
                        .foregroundStyle(.green)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
            
            Spacer()
            
            TabView(selection: $currentStep) {
                ForEach(directions.indices, id: \.self) { index in
                    Text(directions[index])
                        .font(.system(size: 20))
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .tag(index) // Bind tab selection to `currentStep`
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default dots
            .onChange(of: currentStep) { // Update progress
                withAnimation{
                    progress = CGFloat(currentStep) / CGFloat(directions.count - 1)
                    
                    if currentStep == directions.count - 1 {
                        imageHeight = 0.5
                    }
                    
                    else {
                        imageHeight = 0.3
                    }
                }
            }
            .padding(.bottom, 20)
            
            Spacer()
            
            HStack {
                TextButton(
                    title: "Back",
                    titleColor: .black,
                    titleFontSize: 20
                ) {
                    if currentStep > 0 {
                        withAnimation {
                            progress -= 0.2
                            currentStep -= 1
                            imageHeight = 0.3
                        }
                    }
                    
                    else {
                        action()
                    }
                }
                
                TextButton(
                    title: currentStep == directions.count - 1 ? "Done" : "Next",
                    titleColor: .white,
                    titleFontSize: 20
                ) {
                    if currentStep < directions.count - 1 {
                        withAnimation {
                            progress += 0.2
                            currentStep += 1
                            imageHeight = 0.3
                        }
                        
                        if currentStep == directions.count - 1 {
                            withAnimation {
                                imageHeight = 0.5
                            }
                        }
                    }
                    
                    else {
                        action()
                    }
                }
                .background(.green)
            }
        }
    }
}
