//
//  ChapterFormsViewModel.swift
//  ACL
//
//  Created by zapbuild on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class ChapterFormsViewModel: NSObject {
        var formsData:[FormsDataArray] = []
        override init() {
            self.formsData.append(FormsDataArray(formsHeader: FormsHeader(title: "LEADERSHIP FORMS", isExpended: false), formsTitles: ["ACL Chapter Information (New Chapter","ACL Chapter Information Update form (link)","12 Protocal Starter Kit", "Shared Agreement", "Leader Agreement", "Membership Roaster (Names & Emails)", "Leader Feedback"]))
            
            self.formsData.append(FormsDataArray(formsHeader: FormsHeader(title: " ACL GROUP FORMS", isExpended: false), formsTitles: ["Practice ACL Protocals","Turn in Feedback after each meeting"]))
            
        }
    }

    class FormsDataArray{
        var formsHeader: FormsHeader
        var formsTitles: [String] = []
        init(formsHeader: FormsHeader, formsTitles: [String]) {
            self.formsHeader = formsHeader
            self.formsTitles = formsTitles
        }
    }

    class FormsHeader{
        var title: String
        var isExpended: Bool
        init(title: String, isExpended: Bool) {
            self.title = title
            self.isExpended = isExpended
        }
    }
