//
//  ViewController.swift
//  ghulistios
//
//  Created by f4ni on 13.12.2020.
//

import UIKit
import CoreData

class MainViewController: UITableViewController, UISearchBarDelegate {

    let cellID = "cellID"
    
    var since = Int(0)
    
    let service = APIService()
    
   
    var word: String?{
        didSet{
            self.updateTableContent()

        }
    }
    
    var predicate = NSPredicate(value: true)
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        if let word = self.searchBar.text, (word.trimmingCharacters(in: .whitespaces).count > 0){
            self.predicate = NSPredicate(format: "login contains[c] %@ || notes contains[c] %@", argumentArray: [word, word])

        }
        else{
            
        }
        print("filter by \(word)")

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GitHub User"
        
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshHandle), for: .valueChanged)

        updateTableContent()
            setUpSearchBar()
    }
    
    @objc func refreshHandle(){
        service.since = 0
        Model.sharedInstance.clearData()
        updateTableContent()
    }
    lazy var searchBar: UISearchBar = {
        let s =  UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        s.delegate = self
        return s
    }()

    fileprivate func setUpSearchBar() {

        

        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty, (searchText.trimmingCharacters(in: .whitespaces).count > 0) else {
            self.predicate = NSPredicate(value: true)
            
            return
        }
      
        
        self.predicate = NSPredicate(format: "login contains[c] %@ || notes contains[c] %@", argumentArray: [searchText, searchText])
        self.word = searchText
        //self.fetchedhResultController.fetchRequest.predicate = predicate
        updateTableContent()
        /*do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        
           
        } catch let error  {
            print("ERROR: \(error)")
        }
 */
        print(self.searchBar.text)
        tableView.reloadData()
  
    }
    
    func updateTableContent() {
        do {
            self.fetchedhResultController.fetchRequest.predicate = self.predicate
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        
           
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        service.getUserList (since: since, completion: { (result) in
            switch result {
            case .Success(let data):
                if self.service.since == 0  {
                    
                }
                //Model.sharedInstance.clearData()
                Model.sharedInstance.saveInCoreDataWith(array: data)
                if let lastID = data.last?["id"] {
                    self.since = lastID as! Int
                    print("last id is \(lastID)")
                }
                self.tableView.reloadData()
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
            self.refresh.endRefreshing()
        })
        
    }
        
    
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func scrollViewWillBeginDragging(_: UIScrollView) {
         self.searchBar.endEditing(true)
     }
}

extension MainViewController{

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UserListTableViewCell
        
            if let user = fetchedhResultController.object(at: indexPath) as? User
            {
                var invertAv = false
                if   ((Int(indexPath.row + 1)%3) == 0){
                    invertAv = true
                }
                cell.setPhotoCellWith(user: user, invertAv: invertAv)
                if user.notes != nil, (user.notes?.trimmingCharacters(in: .whitespaces).count)! > 0 {
                    cell.notedLbl.layer.opacity = 1
                }
                else{
                    cell.notedLbl.layer.opacity = 0

                }
            }
     
        return cell
    }
    
   

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0


        if let cnt = fetchedhResultController.sections?.first!.numberOfObjects{
            count = cnt
        }

        
        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 //100 = sum of labels height + height of divider line
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserDetailViewController()
      
        if let usr = fetchedhResultController.object(at: indexPath) as? User {
            vc.user = usr
            vc.mainVC = self
            self.present(vc, animated: true, completion: {(()->Void).self
            })
        }
    }
    
    /*
    override func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let lastElement = fetchedhResultController.sections?.first!.numberOfObjects {
            if indexPath.item == (lastElement - 2) {
                //appendHandler()
                
                tableView.beginUpdates()
                print(indexPath)
                updateTableContent()
                tableView.endUpdates()
            }
        }
    }
 */
    
}

extension MainViewController{
    
    class UserListTableViewCell: UITableViewCell {


        let nameTV: UILabel = {
            let label = UILabel()
            label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 18)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        let notedLbl: UILabel = {
            let label = UILabel()
            label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.text = "NOTED"
            return label
        }()
        
        let avatarIV: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            iv.layer.cornerRadius = 40
            iv.layer.masksToBounds = true
            
            return iv
        }()
        
         
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.addSubview(nameTV)
            self.addSubview(avatarIV)
            self.addSubview(notedLbl)
            self.addConstraintsWithFormat("V:|-16-[v0(80)]", views: avatarIV)
            self.addConstraintsWithFormat("H:|-16-[v0(80)]-16-[v1]", views: avatarIV, nameTV)
            self.addConstraintsWithFormat("V:|-24-[v0(24)]", views: nameTV)
            self.addConstraintsWithFormat("V:[v0(24)]-24-|", views: notedLbl)
            self.addConstraintsWithFormat("H:[v0]-24-|", views: notedLbl)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        func setPhotoCellWith(user: User, invertAv: Bool) {
            //print("setPhoto for \( user.login )")
            DispatchQueue.main.async {
                self.nameTV.text = "\(user.login ?? "")"
                //self.tagsLabel.text = photo.tags
                if let url = user.avatar_url {
                    self.avatarIV.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"), invertAv: invertAv)
                }
            }
        }

    }
}
extension MainViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
 
}
