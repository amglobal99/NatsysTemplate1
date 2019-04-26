//
//  UITableView.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation
import PinkyPromise

//MARK:- Protocols

protocol CellTapAction { }

protocol Selectable {
    var selectable: Bool { get }
}

protocol Highlightable: class {
    func highlight()
}

protocol ItemViewModel {
    var selected: Bool { get }
}

protocol ErrorMessageViewModelContainer {
    var errorMessageViewModel: ErrorMessageViewModelType? { get }
}

protocol ErrorMessageViewModelType {
    var message: String { get }
    var backgroundColor: UIColor { get }
    var contentErrorStateColor: UIColor? { get }
    var image: UIImage? { get }
}

protocol DeliveryDetailsItemType {
    var identifier: String { get }
}

protocol BaseViewModelSectionType {
    var title: String? { get }
    var headerHeight: CGFloat { get }
    var footerHeight: CGFloat { get }
    var sectionCellHeight: CGFloat? { get }
    var kind: ViewModelSectionKind { get }
}

protocol ViewModelSectionType : BaseViewModelSectionType {
    var dataSource: [ItemViewModel] { get set }
}

protocol TableViewModelSectionType : ViewModelSectionType {
    // makes sure that we add only view models that implement `configure(cell:)`
    var dataSource: [AnyTableViewCellViewModel] { get set }
}

protocol AnyTableViewCellViewModelDataSourceType {
    static var cellsToRegister: [AnyCellViewModel.Type] { get }
    
    func tableCellViewModel(at indexPath: IndexPath) -> AnyTableViewCellViewModel
}

protocol BaseTableViewDataSourceType: AnyTableViewCellViewModelDataSourceType {
    var sectionCount : Int { get }
    func rowCount(for section: Int) -> Int
    func section(for index: Int) -> BaseViewModelSectionType
    var defaultRowHeight : CGFloat? { get }
}

protocol SimpleTableViewDataSourceType: BaseTableViewDataSourceType {
    var sections: [BaseTableViewDataSourceSection] { get set }
    var enabled: Bool { get set }
    var selectedIndexPath: IndexPath? { get set }
}

protocol TableViewDataSourceType {
    var headerView: UIView? { get }
    var footerView: UIView? { get }
    var navigationBarTitle: String { get }
    var items: [ViewModelSectionType] { get }
    var successCallback: Callback? { get }
    var selectedIndexPath: IndexPath? { get }
    func item(at indexPath: IndexPath) -> ItemViewModel
}

protocol NibRegistrable {
    var tableView: UITableView! { get }
    var nibsToLoad: [(String, AnyClass)] { get }
    func registerNibs()
}

// protocol for any view that we can register nibs or classes with (ie. either UITableView or UICollectionView)
protocol RegistersNibsAndClasses {
    associatedtype CellViewModelType // ideally this would be constraints to types that conform to AnyCellViewModel
    func registerClass(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
    func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String)
}

// protocol for view models that are meant to be used with a view that needs reigstering
protocol AnyCellViewModel {
    static var reusableIdentifier : String { get }
    static var tableViewCellClass : UITableViewCell.Type { get }
    static var registerNib : Bool { get }
}

// view models that can configure any UITableViewCell
protocol AnyTableViewCellViewModel: AnyCellViewModel {
    func configure(_ cell: UITableViewCell)
    func configure(_ cell: UITableViewCell, context: AnyObject?)
}

// for objects that can be compared against any other conforming object, even of different concrete type
protocol AnyObjectEquatable {
    func isEqual(_ object: AnyObjectEquatable?) -> Bool
}

//protocol for view models that can configure a specific UITableViewCell subclass
// note: subclassing a class that conforms to this protocol and redefining TableViewCellType is not possible in swift!
// usage: make a view model type conform to TableViewCellViewModel and define `configure(_ cell: YourViewModelsCellType)`
//     this automatically implements all the extension methods of AnyTableViewCellViewModel based on `YourViewModelsCellType`
//     for example `reusableIdentifierAndClass`
protocol TableViewCellViewModel : AnyTableViewCellViewModel {
    associatedtype TableViewCellType: UITableViewCell
    func configure(_ cell: TableViewCellType)
}

