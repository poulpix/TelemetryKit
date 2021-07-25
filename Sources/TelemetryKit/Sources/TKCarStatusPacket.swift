//
//  TKCarStatusPacket.swift
//  TelemetryKit
//
//  Created by Romain on 09/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKCarStatusData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 60
    static let PACKET_SIZE_F1_2021: Int = 47
	
	var tractionControl: TKTractionControl
	var antiLockBrakes: TKBool
	var fuelMix: TKFuelMix
	var frontBrakeBias: UInt8 // percentage
	var pitLimiterStatus: TKBool
	var fuelInTank: Float32
	var fuelCapacity: Float32
	var fuelRemainingLaps: Float32 // laps
	var maxRPM: UInt16 // RPM
	var idleRPM: UInt16 // RPM
	var maxGears: UInt8
	var drsAllowed: TKBool
	var drsActivationDistance: UInt16 // meters
	var tyresWear: [UInt8] // 4 // percentage – Moved elsewhere in F1 2021
	var actualTyreCompound: TKTyreCompound
	var tyreVisualCompound: TKTyreVisualCompound
	var tyresAgeLaps: UInt8 // laps
	var tyresDamage: [UInt8] // 4 // percentage – Moved elsewhere in F1 2021
	var frontLeftWingDamage: UInt8 // percentage – Moved elsewhere in F1 2021
	var frontRightWingDamage: UInt8 // percentage – Moved elsewhere in F1 2021
	var rearWingDamage: UInt8 // percentage – Moved elsewhere in F1 2021
	var drsFault: TKBool // Moved elsewhere in F1 2021
	var engineDamage: UInt8 // percentage – Moved elsewhere in F1 2021
	var gearBoxDamage: UInt8 // percentage – Moved elsewhere in F1 2021
	var vehicleFIAFlags: TKVehicleFIAFlags
	var ersStoreEnergy: Float32 // Joules
	var ersDeployMode: TKERSDeploymentMode
	var ersHarvestedThisLapMGUK: Float32 // Joules
	var ersHarvestedThisLapMGUH: Float32 // Joules
	var ersDeployedThisLap: Float32 // Joules
    var isNetworkPaused: TKBool // New in F1 2021
	
	init() {
		tractionControl = .off
		antiLockBrakes = .no
		fuelMix = .lean
		frontBrakeBias = 0
		pitLimiterStatus = .no
		fuelInTank = 0
		fuelCapacity = 0
		fuelRemainingLaps = 0
		maxRPM = 0
		idleRPM = 0
		maxGears = 0
		drsAllowed = .no
		drsActivationDistance = 0
		tyresWear = [UInt8]()
		actualTyreCompound = .unknown
		tyreVisualCompound = .unknown
		tyresAgeLaps = 0
		tyresDamage = [UInt8]()
		frontLeftWingDamage = 0
		frontRightWingDamage = 0
		rearWingDamage = 0
		drsFault = .no
		engineDamage = 0
		gearBoxDamage = 0
		vehicleFIAFlags = .none
		ersStoreEnergy = 0
		ersDeployMode = .none
		ersHarvestedThisLapMGUK = 0
		ersHarvestedThisLapMGUH = 0
		ersDeployedThisLap = 0
        isNetworkPaused = .no
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            tractionControl = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            antiLockBrakes = type(of: self).readEnum(fromRawData: data, at: offset + 1)
            fuelMix = type(of: self).readEnum(fromRawData: data, at: offset + 2)
            frontBrakeBias = type(of: self).read(fromRawData: data, at: offset + 3)
            pitLimiterStatus = type(of: self).readEnum(fromRawData: data, at: offset + 4)
            fuelInTank = type(of: self).read(fromRawData: data, at: offset + 5)
            fuelCapacity = type(of: self).read(fromRawData: data, at: offset + 9)
            fuelRemainingLaps = type(of: self).read(fromRawData: data, at: offset + 13)
            maxRPM = type(of: self).read(fromRawData: data, at: offset + 17)
            idleRPM = type(of: self).read(fromRawData: data, at: offset + 19)
            maxGears = type(of: self).read(fromRawData: data, at: offset + 21)
            drsAllowed = type(of: self).readEnum(fromRawData: data, at: offset + 22)
            drsActivationDistance = type(of: self).read(fromRawData: data, at: offset + 23)
            tyresWear = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 25)
            actualTyreCompound = type(of: self).readEnum(fromRawData: data, at: offset + 29)
            tyreVisualCompound = type(of: self).readEnum(fromRawData: data, at: offset + 30)
            tyresAgeLaps = type(of: self).read(fromRawData: data, at: offset + 31)
            tyresDamage = type(of: self).readArray(ofSize: 4, fromRawData: data, at: offset + 32)
            frontLeftWingDamage = type(of: self).read(fromRawData: data, at: offset + 35)
            frontRightWingDamage = type(of: self).read(fromRawData: data, at: offset + 37)
            rearWingDamage = type(of: self).read(fromRawData: data, at: offset + 38)
            drsFault = type(of: self).readEnum(fromRawData: data, at: offset + 39)
            engineDamage = type(of: self).read(fromRawData: data, at: offset + 40)
            gearBoxDamage = type(of: self).read(fromRawData: data, at: offset + 41)
            vehicleFIAFlags = type(of: self).readEnum(fromRawData: data, at: offset + 42)
            ersStoreEnergy = type(of: self).read(fromRawData: data, at: offset + 43)
            ersDeployMode = type(of: self).readEnum(fromRawData: data, at: offset + 47)
            ersHarvestedThisLapMGUK = type(of: self).read(fromRawData: data, at: offset + 48)
            ersHarvestedThisLapMGUH = type(of: self).read(fromRawData: data, at: offset + 52)
            ersDeployedThisLap = type(of: self).read(fromRawData: data, at: offset + 56)
        case .f1_2021:
            tractionControl = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            antiLockBrakes = type(of: self).readEnum(fromRawData: data, at: offset + 1)
            fuelMix = type(of: self).readEnum(fromRawData: data, at: offset + 2)
            frontBrakeBias = type(of: self).read(fromRawData: data, at: offset + 3)
            pitLimiterStatus = type(of: self).readEnum(fromRawData: data, at: offset + 4)
            fuelInTank = type(of: self).read(fromRawData: data, at: offset + 5)
            fuelCapacity = type(of: self).read(fromRawData: data, at: offset + 9)
            fuelRemainingLaps = type(of: self).read(fromRawData: data, at: offset + 13)
            maxRPM = type(of: self).read(fromRawData: data, at: offset + 17)
            idleRPM = type(of: self).read(fromRawData: data, at: offset + 19)
            maxGears = type(of: self).read(fromRawData: data, at: offset + 21)
            drsAllowed = type(of: self).readEnum(fromRawData: data, at: offset + 22)
            drsActivationDistance = type(of: self).read(fromRawData: data, at: offset + 23)
            actualTyreCompound = type(of: self).readEnum(fromRawData: data, at: offset + 25)
            tyreVisualCompound = type(of: self).readEnum(fromRawData: data, at: offset + 26)
            tyresAgeLaps = type(of: self).read(fromRawData: data, at: offset + 27)
            vehicleFIAFlags = type(of: self).readEnum(fromRawData: data, at: offset + 28)
            ersStoreEnergy = type(of: self).read(fromRawData: data, at: offset + 29)
            ersDeployMode = type(of: self).readEnum(fromRawData: data, at: offset + 33)
            ersHarvestedThisLapMGUK = type(of: self).read(fromRawData: data, at: offset + 34)
            ersHarvestedThisLapMGUH = type(of: self).read(fromRawData: data, at: offset + 38)
            ersDeployedThisLap = type(of: self).read(fromRawData: data, at: offset + 42)
            isNetworkPaused = type(of: self).readEnum(fromRawData: data, at: offset + 46)
        }
	}
	
}

extension TKCarStatusData: CustomStringConvertible {
	
	var description: String {
		return "fuel mix \(fuelMix), fuel remaining laps: \(fuelRemainingLaps), tyre compound: \(actualTyreCompound) (FIA: \(tyreVisualCompound), aged \(tyresAgeLaps) laps), ERS deployment: \(ersDeployMode)"
	}
	
}

internal struct TKCarStatusPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + (Self.DRIVERS_COUNT * TKCarStatusData.packetSize(forVersion: .f1_2020))
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (Self.DRIVERS_COUNT * TKCarStatusData.packetSize(forVersion: .f1_2021))
	
	var header: TKPacketHeader
	var carStatusData: [TKCarStatusData] // 22
	
	init() {
		header = TKPacketHeader()
		carStatusData = [TKCarStatusData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        default:
            carStatusData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0, forVersion: version)
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(carStatuses: carStatusData)
	}

}

extension TKCarStatusPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		for (index, csd) in carStatusData.enumerated() {
			lines.append("\t\tCar \(index + 1): \(csd.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
