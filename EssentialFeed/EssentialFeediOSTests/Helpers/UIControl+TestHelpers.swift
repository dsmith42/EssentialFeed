//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit
@testable import EssentialFeed

extension UIControl {
	func simulate(event: UIControl.Event) {
		allTargets.forEach { target in
			actions(forTarget: target, forControlEvent: event)?.forEach {
				(target as NSObject).perform(Selector($0))
			}
		}
	}
}
