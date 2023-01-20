import UIKit
import SDWebImage

class ShowNewsVc: UIViewController {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var contentView: UILabel!
    
    @IBOutlet weak var descriptionView: UILabel!
    
    @IBOutlet weak var date: UILabel!
    var categoryFromVc = ""
    var titleFromVc = ""
    var authorFromVc = ""
    var imageFromVc = ""
    var sourceNameFromVc = ""
    var contentFromVc = ""
    var descriptionFromVc = ""
    var dateFromVc = ""
    var fullnewsUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryFromVc
        image.layer.cornerRadius = 10
        newsTitle.text = titleFromVc
        author.text = authorFromVc
        image.sd_setImage(with: URL(string: imageFromVc))
        sourceName.text = sourceNameFromVc
        descriptionView.text = descriptionFromVc
        contentView.text = contentFromVc
        date.text = TimeConvertion.shared.timeConvert(time: dateFromVc)
    }
    
    @IBAction func showFullNewsAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.showWebView, sender: nil)
    }
    
    @IBAction func addToBookMark(_ sender: Any) {
        print(dateFromVc)
        let data = NewsData(author: authorFromVc, category: categoryFromVc, content: contentFromVc, newsDescription: descriptionFromVc, publishedAt: dateFromVc, sourceName: sourceNameFromVc, title:titleFromVc, url: fullnewsUrl, urlToImage:imageFromVc)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showWebView{
            if let webView = segue.destination as? WebView {
                webView.url = fullnewsUrl
            }
        }
    }
    
}
