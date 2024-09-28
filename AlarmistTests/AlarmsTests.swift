//
//  AlarmsTests.swift
//  AlarmistTests
//
//  Created by John Goodchild on 9/27/24.
//

import XCTest
@testable import Alarmist

final class AlarmsTests: XCTestCase {
    
    var sut: RemoteAlarms!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testAlarmsDecoding() throws {
        let path = Bundle(for: AlarmsTests.self).path(forResource: "MockAlarms", ofType: "json")
        let data = NSData(contentsOfFile: path!)! as Data
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        sut = try! decoder.decode(RemoteAlarms.self, from: data)
        XCTAssertNotNil(sut.alarms)
        let alarm1 = sut.alarms[0]
        XCTAssertEqual(alarm1.timestamp, TestFunctions.testTimestamp, "Timestamps do not match")
        XCTAssertEqual(alarm1.alarmSound, SoundType.oceanWaves, "Sound types do not match")
        XCTAssertEqual(alarm1.sortString, TestFunctions.generateSortString(), "Sort strings do not match")
        XCTAssertEqual(alarm1.displayString, TestFunctions.generateDisplayString(), "Display strings do not match")
        XCTAssertTrue(alarm1.isRemote, "Remote alarm is not flagged as being remote")
    }

}
