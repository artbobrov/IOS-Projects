//
//  PodcastTableViewCell.swift
//  MusicPlayer
//
//  Created by Artem Bobrov on 26.02.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import UIKit
import MediaPlayer

class PodcastTableViewCell: AlbumTableViewCell {
	override var item: MPMediaItem? {
		set {
			object = newValue
			guard let item = item else { return }
			titleLabel.text = item.title ?? ""
			subtitleLabel.text = item.releaseDate?.formatted
		}
		get {
			return object
		}
	}
}
