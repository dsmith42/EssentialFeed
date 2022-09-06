//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 06/09/2022.
//

import Foundation

public final class ImageCommentsPresenter {

	public static var title: String {
		NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
											tableName: "ImageComments",
											bundle: Bundle(for: Self.self),
											comment: "Title for the image comments view")
	}

}
