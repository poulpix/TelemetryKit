//
//  TKEnums.swift
//  TelemetryKit
//
//  Created by Romain on 11/08/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif

public enum TKF1Version: UInt16 {
    
    case unknown = 0
    case f1_2020 = 2020
    case f1_2021
    
}

extension TKF1Version {
    
    public var name: String {
        get {
            switch self {
            case .unknown:
                return "???"
            case .f1_2020:
                return "F1 2020"
            case .f1_2021:
                return "F1 2021"
            }
        }
    }
    
}

public enum TKBool: UInt8 {
	
	case yes
	case no
	
}

extension TKBool {
	
	public static func from(_ rawValue: Bool) -> TKBool {
		return rawValue ? .yes : .no
	}
	
	public var boolValue: Bool {
		return self == .yes
	}
	
	public var opposite: TKBool {
		switch self {
		case .yes:
			return .no
		case .no:
			return .yes
		}
	}
	
	public var asString: String {
		get {
			switch self {
			case .yes:
				return "yes"
			case .no:
				return "no"
			}
		}
		set {
		}
	}
	
}

public enum TKPacketType: UInt8 {
	
	case motion
	case session
	case lapData
	case event
	case participants
	case carSetups
	case carTelemetry
	case carStatus
	case finalClassification
	case lobbyInfo
    case carDamage // New in F1 2021
    case sessionHistory // New in F1 2021
	
}

public enum TKZoneFlag: Int8 {
	
	case invalid = -1
	case none
	case green
	case blue
	case yellow
	case red
	
}

extension TKZoneFlag {
	
	var name: String {
		switch self {
		case .invalid:
			return "???"
		case .none:
			return "none"
		case .green:
			return "green"
		case .blue:
			return "blue"
		case .yellow:
			return "yellow"
		case .red:
			return "red"
		}
	}
	
}

public enum TKWeather: UInt8 {
	
	case clear
	case lightCloud
	case overcast
	case lightRain
	case heavyRain
	case storm
	
}

extension TKWeather {
	
	public var emojiWeather: String {
		get {
			switch self {
			case .clear:
				return "☀️"
			case .lightCloud:
				return "🌤"
			case .overcast:
				return "☁️"
			case .lightRain:
				return "🌦"
			case .heavyRain:
				return "🌧"
			case .storm:
				return "⛈"
			}
		}
		set {
		}
	}
	
}

public enum TKSessionType: UInt8 {
	
	case unknown
	case p1
	case p2
	case p3
	case shortP
	case q1
	case q2
	case q3
	case shortQ
	case oneShotQ
	case r
	case r2
	case timeTrial
	
}

extension TKSessionType {
	
	public var name: String {
		get {
			switch self {
			case .unknown:
				return "???"
			case .p1:
				return "Practice 1"
			case .p2:
				return "Practice 2"
			case .p3:
				return "Practice 3"
			case .shortP:
				return "Short practice"
			case .q1:
				return "Q1"
			case .q2:
				return "Q2"
			case .q3:
				return "Q3"
			case .shortQ:
				return "Short qualifying"
			case .oneShotQ:
				return "One-shot qualifying"
			case .r:
				return "Race"
			case .r2:
				return "Race 2"
			case .timeTrial:
				return "Time trial"
			}
		}
		set {
		}
	}
	
	var isRaceSession: Bool {
		return (self == .r) || (self == .r2)
	}
	
	var isQualifyingSession: Bool {
		return (self == .q1) || (self == .q2) || (self == .q3) || (self == .shortQ) || (self == .oneShotQ)
	}
	
}

// New in F1 2021
public enum TKMetricChange: Int8 {
    
    case up
    case down
    case noChange
    
}

extension TKMetricChange {
    
    var name: String {
        switch self {
        case .up:
            return "↗️"
        case .down:
            return "↘️"
        case .noChange:
            return "➡️"
        }
    }
    
}

// New in F1 2021
public enum TKBrakingAssistType: UInt8 {
    
    case off
    case low
    case medium
    case high
    
}

extension TKBrakingAssistType {
    
    var name: String {
        switch self {
        case .off:
            return "⏹"
        case .low:
            return "🔽"
        case .medium:
            return "▶️"
        case .high:
            return "🔼"
        }
    }
    
}

// New in F1 2021
public enum TKGearboxAssistType: UInt8 {
    
    case manual = 1
    case manualSuggestedGear
    case auto
    
}

extension TKGearboxAssistType {
    
    var name: String {
        switch self {
        case .manual:
            return "🔴"
        case .manualSuggestedGear:
            return "🟠"
        case .auto:
            return "🟢"
        }
    }
    
}

// New in F1 2021
public enum TKDynamicRacingLineType: UInt8 {
    
    case off
    case cornersOnly
    case full
    
}

extension TKDynamicRacingLineType {
    
    var name: String {
        switch self {
        case .off:
            return "✖️"
        case .cornersOnly:
            return "➰"
        case .full:
            return "✔️"
        }
    }
    
}

public enum TKTrack: Int8 {
	
	case unknown = -1
	case melbourne
	case paulRicard
	case shanghai
	case sakhir
	case catalunya
	case monaco
	case montreal
	case silverstone
	case hockenheim
	case hungaroring
	case spa
	case monza
	case singapore
	case suzuka
	case abuDhabi
	case texas
	case brazil
	case austria
	case sochi
	case mexico
	case baku
	case sakhirShort
	case silverstoneShort
	case texasShort
	case suzukaShort
	case hanoi
	case zandvoort
    case imola // New in F1 2021
    case portimao // New in F1 2021
    case jeddah // New in F1 2021
	
}

extension TKTrack {
	
	public var emojiFlag: String {
		switch self {
		case .unknown:
			return "🏳️"
		case .melbourne:
			return "🇦🇺"
		case .paulRicard:
			return "🇫🇷"
		case .shanghai:
			return "🇨🇳"
		case .sakhir:
			return "🇧🇭"
		case .catalunya:
			return "🇪🇸"
		case .monaco:
			return "🇲🇨"
		case .montreal:
			return "🇨🇦"
		case .silverstone:
			return "🇬🇧"
		case .hockenheim:
			return "🇩🇪"
		case .hungaroring:
			return "🇭🇺"
		case .spa:
			return "🇧🇪"
		case .monza:
			return "🇮🇹"
		case .singapore:
			return "🇸🇬"
		case .suzuka:
			return "🇯🇵"
		case .abuDhabi:
			return "🇦🇪"
		case .texas:
			return "🇺🇸"
		case .brazil:
			return "🇧🇷"
		case .austria:
			return "🇦🇹"
		case .sochi:
			return "🇷🇺"
		case .mexico:
			return "🇲🇽"
		case .baku:
			return "🇦🇿"
		case .sakhirShort:
			return "🇧🇭"
		case .silverstoneShort:
			return "🇬🇧"
		case .texasShort:
			return "🇺🇸"
		case .suzukaShort:
			return "🇯🇵"
		case .hanoi:
			return "🇻🇳"
		case .zandvoort:
			return "🇳🇱"
        case .imola:
            return "🇮🇹"
        case .portimao:
            return "🇵🇹"
        case .jeddah:
            return "🇸🇦"
		}
	}
	
