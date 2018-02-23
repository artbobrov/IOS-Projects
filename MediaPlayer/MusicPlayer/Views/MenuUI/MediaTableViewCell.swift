//
//  MediaTableViewCell.swift
//  MusicPlayer
//
//  Created by Artem Bobrov on 23.02.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaTableViewCell: SelectedTableViewCell {

	@IBOutlet weak var albumArtworkImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!

	let imageCornerRadius: CGFloat = 7

	override func awakeFromNib() {
		super.awakeFromNib()

		self.albumArtworkImageView.layer.masksToBounds = true
		self.albumArtworkImageView.layer.cornerRadius = imageCornerRadius
		self.albumArtworkImageView.layer.backgroundColor = UIColor.black.cgColor
	}

	weak var item: MPMediaItem? {
		didSet {
			guard let item = item else { return }
			if let artwork = item.artwork {
				albumArtworkImageView.image = artwork.image(at: albumArtworkImageView.frame.size)
			}
			if let title = item.title {
				titleLabel.text = title
			}

			artistNameLabel.text = item.artist
		}
	}
}
