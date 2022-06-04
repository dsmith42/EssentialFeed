//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 04/06/2022.
//

import UIKit

extension UIRefreshControl {
	func update(isRefreshing: Bool) {
		isRefreshing ? beginRefreshing() : endRefreshing()
	}
}

