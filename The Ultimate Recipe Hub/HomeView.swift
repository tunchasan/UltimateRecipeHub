//
//  HomePage.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.12.2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var user = User.shared

    var body: some View {
        VStack {
            Text("👨‍🍳")
                .font(.system(size: 100))
                .padding()
            
            Text("We are working on your plan...")
                .font(.title2)
                .fontWeight(.medium)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear(){
            user.setOnboardingAsComplete()
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
