//
//  ShowMoreCell.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 25.07.2021.
//

import UIKit

class ShowMoreOrLessCell: UITableViewCell {
    
    var dateForUpgrate = NecessaryDatesForChangeSizeNewsCommentCell()
    var mainNewsVC: DelegeteForChangeSizeNewsCommenCell?
    
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
            dateForUpgrate.commentCellIsSmall = false
            dateForUpgrate.buttonPressed = true
            dateForUpgrate.moreButtonPressed = true
            let dates = ["dates":dateForUpgrate]
            mainNewsVC?.changeSizeOfCommentCell(data: dateForUpgrate)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeHeightOfCommentCell"), object: nil, userInfo: dates)
        }
        else {
            showButton.setTitle("Show more ...", for: [])
            dateForUpgrate.commentCellIsSmall = true
            dateForUpgrate.buttonPressed = true
            dateForUpgrate.moreButtonPressed = false
            let dates = ["dates":dateForUpgrate]
            mainNewsVC?.changeSizeOfCommentCell(data: dateForUpgrate)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeHeightOfCommentCell"), object: nil, userInfo: dates)
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
    
    
    func config(numberSection: Int){
        dateForUpgrate.numberSectionForUpdate = numberSection
 
        if let sectionHasButtonMoreLess = NewsTableViewController.sectionsWithFullComments[numberSection] {
            if sectionHasButtonMoreLess {
                showButton.setTitle("Show less ...", for: [])
                dateForUpgrate.commentCellIsSmall = true
            }
            else {showButton.setTitle("Show more ...", for: [])}
        }
        
    }
    
}