protocol ExtendedTableViewCellViewModel: TableViewCellViewModel {
    associatedtype ContextType
    func configure(_ cell: TableViewCellType, context: ContextType)
}

protocol ErrorMessageDisplayable : class {
    var errorMessageContainer: UIView! { get }
   // var errorMessageView : BayItemMessageView! { get set }
    
    func configureLabelColor(_ color: UIColor?)
}

protocol TableViewEmptyStateDisplayable {}






//MARK:- Extension for UITableView

extension UITableView {
    
    /// Sizes the tableView based on it's contentSize
    func contentViewFrame(toFitMaxHeight height : CGFloat, offset: CGFloat = 0) -> CGRect {
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: contentSize.width, height: min(contentSize.height+offset,height))
    }
    
    func scrollToBottom() {
        guard numberOfSections > 0 else {
            return
        }
        scrollToRow(at: IndexPath(row: numberOfRows(inSection: numberOfSections-1)-1, section: numberOfSections-1),
                    at: .bottom, animated: true)
    }
    
    
    var totalRowsCount: Int {
        var rows = 0
        
        for i in 0..<self.numberOfSections {
            rows += self.numberOfRows(inSection: i)
        }
        
        return rows
    }
    
    var allRowsSelected: Bool {
        guard let count = self.indexPathsForSelectedRows?.count else {
            return false
        }
        return count == totalRowsCount
    }
    
    func deselectAllRows(animated: Bool) {
        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                self.deselectRow(at: IndexPath(row: row, section: section), animated: animated)
            }
        }
    }
    
    func selectAllRows(animated: Bool) {
        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                self.selectRow(at: IndexPath(row: row, section: section), animated: animated, scrollPosition: .none)
            }
        }
    }
}


//MARK:- Highlightable

extension Highlightable where Self: UITableViewCell {
    
    func highlightCell(color: UIColor, duration: Double) -> Promise<Void> {
        let originalColor = self.contentView.backgroundColor
        return Promise<Void> { (fulfill: @escaping (PinkyPromise.Result<Void>)->()) in
            
            UIView.animate(withDuration: duration, animations: {
                self.contentView.backgroundColor = color
            }, completion: { _ in
                fulfill(.success(()))
            })
            }
            .then {
                UIView.animate(withDuration: duration) {
                    self.contentView.backgroundColor = originalColor
                }
        }
    }
}

//MARK:- Selectable

extension Selectable {
    var selectable: Bool {
        return true
    }
}

//MARK:-

extension ItemViewModel {
    var selected: Bool { return false }
}

//MARK:- Equality

func ==(a: ErrorMessageViewModelType, b: ErrorMessageViewModelType) -> Bool {
    return a.message == b.message &&
        a.backgroundColor == b.backgroundColor &&
        a.contentErrorStateColor == b.contentErrorStateColor
}

func ==(a: ErrorMessageViewModelType?, b: ErrorMessageViewModelType?) -> Bool {
    switch (a,b) {
    case (.none, .none):
        return true
    case (.some(let x), .some(let y)):
        return x == y
    default:
        return false
    }
}

//MARK:- Error Message View Model

struct ErrorMessageViewModel: ErrorMessageViewModelType {
    
    let message: String
    let backgroundColor: UIColor
    let contentErrorStateColor: UIColor?
    let image: UIImage?
    
    init(warningMessage: String, backgroundColor: UIColor = Theme.Colors.lightMustardColor(), contentErrorStateColor: UIColor? = nil, image: UIImage? = UIImage(named: "ico_closed")) {
        self.message = warningMessage
        self.backgroundColor = backgroundColor
        self.contentErrorStateColor = contentErrorStateColor
        self.image = image
    }
    
    init(errorMessage: String, backgroundColor: UIColor = Theme.Colors.coralColor(), contentErrorStateColor: UIColor? = Theme.Colors.coralColor(), image: UIImage? = UIImage(named: "ico_closed")) {
        self.message = errorMessage
        self.backgroundColor = backgroundColor
        self.contentErrorStateColor = contentErrorStateColor
        self.image = image
    }
    