	public var trackName: String {
		switch self {
		case .unknown:
			return "???"
		case .melbourne:
			return "Melbourne"
		case .paulRicard:
			return "Le Castellet"
		case .shanghai:
			return "Shanghai"
		case .sakhir:
			return "Sakhir"
		case .catalunya:
			return "Catalunya"
		case .monaco:
			return "Monaco"
		case .montreal:
			return "Montreal"
		case .silverstone:
			return "Silverstone"
		case .hockenheim:
			return "Hockenheim"
		case .hungaroring:
			return "Hungaroring"
		case .spa:
			return "Spa-Francorchamps"
		case .monza:
			return "Monza"
		case .singapore:
			return "Singapore"
		case .suzuka:
			return "Suzuka"
		case .abuDhabi:
			return "Abu Dhabi"
		case .texas:
			return "Austin"
		case .brazil:
			return "Interlagos"
		case .austria:
			return "Spielberg"
		case .sochi:
			return "Sochi"
		case .mexico:
			return "Mexico"
		case .baku:
			return "Baku"
		case .sakhirShort:
			return "Sakhir (short)"
		case .silverstoneShort:
			return "Silverstone (short)"
		case .texasShort:
			return "Austin (short)"
		case .suzukaShort:
			return "Suzuka (short)"
		case .hanoi:
			return "Hanoi"
		case .zandvoort:
			return "Zandvoort"
        case .imola:
            return "Imola"
        case .portimao:
            return "Portimāo"
        case .jeddah:
            return "Jeddah"
		}
	}
	
	public var trackNameAndFlag: String {
		get {
			return "\(emojiFlag) \(trackName)"
		}
		set {
		}
	}
	
}

public enum TKFormula: UInt8 {
	
	case f1modern
	case f1classic
	case f2
	case f1generic
	
}

extension TKFormula {
	
	public var name: String {
		get {
			switch self {
			case .f1modern:
				return "F1"
			case .f1classic:
				return "F1 Classic"
			case .f2:
				return "F2"
			case .f1generic:
				return "F1 Generic"
			}
		}
		set {
		}
	}
	
}

public enum TKSafetyCarStatus: UInt8 {
	
	case noSafetyCar
	case fullSafetyCar
	case virtualSafetyCar
	case formationLap
	
}

extension TKSafetyCarStatus {
	
	public var name: String {
		get {
			switch self {
			case .noSafetyCar:
				return "no safety car"
			case .fullSafetyCar:
				return "safety car on track"
			case .virtualSafetyCar:
				return "virtual safety car (VSC)"
			case .formationLap:
				return "formation lap"
			}
		}
		set {
		}
	}
	
}

public enum TKPitStatus: UInt8 {
	
	case none
	case pitting
	case inPitArea
	
}

extension TKPitStatus {
	
	var name: String {
		switch self {
		case .none:
			return "on track"
		case .pitting:
			return "pitting"
		case .inPitArea:
			return "in pit area"
		}
	}
	
}

public enum TKSector: UInt8 {
	
	case sector1
	case sector2
	case sector3
	
}

public enum TKDriverStatus: UInt8 {
	
	case inGarage
	case flyingLap
	case inLap
	case outLap
	case onTrack
	
}

extension TKDriverStatus {
	
	var name: String {
		switch self {
		case .inGarage:
			return "in garage"
		case .flyingLap:
			return "flying lap"
		case .inLap:
			return "in lap"
		case .outLap:
			return "out lap"
		case .onTrack:
			return "on track"
		}
	}
	
}

public enum TKResultStatus: UInt8 {
	
	case invalid
	case inactive
	case active
	case finished
    case didNotFinish
	case disqualified
	case notClassified
	case retired
	
}

extension TKResultStatus {
	
	var name: String {
		switch self {
		case .invalid:
			return "???"
		case .inactive:
			return "inactive"
		case .active:
			return "active"
		case .finished:
			return "finished"
        case .didNotFinish:
            return "did not finish"
		case .disqualified:
			return "disqualified"
		case .notClassified:
			return "not classified"
		case .retired:
			return "retired"
		}
	}
	
}

internal enum TKPosition: Int8 {
	
	case behind = -1
	case ahead
	case p1
	case p2
	case p3
	case p4
	case p5
	case p6
	case p7
	case p8
	case p9
	case p10
	case p11
	case p12
	case p13
	case p14
	case p15
	case p16
	case p17
	case p18
	case p19
	case p20
	case last
	
}

internal enum TKEventCode: String {
	
	case sessionStarted = "SSTA"
	case sessionEnded = "SEND"
	case fastestLap = "FTLP"
	case retirement = "RTMT"
	case drsEnabled = "DRSE"
	case drsDisabled = "DRSD"
	case teamMateInPits = "TMPT"
	case chequeredFlag = "CHQF"
	case raceWinner = "RCWN"
	case penaltyIssued = "PENA"
	case speedTrapTriggered = "SPTP"
    case startLights = "STLG" // New in F1 2021
    case lightsOut = "LGOT" // New in F1 2021
    case driveThroughServed = "DTSV" // New in F1 2021
    case stopGoServed = "SGSV" // New in F1 2021
    case flashback = "FLBK" // New in F1 2021
    case buttonStatus = "BUTN" // New in F1 2021
	
}

public enum TKPenaltyType: UInt8 {
    
	case driveThrough
	case stopGo
	case gridPenalty
	case penaltyReminder
	case timePenalty
	case warning
	case disqualified
	case removedFromFormationLap
	case parkedTooLongTimer
	case tyreRegulations
	case thisLapInvalidated
	case thisAndNextLapInvalidated
	case thisLapInvalidatedWithoutReason
	case thisAndNextLapInvalidatedWithoutReason
	case thisAndPreviousLapInvalidated
	case thisAndPreviousLapInvalidatedWithoutReason
	case retired
	case blackFlagTimer
    
}

public enum TKInfringementType: UInt8 {
    
	case blockingBySlowDriving
	case blockingByWrongWayDriving
	case reversingOffTheStartLine
	case bigCollision
	case smallCollision
	case collisionFailedToHandBackPositionSingle
	case collisionFailedToHandBackPositionMultiple
	case cornerCuttingGainedTime
	case cornerCuttingOvertakeSingle
	case cornerCuttingOvertakeMultiple
	case crossedPitExitLane
	case ignoringBlueFlags
	case ignoringYellowFlags
	case ignoringDriveThrough
	case tooManyDriveThroughs
	case driveThroughReminderServeWithinNLaps
	case driveThroughReminderServeThisLap
	case pitLaneSpeeding
	case parkedForTooLong
	case ignoringTyreRegulations
	case tooManyPenalties
	case multipleWarnings
	case approachingDisqualification
	case tyreRegulationsSelectSingle
	case tyreRegulationsSelectMultiple
	case lapInvalidatedCornerCutting
	case lapInvalidatedRunningWide
	case cornerCuttingRanWideGainedTimeMinor
	case cornerCuttingRanWideGainedTimeSignificant
	case cornerCuttingRanWideGainedTimeExtreme
	case lapInvalidatedWallRiding
	case lapInvalidatedFlashbackUsed
	case lapInvalidatedResetToTrack
	case blockingThePitlane
	case jumpStart
	case safetyCarToCarCollision
	case safetyCarIllegalOvertake
	case safetyCarExceedingAllowedPace
	case virtualSafetyCarExceedingAllowedPace
	case formationLapBelowAllowedSpeed
	case retiredMechanicalFailure
	case retiredTerminallyDamaged
	case safetyCarFallingTooFarBack
	case blackFlagTimer
	case unservedStopGoPenalty
	case unservedDriveThroughPenalty
	case engineComponentChange
	case gearboxChange
	case leagueGridPenalty
	case retryPenalty
	case illegalTimeGain
	case mandatoryPitstop
	
}

