//
//  ContentView.swift
//  TimerApp Watch App
//
//  Created by Jake Huang on 1/25/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var selectedTime = UserDefaults.standard.integer(forKey: "selectedTime") > 0 ? UserDefaults.standard.integer(forKey: "selectedTime") : 60
    @State private var timeRemaining = 60
    let timeOptions = [10, 30, 60, 120]
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            
            Text(formatTime(timeRemaining))
                .font(.largeTitle)
                .foregroundColor(.white)
            HStack {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        stopTimer()
                    }
                    else {
                        startTimer()
                    }
                }.buttonStyle(.borderedProminent)
                Button("Reset") {
                    resetTimer()
                }
                .buttonStyle(.bordered)
            }
            Picker("Set Time", selection: $selectedTime) {
                ForEach(timeOptions, id: \.self) { time in
                    Text("\(time) seconds")
                }
            }.pickerStyle(.wheel)
            .onChange(of: selectedTime) {
                    resetTimer()
                timeRemaining = selectedTime
                UserDefaults.standard.set(selectedTime, forKey: "selectedTime")
                }
        }
    }
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            else {
                stopTimer()
                WKInterfaceDevice.current().play(.success)
            }
        }
    }
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    func resetTimer() {
        stopTimer()
        timeRemaining = UserDefaults.standard.integer(forKey: "selectedTime")
    }
    func formatTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
