//
//  RemoteFeedMapper.swift
//  FeedAPIChallenge
//
//  Created by Kasper Josefsen on 11/05/2023.
//  Copyright © 2023 Essential Developer Ltd. All rights reserved.
//

import Foundation

enum RemoteFeedMapper {
	private struct FeedImagesResponse: Decodable {
		let items: [FeedImageResponse]
		var feedImages: [FeedImage] { items.map { $0.image } }
	}

	private struct FeedImageResponse: Decodable {
		var image_id: UUID
		var image_desc: String?
		var image_loc: String?
		var image_url: URL

		var image: FeedImage {
			FeedImage(id: image_id, description: image_desc, location: image_loc, url: image_url)
		}
	}

	private static var OK_200: Int { 200 }

	static func map(data: Data, response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard
			response.statusCode == OK_200,
			let root = try? JSONDecoder().decode(FeedImagesResponse.self, from: data)
		else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(root.feedImages)
	}
}