public struct TKPlayerData {

    public static var playerFirstName = TKListener.DEFAULT_PLAYER_FIRST_NAME
    public static var playerFamilyName = TKListener.DEFAULT_PLAYER_FAMILY_NAME
    public static var playerTrigram = TKListener.DEFAULT_PLAYER_TRIGRAM
    public static var playerMyTeamName = TKListener.DEFAULT_MY_TEAM_NAME
    
    public static func set(firstName: String, familyName: String, trigram: String, myTeamName: String) {
        playerFirstName = firstName
        playerFamilyName = familyName
        playerTrigram = trigram
        playerMyTeamName = myTeamName
    }
    
}

public enum TKDriver: UInt8, CaseIterable {

	case carlosSainz
	case daniilKvyat
	case danielRicciardo
    case fernandoAlonso // New in F1 2021
    case felipeMassa // New in F1 2021
	case kimiRaikkonen = 6
	case lewisHamilton
	case maxVerstappen = 9
	case nicoHulkenberg
	case kevinMagnussen
	case romainGrosjean
	case sebastianVettel
	case sergioPerez
	case valtteriBottas
	case estebanOcon = 17
	case lanceStroll = 19
	case aaronBarnes
	case martinGiles
	case alexMurray
	case lucasRoth
	case igorCorreia
	case sophieLevasseur
	case jonasSchiffer
	case alainForest
	case jayLetourneau
	case estoSaari
	case yasarAtiyeh
	case callistoCalabresi
	case naotaIzum
	case howardClarke
	case wilhelmKaufmann
	case marieLaursen
	case flavioNieves
	case peterBelousov
	case klimekMichalski
	case santiagoMoreno
	case benjaminCoppens
	case noahVisser
	case gertWaldmuller
	case julianQuesada
	case danielJones
	case artemMarkelov
	case tadasukeMakino
	case seanGelael
	case nyckDeVries
	case jackAitken
	case georgeRussell
	case maximilianGunther
	case nireiFukuzumi
	case lucaGhiotto
	case landoNorris
	case sergioSetteCamara
	case louisDeletraz
	case antonioFuoco
	case charlesLeclerc
	case pierreGasly
	case alexanderAlbon = 62
	case nicholasLatifi
	case dorianBoccolacci
	case nikoKari
	case robertoMerhi
	case arjunMaini
	case alessioLorandi
	case rubenMeijer
	case rashidNair
	case jackTremblay
	case devonButler
	case lukasWeber
	case antonioGiovinazzi
	case robertKubica
    case alainProst // New in F1 2021
    case ayrtonSenna // New in F1 2021
	case nobuharuMatsushita
	case nikitaMazepin
	case guanyaZhou
	case mickSchumacher
	case callumIlott
	case juanManuelCorrea
	case jordanKing
	case mahaveerRaghunathan
	case tatianaCalderon
	case anthoineHubert
	case giulianoAlesi
	case ralphBoschung
    case michaelSchumacher // New in F1 2021
	case danTicktum
	case marcusArmstrong
	case christianLundgaard
	case yukiTsunoda
	case jehanDaruvala
	case guilhermeSamaia
	case pedroPiquet
	case felipeDrugovich
	case robertShwartzman
    case royNissany
    case marinoSato
    case aidenJackson // New in F1 2021
    case casperAkkerman // New in F1 2021
    case jensonButton = 109 // New in F1 2021
    case davidCoulthard // New in F1 2021
    case nicoRosberg // New in F1 2021
	case unknownDriver = 254 // RLT: added to handle cases where team ID is not found in the enum
	case onlinePlayer // RLT: added to handle multiplayer games
	
}

extension TKDriver {
	
	var firstName: String {
		get {
			switch self {
			case .carlosSainz:
				return "Carlos"
			case .daniilKvyat:
				return "Daniil"
			case .danielRicciardo:
				return "Daniel"
            case .fernandoAlonso:
                return "Fernando"
            case .felipeMassa:
                return "Felipe"
			case .kimiRaikkonen:
				return "Kimi"
			case .lewisHamilton:
				return "Lewis"
			case .maxVerstappen:
				return "Max"
			case .nicoHulkenberg:
				return "Nico"
			case .kevinMagnussen:
				return "Kevin"
			case .romainGrosjean:
				return "Romain"
			case .sebastianVettel:
				return "Sebastian"
			case .sergioPerez:
				return "Sergio"
			case .valtteriBottas:
				return "Valtteri"
			case .estebanOcon:
				return "Esteban"
			case .lanceStroll:
				return "Lance"
			case .aaronBarnes:
				return "Aaron"
			case .martinGiles:
				return "Martin"
			case .alexMurray:
				return "Alex"
			case .lucasRoth:
				return "Lucas"
			case .igorCorreia:
				return "Igor"
			case .sophieLevasseur:
				return "Sophie"
			case .jonasSchiffer:
				return "Jonas"
			case .alainForest:
				return "Alain"
			case .jayLetourneau:
				return "Jay"
			case .estoSaari:
				return "Esto"
			case .yasarAtiyeh:
				return "Yasar"
			case .callistoCalabresi:
				return "Callisto"
			case .naotaIzum:
				return "Naota"
			case .howardClarke:
				return "Howard"
			case .wilhelmKaufmann:
				return "Wilhelm"
			case .marieLaursen:
				return "Marie"
			case .flavioNieves:
				return "Flavio"
			case .peterBelousov:
				return "Peter"
			case .klimekMichalski:
				return "Klimek"
			case .santiagoMoreno:
				return "Santiago"
			case .benjaminCoppens:
				return "Benjamin"
			case .noahVisser:
				return "Noah"
			case .gertWaldmuller:
				return "Gert"
			case .julianQuesada:
				return "Julian"
			case .danielJones:
				return "Daniel"
			case .artemMarkelov:
				return "Artem"
			case .tadasukeMakino:
				return "Tadasuke"
			case .seanGelael:
				return "Sean"
			case .nyckDeVries:
				return "Nyck"
			case .jackAitken:
				return "Jack"
			case .georgeRussell:
				return "George"
			case .maximilianGunther:
				return "Maximilian"
			case .nireiFukuzumi:
				return "Nirei"
			case .lucaGhiotto:
				return "Luca"
			case .landoNorris:
				return "Lando"
			case .sergioSetteCamara:
				return "Sergio"
			case .louisDeletraz:
				return "Louis"
			case .antonioFuoco:
				return "Antonio"
			case .charlesLeclerc:
				return "Charles"
			case .pierreGasly:
				return "Pierre"
			case .alexanderAlbon:
				return "Alexander"
			case .nicholasLatifi:
				return "Nicholas"
			case .dorianBoccolacci:
				return "Dorian"
			case .nikoKari:
				return "Niko"
			case .robertoMerhi:
				return "Roberto"
			case .arjunMaini:
				return "Arjun"
			case .alessioLorandi:
				return "Alessio"
			case .rubenMeijer:
				return "Ruben"
			case .rashidNair:
				return "Rashid"
			case .jackTremblay:
				return "Jack"
			case .devonButler:
				return "Devon"
			case .lukasWeber:
				return "Lukas"
			case .antonioGiovinazzi:
				return "Antonio"
			case .robertKubica:
				return "Robert"
            case .alainProst:
                return "Alain"
            case .ayrtonSenna:
                return "Ayrton"
			case .nobuharuMatsushita:
				return "Nobuharu"
			case .nikitaMazepin:
				return "Nikita"
			case .guanyaZhou:
				return "Guanya"
			case .mickSchumacher:
				return "Mick"
			case .callumIlott:
				return "Callum"
			case .juanManuelCorrea:
				return "Juan Manuel"
			case .jordanKing:
				return "Jordan"
			case .mahaveerRaghunathan:
				return "Mahaveer"
			case .tatianaCalderon:
				return "Tatiana"
			case .anthoineHubert:
				return "Anthoine"
			case .giulianoAlesi:
				return "Giuliano"
			case .ralphBoschung:
				return "Ralph"
            case .michaelSchumacher:
                return "Michael"
			case .danTicktum:
				return "Dan"
			case .marcusArmstrong:
				return "Marcus"
			case .christianLundgaard:
				return "Christian"
			case .yukiTsunoda:
				return "Yuki"
			case .jehanDaruvala:
				return "Jehan"
			case .guilhermeSamaia:
				return "Guilherme"
			case .pedroPiquet:
				return "Pedro"
			case .felipeDrugovich:
				return "Felipe"
			case .robertShwartzman:
				return "Robert"
			case .royNissany:
				return "Roy"
			case .marinoSato:
				return "Marino"
            case .aidenJackson:
                return "Aiden"
            case .casperAkkerman:
                return "Casper"
            case .jensonButton:
                return "Jenson"
            case .davidCoulthard:
                return "David"
            case .nicoRosberg:
                return "Nico"
			case .unknownDriver:
				return "Unknown"
			case .onlinePlayer:
				return "Online"
			}
		}
		set {
		}
	}
	
