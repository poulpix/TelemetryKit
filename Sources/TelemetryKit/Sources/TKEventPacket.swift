//
//  TKEventPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal enum TKEventDetails {
	
	case none
	case fastestLap(vehicleIdx: UInt8, lapTime: Float32)
	case retirement(vehicleIdx: UInt8)
	case teamMateInPits(vehicleIdx: UInt8)
	case raceWinner(vehicleIdx: UInt8)
	case penalty(penaltyType: TKPenaltyType, infringementType: TKInfringementType, vehicleIdx: UInt8, otherVehicleIdx: UInt8, time: UInt8, lapNum: UInt8, placesGained: UInt8)
	case speedTrapOld(vehicleIdx: UInt8, speed: Float32)
    case speedTrap(vehicleIdx: UInt8, speed: Float32, overallFastestInSession: TKBool, driverFastestInSession: TKBool)
    case startLights(numLights: UInt8) // New in F1 2021
    case driveThroughPenaltyServed(vehicleIdx: UInt8) // New in F1 2021
    case stopGoPenaltyServed(vehicleIdx: UInt8) // New in F1 2021
    case flashbackUsed(toFrameIdentifier: UInt32, toSessionTime: Float32) // New in F1 2021
    case buttonsPressed(buttonStatus: UInt32) // New in F1 2021
}

extension TKEventDetails: CustomStringConvertible {
	
	var description: String {
		switch self {
		case .none:
			return "-"
		case .fastestLap(vehicleIdx: let vehicleIdx, lapTime: let lapTime):
			return "driver no \(vehicleIdx) set new fastest lap of: \(lapTime)"
		case .retirement(vehicleIdx: let vehicleIdx):
			return "driver no \(vehicleIdx) retired from the race"
		case .teamMateInPits(vehicleIdx: let vehicleIdx):
			return "team mate is in the pits (driver no \(vehicleIdx))"
		case .raceWinner(vehicleIdx: let vehicleIdx):
			return "driver no \(vehicleIdx) has won the race"
		case .penalty(penaltyType: let penaltyType, infringementType: let infringementType, vehicleIdx: let vehicleIdx, otherVehicleIdx: _, time: _, lapNum: let lapNum, placesGained: _):
			return "driver no \(vehicleIdx) received a penalty \(penaltyType) on lap \(lapNum) for infringement \(infringementType)"
        case .speedTrapOld(vehicleIdx: let vehicleIdx, speed: let speed):
			return "driver no \(vehicleIdx) triggered speed trap at: \(speed) kph"
        case .speedTrap(vehicleIdx: let vehicleIdx, speed: let speed, overallFastestInSession: _, driverFastestInSession: _):
            return "driver no \(vehicleIdx) triggered speed trap at: \(speed) kph"
        case .startLights(numLights: let numLights):
            return "start lights: \(String(repeating: "🔴", count: Int(numLights)))"
        case .driveThroughPenaltyServed(vehicleIdx: let vehicleIdx):
            return "driver no \(vehicleIdx) served drive through penalty"
        case .stopGoPenaltyServed(vehicleIdx: let vehicleIdx):
            return "driver no \(vehicleIdx) served stop-go penalty"
        case .flashbackUsed(toFrameIdentifier: let frameIdentifier, toSessionTime: let sessionTime):
            return "used flashback to go back to session time at \(sessionTime) (frame ID: \(frameIdentifier))"
        case .buttonsPressed(buttonStatus: let buttonStatus):
            return "buttons pressed: \(buttonStatus)"
		}
	}
	
}

