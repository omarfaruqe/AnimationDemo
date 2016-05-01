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
        //self.backgroundColor = UIColor.blueColor()
        
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
    }
}