//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 29/05/2022.
//

import UIKit

extension UIImageView {
	func setImageAnimated(_ newImage: UIImage?) {
		image = newImage

		guard newImage != nil else { return }
		self.alpha = 0
		UIView.animate(withDuration: 0.25) {
			self.alpha = 1
		}
	}
}
