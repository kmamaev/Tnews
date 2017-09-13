import UIKit

class NewsItemDetailsVC: UIViewController {
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var dateLabel: UILabel!
    @IBOutlet fileprivate var webView: UIWebView!
    @IBOutlet fileprivate var webViewHeight: NSLayoutConstraint!

    var context: Context!
    var newsItem: NewsItem!
    var viewModel: NewsItemDetailsVMType!
}

extension NewsItemDetailsVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebView()
        setupViewModel()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        webView.delegate = nil
    }
}

private extension NewsItemDetailsVC {
    func configureWebView() {
        webView.scrollView.contentInset = .zero
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
    }

    func setupViewModel() {
        viewModel = NewsItemDetailsVM(newsItem: newsItem, newsService: context.newsService,
            dateFormatter: context.dateFormatter)

        viewModel.delegate = self

        titleLabel.text = viewModel.title.htmlConvertedString()
        dateLabel.text = viewModel.formattedDateString
        updateContent()
    }

    func updateContent() {
        webView.loadHTMLString(viewModel.content, baseURL: nil)
    }
}

extension NewsItemDetailsVC: NewsItemDetailsVMDelegate {
    func newsItemsDetailsVMDidUpdateContent(_ newsItemDetailsVM: NewsItemDetailsVM) {
        updateContent()
    }
}

extension NewsItemDetailsVC: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeight.constant = webView.scrollView.contentSize.height
    }
}
