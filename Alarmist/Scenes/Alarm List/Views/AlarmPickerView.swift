//
//  AlarmPickerView.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import SwiftUI

struct AlarmPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: AlarmListView.ViewModel
    @State private var alarmDate = Date.now + 60.0
    @State private var alarmSound = SoundType.alarmClock
    
    var body: some View {
        content
            .padding([.horizontal, .bottom], 16.0)
            .padding(.top, 32.0)
    }
    
    private var content: some View {
        VStack {
            Group {
                Text("Add Alarm")
                timerPickerView
                soundPickerView
            }
            .font(.system(size: 20.0))
            .bold()
            saveButtonView
            Spacer()
        }
    }
    
    private var timerPickerView: some View {
        DatePicker("Time:", selection: $alarmDate, displayedComponents: .hourAndMinute)
    }
    
    private var soundPickerView: some View {
        HStack {
            Text("Sound:")
            Spacer()
            Picker("", selection: $alarmSound) {
                ForEach(SoundType.allCases, id: \.self) { sound in
                    HStack {
                        Text("\(sound.displayIcon)   \(sound.displayName)")
                    }
                }
            }
        }
        .padding(.bottom, 32.0)
    }
    
    private var saveButtonView: some View {
        Button {
            viewModel.addLocalAlarm(withDate: alarmDate.stripSeconds(), sound: alarmSound)
            dismiss()
        } label: {
            Text("Save")
        }
    }
    
}

#Preview {
    AlarmPickerView(viewModel: Binding.constant(AlarmListView.ViewModel()))
}
