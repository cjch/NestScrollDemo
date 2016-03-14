//
//  ViewController.swift
//  NestScrollDemo
//
//  Created by jiechen on 16/3/14.
//  Copyright © 2016年 jiechen. All rights reserved.
//

import UIKit

let DeviceWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let DeviceHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
let HeaderHeight: CGFloat = 150
let SectionHeaderHeight: CGFloat = 200 - HeaderHeight
let ReuseCellID = String(UITableViewCell)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.scrollView.addSubview(self.tableView1)
        self.scrollView.addSubview(self.tableView2)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - getter
    lazy var scrollView: UIScrollView = {
        [unowned self] in
        let sView = UIScrollView(frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: DeviceHeight))
        sView.contentSize = CGSize(width: DeviceWidth * 2, height: DeviceHeight)
        sView.pagingEnabled = true
        sView.showsVerticalScrollIndicator = false;
        sView.showsHorizontalScrollIndicator = false;
        sView.backgroundColor = UIColor.clearColor()
        
        return sView
    }()
    
    lazy var tableView1: UITableView = {
        [unowned self] in
        return self.commonTableView(0)
    }()
    
    lazy var tableView2: UITableView = {
        [unowned self] in
        return self.commonTableView(1)
    }()
    
    lazy var headerView: UIView = {
        [unowned self] in
        let view = self.tableHeaderView()
        view.userInteractionEnabled = false
        return view
    }()
    
    //MARK: - Helper
    func commonTableView(index: Int) -> UITableView {
        let table = UITableView(frame: CGRect(x: CGFloat(index) * DeviceWidth, y: 0, width: DeviceWidth, height: DeviceHeight), style: .Plain)
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: ReuseCellID)
        table.delegate = self;
        table.dataSource = self;
        table.tableHeaderView = self.tableHeaderView()
        return table
    }
    
    func tableHeaderView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: 200));
        view.backgroundColor = UIColor.redColor()
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: HeaderHeight, width: DeviceWidth/2, height: SectionHeaderHeight));
        leftButton.setTitle("table 1", forState: .Normal)
        leftButton.addTarget(self, action: Selector("onLeft"), forControlEvents: .TouchUpInside)
        leftButton.backgroundColor = UIColor.lightGrayColor()
        
        let rightButton = UIButton(frame: CGRect(x: DeviceWidth/2, y: HeaderHeight, width: DeviceWidth/2, height: SectionHeaderHeight));
        rightButton.setTitle("table 2", forState: .Normal)
        rightButton.addTarget(self, action: Selector("onRight"), forControlEvents: .TouchUpInside)
        rightButton.backgroundColor = UIColor .darkGrayColor()
       
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        return view
    }
    
    //MARK: -
    func onLeft() {
        print("left button clicked")
    }
    
    func onRight() {
        print("right button clicked")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseCellID)
        let tableIndex = tableView == self.tableView1 ? 1 : 2
        cell?.textLabel?.text = "table \(tableIndex), row \(indexPath.row)"
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            return;
        }
        
        var point = scrollView.contentOffset
        if point.y < 0 {
            point.y = 0
            scrollView.contentOffset = point
        }
        
        let headerY = self.headerView.frame.origin.y
        // header没有滑动到设定的位置 或者 header已经到了指定位置，但此时要滑动header(下拉)
        if headerY != -HeaderHeight || headerY < -point.y {
            let offY = min(HeaderHeight, point.y)
            var rect = self.headerView.frame
            rect.origin.y = -offY
            self.headerView.frame = rect
            
            self.tableView1.contentOffset = point
            self.tableView2.contentOffset = point
        }
    }
}