    init(correctionMessage: String, backgroundColor: UIColor = Theme.Colors.tealishColor(), contentErrorStateColor: UIColor? = nil, image: UIImage? = UIImage(named: "ico_corrected")) {
        self.message = correctionMessage
        self.backgroundColor = backgroundColor
        self.contentErrorStateColor = contentErrorStateColor
        self.image = image
    }
}

//MARK:-

enum GroupedButtonActionType {
    case reorder
    case rescheduleAll
    case par
}




enum ViewModelSectionKind {
    struct Action {
        let title: String
        let showDisclosure: Bool
        let actionType: GroupedButtonActionType
    }
    case basic
    case action(Action)
}

//MARK:- ViewModelSection


struct ViewModelSection: ViewModelSectionType {
    var title: String?
    var dataSource = [ItemViewModel]()
    var headerHeight: CGFloat
    var footerHeight: CGFloat
    var sectionCellHeight: CGFloat?
    var kind: ViewModelSectionKind
    
    init(title: String?, dataSource: [ItemViewModel], headerHeight: CGFloat, footerHeight: CGFloat, sectionCellHeight: CGFloat? = nil, kind: ViewModelSectionKind = .basic) {
        self.title = title
        self.dataSource.append(contentsOf: dataSource)
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.sectionCellHeight = sectionCellHeight
        self.kind = kind
    }
}

//MARK:- Base Data Source Section

class BaseTableViewDataSourceSection: BaseViewModelSectionType {
    let title: String?
    let headerHeight: CGFloat
    let footerHeight: CGFloat
    var sectionCellHeight: CGFloat?
    let kind: ViewModelSectionKind
    var items: [AnyTableViewCellViewModel]
    
    init(title: String?,
         items: [AnyTableViewCellViewModel],
         headerHeight: CGFloat = 0,
         footerHeight: CGFloat = 0,
         sectionCellHeight: CGFloat? = nil,
         kind:ViewModelSectionKind = .basic) {
        self.title = title
        self.items = items
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.kind = kind
        self.sectionCellHeight = sectionCellHeight
    }
}

//MARK:-

extension SimpleTableViewDataSourceType {
    var sectionCount : Int {
        return sections.count
    }
    
    func rowCount(for section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }
    
    func section(for index: Int) -> BaseViewModelSectionType {
        return sections[index]
    }
    
    func tableCellViewModel(at indexPath: IndexPath) -> AnyTableViewCellViewModel {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    var defaultRowHeight : CGFloat? { return nil }
}

//MARK:-

extension TableViewDataSourceType {
    var selectedIndexPath: IndexPath? {
        for (sectionidx, section) in items.enumerated() {
            for (rowidx, item) in section.dataSource.enumerated() {
                if item.selected {
                    return IndexPath(row: rowidx, section: sectionidx)
                }
            }
        }
        return nil
    }
    
    func item(at indexPath: IndexPath) -> ItemViewModel {
        return items[indexPath.section].dataSource[indexPath.row]
    }
    
    func item(safelyAt indexPath: IndexPath) -> ItemViewModel? {
        return items[safe: indexPath.section]?.dataSource[safe: indexPath.row]
    }
}

//MARK:- Data Source

struct TableViewDataSource: TableViewDataSourceType {
    var headerView: UIView?
    var footerView: UIView?
    var navigationBarTitle: String
    var items = [ViewModelSectionType]()
    var successCallback: Callback?
    
    init(headerView header: UIView? = nil, navigationBarTitle: String, items: [ViewModelSectionType], successCallback: Callback?) {
        self.headerView = header
        self.navigationBarTitle = navigationBarTitle
        self.items.append(contentsOf: items)
        self.successCallback = successCallback
    }
}

//MARK:- Register NIBs

extension NibRegistrable  {
    func registerNibs() {
        for (identifier, type) in nibsToLoad {
            let nib = UINib(nibName: identifier, bundle: Bundle(for: type))
            tableView.register(nib, forCellReuseIdentifier: identifier)
        }
    }
}

//MARK:-

// convenient instance methods to get values based on the specific type that conforms to AnyTableViewCellViewModel
extension AnyCellViewModel {
    var reusableIdentifier : String { return type(of: self).reusableIdentifier }
    var tableViewCellClass : UITableViewCell.Type { return type(of: self).tableViewCellClass }
    var registerNib : Bool { return type(of: self).registerNib }
    
