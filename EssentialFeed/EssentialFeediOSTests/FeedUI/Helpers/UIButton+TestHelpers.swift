//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit

extension UIButton {
	func simulateTap() {
		simulate(event: .touchUpInside)
	}
}