	var name: String {
		get {
			switch self {
			case .carlosSainz:
				return "Sainz"
			case .daniilKvyat:
				return "Kvyat"
			case .danielRicciardo:
				return "Ricciardo"
            case .fernandoAlonso:
                return "Alonso"
            case .felipeMassa:
                return "Massa"
			case .kimiRaikkonen:
				return "Raïkkönen"
			case .lewisHamilton:
				return "Hamilton"
			case .maxVerstappen:
				return "Verstappen"
			case .nicoHulkenberg:
				return "Hülkenberg"
			case .kevinMagnussen:
				return "Magnussen"
			case .romainGrosjean:
				return "Grosjean"
			case .sebastianVettel:
				return "Vettel"
			case .sergioPerez:
				return "Perez"
			case .valtteriBottas:
				return "Bottas"
			case .estebanOcon:
				return "Ocon"
			case .lanceStroll:
				return "Stroll"
			case .aaronBarnes:
				return "Barnes"
			case .martinGiles:
				return "Giles"
			case .alexMurray:
				return "Murray"
			case .lucasRoth:
				return "Roth"
			case .igorCorreia:
				return "Correia"
			case .sophieLevasseur:
				return "Levasseur"
			case .jonasSchiffer:
				return "Schiffer"
			case .alainForest:
				return "Forest"
			case .jayLetourneau:
				return "Letourneau"
			case .estoSaari:
				return "Saari"
			case .yasarAtiyeh:
				return "Atiyeh"
			case .callistoCalabresi:
				return "Calabresi"
			case .naotaIzum:
				return "Izum"
			case .howardClarke:
				return "Clarke"
			case .wilhelmKaufmann:
				return "Kaufmann"
			case .marieLaursen:
				return "Laursen"
			case .flavioNieves:
				return "Nieves"
			case .peterBelousov:
				return "Belousov"
			case .klimekMichalski:
				return "Michalski"
			case .santiagoMoreno:
				return "Moreno"
			case .benjaminCoppens:
				return "Coppens"
			case .noahVisser:
				return "Visser"
			case .gertWaldmuller:
				return "Waldmuller"
			case .julianQuesada:
				return "Quesada"
			case .danielJones:
				return "Jones"
			case .artemMarkelov:
				return "Markelov"
			case .tadasukeMakino:
				return "Makino"
			case .seanGelael:
				return "Gelael"
			case .nyckDeVries:
				return "De Vries"
			case .jackAitken:
				return "Aitken"
			case .georgeRussell:
				return "Russell"
			case .maximilianGunther:
				return "Gunther"
			case .nireiFukuzumi:
				return "Fukuzumi"
			case .lucaGhiotto:
				return "Ghiotto"
			case .landoNorris:
				return "Norris"
			case .sergioSetteCamara:
				return "Sette Camara"
			case .louisDeletraz:
				return "Deletraz"
			case .antonioFuoco:
				return "Fuoco"
			case .charlesLeclerc:
				return "Leclerc"
			case .pierreGasly:
				return "Gasly"
			case .alexanderAlbon:
				return "Albon"
			case .nicholasLatifi:
				return "Latifi"
			case .dorianBoccolacci:
				return "Boccolacci"
			case .nikoKari:
				return "Kari"
			case .robertoMerhi:
				return "Merhi"
			case .arjunMaini:
				return "Maini"
			case .alessioLorandi:
				return "Lorandi"
			case .rubenMeijer:
				return "Meijer"
			case .rashidNair:
				return "Nair"
			case .jackTremblay:
				return "Tremblay"
			case .devonButler:
				return "Butler"
			case .lukasWeber:
				return "Weber"
			case .antonioGiovinazzi:
				return "Giovinazzi"
			case .robertKubica:
				return "Kubica"
            case .alainProst:
                return "Prost"
            case .ayrtonSenna:
                return "Senna"
			case .nobuharuMatsushita:
				return "Matsushita"
			case .nikitaMazepin:
				return "Mazepin"
			case .guanyaZhou:
				return "Zhou"
			case .mickSchumacher:
				return "Schumacher"
			case .callumIlott:
				return "Ilott"
			case .juanManuelCorrea:
				return "Correa"
			case .jordanKing:
				return "King"
			case .mahaveerRaghunathan:
				return "Raghunathan"
			case .tatianaCalderon:
				return "Calderón"
			case .anthoineHubert:
				return "Hubert"
			case .giulianoAlesi:
				return "Alesi"
			case .ralphBoschung:
				return "Boschung"
            case .michaelSchumacher:
                return "Schumacher"
			case .danTicktum:
				return "Ticktum"
			case .marcusArmstrong:
				return "Armstrong"
			case .christianLundgaard:
				return "Lundgaard"
			case .yukiTsunoda:
				return "Tsunoda"
			case .jehanDaruvala:
				return "Daruvala"
			case .guilhermeSamaia:
				return "Samaia"
			case .pedroPiquet:
				return "Piquet"
			case .felipeDrugovich:
				return "Drugovich"
			case .robertShwartzman:
				return "Shwartzman"
			case .royNissany:
				return "Nissany"
			case .marinoSato:
				return "Sato"
            case .aidenJackson:
                return "Jackson"
            case .casperAkkerman:
                return "Akkerman"
            case .jensonButton:
                return "Button"
            case .davidCoulthard:
                return "Coulthard"
            case .nicoRosberg:
                return "Rosberg"
			case .unknownDriver:
				return "Driver"
			case .onlinePlayer:
				return "Player"
			}
		}
		set {
		}
	}
	