    // override if the UITableViewCell does not use `registerNib(:forCellReuseIdentifier:)`
    static var registerNib : Bool { return true }
}

//MARK:- CONFIGURE

extension AnyTableViewCellViewModel {
    func configure(_ cell: UITableViewCell, context: AnyObject?) {
        configure(cell)
    }
}

//MARK:-

extension TableViewCellViewModel {
    func configure(_ cell: UITableViewCell) {
        // we assume that cell will always be of type TableViewCellType
        // otherwise there was an error registering cell classes or dequeing cells
        // this should happen automatically if using TableViewDataSourceType.register
        configure(cell as! TableViewCellType)
    }
    
    static var tableViewCellClass : UITableViewCell.Type { return TableViewCellType.self }
}

//MARK:-

extension ExtendedTableViewCellViewModel {
    func configure(_ cell: TableViewCellType) {
        configure(cell, context: nil)
    }
    
    func configure(_ cell: UITableViewCell, context: AnyObject?) {
        // we assume that cell will always be of type TableViewCellType
        // otherwise there was an error registering cell classes or dequeing cells
        // this should happen automatically if using TableViewDataSourceType.register
        configure(cell as! TableViewCellType, context: context as! ContextType)
    }
}

//MARK:-

extension TableViewCellViewModel where TableViewCellType : IdentifiableByClassName {
    static var reusableIdentifier : String { return TableViewCellType.reusableIdentifier }
}

//MARK:-

extension UITableView : RegistersNibsAndClasses {
    typealias CellViewModelType = AnyTableViewCellViewModel
    
    @nonobjc func registerClass(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    @nonobjc func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}

//MARK:- Register

extension AnyTableViewCellViewModelDataSourceType {
    // register all subclasses used by this dataSource with the tableview or collectionview
    static func register<T : RegistersNibsAndClasses>(_ view: T) {
        for viewModelType in self.cellsToRegister {
            if viewModelType.registerNib {
                let nib = UINib(nibName: viewModelType.reusableIdentifier,
                                bundle: Bundle(for: viewModelType.tableViewCellClass))
                view.registerNib(nib, forCellReuseIdentifier: viewModelType.reusableIdentifier)
            } else {
                view.registerClass(viewModelType.tableViewCellClass,
                                   forCellReuseIdentifier: viewModelType.reusableIdentifier)
            }
        }
    }
}

//MARK:-

extension ErrorMessageDisplayable {
//    func setupErrorView() {
//        self.errorMessageView = BayItemMessageView.make(with:"",
//                                                        image: UIImage(named: "ico_closed"),
//                                                        backgroundColor: Theme.Colors.coralColor())
//        self.errorMessageView.imageView.tintColor = .white
//        self.errorMessageContainer.addConstrainedSubview(errorMessageView)
//    }
    
//    func configureError(_ viewModel : ErrorMessageViewModelType?) {
//        let errorVisible = (viewModel != nil)
//        errorMessageView.imageView.image = viewModel?.image
//        errorMessageView.titleLabel.text = viewModel?.message
//        errorMessageView.backgroundColor = viewModel?.backgroundColor
//        setErrorHidden(!errorVisible)
//        configureLabelColor(viewModel?.contentErrorStateColor)
//    }
    
    func setErrorHidden(_ hide: Bool) {
        switch (hide: hide, currentlyHidden: errorMessageContainer.isHidden) {
        case (hide: true, currentlyHidden: false):
            errorMessageContainer.isHidden = true
        case (hide: false, currentlyHidden: true):
            errorMessageContainer.isHidden = false
        default:
            break
        }
    }
}

//MARK:-

enum TableViewContentDisplayType {
    case content([ViewModelSectionType])
    case empty(image: UIImage?, detail: String)
}

//MARK:-

extension TableViewEmptyStateDisplayable where Self: UITableViewController {
    
//    func showEmptyState(detail: String, image: UIImage?) {
//        let emptyStateView = TableViewEmptyStateView.make(with: detail,
//                                                          image: image)
//        tableView.backgroundView = emptyStateView
//    }
}
