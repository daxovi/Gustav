//
//  ContentView.swift
//  Gustav
//
//  Created by Dalibor Janeček on 25.02.2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("background") var savedBackground = 1
    @AppStorage("workout") var savedWorkoutTime = 60
    @AppStorage("rest") var savedRestTime = 5
    
    @StateObject var timer = TimerViewModel(
        workout: 60,
        rest: 5
    )
    @StateObject var backgroundViewModel = BackgroundViewModel()
    @State private var showingSheet = false
    
    
        
    var body: some View {
        ZStack {
            background
            VStack {
                progress
                settings
                Spacer()
                counter
                Spacer()
                controls
            }
            .foregroundColor(.white)
            .padding()
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            backgroundViewModel.selectImage(imageNumber: savedBackground)
            timer.setRest(time: savedRestTime)
            timer.setWorkout(time: savedWorkoutTime)
        }
    }
    
    var progress: some View {
        // progressbar
        HStack {
            ProgressBarView(progress: $timer.percentageWorkout, color: Color("AccentColor"))
                .frame(height: 10)
            ProgressBarView(progress: $timer.percentageRest, color: Color("RestColor"))
                .frame(width: 80, height: 10)
        }
        .padding(.bottom)
    }
    
    var background: some View {
        ZStack {
            backgroundViewModel.getBackgroundImage(image: backgroundViewModel.selectedImage)
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width
                )
            Color("GrayColor").opacity(0.4)
        }
        .ignoresSafeArea()
    }
    
    var controls: some View {
        HStack(alignment: .center) {
            Button {
                timer.reset()
            } label: {
                Image(systemName: "backward.end")
                    .font(.system(size: 25))
            }
            Spacer()
            Button {
                timer.startStop()
            } label: {
                Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(timer.phase == .workout ? "AccentColor" : "RestColor"))
            }
            Spacer()
            Button {
                timer.skip()
            } label: {
                Image(systemName: "forward.frame")
                    .font(.system(size: 25))
            }
        }
    }
    
    var settings: some View {
        HStack {
            HStack {
                Text("W: \(timer.workout.totalTime)")
                    .foregroundColor(timer.phase == .workout ? Color("AccentColor") : Color.gray)
                Text("R: \(timer.rest.totalTime)")
                    .foregroundColor(timer.phase == .rest ? Color("RestColor") : Color.gray)
            }
            Spacer()
            Button {
                showingSheet.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 25))
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                savedBackground = backgroundViewModel.selectedImage
                savedWorkoutTime = timer.workout.totalTime
                savedRestTime = timer.rest.totalTime
            }) {
                SettingsView(timer: timer, backgroundViewModel: backgroundViewModel)
            }
        }
    }
    
    var counter: some View {
        if timer.phase == .workout && timer.time == timer.workout.totalTime && timer.isRunning {
            return Text("start")
                .padding(40)
                .padding(.bottom, 40)
                .font(.system(size: 120))
                .foregroundColor(Color("AccentColor"))
                .shadow(color: .black, radius: 50, x: 1, y: 1)
        } else if timer.phase == .rest && timer.time == timer.rest.totalTime {
            return Text("rest")
                .padding(40)
                .padding(.bottom, 40)
                .font(.system(size: 120))
                .foregroundColor(Color("RestColor"))
                .shadow(color: .black, radius: 50, x: 1, y: 1)
        } else {
            return Text("\(timer.time)")
                .padding(40)
                .padding(.bottom, 40)
                .font(.system(size: (timer.time < 10) ? 300 : 200))
                .foregroundColor(Color(timer.phase == .workout ? "AccentColor" : "RestColor"))
                .shadow(color: .black, radius: 50, x: 1, y: 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

