//
//  UIKit+Extensions.swift
//  SwiftyAnimate
//
//  Created by Reid Chatham on 12/23/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import Foundation

public extension UIView {
    
    /**
     Perform multiple core graphics transformations on a view.
     
     - parameter transforms: Array of transformations to be performed on the view represented by `Transform` enum cases.
     */
    func transformed(by transforms: [Transform]) {
        var transform: CGAffineTransform?
        for t in transforms {
            switch t {
            case .rotate(angle: let angle):
                let angle: CGFloat = angle * .pi / 180
                transform = transform?.rotated(by: angle) ?? CGAffineTransform(rotationAngle: angle)
            case .scale(x: let x, y: let y):
                transform = transform?.scaledBy(x: x, y: y) ?? CGAffineTransform(scaleX: x, y: y)
            case .move(x: let x, y: let y):
                transform = transform?.translatedBy(x: x, y: y) ?? CGAffineTransform(translationX: x, y: y)
            }
        }
        if let transform = transform {
            self.transform = transform
        }
    }
    
    /**
     Performs a translation core graphics transformation on a view.
     
     - parameter x: Value to shift in the x direction.
     - parameter y: Value to shift in the y direction.
     */
    func move(x: CGFloat, y: CGFloat) {
        transformed(by: [.move(x: x, y: y)])
    }
    
    /**
     Performs a rotation core graphics transformation on a view.
     
     - parameter angle: Degrees to rotate the view.
     */
    func rotate(angle: CGFloat) {
        transformed(by: [.rotate(angle: angle)])
    }
    
    /**
     Performs a scale core graphics transformation on a view.
     
     - parameter x: Value to scale in the x direction.
     - parameter y: Value to scale in the y direction.
     */
    func scale(x: CGFloat, y: CGFloat) {
        transformed(by: [.scale(x: x, y: y)])
    }
    
    /**
     Sets the view's background color.
     
     - parameter color: Value for the new background color.
     */
    func color(_ color: UIColor) {
        backgroundColor = color
    }
}

public extension UIView {
    
    // TODO: - Should these functions be UIView extenstions or Animate functions?
    // MARK: - UIView animations
    
    /**
     Creates an `Animate` instance that sets the corner radius on the view's CALayer.
     
     - parameter duration: Duration for the transformation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter radius: Value for the new corner radius.
     - parameter timing: The animation timing function to use.
     
     - returns: Animate instance.
     */
    func corner(duration: TimeInterval, delay: TimeInterval = 0.0, radius: CGFloat, timing: Timing = .easeInOut) -> Animate {
        return Animate(animation: BasicAnimation.cornerRadius(view: self, duration: duration, delay: delay, radius: radius, timing: timing))
    }
    
    /**
     Creates an `Animate` instance that sets the view's background color.
     
     - parameter duration: Duration for the transformation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter color: Value for the new background color.
     - parameter options: Takes a set of UIViewAnimationOptions. Default is an empty array.
     
     - returns: Animate instance.
     */
    func color(duration: TimeInterval, delay: TimeInterval = 0.0, color value: UIColor, options: UIView.AnimationOptions = []) -> Animate {
        return Animate(duration: duration, delay: delay, options: options) { [weak self] in
            self?.color(value)
        }
    }
    
    /**
     Creates an `Animate` instance that performs a scale core graphics transformation on a view.
     
     - parameter duration: Duration for the transformation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter x: Value to scale in the x direction.
     - parameter y: Value to scale in the y direction.
     - parameter options: Takes a set of UIViewAnimationOptions. Default is an empty array.
     
     - returns: Animate instance.
     */
    func scale(duration: TimeInterval, delay: TimeInterval = 0.0, x: CGFloat, y: CGFloat, options: UIView.AnimationOptions = []) -> Animate {
        return Animate(duration: duration, delay: delay, options: options) { [weak self] in
            self?.scale(x: x, y: y)
        }
    }
    
    /**
     Creates an `Animate` instance that performs a rotation core graphics transformation on a view.
     
     - parameter duration: Duration for the transformation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter angle: Degrees to rotate the view.
     - parameter options: Takes a set of UIViewAnimationOptions. Default is an empty array.
     
     - returns: Animate instance.
     */
    func rotate(duration: TimeInterval, delay: TimeInterval = 0.0, angle: CGFloat, options: UIView.AnimationOptions = []) -> Animate {
        return Animate(duration: duration, delay: delay, options: options) { [weak self] in
            self?.rotate(angle: angle)
        }
    }
    
    /**
     Creates an `Animate` instance that performs a translation core graphics transformation on a view.
     
     - parameter duration: Duration for the transformation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter x: Value to shift in the x direction.
     - parameter y: Value to shift in the y direction.
     - parameter options: Takes a set of UIViewAnimationOptions. Default is an empty array.
     
     - returns: Animate instance.
     */
    func move(duration: TimeInterval, delay: TimeInterval = 0.0, x: CGFloat, y: CGFloat, options: UIView.AnimationOptions = []) -> Animate {
        return Animate(duration: duration, delay: delay, options: options) { [weak self] in
            self?.move(x: x, y: y)
        }
    }
    
    /**
     Creates an `Animate` object for performing multiple core graphics transformations on a view.
     
     - parameter duration: Duration for the transformation.
     - parameter delay: Takes a time interval to delay the animation.
     - parameter transforms: Array of transformations to be performed on the view represented by `Transform` enum cases.
     - parameter options: Takes a set of UIViewAnimationOptions. Default is an empty array.
     
     - returns: Animate instance.
     */
    func transform(duration: TimeInterval, delay: TimeInterval = 0.0, transforms: [Transform], options: UIView.AnimationOptions = []) -> Animate {
        return Animate(duration: duration, delay: delay, options: options) { [weak self] in
            self?.transformed(by: transforms)
        }
    }

}
