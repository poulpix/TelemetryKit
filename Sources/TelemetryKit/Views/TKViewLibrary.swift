//
//  TKViewLibrary.swift
//  TelemetryKit
//
//  Created by Romain on 03/01/2021.
//  Copyright © 2021 Poulpix. All rights reserved.
//

import Foundation
import SwiftUI

struct TKViewLibrary: LibraryContentProvider {
	
	@LibraryContentBuilder
	var views: [LibraryItem] {
		LibraryItem(TKImage("TelemetryIcon"), title: "Image from the TelemetryKit package", category: .control)
		LibraryItem(TKTextLabelView("Label:", data: .constant("test")), title: "Label with data (of string type)", category: .control)
		LibraryItem(TKBooleanLabelView("Label:", data: .constant(true)), title: "Label with data (of boolean type)", category: .control)
		LibraryItem(TKUInt8LabelView("Label:", data: .constant(123)), title: "Label with data (of UInt8 type)", category: .control)
		LibraryItem(TKUInt64LabelView("Label:", data: .constant(1234)), title: "Label with data (of UInt64 type)", category: .control)
	}
 
}
