//
//  ProfileView.swift
//  DatingApp
//
//  Created by Omar Faruqe on 2016-05-01.
//  Copyright © 2016 Omar Faruqe. All rights reserved.
//

import UIKit


class ProfileView: UIView{
    
    var person: Person! {
        didSet{
            imageView.image = person.image
            nameLabel.text = person.name
            ageLabel.text = String(person.age)
        }
    }
    
    let likeLabel = StatusPill()
    let nopeLabel = StatusPill()
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let ageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    func defaultInit(){
        self.backgroundColor = UIColor.whiteColor()
        
        for v in [imageView, nameLabel, ageLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(v)
        }
        
        //Image View
        NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.8, constant: 0).active = true
        
        //Name
        NSLayoutConstraint(item: nameLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: nameLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 7).active = true
        NSLayoutConstraint(item: nameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        
        //Age
        NSLayoutConstraint(item: ageLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: ageLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -7).active = true
        NSLayoutConstraint(item: ageLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        nameLabel.textAlignment = .Left
        
        ageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        ageLabel.textAlignment = .Right
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        
        for v in [nopeLabel, likeLabel] {
            self.addSubview(v)
            
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: v, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: v, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0).active = true
            v.alpha = 0
        }
        
        nopeLabel.text = "Nope"
        nopeLabel.color = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1)
        
        likeLabel.text = "Like"
        likeLabel.color = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1)
    }
}