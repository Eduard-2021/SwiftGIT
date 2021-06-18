//
//  NewsTableViewController.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    

    static var news : [News] =
        [News(avatarPhoto : UIImage(named: "1")!, avatarName: "Алексей Алексеев", date: "12.04.2021", photo: UIImage(named: "Nature1")!, Comment: "Первый информационный пост", numberOfLiles: 5, iLike: true, numberOfViews: 30),
         News(avatarPhoto : UIImage(named: "2")!, avatarName: "Богдан Богданов", date: "14.04.2021", photo: UIImage(named: "Nature2")!, Comment: "Второй информационный пост", numberOfLiles: 12, iLike: false, numberOfViews: 43),
         News(avatarPhoto : UIImage(named: "3")!, avatarName: "Валентин Валентинов", date: "17.04.2021", photo: UIImage(named: "Nature3")!, Comment: "Третий информационный пост", numberOfLiles: 6, iLike: true, numberOfViews: 20),
         News(avatarPhoto : UIImage(named: "4")!, avatarName: "Глеб Глебов", date: "18.04.2021", photo: UIImage(named: "Nature4")!, Comment: "Четверный информационный пост", numberOfLiles: 10, iLike: false, numberOfViews: 15),]
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//       500.0
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "NewsAvatarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsAvatarCell")
        nib = UINib(nibName: "NewsPhotoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsPhotoCell")
        nib = UINib(nibName: "NewsCommentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsCommentCell")
        nib = UINib(nibName: "NewsLikesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsLikesCell")
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return NewsTableViewController.news.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellNews = UITableViewCell()
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsAvatarCell", for: indexPath) as! NewsAvatarCell
            cell.NewsAvatarImage.image =  NewsTableViewController.news[indexPath.section].avatarPhoto
            cell.NewsAvatarName.text = NewsTableViewController.news[indexPath.section].avatarName
            cell.NewsAvatarDate.text = NewsTableViewController.news[indexPath.section].date
            //cell.backgroundColor = .systemGray5
            cellNews = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCell
            cell.newsPhoto.image =  NewsTableViewController.news[indexPath.section].photo
            cell.newsPhoto.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            cellNews = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCommentCell", for: indexPath) as! NewsCommentCell
            cell.newsComment.text =  NewsTableViewController.news[indexPath.section].Comment
            cellNews = cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesCell", for: indexPath) as! NewsLikesCell
            cell.newsNumberOfLikes.text =  String(NewsTableViewController.news[indexPath.section].numberOfLiles)
            cell.newsNumberOfViews.text =  String(NewsTableViewController.news[indexPath.section].numberOfViews)
            cell.section.text = String(indexPath.section)
            if NewsTableViewController.news[indexPath.section].iLike {
                cell.newsButtonLikesImage.setImage(UIImage(named: "Like")!, for: .normal)

            }
            else {
                cell.newsButtonLikesImage.setImage(UIImage(named: "NoLike")!, for: .normal)
            }
            cellNews = cell
            
        default : break
        }
        return cellNews
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
