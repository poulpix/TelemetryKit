//
//  TKCarTelemetryPacket.swift
//  TelemetryKit
//
//  Created by Romain on 09/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKCarTelemetryData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 58
    static let PACKET_SIZE_F1_2021: Int = 60
	
	var speed: UInt16 // km/h
	var throttle: Float32 // 0...1
	var steer: Float32 // -1...1
	var brake: Float32 // 0...1
	var clutch: UInt8 // 0...10
	var gear: Int8 // -1...8
	var engineRPM: UInt16 // RPM
	var drs: TKBool
	var revLightsPercent: UInt8 // percentage
    var revLightsBitValue: UInt16 // bit 0 = leftmost LED ; bit 14 = rightmost LED – New in F1 2021
	var brakesTemperature: [UInt16] // 4 // °C
	var tyresSurfaceTemperature: [UInt8] // 4 // °C
	var tyresInnerTemperature: [UInt8] // 4 // °C
	var engineTemperature: UInt16 // °C
	var tyresPressure: [Float32] // 4 // PSI
	var surfaceType: [TKDrivingSurface] // 4
	
	init() {
		speed = 0
		throttle = 0
		steer = 0
		brake = 0
		clutch = 0
		gear = 0
		engineRPM = 0
		drs = .no
		revLightsPercent = 0
        revLightsBitValue = 0
		brakesTemperature = [UInt16]()
		tyresSurfaceTemperature = [UInt8]()
		tyresInnerTemperature = [UInt8]()
		engineTemperature = 0
		tyresPressure = [Float32]()
		surfaceType = [TKDrivingSurface]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            speed = type(of: self).read(fromRawData: data, at: offset + 0)
            throttle = type(of: self).read(fromRawData: data, at: offset + 2)
            steer = type(of: self).read(fromRawData: data, at: offset + 6)
            brake = type(of: self).read(fromRawData: data, at: offset + 10)
            clutch = type(of: self).read(fromRawData: data, at: offset + 14)
            gear = type(of: self).read(fromRawData: data, at: offset + 15)
            engineRPM = type(of: self).read(fromRawData: data, at: offset + 16)
            let tmpDRS: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 18)
            drs = tmpDRS.opposite
            revLightsPercent = type(of: self).read(fromRawData: data, at: offset + 19)
            brakesTemperature = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 20)
            tyresSurfaceTemperature = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 28)
            tyresInnerTemperature = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 32)
            engineTemperature = type(of: self).read(fromRawData: data, at: offset + 36)
            tyresPressure = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 38)
            surfaceType = type(of: self).readEnumArray(ofSize: 4, fromRawData: data, at: offset + 54)
        case .f1_2021:
            speed = type(of: self).read(fromRawData: data, at: offset + 0)
            throttle = type(of: self).read(fromRawData: data, at: offset + 2)
            steer = type(of: self).read(fromRawData: data, at: offset + 6)
            brake = type(of: self).read(fromRawData: data, at: offset + 10)
            clutch = type(of: self).read(fromRawData: data, at: offset + 14)
            gear = type(of: self).read(fromRawData: data, at: offset + 15)
            engineRPM = type(of: self).read(fromRawData: data, at: offset + 16)
            let tmpDRS: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 18)
            drs = tmpDRS.opposite
            revLightsPercent = type(of: self).read(fromRawData: data, at: offset + 19)
            revLightsBitValue = type(of: self).read(fromRawData: data, at: offset + 20)
            brakesTemperature = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 22)
            tyresSurfaceTemperature = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 30)
            tyresInnerTemperature = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 34)
            engineTemperature = type(of: self).read(fromRawData: data, at: offset + 38)
            tyresPressure = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 40)
            surfaceType = type(of: self).readEnumArray(ofSize: 4, fromRawData: data, at: offset + 56)
        }
	}
	
}

extension TKCarTelemetryData: CustomStringConvertible {
	
	var description: String {
		return "speed: \(speed), throttle: \(throttle), steer: \(steer), brake: \(brake), clutch: \(clutch), gear: \(gear), engine RPM: \(engineRPM), DRS: \(drs), engine temperature: \(engineTemperature)"
	}
	
}

internal struct TKCarTelemetryPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: .f1_2020)) + 7
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: .f1_2021)) + 3
	
	var header: TKPacketHeader
	var carTelemetryData: [TKCarTelemetryData] // 22
	var buttonStatus: UInt32 // binary composition of TKButtonFlags – Moved elsewhere in F1 2021
	var mfdPanelIndex: TKMFDPanel
	var mfdPanelIndexSecondaryPlayer: TKMFDPanel
	var suggestedGear: Int8 // 0...8
	
	init() {
		header = TKPacketHeader()
		carTelemetryData = [TKCarTelemetryData]()
		buttonStatus = 0
		mfdPanelIndex = .closed
		mfdPanelIndexSecondaryPlayer = .closed
		suggestedGear = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        case .f1_2020:
            carTelemetryData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0, forVersion: version)
            buttonStatus = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 0)
            mfdPanelIndex = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 4)
            mfdPanelIndexSecondaryPlayer = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 5)
            mfdPanelIndex = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 6)
        case .f1_2021:
            carTelemetryData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0, forVersion: version)
            mfdPanelIndex = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 0)
            mfdPanelIndexSecondaryPlayer = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 1)
            mfdPanelIndex = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + (Self.DRIVERS_COUNT * TKCarTelemetryData.packetSize(forVersion: version)) + 2)
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(carTelemetries: carTelemetryData)
	}

}

extension TKCarTelemetryPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\tButton status: \(buttonStatus)")
		lines.append("\tMFD panel: \(mfdPanelIndex)")
		for (index, ctd) in carTelemetryData.enumerated() {
			lines.append("\t\tCar \(index + 1): \(ctd.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
