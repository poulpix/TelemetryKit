//
//  TKLapDataPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKLapData: TKPacket {
	
	static let PACKET_SIZE = 53
	
	var lastLapTime: Float32 // sec
	var currentLapTime: Float32 // sec
	var sector1TimeInMS: UInt16 // ms
	var sector2TimeInMS: UInt16 // ms
	var bestLapTime: Float32 // sec
	var bestLapNum: UInt8
	var bestLapSector1TimeInMS: UInt16 // ms
	var bestLapSector2TimeInMS: UInt16 // ms
	var bestLapSector3TimeInMS: UInt16 // ms
	var bestOverallSector1TimeInMS: UInt16 // ms
	var bestOverallSector1LapNum: UInt8
	var bestOverallSector2TimeInMS: UInt16 // ms
	var bestOverallSector2LapNum: UInt8
	var bestOverallSector3TimeInMS: UInt16 // ms
	var bestOverallSector3LapNum: UInt8
	var lapDistance: Float32 // meters
	var totalDistance: Float32 // meters
	var safetyCarDelta: Float32 // sec
	var carPosition: UInt8
	var currentLapNum: UInt8
	var pitStatus: TKPitStatus
	var sector: TKSector
	var currentLapInvalid: TKBool
	var penalties: UInt8 // sec
	var gridPosition: UInt8
	var driverStatus: TKDriverStatus
	var resultStatus: TKResultStatus
	
	var sector1Time: Float32 {
		return Float32(sector1TimeInMS) / 1000.0
	}
	var sector2Time: Float32 {
		return Float32(sector2TimeInMS) / 1000.0
	}
	
	init() {
		lastLapTime = 0
		currentLapTime = 0
		sector1TimeInMS = 0
		sector2TimeInMS = 0
		bestLapTime = 0
		bestLapNum = 0
		bestLapSector1TimeInMS = 0
		bestLapSector2TimeInMS = 0
		bestLapSector3TimeInMS = 0
		bestOverallSector1TimeInMS = 0
		bestOverallSector1LapNum = 0
		bestOverallSector2TimeInMS = 0
		bestOverallSector2LapNum = 0
		bestOverallSector3TimeInMS = 0
		bestOverallSector3LapNum = 0
		lapDistance = 0
		totalDistance = 0
		safetyCarDelta = 0
		carPosition = 0
		currentLapNum = 0
		pitStatus = .none
		sector = .sector1
		currentLapInvalid = .no
		penalties = 0
		gridPosition = 0
		driverStatus = .inGarage
		resultStatus = .invalid
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		lastLapTime = type(of: self).read(fromRawData: data, at: offset + 0)
		currentLapTime = type(of: self).read(fromRawData: data, at: offset + 4)
		sector1TimeInMS = type(of: self).read(fromRawData: data, at: offset + 8)
		sector2TimeInMS = type(of: self).read(fromRawData: data, at: offset + 10)
		bestLapTime = type(of: self).read(fromRawData: data, at: offset + 12)
		bestLapNum = type(of: self).read(fromRawData: data, at: offset + 16)
		bestLapSector1TimeInMS = type(of: self).read(fromRawData: data, at: 17)
		bestLapSector2TimeInMS = type(of: self).read(fromRawData: data, at: 19)
		bestLapSector3TimeInMS = type(of: self).read(fromRawData: data, at: 21)
		bestOverallSector1TimeInMS = type(of: self).read(fromRawData: data, at: 23)
		bestOverallSector1LapNum = type(of: self).read(fromRawData: data, at: 25)
		bestOverallSector2TimeInMS = type(of: self).read(fromRawData: data, at: 26)
		bestOverallSector2LapNum = type(of: self).read(fromRawData: data, at: 28)
		bestOverallSector3TimeInMS = type(of: self).read(fromRawData: data, at: 29)
		bestOverallSector3LapNum = type(of: self).read(fromRawData: data, at: 31)
		lapDistance = type(of: self).read(fromRawData: data, at: offset + 32)
		totalDistance = type(of: self).read(fromRawData: data, at: offset + 36)
		safetyCarDelta = type(of: self).read(fromRawData: data, at: offset + 40)
		carPosition = type(of: self).read(fromRawData: data, at: offset + 44)
		currentLapNum = type(of: self).read(fromRawData: data, at: offset + 45)
		pitStatus = type(of: self).readEnum(fromRawData: data, at: offset + 46)
		sector = type(of: self).readEnum(fromRawData: data, at: offset + 47)
		currentLapInvalid = type(of: self).readEnum(fromRawData: data, at: offset + 48)
		penalties = type(of: self).read(fromRawData: data, at: offset + 49)
		gridPosition = type(of: self).read(fromRawData: data, at: offset + 50)
		driverStatus = type(of: self).readEnum(fromRawData: data, at: offset + 51)
		resultStatus = type(of: self).readEnum(fromRawData: data, at: offset + 52)
	}
	
}

extension TKLapData: CustomStringConvertible {
	
	var description: String {
		return "last lap time: \(lastLapTime), current lap time: \(currentLapTime), best lap time: \(bestLapTime), position: \(carPosition), current lap number: \(currentLapNum), sector: \(sector), grid position: \(gridPosition), driver status: \(driverStatus), result status: \(resultStatus)"
	}
	
}

internal extension Array where Element == TKLapData {
	
	var leaderLapData: TKLapData {
		return (self.filter { $0.carPosition == 1 }).first!
	}
	
}

internal struct TKLapDataPacket: TKPacket {
	
	static let PACKET_SIZE = TKPacketHeader.PACKET_SIZE + (Self.DRIVERS_COUNT * TKLapData.PACKET_SIZE)
	
	var header: TKPacketHeader
	var lapData: [TKLapData] // 22
	
	init() {
		header = TKPacketHeader()
		lapData = [TKLapData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		header = TKPacketHeader.build(fromRawData: data)
		lapData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 0)
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(lapData: lapData, at: header.sessionTimestamp)
	}

}

extension TKLapDataPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		for (index, ld) in lapData.enumerated() {
			lines.append("\t\tCar \(index + 1): \(ld.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
