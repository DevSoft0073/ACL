//
//  AboutChapterViewModel.swift
//  ACL
//
//  Created by zapbuild on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class AboutChapterViewModel: NSObject {

    var chaptersData:[ChapterDataArray] = []
    override init() {
        self.chaptersData.append(ChapterDataArray(chapterHeader: ChapterHeader(title: "All Chapters", isExpended: false), chapterTitles: ["Practice ACL Protocals","Sign Leader Agreements","Turn in Feedback after each meeting"]))
        
        self.chaptersData.append(ChapterDataArray(chapterHeader: ChapterHeader(title: "Public Chapter", isExpended: false), chapterTitles: ["Practice ACL Protocals","Turn in Feedback after each meeting"]))
        
        self.chaptersData.append(ChapterDataArray(chapterHeader: ChapterHeader(title: "Private Chapter", isExpended: false), chapterTitles: ["Practice ACL Protocals","Sign Leader Agreements"]))
    }
}

class ChapterDataArray{
    var chapterHeader: ChapterHeader
    var chapterTitles: [String] = []
    init(chapterHeader: ChapterHeader, chapterTitles: [String]) {
        self.chapterHeader = chapterHeader
        self.chapterTitles = chapterTitles
    }
}

class ChapterHeader{
    var title: String
    var isExpended: Bool
    init(title: String, isExpended: Bool) {
        self.title = title
        self.isExpended = isExpended
    }
}
