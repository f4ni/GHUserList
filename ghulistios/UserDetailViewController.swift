//
//  ViewController.swift
//  ghulistios
//
//  Created by f4ni on 13.12.2020.
//

import UIKit
import CoreData

class UserDetailViewController: UIViewController {

    var mainVC: MainViewController?
    
    var userDetail: UserDetail?{
        didSet{
            //self.followerTV.text = "\(userDetail?.followers) takipçi"
        }
    }
        
    var user: User?{
        didSet{
            let service = APIService()
            if let login = user?.login {
                do {
                    print("ress")
                    let res = try CoreDataStack.sharedInstance.getUserWith(login: login)
                    guard res != nil, res!.count > 0 else {
                        print("res is empty")
                        return
                    }
                    if let notes = res?[0].notes{
                        self.notesTF.text = notes
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            service.getUserDetail (user: user!.login, completion: {(result) in
                //print(result)
                switch result {
                case .Success(let data):
                    if let following = data["following"] {
                        self.followingLb.text = "\(following) following"
                    }
                    if let followers = data["followers"] {
                        self.followerLb.text = "\(followers) followers"
                    }
                    if let name = data["name"] {
                        self.nameLb.text = "Name: \(name) "
                    }
                    if let company = data["company"] {
                        self.companyLb.text = "Company: \(company)"
                    }
                    if let blog = data["blog"] {
                        self.blogLb.text = "Blog: \(blog)"
                    }
                    if let url = data["avatar_url"] {
                        DispatchQueue.main.async {
                            self.avatarIV.loadImageUsingCacheWithURLString(url as! String, placeHolder: UIImage(named: "placeholder"), invertAv: false)
                        }
                    }
                case .Error(let message):
                    DispatchQueue.main.async {
                        //self.showAlertWith(title: "Error", message: message)
                    }
                }
            })
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        view.addSubview(avatarIV)
        view.addSubview(followingLb)
        view.addSubview(followerLb)
        view.addSubview(nameLb)
        view.addSubview(companyLb)
        view.addSubview(blogLb)
        view.addSubview(notesLb)
        view.addSubview(notesTF)
        view.addSubview(saveBtn)

        view.addConstraintsWithFormat("H:|[v0]|", views: avatarIV)
        view.addConstraintsWithFormat("V:|[v0(200)]-16-[v1]", views: avatarIV, followerLb)
        view.addConstraintsWithFormat("V:|[v0(200)]-16-[v1]", views: avatarIV, followingLb)
        view.addConstraintsWithFormat("H:|-24-[v0]-16-[v1]-24-|", views: followerLb, followingLb)

        view.addConstraintsWithFormat("V:[v0]-24-[v1]-16-[v2]-16-[v3]", views: followerLb, nameLb, companyLb, blogLb)
        view.addConstraintsWithFormat("H:|-24-[v0]", views: nameLb)
        view.addConstraintsWithFormat("H:|-24-[v0]", views: companyLb)
        view.addConstraintsWithFormat("H:|-24-[v0]", views: blogLb)
        view.addConstraintsWithFormat("H:|-24-[v0]-24-|", views: notesTF)
        view.addConstraintsWithFormat("H:|-24-[v0]", views: notesLb)
        view.addConstraintsWithFormat("H:|[v0]|", views: saveBtn)
        view.addConstraintsWithFormat("V:[v0]-24-[v1]-16-[v2(36)]", views: blogLb, notesLb, notesTF)
        view.addConstraintsWithFormat("V:[v0]-24-[v1(36)]", views: notesTF, saveBtn)

    }

    let followerLb: UILabel = {
        let label = UILabel()
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let nameLb: UILabel = {
        let label = UILabel()
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let companyLb: UILabel = {
        let label = UILabel()
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let blogLb: UILabel = {
        let label = UILabel()
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let followingLb: UILabel = {
        let label = UILabel()
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let notesLb: UILabel = {
        let label = UILabel()
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.text = "Notes"
        return label
    }()

    let notesTF: UITextField = {
        let tf = UITextField(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 240)))
        var frameRect = tf.frame
        frameRect.size.height = 53
        tf.frame = frameRect
        //label.textColor =  UIColor.white
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        tf.font = UIFont.systemFont(ofSize: 16)
        //label.numberOfLines = 0
        tf.textAlignment = .center
        //label.lineBreakMode = .byWordWrapping
        tf.placeholder = "placeholder..."
        tf.borderStyle = .line
        tf.borderRect(forBounds: CGRect(origin: .zero, size: CGSize(width: 300, height: 240)))
        tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        return tf
    }()

    let avatarIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        //iv.backgroundColor =  colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        iv.layer.masksToBounds = true
        return iv
    }()

    let saveBtn: UIButton = {
        let bt = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 84, height: 36)))
        bt.setTitle("Save", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.addTarget(self, action: #selector(saveNotes), for: .touchUpInside)
        return bt
    }()
    
    @objc func saveNotes() {
        if let notes = notesTF.text, let login = user?.login {
            if CoreDataStack.sharedInstance.updateData(login: login, notes: notes){
                print("note save is success")
                mainVC?.tableView.reloadData()
            }
            else{
                print("note couldn't save")
            }
        }
        print("note ->\(notesTF.text) for \(user?.login)")
    }
}


