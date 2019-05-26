//
//  CancelChildViewProtocol.swift
//  mytaxiDriver
//
//  Created by Mounir Dellagi on 03.11.17.
//  Copyright © 2017 Intelligent Apps GmbH. All rights reserved.
//

import UIKit

public protocol CancelChildViewProtocol {
    var explanationTextView: UITextView! { get }
    var scrollView: UIScrollView! { get }
}

public extension CancelChildViewProtocol where Self: UIView {
    func addDismissKeyboardHandler() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(explanationTextView.endEditing(_:)))
        addGestureRecognizer(tapRecognizer)
    }

    func handleKeyboardShown(_ notification: Notification) {
        guard let info = notification.userInfo else {
            return
        }

        let kbRectObject = info[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        let kbSize = kbRectObject.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var bottomOffsetY = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        // We don't want to take into account the bottom safe area when scrolling the content
        if #available(iOS 11.0, *) {
            bottomOffsetY -= safeAreaInsets.bottom
        }

        let bottomOffset = CGPoint(x: 0, y: bottomOffsetY)
        scrollView.setContentOffset(bottomOffset, animated: true)

        layoutIfNeeded()
    }

    func handleKeyboardHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        let bottomOffset = CGPoint.zero
        scrollView.setContentOffset(bottomOffset, animated: true)

        layoutIfNeeded()
    }
}
