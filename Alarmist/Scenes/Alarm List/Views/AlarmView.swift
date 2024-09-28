//
//  AlarmView.swift
//  Alarmist
//
//  Created by John Goodchild on 9/27/24.
//

import SwiftUI

struct AlarmView: View {
    
    @Binding var alarm: Alarm
    
    var body: some View {
        HStack(spacing: 12.0) {
            if let fireDate = alarm.fireDate {
                VStack(alignment: .leading) {
                    Text(fireDate.relativeTitle())
                        .font(.system(size: 10.0))
                    Text(alarm.displayString)
                        .font(.system(size: 28.0))
                        .bold()
                }
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20.0))
                    .foregroundColor(.red)
                Text("Bad Alarm")
                    .bold()
            }
            Spacer()
            Text("\(alarm.alarmSound.displayIcon)")
                .font(.system(size: 28.0))
                .if(alarm.isRemote) { view in
                    view
                        .overlay {
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 12.0))
                                .offset(x: -32.0, y: 10.0)
                        }
                }
        }
        .padding(.vertical, 4.0)
    }
    
}

#Preview {
    AlarmView(alarm: Binding.constant(RemoteAlarms.mockObjects!.alarms[0]))
        .padding()
}