internal struct TKEventPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + 11
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + 11
	
	var header: TKPacketHeader
	var eventStringCode: [UInt8] // 4
	var eventDetails: TKEventDetails // variable
	
	var isValidPacket: Bool {
		return eventType != nil
	}
	
	var eventType: TKEventCode? {
		return TKEventCode(rawValue: String(bytes: eventStringCode, encoding: .ascii)!)
	}
	
	init() {
		header = TKPacketHeader()
		eventStringCode = [UInt8]()
		eventDetails = .none
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        eventStringCode = type(of: self).readArray(ofSize: 4, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
        switch version {
        case .unknown:
            return
        case .f1_2020:
            if let et = eventType {
                switch et {
                case .fastestLap:
                    eventDetails = .fastestLap(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), lapTime: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5))
                case .retirement:
                    eventDetails = .retirement(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .teamMateInPits:
                    eventDetails = .teamMateInPits(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .raceWinner:
                    eventDetails = .raceWinner(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .penaltyIssued:
                    eventDetails = .penalty(penaltyType: type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), infringementType: type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5), vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 6), otherVehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7), time: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 8), lapNum: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 9), placesGained: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 10))
                case .speedTrapTriggered:
                    eventDetails = .speedTrapOld(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), speed: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5))
                default:
                    eventDetails = .none
                }
            }
        case .f1_2021:
            if let et = eventType {
                switch et {
                case .fastestLap:
                    eventDetails = .fastestLap(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), lapTime: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5))
                case .retirement:
                    eventDetails = .retirement(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .teamMateInPits:
                    eventDetails = .teamMateInPits(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .raceWinner:
                    eventDetails = .raceWinner(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .penaltyIssued:
                    eventDetails = .penalty(penaltyType: type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), infringementType: type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5), vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 6), otherVehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7), time: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 8), lapNum: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 9), placesGained: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 10))
                case .speedTrapTriggered:
                    eventDetails = .speedTrap(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), speed: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 5), overallFastestInSession: type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 9), driverFastestInSession: type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 10))
                case .startLights:
                    eventDetails = .startLights(numLights: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .driveThroughServed:
                    eventDetails = .driveThroughPenaltyServed(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .stopGoServed:
                    eventDetails = .stopGoPenaltyServed(vehicleIdx: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                case .flashback:
                    eventDetails = .flashbackUsed(toFrameIdentifier: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4), toSessionTime: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 8))
                case .buttonStatus:
                    eventDetails = .buttonsPressed(buttonStatus: type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4))
                default:
                    eventDetails = .none
                }
            }
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		if let et = eventType {
			switch et {
			case .sessionStarted:
				delegate.sessionStarted()
			case .sessionEnded:
				delegate.sessionEnded()
			case .fastestLap:
				if case .fastestLap(let vIdx, let lapTime) = eventDetails {
					delegate.driver(no: vIdx, setNewFastestLap: lapTime)
				}
			case .retirement:
				if case .retirement(let vIdx) = eventDetails {
					delegate.driverRetired(no: vIdx)
				}
			case .drsEnabled:
				delegate.drsEnabled()
			case .drsDisabled:
				delegate.drsDisabled()
			case .teamMateInPits:
				if case .teamMateInPits(let vIdx) = eventDetails {
					delegate.driverTeamMateInPits(no: vIdx)
				}
			case .chequeredFlag:
				delegate.chequeredFlag()
			case .raceWinner:
				if case .raceWinner(let vIdx) = eventDetails {
					delegate.driverRaceWinner(no: vIdx)
				}
			case .penaltyIssued:
				if case .penalty(let pType, let iType, let vIdx, _, _, let lapNum, _) = eventDetails {
					delegate.driver(no: vIdx, gotPenalty: pType, forInfringement: iType, onLapNo: lapNum)
				}
			case .speedTrapTriggered:
				if case .speedTrapOld(let vIdx, let speed) = eventDetails {
					delegate.driver(no: vIdx, triggeredSpeedTrap: speed)
				}
                if case .speedTrap(let vIdx, let speed, _, _) = eventDetails {
                    delegate.driver(no: vIdx, triggeredSpeedTrap: speed)
                }
            case .startLights:
                if case .startLights(let numLights) = eventDetails {
                    delegate.startLights(nbLights: numLights)
                }
            case .lightsOut:
                delegate.lightsOut()
            case .driveThroughServed:
                if case .driveThroughPenaltyServed(let vIdx) = eventDetails {
                    delegate.driverServedDriveThroughPenalty(no: vIdx)
                }
            case .stopGoServed:
                if case .stopGoPenaltyServed(let vIdx) = eventDetails {
                    delegate.driverServedStopGoPenalty(no: vIdx)
                }
            case .flashback:
                if case .flashbackUsed(let frameID, let sessionTime) = eventDetails {
                    delegate.flashbackUsed(frameID: frameID, sessionTime: sessionTime)
                }
            case .buttonStatus:
                if case .buttonsPressed(let buttonStatus) = eventDetails {
                    delegate.buttonsPressed(buttons: buttonStatus)
                }
			}
		}
	}
	
}

extension TKEventPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\t\(String(bytes: eventStringCode, encoding: .ascii)!) – details: \(eventDetails.description)")
		return lines.joined(separator: "\n")
	}
	
}
