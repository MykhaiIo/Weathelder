//
//  ObjectSaver.swift
//  Weathelder
//
//  Created by Michel on 29/05/2019.
//  Copyright © 2019 PDL. All rights reserved.
//

import UIKit

class ObjectSaver {
    
    var path : URL
    var obj : NSObject
    
    init(with object: NSObject) {
        self.path = ObjectSaver.privateDocsDir
        self.obj = object
    }

    static let privateDocsDir : URL = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let docsDirectoryURL = paths.first!.appendingPathComponent("PrivateDocuments")
        
        do {
            try FileManager.default.createDirectory(at: docsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Couldn't create directory")
        }
        return docsDirectoryURL
    }()
}
