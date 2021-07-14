//
//  OneNews.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 01.07.2021.
//

struct OneNews: Decodable {
    var sourceID: Int
    var date: Double
    var text: String
    var attachments = [VKAttachmentCommon]()
    var comments = VKNewsComments()
    var likes = VKNewsLikes()
    var reposts = VKNewsReposts()
    var views = VKNewsViews()
    var postID: Int
    var newsGroupVK = VKGroup(idGroup: 0, nameGroup: "", imageGroupURL: "")
    var newsUserVK = VKUser(idUser: 0, firstName: "", lastName: "", userAvatarURL: "")


struct VKAttachmentCommon {
    var type : String = ""
    var attachmentVKPhoto = VKAttachmentPhoto()
    var attachmentVKLink = VKAttachmentLink()
    var attachmentVKAudio = VKAttachmentAudio()
    var attachmentVKVideo = VKAttachmentVideo()
    }

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case attachments
        case comments
        case likes
        case reposts
        case views
        case postID = "post_id"
    }
        
    enum AttachmentKeys: String, CodingKey {
        case type
        case photo
        case video
        case audio
        case link
    }
    
    enum PhotoKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case userID = "user_id"
        case text
        case date
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case height
        case url
        case type
        case width
    }
    
    enum VideoKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case title
        case image
    }
    
    enum CoverPhotoKeys: String, CodingKey {
        case height
        case width
        case url
    }
    
    enum AudioKeys: String, CodingKey {
        case artist
        case id
        case title
        case trackCode = "track_code"
    }
    
    enum LinkKeys: String, CodingKey {
        case url
        case title
    }
    
    enum CommentsKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }

    enum LikesKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
    
    enum RepostsKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
    
    enum ViewsKeys: String, CodingKey {
        case count
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceID = try values.decode(Int.self, forKey: .sourceID)
        self.date = try values.decode(Double.self, forKey: .date)
        self.text = try values.decode(String.self, forKey: .text)
        self.postID = try values.decode(Int.self, forKey: .postID)
        do {
            var attachmentsVKArray = try values.nestedUnkeyedContainer(forKey: .attachments)
            while !attachmentsVKArray.isAtEnd {
                var oneAttachment = VKAttachmentCommon()
                let valuesAttachment = try attachmentsVKArray.nestedContainer(keyedBy: AttachmentKeys.self)
                oneAttachment.type = try valuesAttachment.decode(String.self, forKey: .type)
                    
                    switch oneAttachment.type {
                    case "photo":
                        let photoValues = try valuesAttachment.nestedContainer(keyedBy: PhotoKeys.self, forKey: .photo)
                        oneAttachment.attachmentVKPhoto.photo.id = try photoValues.decode(Int.self, forKey: .id)
                        oneAttachment.attachmentVKPhoto.photo.ownerID = try photoValues.decode(Int.self, forKey: .ownerID)
                        oneAttachment.attachmentVKPhoto.photo.userID = try photoValues.decode(Int.self, forKey: .userID)
                        oneAttachment.attachmentVKPhoto.photo.text = try photoValues.decode(String.self, forKey: .text)
                        oneAttachment.attachmentVKPhoto.photo.date = try photoValues.decode(Double.self, forKey: .date)

                        var sizesValuesUnkeyed = try photoValues.nestedUnkeyedContainer(forKey: .sizes)
                        while !sizesValuesUnkeyed.isAtEnd {
                            let sizesValues = try sizesValuesUnkeyed.nestedContainer(keyedBy: SizesKeys.self)
                            var sizeOnePhoto = SizeVKNewsPhoto()
                            sizeOnePhoto.height = try sizesValues.decode(Int.self, forKey: .height)
                            sizeOnePhoto.url = try sizesValues.decode(String.self, forKey: .url)
                            sizeOnePhoto.type = try sizesValues.decode(String.self, forKey: .type)
                            sizeOnePhoto.width = try sizesValues.decode(Int.self, forKey: .width)
                            oneAttachment.attachmentVKPhoto.photo.sizes.append(sizeOnePhoto)
                        }
                    case "audio":
                        let audioValues = try valuesAttachment.nestedContainer(keyedBy: AudioKeys.self, forKey: .audio)
                        oneAttachment.attachmentVKAudio.audio.artist = try audioValues.decode(String.self, forKey: .artist)
                        oneAttachment.attachmentVKAudio.audio.id = try audioValues.decode(Int.self, forKey: .id)
                        oneAttachment.attachmentVKAudio.audio.title = try audioValues.decode(String.self, forKey: .title)
                        oneAttachment.attachmentVKAudio.audio.trackCode = try audioValues.decode(String.self, forKey: .trackCode)
                    case "video":
                        let videoValues = try valuesAttachment.nestedContainer(keyedBy: VideoKeys.self, forKey: .video)
                        oneAttachment.attachmentVKVideo.video.id = try videoValues.decode(Int.self, forKey: .id)
                        oneAttachment.attachmentVKVideo.video.ownerID = try videoValues.decode(Int.self, forKey: .ownerId)
                        oneAttachment.attachmentVKVideo.video.title = try videoValues.decode(String.self, forKey: .title)
                        let coverPhotoValues = try videoValues.nestedContainer(keyedBy: CoverPhotoKeys.self, forKey: .image)
                        oneAttachment.attachmentVKVideo.video.image.height = try coverPhotoValues.decode(Int.self, forKey: .height)
                        oneAttachment.attachmentVKVideo.video.image.url = try coverPhotoValues.decode(String.self, forKey: .url)
                        oneAttachment.attachmentVKVideo.video.image.width = try coverPhotoValues.decode(Int.self, forKey: .width)
                    case "link":
                        let linkValues = try valuesAttachment.nestedContainer(keyedBy: LinkKeys.self, forKey: .link)
                        oneAttachment.attachmentVKLink.link.title = try linkValues.decode(String.self, forKey: .title)
                        oneAttachment.attachmentVKLink.link.url = try linkValues.decode(String.self, forKey: .url)
                    default:
                        print("Появился еще один тип Attachment")
                    }
                        attachments.append(oneAttachment)
            }
        }
        catch {}
        let commentsValue = try values.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
            comments.count = try commentsValue.decode(Int.self, forKey: .count)
            comments.canPost = try commentsValue.decode(Int.self, forKey: .canPost)
        let likesValue = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
            likes.count = try likesValue.decode(Int.self, forKey: .count)
            likes.userLikes = try likesValue.decode(Int.self, forKey: .userLikes)
            likes.canLike = try likesValue.decode(Int.self, forKey: .canLike)
            likes.canPublish = try likesValue.decode(Int.self, forKey: .canPublish)
        let repostsValue = try values.nestedContainer(keyedBy: RepostsKeys.self, forKey: .reposts)
            reposts.count = try repostsValue.decode(Int.self, forKey: .count)
            reposts.userReposted = try repostsValue.decode(Int.self, forKey: .userReposted)
        let viewsValue = try values.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
            views.count = try viewsValue.decode(Int.self, forKey: .count)
    }

}


