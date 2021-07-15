//
//  VKAttachments.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 02.07.2021.
//

struct VKAttachmentCommon: Decodable {
    var type : String
    var attachmentVKPhoto = VKAttachmentPhoto()
    var attachmentVKLink = VKAttachmentLink()
    var attachmentVKAudio = VKAttachmentAudio()
    var attachmentVKVideo = VKAttachmentVideo()
    
    enum CodingKeys: String, CodingKey {
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
    
    
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try values.decode(String.self, forKey: .type)
        
        switch self.type {
        case "photo":
            let photoValues = try values.nestedContainer(keyedBy: PhotoKeys.self, forKey: .photo)
            attachmentVKPhoto.photo.id = try photoValues.decode(Int.self, forKey: .id)
            attachmentVKPhoto.photo.ownerID = try photoValues.decode(Int.self, forKey: .ownerID)
            attachmentVKPhoto.photo.userID = try photoValues.decode(Int.self, forKey: .userID)
            attachmentVKPhoto.photo.text = try photoValues.decode(String.self, forKey: .text)
            attachmentVKPhoto.photo.date = try photoValues.decode(Double.self, forKey: .date)

            var sizesValuesUnkeyed = try photoValues.nestedUnkeyedContainer(forKey: .sizes)
            while !sizesValuesUnkeyed.isAtEnd {
                let sizesValues = try sizesValuesUnkeyed.nestedContainer(keyedBy: SizesKeys.self)
                var sizeOnePhoto = SizeVKNewsPhoto()
                sizeOnePhoto.height = try sizesValues.decode(Int.self, forKey: .height)
                sizeOnePhoto.url = try sizesValues.decode(String.self, forKey: .url)
                sizeOnePhoto.type = try sizesValues.decode(String.self, forKey: .type)
                sizeOnePhoto.width = try sizesValues.decode(Int.self, forKey: .width)
                attachmentVKPhoto.photo.sizes.append(sizeOnePhoto)
            }
        case "audio":
            let audioValues = try values.nestedContainer(keyedBy: AudioKeys.self, forKey: .audio)
            attachmentVKAudio.audio.artist = try audioValues.decode(String.self, forKey: .artist)
            attachmentVKAudio.audio.id = try audioValues.decode(Int.self, forKey: .id)
            attachmentVKAudio.audio.title = try audioValues.decode(String.self, forKey: .title)
            attachmentVKAudio.audio.trackCode = try audioValues.decode(String.self, forKey: .trackCode)
        case "video":
            let videoValues = try values.nestedContainer(keyedBy: VideoKeys.self, forKey: .video)
            attachmentVKVideo.video.id = try videoValues.decode(Int.self, forKey: .id)
            attachmentVKVideo.video.ownerID = try videoValues.decode(Int.self, forKey: .ownerId)
            attachmentVKVideo.video.title = try videoValues.decode(String.self, forKey: .title)
            let coverPhotoValues = try videoValues.nestedContainer(keyedBy: CoverPhotoKeys.self, forKey: .image)
            attachmentVKVideo.video.image.height = try coverPhotoValues.decode(Int.self, forKey: .height)
            attachmentVKVideo.video.image.url = try coverPhotoValues.decode(String.self, forKey: .url)
            attachmentVKVideo.video.image.width = try coverPhotoValues.decode(Int.self, forKey: .width)
        case "link":
            let linkValues = try values.nestedContainer(keyedBy: LinkKeys.self, forKey: .link)
            attachmentVKLink.link.title = try linkValues.decode(String.self, forKey: .title)
            attachmentVKLink.link.url = try linkValues.decode(String.self, forKey: .url)
        default:
            print("Появился еще один тип Attachment")
        }

    }

}

