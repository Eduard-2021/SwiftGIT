//
//  NewsPhotoCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsPhotoCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var numberOfItemsInSection = 0
    private var photosOfOneAttachment = [SizeVKNewsPhoto]()
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
        conststrainForCollection.constant = 0
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
        conststrainForCollection.constant = 0
        if (((indexPath.row != 0) && (indexPath.row % 3 == 0)) || numberOfItemsInSection == 1) && photosOfOneAttachment.count != 0 {
            conststrainForCollection.constant = newsCollectionView.frame.size.width
            return CGSize(width: newsCollectionView.frame.size.width - 7, height: newsCollectionView.frame.size.width - 7)
        }
        else
            if photosOfOneAttachment.count != 0 {
                conststrainForCollection.constant = newsCollectionView.frame.size.width/3 + 20
                return CGSize(width: newsCollectionView.frame.size.width/3 - 7, height: newsCollectionView.frame.size.width/3 - 7)
            }
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else
        {return UICollectionViewCell()}
        
        if photosOfOneAttachment.count != 0, let cellNewsImages = cell.newsImages, videoImageURL == "" {
            cellNewsImages.kf.setImage(with: URL(string: photosOfOneAttachment[indexPath.row].url))
            }
        else
            if videoImageURL != "" {
                cell.newsImages.kf.setImage(with: URL(string: videoImageURL))
            }
        
        return cell
        
    }
    
    func config(currentNews: OneNews) {
        numberOfItemsInSection = currentNews.attachments.count
        photosOfOneAttachment = []
        videoImageURL = ""
        
        if numberOfItemsInSection != 0 {
            for value in currentNews.attachments {
                switch value.type {
                case "photo":
                    let sortedPhotosBySize = value.attachmentVKPhoto.photo.sizes.sorted(by: {$0.height < $1.height})
                    if ((photosOfOneAttachment.count != 0) && (photosOfOneAttachment.count % 3 == 0)) || numberOfItemsInSection == 1 {
                        photosOfOneAttachment.append(sortedPhotosBySize.last!)
                    }
                    else {
                        photosOfOneAttachment.append(sortedPhotosBySize[Int(round(Double(sortedPhotosBySize.count/2)))])
                    }
                case "link":
                    numberOfItemsInSection -= 1
                    if photosOfOneAttachment.count == 0 {conststrainForCollection.constant = 0}
                case "video":
                    if photosOfOneAttachment.count == 0 {conststrainForCollection.constant = 0}
                    videoImageURL = value.attachmentVKVideo.video.image.url
                case "audio":
                    numberOfItemsInSection -= 1
                    if photosOfOneAttachment.count == 0 {conststrainForCollection.constant = 0}

                default:
                    return
                }
            }
        }
        newsCollectionView.reloadData()
    }
}
