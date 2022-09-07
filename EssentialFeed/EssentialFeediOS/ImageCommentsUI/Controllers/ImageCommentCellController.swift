//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 06/09/2022.
//

import Foundation
import EssentialFeed
import UIKit

public final class ImageCommentCellController: CellController {
	private let model: ImageCommentViewModel

	public init(model: ImageCommentViewModel) {
		self.model = model
	}

	public func view(in tableView: UITableView) -> UITableViewCell {
		let cell: ImageCommentCell = tableView.dequeueReusableCell()
		cell.usernameLabel.text = model.username
		cell.dateLabel.text = model.date
		cell.messageLabel.text = model.message
		return cell
	}

}