	var fullName: String {
		get {
			return "\(firstName) \(name)"
		}
		set {
		}
	}
	
	var trigram: String {
		get {
			switch self {
			case .unknownDriver:
				return "???"
			case .onlinePlayer:
				return "XXX"
			default:
				return name.replacingOccurrences(of: " ", with: "").prefix(3).uppercased().folding(options: .diacriticInsensitive, locale: nil)
			}
		}
		set {
		}
	}
	
	// TODO
	var pronunciationKey: String {
		switch self {
		case .lewisHamilton:
			return "lø.ˈwi.sə"
		default:
			return name
		}
	}
	
	static func driver(withFullName fullName: String) -> TKDriver? {
		return TKDriver.allCases.filter { $0.fullName == fullName }.first
	}
	
}

public enum TKTeam: UInt8, CaseIterable {
	
	case mercedes
	case ferrari
	case redBullRacing
	case williams
	case astonMartin
	case alpine
	case alphaTauri
	case haas
	case mcLaren
	case alfaRomeo
	case mcLaren1988
	case mcLaren1991
	case williams1992
	case ferrari1995
	case williams1996
	case mcLaren1998
	case ferrari2002
	case ferrari2004
	case renault2006
	case ferrari2007
	case mcLaren2008
	case redBullRacing2010
	case ferrari1976
	case artGrandPrix
	case camposVexatecRacing
	case carlin
	case charouzRacingSystem
	case dams
	case russianTime
	case mpMotorsport
	case pertamina
	case mcLaren1990
	case trident
	case bwtArden
	case mcLaren1976
	case lotus1972
	case ferrari1979
	case mcLaren1982
	case williams2003
	case brawn2009
	case lotus1978
	case f1Generic
	case artGrandPrix2019
	case campos2019
	case carlin2019
	case sauberJuniorCharouz2019
	case dams2019
	case uniVirtuosi2019
	case mpMotorsport2019
	case prema2019
	case trident2019
	case arden2019
	case benetton1994
	case benetton1995
	case ferrari2000
	case jordan1991
	case ferrari1990 = 63 // RLT: added those 3, which are missing from the docs (in F1 2020)
	case mclaren2010
	case ferrari2010
    case artGrandPrix2020 = 70
    case campos2020
    case carlin2020
    case charouz2020
    case dams2020
    case uniVirtuosi2020
    case mpMotorsport2020
    case prema2020
    case trident2020
    case bwt2020
    case hitech2020
    case mercedes2020 = 85 // New in F1 2021
    case ferrari2020 // New in F1 2021
    case redBullRacing2020 // New in F1 2021
    case williams2020 // New in F1 2021
    case racingPoint2020 // New in F1 2021
    case renault2020 // New in F1 2021
    case alphaTauri2020 // New in F1 2021
    case haas2020 // New in F1 2021
    case mcLaren2020 // New in F1 2021
    case alfaRomeo2020 // New in F1 2021
	case unknownTeam = 254 // RLT: added to handle cases where team ID is not found in the enum
	case myTeam
	
}

extension TKTeam {
	
    var name: String {
		switch self {
		case .mercedes:
			return "Mercedes"
		case .ferrari:
			return "Ferrari"
		case .redBullRacing:
			return "Red Bull Racing"
		case .williams:
			return "Williams"
		case .astonMartin:
            return (TKListener.shared.telemetryVersion == .f1_2021) ? "Aston Martin" : "Racing Point"
		case .alpine:
            return (TKListener.shared.telemetryVersion == .f1_2021) ? "Alpine" : "Renault"
		case .alphaTauri:
			return "Alpha Tauri"
		case .haas:
			return "Haas"
		case .mcLaren:
			return "McLaren"
		case .alfaRomeo:
			return "Alfa Romeo"
		case .mcLaren1988:
			return "McLaren (1988)"
		case .mcLaren1991:
			return "McLaren (1991)"
		case .williams1992:
			return "Williams (1992)"
		case .ferrari1995:
			return "Ferrari (1995)"
		case .williams1996:
			return "Williams (1996)"
		case .mcLaren1998:
			return "McLaren (1998)"
		case .ferrari2002:
			return "Ferrari (2002)"
		case .ferrari2004:
			return "Ferrari (2004)"
		case .renault2006:
			return "Renault (2006)"
		case .ferrari2007:
			return "Ferrari (2007)"
		case .mcLaren2008:
			return "McLaren (2008)"
		case .redBullRacing2010:
			return "Red Bull Racing (2010)"
		case .ferrari1976:
			return "Ferrari (1976)"
		case .artGrandPrix:
			return "ART Grand Prix"
		case .camposVexatecRacing:
			return "Campos Vexatec Racing"
		case .carlin:
			return "Carlin"
		case .charouzRacingSystem:
			return "Charouz Racing System"
		case .dams:
			return "DAMS"
		case .russianTime:
			return "Russian Time"
		case .mpMotorsport:
			return "MP Motorsport"
		case .pertamina:
			return "Pertamina"
		case .mcLaren1990:
			return "McLaren (1990)"
		case .trident:
			return "Trident"
		case .bwtArden:
			return "BWT Arden"
		case .mcLaren1976:
			return "McLaren (1976)"
		case .lotus1972:
			return "Lotus (1972)"
		case .ferrari1979:
			return "Ferrari (1979)"
		case .mcLaren1982:
			return "McLaren (1982)"
		case .williams2003:
			return "Williams (2003)"
		case .brawn2009:
			return "Brawn GP (2009)"
		case .lotus1978:
			return "Lotus (1978)"
		case .f1Generic:
			return "F1 Generic"
		case .artGrandPrix2019:
			return "ART Grand Prix"
		case .campos2019:
			return "Campos"
		case .carlin2019:
			return "Carlin"
		case .sauberJuniorCharouz2019:
			return "Sauber Junior Charouz"
		case .dams2019:
			return "DAMS"
		case .uniVirtuosi2019:
			return "UNI-Virtuosi"
		case .mpMotorsport2019:
			return "MP Motorsport"
		case .prema2019:
			return "Prema"
		case .trident2019:
			return "Trident"
		case .arden2019:
			return "Arden"
		case .benetton1994:
			return "Benetton (1994)"
		case .benetton1995:
			return "Benetton (1995)"
		case .ferrari2000:
			return "Ferrari (2000)"
		case .jordan1991:
			return "Jordan (1991)"
		case .ferrari1990:
			return "Ferrari (1990)"
		case .mclaren2010:
			return "McLaren (2010)"
		case .ferrari2010:
			return "Ferrari (2010)"
        case .artGrandPrix2020:
            return "ART Grand Prix"
        case .campos2020:
            return "Campos Racing"
        case .carlin2020:
            return "Carlin"
        case .charouz2020:
            return "Charouz Racing System"
        case .dams2020:
            return "DAMS"
        case .uniVirtuosi2020:
            return "UNI-Virtuosi Racing"
        case .mpMotorsport2020:
            return "MP Motorsport"
        case .prema2020:
            return "Prema Racing"
        case .trident2020:
            return "Trident"
        case .bwt2020:
            return "BWT HWA RACELAB"
        case .hitech2020:
            return "Hitech Grand Prix"
        case .mercedes2020:
            return "Mercedes"
        case .ferrari2020:
            return "Ferrari"
        case .redBullRacing2020:
            return "Red Bull Racing"
        case .williams2020:
            return "Williams"
        case .racingPoint2020:
            return "Racing Point"
        case .renault2020:
            return "Renault"
        case .alphaTauri2020:
            return "Alpha Tauri"
        case .haas2020:
            return "Haas"
        case .mcLaren2020:
            return "McLaren"
        case .alfaRomeo2020:
            return "Alfa Romeo"
        case .unknownTeam:
			return "Unknown team"
		case .myTeam:
            return TKPlayerData.playerMyTeamName
		}
	}
	
