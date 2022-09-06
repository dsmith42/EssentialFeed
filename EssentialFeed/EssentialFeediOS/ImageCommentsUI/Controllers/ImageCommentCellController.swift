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
		UITableViewCell()
	}

	public func preload() {

	}

	public func cancelLoad() {

	}

}
