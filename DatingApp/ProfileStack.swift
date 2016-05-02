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
    
    func pan(gesture: UIPanGestureRecognizer){
        let profile = gesture.view! as! ProfileView
        
        let translation = gesture.translationInView(self)
        
        var percent = translation.x / CGRectGetMidX(self.bounds)
        percent = min(percent, 1)
        percent = max(percent, -1)
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.setupTransforms(abs(Double(percent)))
            }, completion: nil)
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, translation.x, translation.y)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI) * percent / 30)
        
        profile.transform = transform
        
        if gesture.state == .Ended {
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [], animations: {
                () -> Void in
                    profile.transform = CGAffineTransformIdentity
                }, completion: nil)
            
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