/*
extension OneNews: Decodable {
    enum CodingKeys: String, CodingKey {
        case date
        case text
        case attachments
        case comments
        case likes
        case reposts
        case views
        case sourceID = "source_id"
        case postID = "post_id"
    }
}
*/
/*
 "items": [{
 "source_id": -161486117,
 "date": 1625141580,
 "can_doubt_category": false,
 "can_set_category": false,
 "category_action": {
 "action": {
 "target": "internal",
 "type": "open_url",
 "url": "vk.com/discover?id=discover_category/26"
 },
 "name": "Кино"
 },
 "post_type": "post",
 "text": "Эмма Робертс на новых фото со съёмок голливудской адаптации «Иронии судьбы».",
 "marked_as_ads": 0,
 "attachments": [{
 "type": "photo",
 "photo": {
 "album_id": -7,
 "date": 1625068704,
 "id": 457450781,
 "owner_id": -161486117,
 "has_tags": false,
 "access_key": "f830a7f99439d8cea8",
 "sizes": [{
 "height": 130,
 "url": "https://sun6-23.u...xm4Q&type=album",
 "type": "m",
 "width": 97
 }, {...}, {...}, {...}, {...}, {...}, {...}, {...}, {...}, {...}],
 "text": "",
 "user_id": 100
 }
 }, {...}],
 "post_source": {...},
 "comments": {
 "count": 3,
 "can_post": 1,
 "groups_can_post": true
 },
 "likes": {
 "count": 171,
 "user_likes": 0,
 "can_like": 1,
 "can_publish": 1
 },
 "reposts": {
 "count": 23,
 "user_reposted": 0
 },
 "views": {
 "count": 8677
 },
 "is_favorite": false,
 "donut": {
 "is_donut": false
 },
 "short_text_rate": 0.8,
 "carousel_offset": 0,
 "post_id": 1698599,
 "type": "post"
 },
 */
