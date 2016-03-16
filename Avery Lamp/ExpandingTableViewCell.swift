//
//  ExpandingTableViewCell.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 3/14/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import UIKit

class ExpandingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var sideHighlight = UIView()
    var contentBackground = UIView()
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            
            
        }else{
            
            
            
        }
        
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       let margin = 10.0
        contentBackground.translatesAutoresizingMaskIntoConstraints = false
        contentBackground.layer.cornerRadius = 5
        contentView.addSubview(contentBackground)
        let viewDictionary = ["content":contentBackground,"contentView":contentView, "highlight":sideHighlight]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(margin)-[content]-\(margin)-|", options: [], metrics: nil, views: viewDictionary))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(margin)-[content]-\(margin)-|", options: [], metrics: nil, views: viewDictionary))
        
        sideHighlight.translatesAutoresizingMaskIntoConstraints = false
        sideHighlight.backgroundColor = UIColor.orangeColor()
        contentBackground.addSubview(sideHighlight)
        contentBackground.layer.masksToBounds = true
        contentBackground.clipsToBounds = true
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[highlight(4)]", options: [], metrics: nil, views: viewDictionary))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[highlight]|", options: [], metrics: nil, views: viewDictionary))

        contentBackground.backgroundColor = UIColor.grayColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

}
