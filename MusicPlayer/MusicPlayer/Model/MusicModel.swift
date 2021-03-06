//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Artem Bobrov on 21.02.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import MediaPlayer

typealias Songlist = [MPMediaItemCollection]

class MediaModelController {
	private init() {}

	static let shared = MediaModelController()

	private var noCloudPredicate: MPMediaPropertyPredicate {
		return MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem, comparisonType: .equalTo)
	}

	func songsQuery(containing string: String) -> MPMediaQuery {
		let query = self.songsQuery
		query.addFilterPredicate(MPMediaPropertyPredicate(value: string, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains))
		return query
	}

	var podcastQuery: MPMediaQuery {
		let query = MPMediaQuery.podcasts()
		query.addFilterPredicate(noCloudPredicate)
		return query
	}

	var playlistQuery: MPMediaQuery {
		let query = MPMediaQuery.playlists()
		query.addFilterPredicate(noCloudPredicate)
		return query
	}

	var albumsQuery: MPMediaQuery {
		let query = MPMediaQuery.albums()
		query.addFilterPredicate(noCloudPredicate)
		return query
	}

	var artistsQuery: MPMediaQuery {
		let query = MPMediaQuery.artists()
		query.addFilterPredicate(noCloudPredicate)
		return query
	}

	var songsQuery: MPMediaQuery {
		let query = MPMediaQuery.songs()
		query.addFilterPredicate(noCloudPredicate)
		query.groupingType = .albumArtist
		return query
	}

	func albumsQuery(for albumArtistPersistentID:  MPMediaEntityPersistentID) -> MPMediaQuery {
		let query = self.albumsQuery

		let predicate = MPMediaPropertyPredicate(value: albumArtistPersistentID, forProperty: MPMediaItemPropertyAlbumArtistPersistentID, comparisonType: .equalTo)
		query.addFilterPredicate(predicate)

		return query
	}

	func recentSongs(for maxAmount: Int) -> MPMediaItemCollection? {
		guard let list = songsQuery.items?.filter({$0.hasLastPlayedDate}) else { return nil }
		let items = Array(list.sorted { (lhs, rhs) -> Bool in
			return lhs.lastPlayedDate!.compare(rhs.lastPlayedDate!) == .orderedDescending
			}.prefix(maxAmount))
		return MPMediaItemCollection(items: items)
	}
}
