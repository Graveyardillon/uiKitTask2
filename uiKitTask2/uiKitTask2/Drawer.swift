//
//  Drawer.swift
//  uiKitTask2
//
//  Created by Papillon on 2019/11/04.
//  Copyright © 2019 Papillon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Drawer: UIView, UITextFieldDelegate {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func draw(_ rect: CGRect) {
    let bPath : UIBezierPath = UIBezierPath(rect: rect)
    let fillColor : UIColor = UIColor.init(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
    let strokeColor : UIColor = UIColor.init(red: 1, green: 0.5686, blue: 0.8314, alpha: 1)
    
    bPath.lineWidth = 3
    fillColor.setFill()
    bPath.fill()
    strokeColor.setStroke()
    strokeColor.set()
    bPath.stroke()
    
    let myTextField: UITextField = UITextField()
    myTextField.frame = CGRect(
      origin: CGPoint(
        x: rect.origin.x,
        y: rect.origin.y + CGFloat(40)
      ),
      size: CGSize(
        width: rect.size.width,
        height: CGFloat(20)
      )
    )
    
    myTextField.placeholder = "Text..."
    
    myTextField.delegate = self
    
    // dbから読み込み
    do {
      let fetchRequest: NSFetchRequest<Tags> = Tags.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "index = " + String(self.tag))
      let tags = try context.fetch(fetchRequest)
      
      myTextField.text = tags[0].text
    } catch {
      print("error occurred in loading text field.")
    }
    
    self.addSubview(myTextField)
    
    myTextField.isEnabled = true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    // DBに保存する
    do {
      let fetchRequest: NSFetchRequest<Tags> = Tags.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "index = " + String(self.tag))
      let tags = try context.fetch(fetchRequest)
      
      tags[0].text = textField.text!
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
    } catch {
      print("error occurred in saving text.")
    }
    
    return true
  }
}
