//
//  QuickTransitionControl.swift
//  VK_PlusHW9.2
//
//  Created by Eduard on 10.05.2021.
//

import UIKit

class QuickTransitionControl : UIControl {
    var selectedSection : Character? {
        didSet {
            updateSelectedSection(selectedSection: selectedSection!)
            sendActions(for: .valueChanged)
        }
    }
    var namesOfSections = [Character]()
    var setOfButtons = [Character : UIButton]()
    var arrayOfButtons = [UIButton]()
    var stackView : UIStackView!
    
    init (namesOfSections : [Character], frame : CGRect) {
        super.init(frame: frame)
        self.namesOfSections = namesOfSections
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        namesOfSections.forEach({firstCharacter in
            let button = UIButton(type: .custom)
            button.backgroundColor = .systemGray3
            button.setTitle(String(firstCharacter), for: [])
            button.setTitleColor(.white, for: [])
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
            button.addTarget(self, action: #selector(selectSection), for: .touchUpInside)
            
            let constrainWidthOfButton = NSLayoutConstraint(item: button,
                                         attribute: NSLayoutConstraint.Attribute.width,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: nil,
                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                         multiplier: 1.0,
                                         constant: FriendsViewTableController.heightQuickTransitionControl)
            constrainWidthOfButton.isActive = true
            let constrainHeightOfButton = NSLayoutConstraint(item: button,
                                         attribute: NSLayoutConstraint.Attribute.height,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: nil,
                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                         multiplier: 1.0,
                                         constant: FriendsViewTableController.heightQuickTransitionControl)
            constrainHeightOfButton.isActive = true

            button.translatesAutoresizingMaskIntoConstraints = false
            button.addConstraints([constrainHeightOfButton,constrainHeightOfButton])
            setOfButtons[firstCharacter] = button
            arrayOfButtons.append(button)
        })
        stackView = UIStackView(arrangedSubviews: arrayOfButtons)
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .equalCentering
        stackView.spacing = 5.0
        
        addSubview(stackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func updateSelectedSection(selectedSection : Character) {
        setOfButtons.forEach({(key,value) in
                                value.isSelected = false
                                value.backgroundColor = .systemGray3
        })
    
        stackView.bringSubviewToFront(setOfButtons[selectedSection]!)
        
        UIView.animateKeyframes(withDuration: 0.7,
                                delay: 0,
                                options: [.overrideInheritedDuration],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.33,
                                                       animations: { [self] in
                                                       setOfButtons[selectedSection]?.transform = CGAffineTransform(scaleX: 2, y: 2)
                                                       setOfButtons[selectedSection]?.isSelected = true
                                                       setOfButtons[selectedSection]?.backgroundColor = .link
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.67,
                                                       relativeDuration: 0.33,
                                                       animations: { [self] in
                                                       setOfButtons[selectedSection]?.transform = .identity
                                                       })
                                },
                                completion: nil)
    }
    
    @objc private func selectSection(_ sender : UIButton) {
        setOfButtons.forEach({(key,value) in if value == sender {selectedSection = key}})
    }
}
