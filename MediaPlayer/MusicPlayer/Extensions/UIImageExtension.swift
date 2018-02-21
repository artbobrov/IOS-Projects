//
//  UIImageExtension.swift
//  MusicPlayer
//
//  Created by Artem Bobrov on 06.02.2018.
//  Copyright © 2018 Artem Bobrov. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
	var averageColor: UIColor? {
		guard let imageData = self.cgImage?.dataProvider?.data,
			  let dataPointer = CFDataGetBytePtr(imageData) else {
			return nil
		}

		let precision = 10
		let wideStride = stride(from: 0, to: Int(size.width), by: precision)
		var numberOfItems: CGFloat = 0
		let colorComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = wideStride
				.map { x in
					defer {
						numberOfItems += 1
					}
					return pixelInfo(data: dataPointer, x: x, y: 0, width: size.width)
				}
				.reduce((0.0, 0.0, 0.0, 0.0), { (res: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat), nxt: (r: UInt8, g: UInt8, b: UInt8, a: UInt8)) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) in
					return (res.r + CGFloat(nxt.r),
							res.g + CGFloat(nxt.g),
							res.b + CGFloat(nxt.b),
							res.a + CGFloat(nxt.a))
				})

		return UIColor(red: (colorComponents.r / numberOfItems).normalized,
						green: (colorComponents.g / numberOfItems).normalized,
						blue: (colorComponents.b / numberOfItems).normalized,
						alpha: (colorComponents.a / numberOfItems).normalized)

	}

	private func pixelInfo(data: UnsafePointer<UInt8>, x: Int, y: Int, width: CGFloat) -> (r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
		let pos = ((Int(round(width)) * y) + x) * 4

		return (data.advanced(by: pos + 0).pointee,
				data.advanced(by: pos + 1).pointee,
				data.advanced(by: pos + 2).pointee,
				data.advanced(by: pos + 3).pointee)
	}

	public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}  
}

