//
//  ShowMoreCell.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 25.07.2021.
//

import UIKit

//@IBOutlet weak var showButton: UIButton!

class ShowMoreOrLessCell: UITableViewCell {
    
//    static var numberSection: Int!
//    static var commentCellIsSmall = true
//    static var buttonPressed = false
//    var numberSectionCurrent: Int!
    
    var dataForUpgrate = necessaryDatesForChangeSizeNewsCommentCell()
    
    private var showButton: UIButton = {
        let button = UIButton()
        button.isHidden = false
        button.setTitle("", for: [])
        button.setTitleColor(.systemBlue, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(showButton)
        showButton.addTarget(self, action: #selector(showButtonPushed), for: .touchUpInside)
        makeConstrans()
    }
    
    @objc func showButtonPushed() {
        if showButton.titleLabel?.text == "Show more ..." {
            showButton.setTitle("Show less ...", for: [])
            dataForUpgrate.commentCellIsSmall = false
            dataForUpgrate.buttonPressed = true
//            dataForUpgrate.numberSection = numberSectionCurrent
            dataForUpgrate.moreButtonPressed = true
            let dates = ["dates":dataForUpgrate]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeHeightOfCommentCell"), object: nil, userInfo: dates)
        }
        else {
            showButton.setTitle("Show more ...", for: [])
            dataForUpgrate.commentCellIsSmall = true
            dataForUpgrate.buttonPressed = true
//            ShowMoreOrLessCell.numberSection = numberSectionCurrent
            dataForUpgrate.moreButtonPressed = false
            let dates = ["dates":dataForUpgrate]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeHeightOfCommentCell"), object: nil, userInfo: dates)
        }
    }
    
    private func makeConstrans(){
        showButton.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(0)
            make.top.equalTo(contentView.snp.top).offset(0)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showButton.titleLabel?.text = nil
    }
    
    
    func config(numberSection: Int, needButtonMoreOrLesstext: Bool, moreButtonPressed: Bool = false){
        dataForUpgrate.numberSectionForUpdate = numberSection
 
        if let sectionHasButtonMoreLess = NewsTableViewController.sectionsWithFullComments[numberSection] {
            if sectionHasButtonMoreLess {
                showButton.setTitle("Show less ...", for: [])
                dataForUpgrate.commentCellIsSmall = true
            }
            else {showButton.setTitle("Show more ...", for: [])}
        }
        
//
//        if !moreButtonPressed {
//            showButton.setTitle("Show more ...", for: [])
//        }
//        else {
//            showButton.setTitle("Show less ...", for: [])
//            dataForUpgrate.commentCellIsSmall = true
//        }
//        if !needButtonMoreOrLesstext {
//            showButton.isHidden = true
//        }
//        else {
//            showButton.isHidden = false
//        }
    }
    
}
