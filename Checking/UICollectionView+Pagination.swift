//
//  UICollectionView+Pagination.swift
//  Checking
//
//  Created by Краснокутский Владислав on 22.07.2022.
//

import Foundation
import UIKit

class PagingCollectionView: UICollectionView {
	
	var items: [String] = []
	var indexOfCellBeforeDragging = 0
	var layout: UICollectionViewFlowLayout { collectionViewLayout as! UICollectionViewFlowLayout }
	
	private func indexOfCurrentCell() -> Int {
		let proportionalOffset = contentOffset.x / layout.itemSize.width
		let index = round(proportionalOffset)
		let safeIndex = max(0, min(items.count - 1, Int(index)))

		return safeIndex
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		indexOfCellBeforeDragging = indexOfCurrentCell()
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView,
								   withVelocity velocity: CGPoint,
								   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		targetContentOffset.pointee = scrollView.contentOffset

		let currentIndex = indexOfCurrentCell()
		let swipeVelocityThreshold: CGFloat = 0.5
		let isSwipeToNextCell = indexOfCellBeforeDragging + 1 < items.count && velocity.x > swipeVelocityThreshold
		let isSwipeToPreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
		let currentIndexHasChanged = currentIndex == indexOfCellBeforeDragging
		let needSwipeToOtherCell = currentIndexHasChanged && (isSwipeToNextCell || isSwipeToPreviousCell)

		let newItemCurrentIndex = needSwipeToOtherCell ? indexOfCellBeforeDragging + (isSwipeToNextCell ? 1 : -1) : currentIndex
		let newCurrentItemIndexPath = IndexPath(row: newItemCurrentIndex, section: 0)
		
		scrollToItem(at: newCurrentItemIndexPath, at: .centeredHorizontally, animated: true)
	}
}