    var audioName: String {
		switch self {
		case .mercedes:
			return "Mercedes"
		case .ferrari:
			return "Ferraris"
		case .redBullRacing:
			return "Red Bulls"
		case .williams:
			return "Williams"
        case .astonMartin:
            return (TKListener.shared.telemetryVersion == .f1_2021) ? "Aston Martins" : "Racing Points"
        case .alpine:
            return (TKListener.shared.telemetryVersion == .f1_2021) ? "Alpines" : "Renaults"
		case .alphaTauri:
			return "Alpha Tauris"
		case .haas:
			return "Haas"
		case .mcLaren:
			return "McLarens"
		case .alfaRomeo:
			return "Alfa Romeos"
		case .mcLaren1988:
			return "McLarens"
		case .mcLaren1991:
			return "McLarens"
		case .williams1992:
			return "Williams"
		case .ferrari1995:
			return "Ferraris"
		case .williams1996:
			return "Williams"
		case .mcLaren1998:
			return "McLarens"
		case .ferrari2002:
			return "Ferraris"
		case .ferrari2004:
			return "Ferraris"
		case .renault2006:
			return "Renaults"
		case .ferrari2007:
			return "Ferraris"
		case .mcLaren2008:
			return "McLarens"
		case .redBullRacing2010:
			return "Red Bulls"
		case .ferrari1976:
			return "Ferraris"
		case .artGrandPrix:
			return "ARTs"
		case .camposVexatecRacing:
			return "Campos"
		case .carlin:
			return "Carlins"
		case .charouzRacingSystem:
			return "Charouz"
		case .dams:
			return "DAMS"
		case .russianTime:
			return "Russian Times"
		case .mpMotorsport:
			return "MPs"
		case .pertamina:
			return "Pertaminas"
		case .mcLaren1990:
			return "McLarens"
		case .trident:
			return "Tridents"
		case .bwtArden:
			return "Ardens"
		case .mcLaren1976:
			return "McLarens"
		case .lotus1972:
			return "Lotuses"
		case .ferrari1979:
			return "Ferraris"
		case .mcLaren1982:
			return "McLarens"
		case .williams2003:
			return "Williams"
		case .brawn2009:
			return "Brawns"
		case .lotus1978:
			return "Lotuses"
		case .f1Generic:
			return "F1 Generics"
		case .artGrandPrix2019:
			return "ARTs"
		case .campos2019:
			return "Campos"
		case .carlin2019:
			return "Carlins"
		case .sauberJuniorCharouz2019:
			return "Charouz"
		case .dams2019:
			return "DAMS"
		case .uniVirtuosi2019:
			return "UNI-Virtuosis"
		case .mpMotorsport2019:
			return "MPs"
		case .prema2019:
			return "Premas"
		case .trident2019:
			return "Tridents"
		case .arden2019:
			return "Ardens"
		case .benetton1994:
			return "Benettons"
		case .benetton1995:
			return "Benettons"
		case .ferrari2000:
			return "Ferraris"
		case .jordan1991:
			return "Jordans"
		case .ferrari1990:
			return "Ferraris"
		case .mclaren2010:
			return "McLarens"
		case .ferrari2010:
			return "Ferraris"
        case .artGrandPrix2020:
            return "ARTs"
        case .campos2020:
            return "Campos"
        case .carlin2020:
            return "Carlins"
        case .charouz2020:
            return "Charouz"
        case .dams2020:
            return "DAMS"
        case .uniVirtuosi2020:
            return "UNI-Virtuosis"
        case .mpMotorsport2020:
            return "MPs"
        case .prema2020:
            return "Premas"
        case .trident2020:
            return "Tridents"
        case .bwt2020:
            return "BWTs"
        case .hitech2020:
            return "Hitech GPs"
        case .mercedes2020:
            return "Mercedes"
        case .ferrari2020:
            return "Ferraris"
        case .redBullRacing2020:
            return "Red Bulls"
        case .williams2020:
            return "Williams"
        case .racingPoint2020:
            return "Racing Points"
        case .renault2020:
            return "Renaults"
        case .alphaTauri2020:
            return "Alpha Tauris"
        case .haas2020:
            return "Haas"
        case .mcLaren2020:
            return "McLarens"
        case .alfaRomeo2020:
            return "Alfa Romeos"
        case .unknownTeam:
			return "Unknowns"
		case .myTeam:
			return "MyTeams"
		}
	}
	
	#if os(iOS)
    var color: UIColor {
		switch self {
        case .mercedes, .ferrari, .ferrari1976, .ferrari1979, .ferrari1995, .ferrari2002, .ferrari2004, .ferrari2007, .redBullRacing, .redBullRacing2010, .williams, .williams1992, .williams1996, .williams2003, .astonMartin, .alpine, .renault2006, .alphaTauri, .haas, .mcLaren, .mcLaren1976, .mcLaren1982, .mcLaren1988, .mcLaren1990, .mcLaren1991, .mcLaren1998, .mcLaren2008, .mclaren2010, .alfaRomeo, .brawn2009, .lotus1972, .lotus1978, .benetton1994, .benetton1995, .ferrari1990, .ferrari2000, .ferrari2010, .mercedes2020, .ferrari2020, .redBullRacing2020, .williams2020, .racingPoint2020, .renault2020, .alphaTauri2020, .haas2020, .mcLaren2020, .alfaRomeo2020, .jordan1991, .myTeam:
			return TKResources.color(named: "F1Team\(audioName.replacingOccurrences(of: " ", with: ""))") ?? .lightGray
        case .artGrandPrix, .bwtArden, .camposVexatecRacing, .carlin, .charouzRacingSystem, .dams, .mpMotorsport, .pertamina, .russianTime, .trident, .artGrandPrix2019, .campos2019, .carlin2019, .sauberJuniorCharouz2019, .dams2019, .uniVirtuosi2019, .mpMotorsport2019, .prema2019, .trident2019, .arden2019, .artGrandPrix2020, .campos2020, .carlin2020, .charouz2020, .dams2020, .uniVirtuosi2020, .mpMotorsport2020, .prema2020, .trident2020, .bwt2020, .hitech2020:
			return TKResources.color(named: "F2Team\(audioName.replacingOccurrences(of: " ", with: ""))") ?? .lightGray
		case .f1Generic, .unknownTeam:
			return .lightGray
		}
	}
	#endif
	
