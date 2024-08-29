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

    var totalSum: Int {
        return button1Count + button2Count + button3Count + button4Count
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Sports Relay Counter")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.blue)
            
            TextField("Enter Name", text: $name)
                .font(.system(size: 30))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    CircleButton(count: $button1Count, color: .blue)
                    CircleButton(count: $button2Count, color: .green)
                }
                HStack(spacing: 0) {
                    CircleButton(count: $button3Count, color: .orange)
                    CircleButton(count: $button4Count, color: .red)
                }
            }

            Text("Total: \(totalSum)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.black)
                .padding()

            HStack(spacing: 20) {
                Button(action: {
                    self.resetCounts()
                }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.gray))
                }

                Button(action: {
                    self.saveCounts()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                }

                Button(action: {
                    self.exportToCSV()
                }) {
                    Text("Export to CSV")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.green))
                }
            }
        }
        .padding() // Add padding to the VStack to space out the rows
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Data Saved"),
                message: Text(savedDataDescription()),
                dismissButton: .default(Text("OK"))
            )
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
    
    func exportToCSV() {
        let data = savedData.map { [$0.0] + $0.1.map { String($0) } }
        let csvData = data.map { $0.joined(separator: ",") }.joined(separator: "\n")
        
        do {
            let fileName = "counter_data.csv"
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(fileName)
            try csvData.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file exported: \(fileURL)")
        } catch {
            print("Error exporting CSV: \(error)")
        }
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
