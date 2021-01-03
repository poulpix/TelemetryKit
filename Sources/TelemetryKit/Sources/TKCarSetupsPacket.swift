//
//  TKCarSetupsPacket.swift
//  TelemetryKit
//
//  Created by Romain on 09/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKCarSetup: TKPacket {
	
	static let PACKET_SIZE = 49
	
	var frontWing: UInt8
	var rearWing: UInt8
	var onThrottle: UInt8 // percentage
	var offThrottle: UInt8 // percentage
	var frontCamber: Float32
	var rearCamber: Float32
	var frontToe: Float32
	var rearToe: Float32
	var frontSuspension: UInt8
	var rearSuspension: UInt8
	var frontAntiRollBar: UInt8
	var rearAntiRollBar: UInt8
	var frontSuspensionHeight: UInt8
	var rearSuspensionHeight: UInt8
	var brakePressure: UInt8 // percentage
	var brakeBias: UInt8 // percentage
	var rearLeftTyrePressure: Float32 // PSI
	var rearRightTyrePressure: Float32 // PSI
	var frontLeftTyrePressure: Float32 // PSI
	var frontRightTyrePressure: Float32 // PSI
	var ballast: UInt8
	var fuelLoad: Float32
	
	init() {
		frontWing = 0
		rearWing = 0
		onThrottle = 0
		offThrottle = 0
		frontCamber = 0
		rearCamber = 0
		frontToe = 0
		rearToe = 0
		frontSuspension = 0
		rearSuspension = 0
		frontAntiRollBar = 0
		rearAntiRollBar = 0
		frontSuspensionHeight = 0
		rearSuspensionHeight = 0
		brakePressure = 0
		brakeBias = 0
		rearLeftTyrePressure = 0
		rearRightTyrePressure = 0
		frontLeftTyrePressure = 0
		frontRightTyrePressure = 0
		ballast = 0
		fuelLoad = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		frontWing = type(of: self).read(fromRawData: data, at: offset + 0)
		rearWing = type(of: self).read(fromRawData: data, at: offset + 1)
		onThrottle = type(of: self).read(fromRawData: data, at: offset + 2)
		offThrottle = type(of: self).read(fromRawData: data, at: offset + 3)
		frontCamber = type(of: self).read(fromRawData: data, at: offset + 4)
		rearCamber = type(of: self).read(fromRawData: data, at: offset + 8)
		frontToe = type(of: self).read(fromRawData: data, at: offset + 12)
		rearToe = type(of: self).read(fromRawData: data, at: offset + 16)
		frontSuspension = type(of: self).read(fromRawData: data, at: offset + 20)
		rearSuspension = type(of: self).read(fromRawData: data, at: offset + 21)
		frontAntiRollBar = type(of: self).read(fromRawData: data, at: offset + 22)
		rearAntiRollBar = type(of: self).read(fromRawData: data, at: offset + 23)
		frontSuspensionHeight = type(of: self).read(fromRawData: data, at: offset + 24)
		rearSuspensionHeight = type(of: self).read(fromRawData: data, at: offset + 25)
		brakePressure = type(of: self).read(fromRawData: data, at: offset + 26)
		brakeBias = type(of: self).read(fromRawData: data, at: offset + 27)
		rearLeftTyrePressure = type(of: self).read(fromRawData: data, at: offset + 28)
		rearRightTyrePressure = type(of: self).read(fromRawData: data, at: offset + 32)
		frontLeftTyrePressure = type(of: self).read(fromRawData: data, at: offset + 36)
		frontRightTyrePressure = type(of: self).read(fromRawData: data, at: offset + 40)
		ballast = type(of: self).read(fromRawData: data, at: offset + 44)
		fuelLoad = type(of: self).read(fromRawData: data, at: offset + 45)
	}
	
}

extension TKCarSetup: CustomStringConvertible {
	
	var description: String {
		return "front wing: \(frontWing), rear wing: \(rearWing), brakePressure: \(brakePressure), front tyre pressure: \(frontLeftTyrePressure) – \(frontRightTyrePressure), rear tyre pressure: \(rearLeftTyrePressure) – \(rearRightTyrePressure), fuel load: \(fuelLoad)"
	}
	
}

internal struct TKCarSetupsPacket: TKPacket {
	
	static let PACKET_SIZE = TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKCarSetup.PACKET_SIZE)
	
	var header: TKPacketHeader
	var carSetups: [TKCarSetup] // 22
	
	init() {
		header = TKPacketHeader()
		carSetups = [TKCarSetup]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		header = TKPacketHeader.build(fromRawData: data)
		carSetups = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 0)
	}
	
}

extension TKCarSetupsPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		for (index, cs) in carSetups.enumerated() {
			lines.append("\t\tCar \(index + 1): \(cs.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
