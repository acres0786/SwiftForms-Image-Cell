//
//  CustomController.swift
//  SwiftFormsApplication
//
//  Created by Edward Clavito on 09/01/2016.
//  Copyright © 2016 Miguel Angel Ortuno Ortuno. All rights reserved.
//

import Foundation
import SwiftForms

class ImageCell : FormBaseCell {
    
    let titleLabel = UILabel()
    let imageObject = UIImage()
    let imageContainer = UIImageView()
    
    
    override func configure() {
        super.configure()
        
        selectionStyle = .None
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        textField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        if let checkedUrl = NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            imageContainer.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl)
        }
        
//        imageContainer.image = imageObject
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageContainer)
        
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: imageContainer, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: imageContainer, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
//        textField.addTarget(self, action: "editingChanged:", forControlEvents: .EditingChanged)
    }
    
    override func update() {
        super.update()
        
        if let showsInputToolbar = rowDescriptor.configuration[FormRowDescriptor.Configuration.ShowsInputToolbar] as? Bool {
            if showsInputToolbar && imageContainer.inputAccessoryView == nil {
//                imageContainer.inputAccessoryView = inputAccesoryView()
            }
        }
        
        titleLabel.text = rowDescriptor.title
//        textField.text = rowDescriptor.value as? String
//        textField.placeholder = rowDescriptor.configuration[FormRowDescriptor.Configuration.Placeholder] as? String
//        
//        textField.secureTextEntry = false
//        textField.clearButtonMode = .WhileEditing
    }
    
    override class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    override class func formViewController(formViewController: FormViewController, didSelectRow: FormBaseCell) {
//        formViewController.tableView.reloadData()
        
    }
    
    override func constraintsViews() -> [String : UIView] {
        var views = ["titleLabel" : titleLabel, "imageContainer" : imageContainer]
        if self.imageView!.image != nil {
            views["imageView"] = imageView
        }
        return views
    }
    
    override func defaultVisualConstraints() -> [String] {
        
        if self.imageView!.image != nil {
            
            if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
                return ["H:[imageView]-[titleLabel]-[imageContainer]-16-|"]
            }
            else {
                return ["H:[imageView]-[imageContainer]-16-|"]
            }
        }
        else {
            if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
                return ["H:|-16-[titleLabel]-[imageContainer]-16-|"]
            }
            else {
                return ["H:|-16-[imageContainer]-16-|"]
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imageContainer.image = UIImage(data: data)
            }
        }
    }
}