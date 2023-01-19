//
//  BookMarkVc.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 17/1/23.
//

import UIKit

class BookMarkVc: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var categoryCv: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var bookMarkFromDb = [BookMark]()
    var indexPath: IndexPath?
    var selectIndexPath = IndexPath(row: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        categoryCv.delegate = self
        categoryCv.dataSource = self
        let nib = UINib(nibName: "BookMarkVcCategoryCell", bundle: nil)
        categoryCv.register(nib, forCellWithReuseIdentifier: Constants.bookMarkCategoryCell)
        setSearchBarImage()
        
    }
    func setSearchBarImage(){
        let searchIcon  = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        let uiView = UIView()
        uiView.addSubview(searchIcon)
        uiView.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
        searchIcon.frame = CGRect(x:10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
        searchField.leftView = uiView
        searchField.leftViewMode = .always
        searchField.clearButtonMode = .whileEditing
        searchIcon.tintColor = UIColor.darkGray
        searchField.addTarget(self, action: #selector(searchNews),for: .allEditingEvents)
        //searchField.
    }
    @objc func searchNews(){
        if let searchText = searchField.text{
            if searchText != ""{
                if let news = CoreDataDBBookMark.shared.searchNews(category: Category.categoryList[selectIndexPath.row].categoryName, searchText: searchText){
                    bookMarkFromDb = news
                    tableView.reloadData()
                }
            }else{
                if let bookmark = CategorySectionHelper.shared.selectCategoryForBoomark(category: Category.categoryList[selectIndexPath.row].categoryName){
                    bookMarkFromDb = bookmark
                    tableView.reloadData()
                }
            }
        }
        // print(searchField.text!)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        categoryCv.reloadData()
        if let bookmark = CategorySectionHelper.shared.selectCategoryForBoomark(category: Category.categoryList[selectIndexPath.row].categoryName){
            bookMarkFromDb = bookmark
            tableView.reloadData()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}
extension BookMarkVc: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(searchField.text!)
    }
}

// MARK: - Table View
extension BookMarkVc{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showNewsFromBookmark{
            if let showNewsVc = segue.destination as? ShowNewsVc{
                if let row = indexPath?.row{
                    showNewsVc.titleFromVc  = bookMarkFromDb[row].title ?? ""
                    showNewsVc.dateFromVc =  bookMarkFromDb[row].publishedAt ?? " "
                    showNewsVc.categoryFromVc = bookMarkFromDb[row].category ?? ""
                    showNewsVc.imageFromVc = bookMarkFromDb[row].urlToImage ?? ""
                    showNewsVc.descriptionFromVc = bookMarkFromDb[row].newsDescription ?? ""
                    showNewsVc.sourceNameFromVc = bookMarkFromDb[row].sourceName ?? ""
                    showNewsVc.contentFromVc = bookMarkFromDb[row].content ?? ""
                    showNewsVc.authorFromVc = bookMarkFromDb[row].author ?? ""
                    showNewsVc.fullnewsUrl = bookMarkFromDb[row].url ?? ""
                }
            }
        }
    }
    
}

extension BookMarkVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        performSegue(withIdentifier: Constants.showNewsFromBookmark, sender: nil)
    }
}
extension BookMarkVc: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookMarkFromDb.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookMarkCell, for: indexPath) as! BookMarkCell
        cell.title.text = bookMarkFromDb[indexPath.row].title
        cell.category.text = bookMarkFromDb[indexPath.row].category
        cell.source.text = bookMarkFromDb[indexPath.row].sourceName
        cell.date.text = TimeConvertion.shared.timeConvert(time: bookMarkFromDb[indexPath.row].publishedAt ?? " ")
        
        if let url = bookMarkFromDb[indexPath.row].urlToImage{
            cell.newsImage.layer.cornerRadius = 10
            cell.newsImage.sd_setImage(with: URL(string: url))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){[weak self]_,_,completion in
            guard let self = self else {return}
            self.handleDeleteAction(indexPath: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipAction.performsFirstActionWithFullSwipe = true
        return swipAction
    }
    func handleDeleteAction(indexPath: IndexPath){
        tableView.beginUpdates()
        CoreDataDBBookMark.shared.deleteBookmark(indexPath: indexPath, newsList: bookMarkFromDb)
        bookMarkFromDb.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
    }
    
}

// MARK: - Collection View

extension BookMarkVc: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = categoryCv.cellForItem(at: indexPath) as? BookMarkVcCategoryCell{
            cell.uiView.backgroundColor = UIColor(named: "customBlack")
            selectIndexPath = indexPath
            collectionView.reloadData()
        }
        if let bookmarkDb = CategorySectionHelper.shared.selectCategoryForBoomark(category: Category.categoryList[indexPath.row].categoryName){
            bookMarkFromDb =  bookmarkDb
            tableView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = categoryCv.cellForItem(at: indexPath) as? BookMarkVcCategoryCell{
            cell.uiView.backgroundColor = .white
        }
    }
}
extension BookMarkVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Category.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = categoryCv.dequeueReusableCell(withReuseIdentifier: Constants.bookMarkCategoryCell, for: indexPath) as! BookMarkVcCategoryCell
        if selectIndexPath == indexPath{
            item.uiView.backgroundColor = UIColor(named: "customBlack")
        }
        item.image.image = UIImage(named: Category.categoryList[indexPath.row].image)
        item.categoryName.text = Category.categoryList[indexPath.row].categoryName
        return item
        
    }
    
}
extension BookMarkVc: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 80)
    }
}
