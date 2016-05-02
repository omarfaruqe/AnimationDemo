//
//  ProfileStack.swift
//  DatingApp
//
//  Created by Omar Faruqe on 2016-05-01.
//  Copyright © 2016 Omar Faruqe. All rights reserved.
//

import UIKit


class ProfileStack: UIView{
    var profiles: [ProfileView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    func defaultInit(){
        //self.backgroundColor = UIColor.whiteColor()
        
        for person in people {
            addPerson(person)
        }
    }
    
    func addPerson(person: Person) {
        let profile = ProfileView()
        profile.person = person
        self.addSubview(profile)
        
        profile.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profile, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: profile, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: profile, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: profile, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        
        profiles.append(profile)
        self.sendSubviewToBack(profile)
        
        setupTransforms(0.0)
        
        if profiles.count == 1 {
            profile.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ProfileStack.pan(_:))))
        }
    }
    
    func setupGestures(){
        for profile in profiles {
            let gestures = profile.gestureRecognizers ?? []
            for gesture in gestures {
                profile.removeGestureRecognizer(gesture)
            }
        }
        
        if let firstProfile = profiles.first {
            firstProfile.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ProfileStack.pan(_:))))
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer){
        let profile = gesture.view! as! ProfileView
        
        let translation = gesture.translationInView(self)
        
        var percent = translation.x / CGRectGetMidX(self.bounds)
        percent = min(percent, 1)
        percent = max(percent, -1)
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.setupTransforms(abs(Double(percent)))
            }, completion: nil)
        
        
        if percent > 0.2 {
            profile.nopeLabel.alpha = 0
            
            let newPercent = (percent - 0.2) / 0.8
            profile.likeLabel.alpha = newPercent
        }
        else if percent < -0.2 {
            profile.likeLabel.alpha = 0
            
            let newPercent = (abs(percent) - 0.2) / 0.8
            profile.nopeLabel.alpha = newPercent
        }
        else {
            profile.likeLabel.alpha = 0
            profile.nopeLabel.alpha = 0
        }
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, translation.x, translation.y)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI) * percent / 30)
        
        profile.transform = transform
        
        if gesture.state == .Ended {
            
            let velocity = gesture.velocityInView(self)
            
            let percentBlock = {
                self.profiles.removeAtIndex(self.profiles.indexOf(profile)!)
                self.setupGestures()
                profile.removeGestureRecognizer(profile.gestureRecognizers![0])
                
                let normVelX = velocity.x / translation.x / 10
                let normVelY = velocity.y / translation.y / 10
                
                UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelX, options: [], animations: {
                    () -> Void in
                    profile.center.x = translation.x * 10
                    }, completion: nil)
                
                UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelY, options: [], animations: {
                    () -> Void in
                    profile.center.y = translation.y * 10
                    }, completion: nil)
                
            }
            
            if percent > 0.2 {
                percentBlock()
            }
            else if percent < -0.2 {
                percentBlock()
            }
            else{
                
                let normVelX = -velocity.x / translation.x
                let normVelY = -velocity.y / translation.y
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    profile.likeLabel.alpha = 0
                    profile.nopeLabel.alpha = 0
                    }, completion: nil)
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: normVelX, options: [], animations: {
                    () -> Void in
                    var transform = CGAffineTransformIdentity
                    transform = CGAffineTransformTranslate(transform, 0, translation.y)
                    profile.transform = transform
                    }, completion: nil)
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: normVelY, options: [], animations: {
                    () -> Void in
                    var transform = CGAffineTransformIdentity
                    transform = CGAffineTransformTranslate(transform, 0, 0)
                    profile.transform = transform
                    }, completion: nil)
            }
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.setupTransforms(0.0)
                }, completion: nil)
        }
    }
    
    func setupTransforms(percentCompletion: Double){
        
        let translationDelta: CGFloat = 6
        for (i, profile) in profiles.enumerate(){
            if i == 0 {
                continue
            }
            
            var translationA, rotationA, scaleA: CGFloat!
            var translationB, rotationB, scaleB: CGFloat!
            
            if i % 2 == 0 {
                translationA = CGFloat(i) * translationDelta
                rotationA = CGFloat(M_PI) / 100 * CGFloat(i)
                
                translationB = -CGFloat(i-1) * translationDelta
                rotationB = -CGFloat(M_PI) / 100 * CGFloat(i-1)
            }
            else {
                translationA = -CGFloat(i) * translationDelta
                rotationA = -CGFloat(M_PI) / 100 * CGFloat(i)
                
                translationB = CGFloat(i-1) * translationDelta
                rotationB = CGFloat(M_PI) / 100 * CGFloat(i-1)
            }
            
            scaleA = 1 - CGFloat(i) * 0.05
            scaleB = 1 - CGFloat(i - 1) * 0.05
            
            let translation = translationA * (1-CGFloat(percentCompletion) + translationB * CGFloat(percentCompletion))
            let rotation = rotationA * (1-CGFloat(percentCompletion) + rotationB * CGFloat(percentCompletion))
            let scale = scaleA * (1-CGFloat(percentCompletion) + scaleB * CGFloat(percentCompletion))
            
            var transform = CGAffineTransformIdentity
            transform = CGAffineTransformTranslate(transform, translation, 0)
            transform = CGAffineTransformRotate(transform, rotation)
            transform = CGAffineTransformScale(transform, scale, scale)
            
            profile.transform = transform
        }
    }
}