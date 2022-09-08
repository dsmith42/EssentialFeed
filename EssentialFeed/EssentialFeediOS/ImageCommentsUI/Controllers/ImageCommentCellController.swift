//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 06/09/2022.
//

import EssentialFeed
import UIKit

public final class ImageCommentCellController: NSObject, UITableViewDataSource {

	private let model: ImageCommentViewModel

	public init(model: ImageCommentViewModel) {
		self.model = model
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ImageCommentCell = tableView.dequeueReusableCell()
		cell.usernameLabel.text = model.username
		cell.dateLabel.text = model.date
		cell.messageLabel.text = model.message
		return cell
	}

}
