//
//  ViewController.swift
//  uiKitTask2
//
//  Created by Papillon on 2019/11/04.
//  Copyright © 2019 Papillon. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  var tagIndex = 0

  @IBOutlet weak var transparentView: TransparentView!
  @IBOutlet weak var scrollArea: UIScrollView!
  @IBOutlet weak var botRect: UIView!
  @IBOutlet weak var topRect: UIView!
  @IBOutlet weak var midRect: UIView!
  @IBOutlet weak var titleField: UITextField!
  
  var topPadding: CGFloat = 0
  var bottomPadding: CGFloat = 0
  var leftPadding: CGFloat = 0
  var rightPadding: CGFloat = 0
  
  let screenSize: CGRect = UIScreen.main.bounds
  let goalHeight: CGFloat = 60.0
  var tapPoint: CGPoint = CGPoint(x: 0, y: 0)
  
  var scrollBeginningPoint: CGPoint!
  
  let applicationWidth: CGFloat = UIScreen.main.bounds.width * 5

  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleField.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if #available(iOS 11.0, *) {
      topPadding = self.view.safeAreaInsets.top
      bottomPadding = self.view.safeAreaInsets.bottom
    }
    
    self.view.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: 0
      ),
      size: CGSize(
        width: applicationWidth,
        height: screenSize.height
      )
    )
    
    transparentView.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: topPadding + goalHeight
      ),
      size: CGSize(
        width: applicationWidth,
        height: screenSize.height - topPadding - goalHeight - bottomPadding
      )
    )
    self.view.addSubview(transparentView)
    
    scrollArea.contentSize = CGSize(
      width: applicationWidth,
      height: screenSize.height - topPadding - goalHeight - bottomPadding
    )
    
    scrollArea.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: topPadding + goalHeight
      ),
      size: CGSize(
        width: screenSize.width,
        height: screenSize.height - topPadding - goalHeight - bottomPadding
      )
    )
    scrollArea.tag = 88
    
    let tap = UITapGestureRecognizer(target: self, action: Selector(("svTapped:")))
    tap.numberOfTouchesRequired = 1
    scrollArea.addGestureRecognizer(tap)
    
    scrollArea.delegate = self
    self.view.sendSubviewToBack(scrollArea)
    
    titleField.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: topPadding
      ),
      size: CGSize(
        width: screenSize.width,
        height: goalHeight
      )
    )
    titleField.tag = 99
    
    topRect.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: 0
      ),
      size: CGSize(
        width: applicationWidth,
        height: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      )
    )
    topRect.tag = 100
    
    midRect.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      ),
      size: CGSize(
        width: applicationWidth,
        height: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      )
    )
    midRect.tag = 101
    
    botRect.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3 * 2
      ),
      size: CGSize(
        width: applicationWidth,
        height: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      )
    )
    botRect.tag = 102
    
    // coredataからdrawerを読み込む
    do {
      let fetchRequest: NSFetchRequest<Tags> = Tags.fetchRequest()
      let tags = try context.fetch(fetchRequest)
      
      for i in tags {
        let drawer = Drawer(
          frame: CGRect(
            x: CGFloat(i.x),
            y: CGFloat(i.y),
            width: 200,
            height: 100
          )
        )
        drawer.tag = Int(i.index)
        
        tagIndex = Int(i.index)
        
        transparentView.addSubview(drawer)
        transparentView.bringSubviewToFront(drawer)
      }
    } catch {
      print("error occurred in loadings.")
    }
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    scrollBeginningPoint = scrollView.contentOffset
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentPoint = scrollView.contentOffset
    
    transparentView.frame.origin.x = -currentPoint.x
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc func svTapped(_ touch: UIGestureRecognizer) {
    let touchPoint = touch.location(in: transparentView)
    
    let drawer = Drawer(
      frame: CGRect(
        origin: CGPoint(
          x: touchPoint.x,
          y: touchPoint.y
        ),
        size: CGSize(
          width: 200,
          height: 100
        )
      )
    )
    drawer.tag = tagIndex + 1
    
    transparentView.addSubview(drawer)
    
    // DBに保存する
    let tags = Tags(context: context)
    
    tags.x = Double(touchPoint.x)
    tags.y = Double(touchPoint.y)
    tags.index = Int64(tagIndex+1)
    
    tagIndex = tagIndex + 1
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first!
    let view = touch.view!
    
    if view.tag != 99 && view.tag != 100 && view.tag != 101 && view.tag != 102 {
      let prevState = touch.previousLocation(in: transparentView)
      let nextState = touch.location(in: transparentView)
      
      view.frame.origin.x += (nextState.x - prevState.x)
      view.frame.origin.y += (nextState.y - prevState.y)
      
      do {
        let fetchRequest: NSFetchRequest<Tags> = Tags.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "index = " + String(view.tag))
        let tags = try context.fetch(fetchRequest)
        
        print(view.tag)
        
        tags[0].x += (Double(nextState.x) - Double(prevState.x))
        tags[0].y += (Double(nextState.y) - Double(prevState.y))
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
      } catch {
        print("error occurred in moving drawer.")
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first!
    tapPoint = touch.location(in: transparentView)
    
    let view = touch.view!
    
    if view.tag != 100 && view.tag != 101 && view.tag != 102 && touch.tapCount == 2 {
      view.removeFromSuperview()
      
      // dbから指定のviewを削除する
      do {
        let fetchRequest: NSFetchRequest<Tags> = Tags.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "index = " + String(view.tag))
        let tags = try context.fetch(fetchRequest)
        context.delete(tags[0])
        
        //tags.remove(at: view.tag)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
      } catch {
        print("error occurred in deleting drawer.")
      }
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}

