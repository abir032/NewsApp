//
//  ViewController.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 11/1/23.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var gridList: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabbar: UITabBarItem!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    var articles = [Article]()
    var newsFromDB = [NewsDB]()
    var indexPath: IndexPath?
    var selectedCategoryIndexPath = IndexPath(row: 0, section: 0)
    var flag = true
    let defaults = UserDefaults.standard
    let time = Date()
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.cornerRadius = userImage.bounds.size.width / 2.0
        searchField.layer.cornerRadius = 10
        searchField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.collectionViewLayout = gridView()
        gridList.setImage(UIImage(systemName:"rectangle.grid.1x2.fill"), for: .normal)
        refreshControl.addTarget(self, action: #selector(refreshNewsData), for: UIControl.Event.valueChanged)
        newsCollectionView.addSubview(refreshControl)
        //MARK: - Nib Registration
        let nib  = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.collectionViewNib)
        let nib2 = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        newsCollectionView.register(nib2, forCellWithReuseIdentifier: Constants.newsCell)
        setSearchBarImage()
        checkInitialState()
        checkAutoRefreshing()
    }
    func checkAutoRefreshing(){
        let previousRefreshTime = defaults.object(forKey: "time")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let timeString = dateFormatter.string(from: time)
       
        if let previousRefreshTime  = previousRefreshTime as? String{
            if TimeConvertion.shared.returnMinutes(time: previousRefreshTime) - TimeConvertion.shared.returnMinutes(time: timeString) > 3{
                print("refreshing.....")
                for i in 0..<Category.categoryList.count{
                    CoreDataDB.shared.deleteCached(category: Category.categoryList[i].categoryName)
                    newsFromDB.removeAll()
                    print(ApiMaker.shared.apiMaker(row: i))
                    let apiUrl = ApiMaker.shared.apiMaker(row: i)
                    apiCaller(url: apiUrl , category: Category.categoryList[i].categoryName)
                }
            }
        }
    }
    @IBAction func changeLayout(_ sender: Any) {
        if flag{
            flag = false
            gridViewListView(viewStyle: true)
            gridList.setImage(UIImage(systemName:"rectangle.grid.1x2.fill"), for: .normal)
            
        }else{
            flag = true
            gridViewListView(viewStyle: false)
            gridList.setImage(UIImage(systemName:"square.grid.2x2.fill"), for: .normal)
        }
    }
    
    @objc func refreshNewsData(){
        CoreDataDB.shared.deleteCached(category: Category.categoryList[selectedCategoryIndexPath.row].categoryName)
        newsFromDB.removeAll()
        print(ApiMaker.shared.apiMaker(row: selectedCategoryIndexPath.row))
        apiCaller(url: ApiMaker.shared.apiMaker(row: selectedCategoryIndexPath.row), category: Category.categoryList[selectedCategoryIndexPath.row].categoryName)
        newsCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    func checkInitialState(){
        if !defaults.bool(forKey: "hasLaunchedBefore") {
            defaults.set(true, forKey: "hasLaunchedBefore")
            print("first user")
            for i in 0..<Category.categoryList.count{
                let apiUrl = ApiMaker.shared.apiMaker(row: i)
                apiCaller(url: apiUrl , category: Category.categoryList[i].categoryName)
            }
        } else {
            if let newsDb = CategorySectionHelper.shared.selectCategory(category: Category.categoryList[0].categoryName){
                self.newsFromDB = newsDb
                self.newsCollectionView.reloadData()
            }
        }
    }
    // MARK: - URL gula vhul ache
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
            if searchField.text != ""{
                if let news = CoreDataDB.shared.searchNews(category: Category.categoryList[selectedCategoryIndexPath.row].categoryName, searchText: searchText){
                    newsFromDB = news
                    print(newsFromDB.count)
                    newsCollectionView.reloadData()
                }
            }else{
                if let newsDb = CategorySectionHelper.shared.selectCategory(category: Category.categoryList[selectedCategoryIndexPath.row].categoryName){
                    self.newsFromDB = newsDb
                    self.newsCollectionView.reloadData()
                }
            }
        }
    }
}
extension ViewController{
    func apiCaller(url: String, category: String){
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let timeString = dateFormatter.string(from: time)
        defaults.set(timeString, forKey: "time")
        NewsDataCollection.sheared.getJson(url: url, completion: { result in
            switch result{
            case .success(let news):
                if let article = news?.articles{
                    self.articles = article
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                  self.saveToDb(category: category)
                    if let newsDb = CategorySectionHelper.shared.selectCategory(category: Category.categoryList[self.selectedCategoryIndexPath.row].categoryName){
                        self.newsFromDB = newsDb
                    }
                  self.newsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
        
    }
    func saveToDb(category: String){
        var data: NewsData
        for news in articles{
            if let author = news.author, let content = news.content, let newsDescription = news.description , let publishAt = news.publishedAt, let sourceName = news.source?.name, let title = news.title, let url = news.url, let urlToImage = news.urlToImage{
                data = NewsData(author: author, category: category, content: content, newsDescription: newsDescription, publishedAt: publishAt, sourceName: sourceName, title: title, url: url, urlToImage: urlToImage)
               // print(data)
                CoreDataDB.shared.savePost(article: data)
                
            }
        }
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
// MARK: - Segue Section
extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showNews{
            if let showNewsVc = segue.destination as? ShowNewsVc{
                if let row = indexPath?.row{
                    showNewsVc.titleFromVc  = newsFromDB[row].title ?? ""
                    showNewsVc.dateFromVc = newsFromDB[row].publishedAt ?? " "
                    showNewsVc.categoryFromVc = newsFromDB[row].category ?? ""
                    showNewsVc.imageFromVc = newsFromDB[row].urlToImage ?? ""
                    showNewsVc.descriptionFromVc = newsFromDB[row].newsDescription ?? ""
                    showNewsVc.sourceNameFromVc = newsFromDB[row].sourceName ?? ""
                    showNewsVc.contentFromVc = newsFromDB[row].content ?? ""
                    showNewsVc.authorFromVc = newsFromDB[row].author ?? ""
                    showNewsVc.fullnewsUrl = newsFromDB[row].url ?? ""
                }
            }
        }
    }
}


// MARK: - Collection View

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newsCollectionView{
            self.indexPath = indexPath
            performSegue(withIdentifier: Constants.showNews, sender: nil)
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.uiView.backgroundColor = UIColor(named: "customBlack")
            selectedCategoryIndexPath = indexPath
            collectionView.reloadData()
            Task{
                if let newsDb = CategorySectionHelper.shared.selectCategory(category: Category.categoryList[indexPath.row].categoryName){
                    newsFromDB = newsDb
                    newsCollectionView.reloadData()
                }
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == newsCollectionView{
            
        }else{
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell{
                cell.uiView.backgroundColor = .white
            }
        }
        
    }
}
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newsCollectionView{
            return newsFromDB.count
        }else{
            print(Category.categoryList.count)
            return Category.categoryList.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newsCollectionView{
            let item = newsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.newsCell, for: indexPath) as! NewsCollectionViewCell
            item.title.text = newsFromDB[indexPath.row].title
            if let url = newsFromDB[indexPath.row].urlToImage{
                item.newsImage.sd_setImage(with: URL(string: url))
            }
            item.source.text = newsFromDB[indexPath.row].sourceName
            item.catgory.text = newsFromDB[indexPath.row].category
            item.publishDate.text  = TimeConvertion.shared.timeConvert(time: newsFromDB[indexPath.row].publishedAt ?? " ")
            item.addToBookMark.tag = indexPath.row
            item.addToBookMark.addTarget(self, action: #selector(addBookmark), for: .touchUpInside)
            return item
            
        } else{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewNib, for: indexPath) as! CollectionViewCell
            if selectedCategoryIndexPath == indexPath{
                item.uiView.backgroundColor = UIColor(named: "customBlack")
            }
            item.imageView.image = UIImage(named: Category.categoryList[indexPath.row].image)
            item.categoryName.text = Category.categoryList[indexPath.row].categoryName
            print(indexPath.row)
            return item
        }
    }
    @objc func addBookmark(sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        saveToBookMark(row: indexPath.row)
        
    }
    func saveToBookMark(row: Int){
        let data = NewsData(author: newsFromDB[row].author ?? "Unknown", category: newsFromDB[row].category ?? "Unknown", content: newsFromDB[row].content ?? "Unknown", newsDescription: newsFromDB[row].newsDescription ?? "Unknown", publishedAt: newsFromDB[row].publishedAt ?? "Unknown", sourceName: newsFromDB[row].sourceName ?? "Unknown", title:newsFromDB[row].title ?? "Unknown", url: newsFromDB[row].url ?? "Unknown", urlToImage:newsFromDB[row].urlToImage ?? "Unknown")
        if CoreDataDBBookMark.shared.checkDB(article: data){
            CoreDataDBBookMark.shared.addBookmark(article: data)
        }else{
            showAlert()
        }
    }
    func showAlert(){
        print("AlreadyAdded")
        let alert = UIAlertController(title: "Bookmark Already Added", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive){[weak self]_ in
            guard let self = self else {return}
            self.dismiss(animated: true)
        }
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 80)
    }
}
extension ViewController{
    func gridViewListView(viewStyle: Bool){
        gridList.isUserInteractionEnabled = false
        newsCollectionView.startInteractiveTransition(to: viewStyle ? gridView() : listView()){[weak self]_,_ in
            guard let self = self else{return}
            self.gridList.isUserInteractionEnabled = true
        }
        newsCollectionView.finishInteractiveTransition()
    }
    func gridView()->UICollectionViewLayout{
        let insets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let item =  NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        let horGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: horGroup, subitems: [item])
        let groupInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        group.contentInsets = groupInsets
        let section  = NSCollectionLayoutSection(group: group)
        let compLayout = UICollectionViewCompositionalLayout(section: section)
        return compLayout
    }
    func listView()->UICollectionViewLayout{
        let insets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let item =  NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        let horGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: horGroup, subitems: [item])

        let section  = NSCollectionLayoutSection(group: group)
        let compLayout = UICollectionViewCompositionalLayout(section: section)
        return compLayout
    }
}
    





