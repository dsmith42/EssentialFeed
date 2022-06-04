//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 29/05/2022.
//

import UIKit

extension UITableView {
	func dequeueReusableCell<T: UITableViewCell>() -> T {
		let identifier = String(describing: T.self)
		return dequeueReusableCell(withIdentifier: identifier) as! T
	}
}
