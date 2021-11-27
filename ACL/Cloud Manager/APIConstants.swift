//
//  APIConstants.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class APIConstants {
    
    struct EndPoints {
        static let updateSettings = "setting"
        static let login = "login"
        static let singup = "usercreate"
        static let guestLogin = "guestlogin"
        static let verifyOTP = "email-verification"

        static let resetPassword = "passwordreset"
        static let updateProfile = "userupdate"
        static let getProfile = "userinfo"
        static let checkEmailAvailability = "emailcheck"
        static let weeklyChallenge = "weekly-challenge"
        static let challengeComplete = "challenge-complete"
        static let weeklyMeditation = "weekly-meditation"
        static let getCustomSound = "audio-meditation"
        
        static let nearbyACL = "nearbyacl"
        static let aclinfo = "aclinfo"
        static let weeklyQuestion = "weekly-question"
        static let answerPost = "answerpost"
        static let flowerListing = "flowerlisting"
        static let report_Post = "postreport"

        static let uploadRecordingFile = "upload-recording"
        static let aclExercises = "acl-exercise"
        static let news = "news"
        static let home = "home"
        static let search = "search"
        static let addFavorite = "addfavorite"
        //markchecked
        static let markCheck = "markchecked"

        static let create_Chapter = "aclchaptercreate"
        static let weektrainingList = "chaptertraining"
        static let event_Listing = "eventslisting"
        static let join_Event = "eventjoin"
        static let enrolledEvents = "enrolledevents"
        static let favoritelist = "favoritelist"
        static let recordings = "recordings"
        
        static let reportPages = "report"
        
    }
    
    struct favType{
        //favtype --->>
      static let   Quotes = "1"
      static let  question_ofthe_week = "2"
      static let  Garden_post = "3"
      static let  Meditation = "4"
      static let  Journal_entry = "5"
      static let  Excercise = "6"
      static let  Video = "7"
      static let  Articles = "8"
      static let  Contacts = "9"
      static let  Acl_groups = "10"
      static let weekly_challenge = "11"

    }
    
    
    struct Response {
        static let status = "status"
        static let message = "message"
        static let data = "data"
    }
    
    struct StatusCode {
        static let success = 200
    }
    
    struct ResponseMessage {
        static let invalidResponse = "Invalid api response"
        static let unknown = "Something went wrong"
    }
}
