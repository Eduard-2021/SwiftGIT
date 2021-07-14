//
//  NewsPhotoCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsPhotoCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var numberOfItemsInSection = 0
    private var sortedArrayByProportionFor3Photos = [SizeVKNewsPhoto]()
    private var sortedArrayByProportionFor1Photos = [SizeVKNewsPhoto]()
    private var videoImageURL = ""

    @IBOutlet weak var conststrainForCollection: NSLayoutConstraint!
    @IBOutlet weak var newsCollectionView: UICollectionView! {
        didSet {
            newsCollectionView.dataSource = self
            newsCollectionView.delegate = self
        }
    }
    private var photoURL = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        conststrainForCollection.constant = 200
        let cellName = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        newsCollectionView.register(cellName, forCellWithReuseIdentifier: "NewsCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsInSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if ((indexPath.row != 0) && (indexPath.row % 3 == 0)) || numberOfItemsInSection == 1 {
            conststrainForCollection.constant = newsCollectionView.frame.size.width
            return CGSize(width: newsCollectionView.frame.size.width - 7, height: newsCollectionView.frame.size.width - 7)
        }
        else {
            conststrainForCollection.constant = newsCollectionView.frame.size.width/3 + 20
            return CGSize(width: newsCollectionView.frame.size.width/3 - 7, height: newsCollectionView.frame.size.width/3 - 7)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        if indexPath.row+1 <= sortedArrayByProportionFor3Photos.count {
            cell.newsImages.kf.setImage(with: URL(string: sortedArrayByProportionFor3Photos[indexPath.row].url))
        }
        return cell
        
    }
    
    func config(currentNews: OneNews) {
        numberOfItemsInSection = currentNews.attachments.count
        let proportionSidesOfItem = Double(newsCollectionView.frame.size.width/newsCollectionView.frame.size.height)
        
        if numberOfItemsInSection != 0 {
            for value in currentNews.attachments {
                switch value.type {
                case "photo":
                    let sortedFor3Photos = value.attachmentVKPhoto.photo.sizes.sorted(by: {abs(1 - $0.height/$0.width) < abs(1 - $1.height/$1.width)})
                    sortedArrayByProportionFor3Photos.append(sortedFor3Photos[0])
                    
                    let sortedFor1Photos = value.attachmentVKPhoto.photo.sizes.sorted(by: {abs(proportionSidesOfItem - Double($0.width/$0.height)) < abs(proportionSidesOfItem - Double($1.width/$1.height))})
                    sortedArrayByProportionFor1Photos.append(sortedFor1Photos[0])
                    
                case "link":
                    print(value.attachmentVKLink.link.title, " ", value.attachmentVKLink.link.url)
                case "video":
                    videoImageURL = value.attachmentVKVideo.video.image.url
                case "audio":
                    print(value.attachmentVKAudio.audio.title)

                default:
                    return
                }
            }
        }
    }
}
