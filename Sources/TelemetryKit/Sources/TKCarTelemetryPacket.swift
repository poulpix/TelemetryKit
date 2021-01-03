//
//  TKCarTelemetryPacket.swift
//  TelemetryKit
//
//  Created by Romain on 09/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKCarTelemetryData: TKPacket {
	
	static let PACKET_SIZE = 58
	
	var speed: UInt16 // km/h
	var throttle: Float32 // 0...1
	var steer: Float32 // -1...1
	var brake: Float32 // 0...1
	var clutch: UInt8 // 0...10
	var gear: Int8 // -1...8
	var engineRPM: UInt16 // RPM
	var drs: TKBool
	var revLightsPercent: UInt8 // percentage
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
		brakesTemperature = [UInt16]()
		tyresSurfaceTemperature = [UInt8]()
		tyresInnerTemperature = [UInt8]()
		engineTemperature = 0
		tyresPressure = [Float32]()
		surfaceType = [TKDrivingSurface]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
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
	}
	
}

extension TKCarTelemetryData: CustomStringConvertible {
	
	var description: String {
		return "speed: \(speed), throttle: \(throttle), steer: \(steer), brake: \(brake), clutch: \(clutch), gear: \(gear), engine RPM: \(engineRPM), DRS: \(drs), engine temperature: \(engineTemperature)"
	}
	
}

internal struct TKCarTelemetryPacket: TKPacket {
	
	static let PACKET_SIZE = TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKCarTelemetryData.PACKET_SIZE) + 7
	
	var header: TKPacketHeader
	var carTelemetryData: [TKCarTelemetryData] // 22
	var buttonStatus: UInt32 // binary composition of TKButtonFlags
	var mfdPanelIndex: TKMFDPanel
	var mfdPanelIndexSecondaryPlayer: TKMFDPanel
	var suggestedGear: Int8
	
	init() {
		header = TKPacketHeader()
		carTelemetryData = [TKCarTelemetryData]()
		buttonStatus = 0
		mfdPanelIndex = .closed
		mfdPanelIndexSecondaryPlayer = .closed
		suggestedGear = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		header = TKPacketHeader.build(fromRawData: data)
		carTelemetryData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 0)
		buttonStatus = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKCarTelemetryData.PACKET_SIZE) + 0)
		mfdPanelIndex = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKCarTelemetryData.PACKET_SIZE) + 4)
		mfdPanelIndexSecondaryPlayer = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKCarTelemetryData.PACKET_SIZE) + 5)
		mfdPanelIndex = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKCarTelemetryData.PACKET_SIZE) + 6)
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