	#if os(macOS)
    var color: NSColor {
		switch self {
        case .mercedes, .ferrari, .ferrari1976, .ferrari1979, .ferrari1995, .ferrari2002, .ferrari2004, .ferrari2007, .redBullRacing, .redBullRacing2010, .williams, .williams1992, .williams1996, .williams2003, .astonMartin, .alpine, .renault2006, .alphaTauri, .haas, .mcLaren, .mcLaren1976, .mcLaren1982, .mcLaren1988, .mcLaren1990, .mcLaren1991, .mcLaren1998, .mcLaren2008, .mclaren2010, .alfaRomeo, .brawn2009, .lotus1972, .lotus1978, .benetton1994, .benetton1995, .ferrari1990, .ferrari2000, .ferrari2010, .mercedes2020, .ferrari2020, .redBullRacing2020, .williams2020, .racingPoint2020, .renault2020, .alphaTauri2020, .haas2020, .mcLaren2020, .alfaRomeo2020, .jordan1991, .myTeam:
			return TKResources.color(named: "F1Team\(audioName.replacingOccurrences(of: " ", with: ""))") ?? .lightGray
		case .artGrandPrix, .bwtArden, .camposVexatecRacing, .carlin, .charouzRacingSystem, .dams, .mpMotorsport, .pertamina, .russianTime, .trident, .artGrandPrix2019, .campos2019, .carlin2019, .sauberJuniorCharouz2019, .dams2019, .uniVirtuosi2019, .mpMotorsport2019, .prema2019, .trident2019, .arden2019, .artGrandPrix2020, .campos2020, .carlin2020, .charouz2020, .dams2020, .uniVirtuosi2020, .mpMotorsport2020, .prema2020, .trident2020, .bwt2020, .hitech2020:
			return TKResources.color(named: "F2Team\(audioName.replacingOccurrences(of: " ", with: ""))") ?? .lightGray
		case .f1Generic, .unknownTeam:
			return .darkGray
		}
	}
	#endif
	
	static func team(withFullName fullName: String) -> TKTeam? {
		return TKTeam.allCases.filter { $0.audioName == fullName }.first
	}
}

public enum TKNationality: UInt8 {
	
	case unknown
	case american
	case argentinean
	case australian
	case austrian
	case azerbaijani
	case bahraini
	case belgian
	case bolivian
	case brazilian
	case british
	case bulgarian
	case cameroonian
	case canadian
	case chilean
	case chinese
	case colombian
	case costaRican
	case croatian
	case cypriot
	case czech
	case danish
	case dutch
	case ecuadorian
	case english
	case emirian
	case estonian
	case finnish
	case french
	case german
	case ghanaian
	case greek
	case guatemalan
	case honduran
	case hongKonger
	case hungarian
	case icelander
	case indian
	case indonesian
	case irish
	case israeli
	case italian
	case jamaican
	case japanese
	case jordanian
	case kuwaiti
	case latvian
	case lebanese
	case lithuanian
	case luxembourger
	case malaysian
	case maltese
	case mexican
	case monegasque
	case newZealander
	case nicaraguan
	case northernIrish
	case norwegian
	case omani
	case pakistani
	case panamanian
	case paraguayan
	case peruvian
	case polish
	case portuguese
	case qatari
	case romanian
	case russian
	case salvadoran
	case saudi
	case scottish
	case serbian
	case singaporean
	case slovakian
	case slovenian
	case southKorean
	case southAfrican
	case spanish
	case swedish
	case swiss
	case thai
	case turkish
	case uruguayan
	case ukrainian
	case venezuelan
	case barbadian
    case welsh
	case vietnamese
	
}

extension TKNationality {
	
	var emojiFlag: String {
		switch self {
		case .unknown:
			return "🏳️"
		case .american:
			return "🇺🇸"
		case .argentinean:
			return "🇦🇷"
		case .australian:
			return "🇦🇺"
		case .austrian:
			return "🇦🇹"
		case .azerbaijani:
			return "🇦🇿"
		case .bahraini:
			return "🇧🇭"
		case .belgian:
			return "🇧🇪"
		case .bolivian:
			return "🇧🇴"
		case .brazilian:
			return "🇧🇷"
		case .british:
			return "🇬🇧"
		case .bulgarian:
			return "🇧🇬"
		case .cameroonian:
			return "🇨🇲"
		case .canadian:
			return "🇨🇦"
		case .chilean:
			return "🇨🇱"
		case .chinese:
			return "🇨🇳"
		case .colombian:
			return "🇨🇴"
		case .costaRican:
			return "🇨🇷"
		case .croatian:
			return "🇭🇷"
		case .cypriot:
			return "🇨🇾"
		case .czech:
			return "🇨🇿"
		case .danish:
			return "🇩🇰"
		case .dutch:
			return "🇳🇱"
		case .ecuadorian:
			return "🇪🇨"
		case .english:
			return "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
		case .emirian:
			return "🇦🇪"
		case .estonian:
			return "🇪🇪"
		case .finnish:
			return "🇫🇮"
		case .french:
			return "🇫🇷"
		case .german:
			return "🇩🇪"
		case .ghanaian:
			return "🇬🇭"
		case .greek:
			return "🇬🇷"
		case .guatemalan:
			return "🇬🇹"
		case .honduran:
			return "🇭🇳"
		case .hongKonger:
			return "🇭🇰"
		case .hungarian:
			return "🇭🇺"
		case .icelander:
			return "🇮🇸"
		case .indian:
			return "🇮🇳"
		case .indonesian:
			return "🇮🇩"
		case .irish:
			return "🇮🇪"
		case .israeli:
			return "🇮🇱"
		case .italian:
			return "🇮🇹"
		case .jamaican:
			return "🇯🇲"
		case .japanese:
			return "🇯🇵"
		case .jordanian:
			return "🇯🇴"
		case .kuwaiti:
			return "🇰🇼"
		case .latvian:
			return "🇱🇻"
		case .lebanese:
			return "🇱🇧"
		case .lithuanian:
			return "🇱🇹"
		case .luxembourger:
			return "🇱🇺"
		case .malaysian:
			return "🇲🇾"
		case .maltese:
			return "🇲🇹"
		case .mexican:
			return "🇲🇽"
		case .monegasque:
			return "🇲🇨"
		case .newZealander:
			return "🇳🇿"
		case .nicaraguan:
			return "🇳🇮"
		case .northernIrish:
			return "🇬🇬" // RLT: not exactly the real northern Irish flag, which doesn't exist anymore
		case .norwegian:
			return "🇳🇴"
		case .omani:
			return "🇴🇲"
		case .pakistani:
			return "🇵🇰"
		case .panamanian:
			return "🇵🇦"
		case .paraguayan:
			return "🇵🇾"
		case .peruvian:
			return "🇵🇪"
		case .polish:
			return "🇵🇱"
		case .portuguese:
			return "🇵🇹"
		case .qatari:
			return "🇶🇦"
		case .romanian:
			return "🇷🇴"
		case .russian:
			return "🇷🇺"
		case .salvadoran:
			return "🇸🇻"
		case .saudi:
			return "🇸🇦"
		case .scottish:
			return "🏴󠁧󠁢󠁳󠁣󠁴󠁿"
		case .serbian:
			return "🇷🇸"
		case .singaporean:
			return "🇸🇬"
		case .slovakian:
			return "🇸🇰"
		case .slovenian:
			return "🇸🇮"
		case .southKorean:
			return "🇰🇷"
		case .southAfrican:
			return "🇿🇦"
		case .spanish:
			return "🇪🇸"
		case .swedish:
			return "🇸🇪"
		case .swiss:
			return "🇨🇭"
		case .thai:
			return "🇹🇭"
		case .turkish:
			return "🇹🇷"
		case .uruguayan:
			return "🇺🇾"
		case .ukrainian:
			return "🇺🇦"
		case .venezuelan:
			return "🇻🇪"
		case .barbadian:
			return "🇧🇧"
        case .welsh:
            return "🏴󠁧󠁢󠁷󠁬󠁳󠁿"
		case .vietnamese:
			return "🇻🇳"
		}
	}
	
}

