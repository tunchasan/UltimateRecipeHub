//
//  ContentView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.03.2025.
//


import AlertToast
import SwiftUI

struct ContentView: View{

    @State private var showToast = false

    var body: some View{
        VStack{

            Button("Show Toast"){
                 showToast.toggle()
            }
        }
        .toast(isPresenting: $showToast){

            // `.alert` is the default displayMode
            //AlertToast(type: .regular, title: "Message Sent!")
            
            //Choose .hud to toast alert from the top of the screen
            AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", .green), title: "Meal plan is ready!")
            
            //Choose .banner to slide/pop alert from the bottom of the screen
            //AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
        }
    }
}

struct Save_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

