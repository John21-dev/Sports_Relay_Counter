//
//  ContentView.swift
//  Sport Relay Counter
//
//  Created by John Macera on 8/29/24.
//

import SwiftUI
import SwiftCSV
import UIKit

struct ContentView: View {
    @State private var button1Count = 0
    @State private var button2Count = 0
    @State private var button3Count = 0
    @State private var button4Count = 0
    @State private var name: String = ""
    @State private var savedData: [(String, [Int])] = []
    @State private var isShowingAlert = false
    @State private var isWhiteBackground = true // Track the background color
    
    var totalSum: Int {
        return button1Count + button2Count + button3Count + button4Count
    }

    // Define softer colors
    let softRed = Color(red: 1.0, green: 0.4, blue: 0.4)
    let softBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    let softGreen = Color(red: 0.4, green: 1.0, blue: 0.4)
    
    var body: some View {
        ZStack {
            (isWhiteBackground ? Color.white : Color.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Text("Sports Relay Counter")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(isWhiteBackground ? .black : .white)
                
                TextField("Enter names", text: $name)
                    .font(.system(size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        CircleButton(count: $button1Count, color: .blue)
                        CircleButton(count: $button2Count, color: .green)
                    }
                    HStack(spacing: 15) {
                        CircleButton(count: $button3Count, color: .yellow)
                        CircleButton(count: $button4Count, color: .red)
                    }
                }
                
                Text("Total: \(totalSum)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(isWhiteBackground ? .black : .white)
                    .padding()
                
                HStack(spacing: 20) {
                    Button(action: {
                        self.resetCounts()
                    }) {
                        Text("Reset")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(softRed))
                    }
                    
                    Button(action: {
                        self.saveCounts()
                    }) {
                        Text("Save")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(softBlue))
                    }
                }
                
                // Toggle Switch for Light/Dark Mode
                Toggle(isOn: $isWhiteBackground) {
                    HStack {
                        Image(systemName: isWhiteBackground ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(isWhiteBackground ? .yellow : .gray)
                        Text(isWhiteBackground ? "Light Mode" : "Dark Mode")
                            .foregroundColor(isWhiteBackground ? .black : .white)
                    }
                }
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: .gray)) // Customize the toggle color
            }
            .padding()
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Data Saved"),
                    message: Text(savedDataDescription()),
                    primaryButton: .destructive(Text("Clear Data"), action: {
                        clearSavedData() // Function to clear the saved data
                    }),
                    secondaryButton: .default(Text("OK"))
                )
            }
        }
    }

    func savedDataDescription() -> String {
        var description = ""
        for (name, counts) in savedData {
            let countsString = counts.map { "\($0)" }.joined(separator: ", ")
            let total = counts.reduce(0, +)
            description += "\(name): \(countsString) = \(total)\n"
        }
        return description
    }
    
    func clearSavedData() {
        savedData.removeAll()
        print("Saved data has been cleared")
    }

    func resetCounts() {
        button1Count = 0
        button2Count = 0
        button3Count = 0
        button4Count = 0
        name = ""
    }

    func saveCounts() {
        guard !name.isEmpty else { return }
        let counts = [button1Count, button2Count, button3Count, button4Count]
        savedData.append((name, counts))
        resetCounts()
        isShowingAlert = true
    }
}

struct CircleButton: View {
    @Binding var count: Int
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(self.color)
                .frame(width: 165, height: 165)
                .overlay(
                    Text("\(self.count)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                )
                .gesture(TapGesture()
                    .onEnded {
                        self.count += 1
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    })
        }
    }
}
