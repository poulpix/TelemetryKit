//
//  TKMotionPacket.swift
//  TelemetryKit
//
//  Created by Romain on 06/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKCarMotionData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 60
    static let PACKET_SIZE_F1_2021: Int = 60
	
	var worldPositionX: Float32
	var worldPositionY: Float32
	var worldPositionZ: Float32
	var worldVelocityX: Float32
	var worldVelocityY: Float32
	var worldVelocityZ: Float32
	var worldForwardDirX: Int16
	var worldForwardDirY: Int16
	var worldForwardDirZ: Int16
	var worldRightDirX: Int16
	var worldRightDirY: Int16
	var worldRightDirZ: Int16
	var gForceLateral: Float32
	var gForceLongitudinal: Float32
	var gForceVertical: Float32
	var yaw: Float32
	var pitch: Float32
	var roll: Float32
	
	init() {
		worldPositionX = 0
		worldPositionY = 0
		worldPositionZ = 0
		worldVelocityX = 0
		worldVelocityY = 0
		worldVelocityZ = 0
		worldForwardDirX = 0
		worldForwardDirY = 0
		worldForwardDirZ = 0
		worldRightDirX = 0
		worldRightDirY = 0
		worldRightDirZ = 0
		gForceLateral = 0
		gForceLongitudinal = 0
		gForceVertical = 0
		yaw = 0
		pitch = 0
		roll = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        default:
            worldPositionX = type(of: self).read(fromRawData: data, at: offset + 0)
            worldPositionY = type(of: self).read(fromRawData: data, at: offset + 4)
            worldPositionZ = type(of: self).read(fromRawData: data, at: offset + 8)
            worldVelocityX = type(of: self).read(fromRawData: data, at: offset + 12)
            worldVelocityY = type(of: self).read(fromRawData: data, at: offset + 16)
            worldVelocityZ = type(of: self).read(fromRawData: data, at: offset + 20)
            worldForwardDirX = type(of: self).read(fromRawData: data, at: offset + 24)
            worldForwardDirY = type(of: self).read(fromRawData: data, at: offset + 26)
            worldForwardDirZ = type(of: self).read(fromRawData: data, at: offset + 28)
            worldRightDirX = type(of: self).read(fromRawData: data, at: offset + 30)
            worldRightDirY = type(of: self).read(fromRawData: data, at: offset + 32)
            worldRightDirZ = type(of: self).read(fromRawData: data, at: offset + 34)
            gForceLateral = type(of: self).read(fromRawData: data, at: offset + 36)
            gForceLongitudinal = type(of: self).read(fromRawData: data, at: offset + 40)
            gForceVertical = type(of: self).read(fromRawData: data, at: offset + 44)
            yaw = type(of: self).read(fromRawData: data, at: offset + 48) // radians
            pitch = type(of: self).read(fromRawData: data, at: offset + 52) // radians
            roll = type(of: self).read(fromRawData: data, at: offset + 56) // radians
        }
	}
	
}

extension TKCarMotionData: CustomStringConvertible {
	
	var description: String {
		return "position: (\(worldPositionX), \(worldPositionY), \(worldPositionZ)) ; g-force: lat=\(gForceLateral), lon=\(gForceLongitudinal), ver=\(gForceVertical)"
	}
	
}

internal struct TKMotionPacket: TKPacket {
	
    static var PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + (Self.DRIVERS_COUNT * TKCarMotionData.packetSize(forVersion: .f1_2020)) + 120
    static var PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (Self.DRIVERS_COUNT * TKCarMotionData.packetSize(forVersion: .f1_2021)) + 120
	
	var header: TKPacketHeader
	var carMotionData: [TKCarMotionData] // 22
	var suspensionPosition: [Float32] // 4 // RL, RR, FL, FR
	var suspensionVelocity: [Float32] // 4 // RL, RR, FL, FR
	var suspensionAcceleration: [Float32] // 4 // RL, RR, FL, FR
	var wheelSpeed: [Float32] // 4 // RL, RR, FL, FR
	var wheelSlip: [Float32] // 4 // RL, RR, FL, FR
	var localVelocityX: Float32
	var localVelocityY: Float32
	var localVelocityZ: Float32
	var angularVelocityX: Float32
	var angularVelocityY: Float32
	var angularVelocityZ: Float32
	var angularAccelerationX: Float32
	var angularAccelerationY: Float32
	var angularAccelerationZ: Float32
	var frontWheelsAngle: Float32 // radians
	
	init() {
		header = TKPacketHeader()
		carMotionData = [TKCarMotionData]()
		suspensionPosition = [Float32]()
		suspensionVelocity = [Float32]()
		suspensionAcceleration = [Float32]()
		wheelSpeed = [Float32]()
		wheelSlip = [Float32]()
		localVelocityX = 0
		localVelocityY = 0
		localVelocityZ = 0
		angularVelocityX = 0
		angularVelocityY = 0
		angularVelocityZ = 0
		angularAccelerationX = 0
		angularAccelerationY = 0
		angularAccelerationZ = 0
		frontWheelsAngle = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int = 0, forVersion version: TKF1Version) {
        header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        default:
            carMotionData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0, forVersion: version)
            let offset = TKPacketHeader.packetSize(forVersion: version) + Self.DRIVERS_COUNT * TKCarMotionData.packetSize(forVersion: version)
            suspensionPosition = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 0)
            suspensionVelocity = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 16)
            suspensionAcceleration = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 32)
            wheelSpeed = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 48)
            wheelSlip = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 64)
            localVelocityX = type(of: self).read(fromRawData: data, at: offset + 80)
            localVelocityY = type(of: self).read(fromRawData: data, at: offset + 84)
            localVelocityZ = type(of: self).read(fromRawData: data, at: offset + 88)
            angularVelocityX = type(of: self).read(fromRawData: data, at: offset + 92)
            angularVelocityX = type(of: self).read(fromRawData: data, at: offset + 96)
            angularVelocityZ = type(of: self).read(fromRawData: data, at: offset + 100)
            angularAccelerationX = type(of: self).read(fromRawData: data, at: offset + 104)
            angularAccelerationY = type(of: self).read(fromRawData: data, at: offset + 108)
            angularAccelerationZ = type(of: self).read(fromRawData: data, at: offset + 112)
            frontWheelsAngle = type(of: self).read(fromRawData: data, at: offset + 116)
        }
	}
	
}

extension TKMotionPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\tPlayer front wheel angle: \(frontWheelsAngle)")
		for (index, cmd) in carMotionData.enumerated() {
			lines.append("\t\tCar \(index + 1): \(cmd.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
