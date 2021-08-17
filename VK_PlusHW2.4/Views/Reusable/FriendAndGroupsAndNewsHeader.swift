//
//  FriendAndGroupsHeader.swift
//  VK_PlusHW7
//
//  Created by Eduard on 20.04.2021.
//

import UIKit

class FriendAndGroupsAndNewsHeader: UITableViewHeaderFooterView {

    private let myLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()
    
    private let myView : UIView = {
        let myView = UIView()
        return myView
    }()
    
    
    override var reuseIdentifier: String? {
        "TableSectionHeaderView"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myLabel.text = nil
    }
    
    override init (reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configurateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateViews() {
        contentView.addSubview(myView)
        contentView.addSubview(myLabel)
        makeGradient(myView)
    }
    
    func configure(with text : String, colorOfCell : UIColor = UIColor.systemBlue){
        myLabel.text = text
        myView.backgroundColor = colorOfCell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myLabel.frame = CGRect(x: 20, y: self.bounds.midY-15, width: 50, height: 30)
        myView.frame = self.bounds
    }
}
