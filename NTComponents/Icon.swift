//
//  Icon.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/2/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import Foundation

public struct Icon {
    
    /// An internal reference to the icons bundle.
    private static var internalBundle: Bundle?
    
    /**
     A public reference to the icons bundle, that aims to detect
     the correct bundle to use.
     */
    public static var bundle: Bundle {
        if nil == Icon.internalBundle {
            Icon.internalBundle = Bundle(for: NTView.self)
            let url = Icon.internalBundle!.resourceURL!
            let b = Bundle(url: url)
            if let v = b {
                Icon.internalBundle = v
            }
        }
        return Icon.internalBundle!
    }
    
    /// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    public static let facebook = UIImage(named: "ic_facebook_logo", in: bundle, compatibleWith: nil)
    public static let twitter = UIImage(named: "ic_twitter_logo", in: bundle, compatibleWith: nil)
    public static let google = UIImage(named: "ic_google_logo", in: bundle, compatibleWith: nil)
    public static let email = UIImage(named: "ic_email_logo", in: bundle, compatibleWith: nil)
    
    // Google icons
    public struct Google {
        public static let add = Icon.icon("ic_add_white")
        public static let addCircle = Icon.icon("ic_add_circle_white")
        public static let addCircleOutline = Icon.icon("ic_add_circle_outline_white")
        public static let arrowBack = Icon.icon("ic_arrow_back_white")
        public static let arrowDownward = Icon.icon("ic_arrow_downward_white")
        public static let audio = Icon.icon("ic_audiotrack_white")
        public static let cameraFront = Icon.icon("ic_camera_front_white")
        public static let cameraRear = Icon.icon("ic_camera_rear_white")
        public static let check = Icon.icon("ic_check_white")
        public static let clear = Icon.icon("ic_close_white")
        public static let close = Icon.icon("ic_close_white")
        public static let edit = Icon.icon("ic_edit_white")
        public static let email = Icon.icon("ic_email_white")
        public static let favorite = Icon.icon("ic_favorite_white")
        public static let favoriteBorder = Icon.icon("ic_favorite_border_white")
        public static let flashAuto = Icon.icon("ic_flash_auto_white")
        public static let flashOff = Icon.icon("ic_flash_off_white")
        public static let flashOn = Icon.icon("ic_flash_on_white")
        public static let history = Icon.icon("ic_history_white")
        public static let home = Icon.icon("ic_home_white")
        public static let image = Icon.icon("ic_image_white")
        public static let menu = Icon.icon("ic_menu_white")
        public static let moreHorizontal = Icon.icon("ic_more_horiz_white")
        public static let moreVertical = Icon.icon("ic_more_vert_white")
        public static let movie = Icon.icon("ic_movie_white")
        public static let pen = Icon.icon("ic_edit_white")
        public static let place = Icon.icon("ic_place_white")
        public static let phone = Icon.icon("ic_phone_white")
        public static let photoCamera = Icon.icon("ic_photo_camera_white")
        public static let photoLibrary = Icon.icon("ic_photo_library_white")
        public static let search = Icon.icon("ic_search_white")
        public static let settings = Icon.icon("ic_settings_white")
        public static let share = Icon.icon("ic_share_white")
        public static let star = Icon.icon("ic_star_white")
        public static let starBorder = Icon.icon("ic_star_border_white")
        public static let starHalf = Icon.icon("ic_star_half_white")
        public static let videocam = Icon.icon("ic_videocam_white")
        public static let visibility = Icon.icon("ic_visibility_white")
        public static let send = Icon.icon("ic_send_white")
    }
    
    // Apple Icons
    public struct Apple {
        public static let check = Icon.icon("ic_checkmark")
        public static let comment = Icon.icon("ic_comment")
        public static let commentFilled = Icon.icon("ic_comment_filled")
        public static let edit = Icon.icon("ic_edit")
        public static let editFilled = Icon.icon("ic_edit_filled")
        public static let like = Icon.icon("ic_like")
        public static let likeFilled = Icon.icon("ic_like_filled")
        public static let moreVertical = Icon.icon("ic_more_vertical")
        public static let moreVerticalFilled = Icon.icon("ic_more_vertical_filled")
        public static let moreHorizontal = Icon.icon("ic_more_horizontal")
        public static let moreHorizontalFilled = Icon.icon("ic_more_horizontal_filled")
        public static let arrowForward = Icon.icon("ic_forward")
        public static let arrowForwardFilled = Icon.icon("ic_forward_filled")
        public static let arrowBackward = Icon.icon("ic_backward")
        public static let arrowBackwardFilled = Icon.icon("ic_backward_filled")
        public static let heart = Icon.icon("ic_heart")
        public static let heartFilled = Icon.icon("ic_heart_filled")
        public static let info = Icon.icon("ic_info")
        public static let infoFilled = Icon.icon("ic_info_filled")
        public static let menu = Icon.icon("ic_menu")
        public static let menuFilled = Icon.icon("ic_menu_filled")
        public static let message = Icon.icon("ic_message")
        public static let messageFilled = Icon.icon("ic_message_filled")
        public static let plus = Icon.icon("ic_plus")
        public static let plusFilled = Icon.icon("ic_plus_filled")
        public static let inbox = Icon.icon("ic_inbox")
        public static let inboxFilled = Icon.icon("ic_inbox_filled")
        public static let hub = Icon.icon("ic_hub")
        public static let hubFilled = Icon.icon("ic_hub_filled")
        public static let feed = Icon.icon("ic_feed")
        public static let feedFilled = Icon.icon("ic_feed_filled")
        public static let team = Icon.icon("ic_team_filled")
        public static let teamFilled = Icon.icon("ic_team_filled")
        public static let profile = Icon.icon("ic_profile")
        public static let profileFilled = Icon.icon("ic_profile_filled")
    }
}
