//
//  StarRatingWidget.swift
//  mytaxiDriver
//
//  Created by Fabio Cuomo on 11/02/2019.
//  Copyright © 2019 Intelligent's App. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public final class StarRatingWidget: UIControl {

    public var shouldBecomeFirstResponder: Bool = false
    
    struct Constant {
        static let min: Float = 0
        static let max: Float = 5
        static let spacing: Float = 8
    }
    
    fileprivate var value: Float = 0 {
        didSet {
            if value != oldValue {
                self.sendActions(for: .valueChanged)
                setNeedsDisplay()
            }
        }
    }

    private let emptyStarImage = UIImage(named: "ic_circle_unselected")
    public var filledStarImage = UIImage(named: "ic_yellow_circle") {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var isEnabled: Bool {
        willSet {
            updateAppearance(enabled: newValue)
        }
    }
    
    override public var canBecomeFirstResponder: Bool {
        return shouldBecomeFirstResponder
    }
    
    override public var intrinsicContentSize: CGSize {
        let (spacing, max) = (CGFloat(Constant.spacing), CGFloat(Constant.max))
        let height: CGFloat = 48.0
        return CGSize(width: CGFloat(max * height + (max - 1) * spacing), height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented. Please use init() method") }
    
    private func setup() {
        isExclusiveTouch = true
        updateAppearance(enabled: self.isEnabled)
    }
    
    private func updateAppearance(enabled: Bool) {
        alpha = enabled ? 1.0 : 0.5
    }
    
    override public func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor((self.backgroundColor?.cgColor ?? UIColor.white.cgColor)!)
        context?.fill(rect)
        
        let (spacing, max) = (CGFloat(Constant.spacing), CGFloat(Constant.max))
        let spaceBetweenStars = spacing * (max - 1)
        let availableWidth = rect.width - 2 - CGFloat(spaceBetweenStars)
        let cellWidth = availableWidth / max
        let starSide = min(cellWidth, rect.height)
        
        for idx in 0..<Int(max) {
            
            let center = CGPoint(x: (cellWidth + spacing) * CGFloat(idx) + cellWidth / 2 + 1, y: rect.size.height / 2)
            let frame = CGRect(x: center.x - starSide / 2, y: center.y - starSide / 2, width: starSide, height: starSide)
            let highlighted = Float(idx+1) <= ceilf(Float(value))
            
            let image = highlighted ? filledStarImage : emptyStarImage
            draw(image: image, frame: frame, tintColor: tintColor)
        }
    }
    
    private func draw(image: UIImage?, frame: CGRect, tintColor: UIColor) {
        guard let image = image else { return }
        if image.renderingMode == .alwaysTemplate {
            tintColor.setFill()
        }
        image.draw(in: frame)
    }
}

extension StarRatingWidget {
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isEnabled {
            super.beginTracking(touch, with: event)
            if shouldBecomeFirstResponder && !self.isFirstResponder {
                self.becomeFirstResponder()
            }
            handle(touch: touch)
        }
        return isEnabled
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isEnabled {
            super.continueTracking(touch, with: event)
            handle(touch: touch)
        }
        return isEnabled
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if shouldBecomeFirstResponder && self.isFirstResponder {
            self.resignFirstResponder()
        }
        handle(touch: touch!)
    }
    
    override public func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        if shouldBecomeFirstResponder && self.isFirstResponder {
            self.resignFirstResponder()
        }
    }
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureView = gestureRecognizer.view, gestureView.isEqual(self) {
            return !self.isUserInteractionEnabled
        } else {
            let location = gestureRecognizer.location(in: self)
            updateValue(for: location)
            return true
        }
    }
    
    private func handle(touch: UITouch) {
        let location = touch.location(in: self)
        updateValue(for: location)
    }
    
    private func updateValue(for location: CGPoint) {
        let cellWidth = self.bounds.width / CGFloat(Constant.max)
        let aValue = max(location.x / cellWidth, 1)
        let value = ceilf(Float(aValue))
        let normalizedRate = Float.maximum(Float.minimum(value, Constant.max), Constant.min)
        self.value = normalizedRate
    }    
}

extension Reactive where Base: StarRatingWidget {
    public var rating: ControlProperty<Float> {
        return controlProperty(editingEvents: .valueChanged,
                               getter: { starRatingWidget in starRatingWidget.value },
                               setter: { starRatingWidget, value in starRatingWidget.value = value })
    }
}
