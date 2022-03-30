//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Daffolapmac-155 on 26/03/22.
//

import UIKit
enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular =  2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUiView?
    
    
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
    }
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result{
            case .success(let titles):
                self?.randomTrendingMovie = titles.randomElement()
                guard let title  = self?.randomTrendingMovie?.original_title ?? self?.randomTrendingMovie?.original_name else{return}
                self?.headerView?.configure(with: titleViewModel(titleName: title, posterURL: self?.randomTrendingMovie?.poster_path ?? "" ))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func configureNavBar() {
        // we have to modify the image before adding to the navbar
        var image = UIImage(named: "netflixLogo")
        image  = image?.withRenderingMode(.alwaysOriginal)// enforce the ios to use original image
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done , target: self, action: nil)
//       navigationItem.leftBarButtonItem?.largeContentSizeImageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -2, right: 10)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName:"person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // giving it the frame just equal to the view
        homeFeedTable.frame = view.bounds
    }
    
 

}


extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        
        cell.delegate =  self
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case . failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        default:
            return UITableViewCell()
         }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalisedFirstLetter()
    }
    
    
    
    // used for pushing navigation bar up when scroll view moves up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView offset value increase as we move upward and decreases as we move downward
        
        
        let defaultOffset = view.safeAreaInsets.top// calculate the safearea top
        let offset = scrollView.contentOffset.y + defaultOffset//calculate the offset when scrollview moves upward/downward
 
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in 
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
   
    }
}
