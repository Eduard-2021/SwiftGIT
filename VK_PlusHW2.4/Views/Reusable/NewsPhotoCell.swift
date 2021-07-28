//
//  NewsPhotoCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsPhotoCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var numberOfItemsInSection = 0
    private var currentNews: OneNews!
    private var photosOfOneAttachment = [SizeVKNewsPhoto]()
    private var videoImageURL = ""

    @IBOutlet weak var newsCollectionView: UICollectionView! {
        didSet {
            newsCollectionView.dataSource = self
            newsCollectionView.delegate = self
        }
    }
    private var photoURL = [String]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cellName = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        newsCollectionView.register(cellName, forCellWithReuseIdentifier: "NewsCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsInSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (((numberOfItemsInSection - 2) % 4 == 0)||((numberOfItemsInSection - 1) % 4 == 0)) && ((indexPath.row == numberOfItemsInSection-1) || (indexPath.row == numberOfItemsInSection-2)) && numberOfItemsInSection != 1  {
            return CGSize(width: newsCollectionView.frame.size.width/2 - 7, height: newsCollectionView.frame.size.width/2 - 7)
        }
        else
        if (((indexPath.row != 0) && ((indexPath.row+1) % 4 == 0)) || numberOfItemsInSection == 1) && photosOfOneAttachment.count != 0 {
            var proportion = 1.0
            for (index,value) in currentNews.attachments.enumerated() {
                if (value.type == "photo") && (index==indexPath.row) {
                    proportion = value.attachmentVKPhoto.photo.aspectRatio
                }
            }
            return CGSize(width: newsCollectionView.frame.size.width - 7, height:CGFloat( Double(newsCollectionView.frame.size.width)*proportion - 7))
        }
        else
            if photosOfOneAttachment.count != 0 {
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
        separatorInset.left = contentView.frame.size.width
        self.currentNews = currentNews

        if numberOfItemsInSection != 0 {
            for value in currentNews.attachments {
                switch value.type {
                case "photo":
                    let sortedPhotosBySize = value.attachmentVKPhoto.photo.sizes.sorted(by: {$0.height < $1.height})
                    if ((photosOfOneAttachment.count != 0) && ((photosOfOneAttachment.count+1) % 4 == 0)) || numberOfItemsInSection == 1 {
                        photosOfOneAttachment.append(sortedPhotosBySize.last!)
                    }
                    else {
                        photosOfOneAttachment.append(sortedPhotosBySize[Int(round(Double(sortedPhotosBySize.count/2)))])
                    }
                case "link":
                    numberOfItemsInSection -= 1
                case "video":
                    videoImageURL = value.attachmentVKVideo.video.image.url
                case "audio":
                    numberOfItemsInSection -= 1

                default:
                    return
                }
            }
        }
        newsCollectionView.reloadData()
    }
}
