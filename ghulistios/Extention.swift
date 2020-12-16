//
//  Extention.swift
//  NewHorizon005
//
//  Created by fârûqî on 25.07.2017.
//  Copyright © 2017 frq. All rights reserved.
//

import UIKit

extension UIView {
   func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
      anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
   }

   func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
      _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
   }

   func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
      translatesAutoresizingMaskIntoConstraints = false

      var anchors = [NSLayoutConstraint]()

      if let top = top {
         anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
      }

      if let left = left {
         anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
      }

      if let bottom = bottom {
         anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
      }

      if let right = right {
         anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
      }

      if widthConstant > 0 {
         anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
      }

      if heightConstant > 0 {
         anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
      }

      anchors.forEach({ $0.isActive = true })

      return anchors
   }
}

extension UIView {
   func addConstraintsWithFormat(_ format: String, views: UIView...) {
      var viewsDictionary = [String: UIView]()
      for (index, view) in views.enumerated() {
         let key = "v\(index)"
         viewsDictionary[key] = view
         view.translatesAutoresizingMaskIntoConstraints = false
      }

      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
   }
}

extension UIView {
   func withPadding(padding: UIEdgeInsets) -> UIView {
      let container = UIView()
      translatesAutoresizingMaskIntoConstraints = false
      container.addSubview(self)
      container.addConstraintsWithFormat("H:|-(\(padding.left))-[v0]-(\(padding.right))-|", views: self)
      container.addConstraintsWithFormat("V:|-(\(padding.top))-[v0]-(\(padding.bottom))-|", views: self)
      return container
   }
}

extension UIButton {
   func flash() {
      let flash = CABasicAnimation(keyPath: "opacity")

      flash.duration = 0.3
      flash.fromValue = 1
      flash.toValue = 0.1
      flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
      flash.autoreverses = false
      layer.add(flash, forKey: nil)
   }
}

extension UIColor {
   static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
      return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
   }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
      assert(red >= 0 && red <= 255, "Invalid red component")
      assert(green >= 0 && green <= 255, "Invalid green component")
      assert(blue >= 0 && blue <= 255, "Invalid blue component")
      
      self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
      self.init(
         red: (rgb >> 16) & 0xFF,
         green: (rgb >> 8) & 0xFF,
         blue: rgb & 0xFF
      )
   }
}


extension UIDevice {
   var iPhoneX: Bool {
      return UIScreen.main.nativeBounds.height == 2436
   }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?, invertAv: Bool) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            if invertAv {
                let beginImg = CIImage(image: self.image ?? #imageLiteral(resourceName: "placeholder"))
                if let filter = CIFilter(name: "CIColorInvert") {
                    filter.setValue(beginImg, forKey: kCIInputImageKey)
                    let newImg = UIImage(ciImage: filter.outputImage!)
                    self.image = newImg
                }
            }
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                            if invertAv {
                      
                                
                                let beginImg = CIImage(image: self.image ?? #imageLiteral(resourceName: "placeholder"))
                                if let filter = CIFilter(name: "CIColorInvert") {
                                    filter.setValue(beginImg, forKey: kCIInputImageKey)
                                    let newImg = UIImage(ciImage: filter.outputImage!)
                                    self.image = newImg
                                }
                            }
                        }
                    }
                }
            }).resume()
        }
    }
}

    
    

