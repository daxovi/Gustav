//
//  SettingsView.swift
//  Gustav
//
//  Created by Dalibor Janeček on 25.02.2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var timer: TimerViewModel
    @ObservedObject var backgroundViewModel: BackgroundViewModel
    
    @State var workoutTextField: String = ""
    @State var restTextField: String = ""
        
    var columns: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 4)
    }
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Select background")
                        .font(.title)
                        
                    backgroundThumbnails
                    Text("Set timers")
                        .font(.title)
                        .padding(.top, 40)
                    HStack(spacing: 20) {
                        workoutSetter
                        restSetter
                    }
                    saveButton
                        .padding(.top, 40)
                }
                .padding()
                .foregroundColor(.black)
            }
            
        }
    }
    
    var workoutSetter: some View {
        VStack {
            Text("Workout")
                .padding(.bottom, -10)
            TextField("\(timer.workout.totalTime)", text: $workoutTextField)
                .font(.system(size: 60))
                .foregroundColor(Color("AccentColor"))
                .keyboardType(.numberPad)
                .padding(5)
                .multilineTextAlignment(.center)
                .onSubmit {
                    if let workout = Int(workoutTextField) {
                        timer.setWorkout(time: workout)
                    }
                }
        }
        .padding(.top, 20)
        .background(
            Color.white.cornerRadius(20).opacity(0.2)
        )
    }
    
    var restSetter: some View {
        VStack {
            Text("Rest")
                .padding(.bottom, -10)
            TextField("\(timer.rest.totalTime)", text: $restTextField)
                .font(.system(size: 60))
                .foregroundColor(Color("RestColor"))
                .keyboardType(.numberPad)
                .padding(5)
                .multilineTextAlignment(.center)
                .onSubmit {
                    if let rest = Int(restTextField) {
                        timer.setRest(time: rest)
                    }
                }
        }
        .padding(.top, 20)
        .background(
            Color.white.cornerRadius(20).opacity(0.2)
        )
    }
    
    var backgroundThumbnails: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach (0..<backgroundViewModel.images.count) { item in
                    Button {
                        backgroundViewModel.selectImage(imageNumber: item)
                    } label: {
                        backgroundViewModel.images[item].getThumbnail()
                            .scaledToFill()
                            .frame(width: 80, height: 140)
                            .cornerRadius(10)
                            .overlay {
                                Circle()
                                    .fill(Color("AccentColor"))
                                    .scaleEffect(0.5)
                                    .overlay {
                                        Image(systemName: "checkmark")
                                            .font(.headline)
                                    }
                                    .opacity(backgroundViewModel.selectedImage == item ? 1.0 : 0.0)
                            }
                    }
                }
            }
        }
    }
    
    var saveButton: some View {
        Button {
            if let workout = Int(workoutTextField) {
                timer.setWorkout(time: workout)
            }
            
            if let rest = Int(restTextField) {
                timer.setRest(time: rest)
            }
            timer.reset()
            dismiss()
        } label: {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color("AccentColor"))
                .frame(height: 50)
                .overlay {
                    Text("Save")
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @StateObject static var value = TimerViewModel(workout: 30, rest: 5)
    @StateObject static var backgroundVM = BackgroundViewModel()
    
    static var previews: some View {
        SettingsView(timer: value, backgroundViewModel: backgroundVM)
    }
}
