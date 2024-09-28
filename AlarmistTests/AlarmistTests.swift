//
//  AlarmistTests.swift
//  AlarmistTests
//
//  Created by John Goodchild on 9/27/24.
//

import XCTest
@testable import Alarmist

final class AlarmistTests: XCTestCase {
    
    var sut: AlarmListView.ViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AlarmListView.ViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testAlarmListDataFetching() async throws {
        do {
            try await sut.fetchAlarmList()
        } catch let error {
            XCTFail("Data fetch failed. Error: \(error.localizedDescription)")
        }
        XCTAssertNotNil(sut.alarmList) /// We should have received alarms from the backend
        XCTAssertGreaterThan(sut.alarmList.count, 0) /// The number of alarms should be greater than zero.
        XCTAssertEqual(sut.exposedTimerList().count, sut.alarmList.count) /// The timer count should match the alarm count.
    }
    
    func testAlarmDeletion() async throws {
        do {
            try await sut.fetchAlarmList()
        } catch let error {
            XCTFail("Data fetch failed. Error: \(error.localizedDescription)")
        }
        let count = sut.alarmList.count /// Store the current alarm count
        let indexSet = IndexSet(integer: 0) /// Generate an index set
        sut.deleteAlarm(at: indexSet) /// Delete the first alarm in the array
        XCTAssertEqual(sut.alarmList.count, (count - 1)) /// The number of alarms should be 1 less than the stored count.
    }
    
    func testLocalAlarmAddition() throws {
        guard let date = TestFunctions.testTimestamp.toDate() else {
            XCTFail("Expected a date object at this point")
            return
        }
        sut.addLocalAlarm(withDate: date, sound: .whiteNoise)
        guard let alarm = sut.alarmList.first else {
            XCTFail("Expected an alarm object at this point")
            return
        }
        XCTAssertNotNil(alarm.timestamp, "Timestamp should not be nil")
        XCTAssertEqual(alarm.alarmSound, SoundType.whiteNoise, "Sound types do not match")
        XCTAssertEqual(alarm.sortString, TestFunctions.generateSortString(), "Sort strings do not match")
        XCTAssertEqual(alarm.displayString, TestFunctions.generateDisplayString(), "Display strings do not match")
        XCTAssertFalse(alarm.isRemote, "Local alarm is flagged as being remote")
    }

}