internal enum TKDrivingSurface: UInt8 {
	
	case tarmac
	case rumbleStrip
	case concrete
	case rock
	case gravel
	case mud
	case sand
	case grass
	case water
	case cobblestone
	case metal
	case ridged
	
}

internal enum TKButtonFlags: UInt32 {
	
	case a = 0x00000001
	case y = 0x00000002
	case b = 0x00000004
	case x = 0x00000008
	case left = 0x00000010
	case right = 0x00000020
	case up = 0x00000040
	case down = 0x00000080
	case menu = 0x00000100
	case lb = 0x00000200
	case rb = 0x00000400
	case lt = 0x00000800
	case rt = 0x00001000
	case leftStick = 0x00002000
	case rightStick = 0x00004000
    case rightStickLeft = 0x00008000
    case rightStickRight = 0x00010000
    case rightStickUp = 0x00020000
    case rightStickDown = 0x00040000
    case special = 0x00080000
	
}

public enum TKMFDPanel: UInt8 {
	
	case carSetup
	case pits
	case damage
	case engine
	case temperatures
	case closed = 255
	
}

internal enum TKTractionControl: UInt8 {
	
	case off
	case medium
	case full
	
}

public enum TKFuelMix: UInt8 {
	
	case lean
	case standard
	case rich
	case max
	
}

internal enum TKTyreCompound: UInt8 {
	
	case unknown = 0
	case f1ModernInter = 7
	case f1ModernWet
	case f1ClassicDry
	case f1ClassicWet
	case f2SuperSoft
	case f2Soft
	case f2Medium
	case f2Hard
	case f2Wet
	case f1ModernC5
	case f1ModernC4
	case f1ModernC3
	case f1ModernC2
	case F1ModernC1
	case undefined = 255
	
}

public enum TKTyreVisualCompound: UInt8 {
	
	case unknown = 0
	case f1ModernInter = 7
	case f1ModernWet
	case f1ClassicDry
	case f1ClassicWet
	case f2SuperSoftOld // Removed in F1 2021
	case f2SoftOld // Removed in F1 2021
	case f2MediumOld // Removed in F1 2021
	case f2HardOld // Removed in F1 2021
	case f2WetOld // Removed in F1 2021
	case f1ModernSoft
	case f1ModernMedium
	case f1ModernHard
	case f2SuperSoft
	case f2Soft
	case f2Medium
	case f2Hard
	case f2Wet // RLT: added while debugging F2 races (F1 2020)
	
}

extension TKTyreVisualCompound {
	
	var name: String {
		switch self {
		case .unknown:
			return "unknown"
		case .f1ModernInter:
			return "Intermediates (I)"
		case .f1ModernWet:
			return "Wet (W)"
		case .f1ClassicDry:
			return "classic Dry"
		case .f1ClassicWet:
			return "classic Wet"
        case .f2SuperSoft, .f2SuperSoftOld:
			return "Super Softs (F2)"
        case .f2Soft, .f2SoftOld:
			return "Softs (F2)"
        case .f2Medium, .f2MediumOld:
			return "Mediums (F2)"
        case .f2Hard, .f2HardOld:
			return "Hards (F2)"
        case .f2Wet, .f2WetOld:
			return "Wet (F2)"
		case .f1ModernSoft:
			return "Softs (S)"
		case .f1ModernMedium:
			return "Mediums (M)"
		case .f1ModernHard:
			return "Hards (H)"
		}
	}
	
	var abbreviation: String {
		get {
			switch self {
			case .unknown:
				return "X"
			case .f1ModernInter:
				return "I"
			case .f1ModernWet:
				return "W"
			case .f1ClassicDry:
				return "D"
			case .f1ClassicWet:
				return "R"
            case .f2SuperSoft, .f2SuperSoftOld:
				return "U"
            case .f2Soft, .f2SoftOld:
				return "S"
            case .f2Medium, .f2MediumOld:
				return "M"
            case .f2Hard, .f2HardOld:
				return "H"
            case .f2Wet, .f2WetOld:
				return "W"
			case .f1ModernSoft:
				return "S"
			case .f1ModernMedium:
				return "M"
			case .f1ModernHard:
				return "H"
			}
		}
		set {
		}
	}
	
	var color: Color {
		get {
			switch self {
			case .unknown:
				return .gray
			case .f1ModernInter:
				return Color(TKResources.color(named: "F1TyreIntermediate") ?? .green)
			case .f1ModernWet, .f1ClassicWet, .f2Wet, .f2WetOld:
				return Color(TKResources.color(named: "F1TyreWet") ?? .blue)
			case .f1ClassicDry, .f2Hard, .f1ModernHard, .f2HardOld:
				return Color(TKResources.color(named: "F1TyreHard") ?? .white)
			case .f2SuperSoft, .f2SuperSoftOld:
				return Color(TKResources.color(named: "F1TyreUltraSoft") ?? .purple)
			case .f2Soft, .f1ModernSoft, .f2SoftOld:
				return Color(TKResources.color(named: "F1TyreSoft") ?? .red)
			case .f2Medium, .f1ModernMedium, .f2MediumOld:
				return Color(TKResources.color(named: "F1TyreMedium") ?? .yellow)
			}
		}
		set {
		}
	}
	
}

public enum TKVehicleFIAFlags: Int8 {
	
	case invalid = -1
	case none
	case green
	case blue
	case yellow
	case red
	
}

public enum TKERSDeploymentMode: UInt8 {
	
	case none
	case medium
	case overtake
	case hotlap
	
}

internal enum TKReadyStatus: UInt8 {
	
	case notReady
	case ready
	case spectating
	
}

public enum TKTimeColor: CaseIterable {
	
	case white
	case yellow
	case green
	case purple
	
	#if os(iOS)
	var color: UIColor? {
		switch self {
		case .white:
			return TKResources.color(named: "F1TimingWhite")
		case .yellow:
			return TKResources.color(named: "F1TimingYellow")
		case .green:
			return TKResources.color(named: "F1TimingGreen")
		case .purple:
			return TKResources.color(named: "F1TimingPurple")
		}
	}
	#endif

	#if os(macOS)
	var color: NSColor? {
		switch self {
		case .white:
			return TKResources.color(named: "F1TimingWhite")
		case .yellow:
			return TKResources.color(named: "F1TimingYellow")
		case .green:
			return TKResources.color(named: "F1TimingGreen")
		case .purple:
			return TKResources.color(named: "F1TimingPurple")
		}
	}
	#endif
	
}
