//
//  DateChartText.swift
//  BirdMonitorSystem
//
//  Created by 白云松 on 4/10/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit
import SwiftCharts
class DateChartText: UIViewController {
    fileprivate var chart: Chart? // arc
    var historys: [HistoryRecordInfo]!
    let datePicker = UIDatePicker()
    
    var dateInfo:String = ""
    //var historysTest: [HistoryRecordInfo]!
    let expiryDatePicker = MonthYearPickerView()
    @IBOutlet weak var dateLabel: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.chart?.clearView()
        //current time
        let nowD = Date()
        var dateC:DateFormatter = DateFormatter()
        dateC.dateFormat = "yyyy-MM-dd"
        let dateS:String = dateC.string(from: nowD)
        let dateA:[String] = dateS.components(separatedBy: "-")
        let dateF = dateA[0] + "-" + dateA[1]
    
        dateLabel.text = dateF
        //datepicker
        createDatePicker()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            //self.dateInfo = String(format: "%02d/%d", month, year)
            self.dateInfo = String(format: "%d-%02d", year, month)
            //self.dateInfo = String(month) + String(year)
            self.dateLabel.text = self.dateInfo
            //NSLog(self.dateInfo) // should show something like 05/2015
        }
        // database
        
        historys = DBManager.shared.loadMovies(IDqueryOrDatequery: "DATE", certainMonth:" ")
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd.MM.yyyy"
        
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }
        
        let calendar = Calendar.current
        
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.date(from: components)!
        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        /*
        let chartPoints = [
            createChartPoint(dateStr: "Oct 1, 2015", percent: 5, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "Oct 4, 2015", percent: 10, readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
 
        */
        // eatline
        var chartPointEat:[ChartPoint] = []
        
        for history in historys{
            chartPointEat.append(createChartPoint(dateStr:history.date, percent: Double(history.eatNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
            
        }
        //drink line
        var chartPointDrink:[ChartPoint] = []
        
        for history in historys{
            chartPointDrink.append(createChartPoint(dateStr:history.date, percent: Double(history.drinkNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        //feeding line
        var chartPointFeeding:[ChartPoint] = []
        
        for history in historys{
            chartPointFeeding.append(createChartPoint(dateStr:history.date, percent: Double(history.feedNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        //flying line
        var chartPointFlying:[ChartPoint] = []
        
        for history in historys{
            chartPointFlying.append(createChartPoint(dateStr:history.date, percent: Double(history.flyNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        /*
        let chartPoints1 = [
            createChartPoint(dateStr: "Oct 1, 2015", percent: 6, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "Oct 4, 2015", percent: 13, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "Oct 5, 2015", percent: 25, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "Oct 6, 2015", percent: 80, readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        */
        let yValues = stride(from: 0, through: 100, by: 10).map {ChartAxisValuePercent($0, labelSettings: labelSettings)}

        let xValues = [
            createDateAxisValue("\(dateF)-01 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-03 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-05 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-07 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-09 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-11 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-13 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-15 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-17 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-19 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-21 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-23 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-25 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-27 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-29 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(dateF)-30 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter)
            
        ]
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Date(Monthly)", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Quantity of herons in different behaviours", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
        var chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        chartSettings.trailing = 80
        
        // Set a fixed (horizontal) scrollable area 2x than the original width, with zooming disabled.
        chartSettings.zoomPan.maxZoomX = 0.5
        chartSettings.zoomPan.minZoomX = 0.5
        chartSettings.zoomPan.minZoomY = 1
        chartSettings.zoomPan.maxZoomY = 1
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        //let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 2, animDuration: 1, animDelay: 0)
        
        //let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.blue, lineWidth: 2, animDuration: 1, animDelay: 0)
        //eating
        let lineModelEat = ChartLineModel(chartPoints: chartPointEat, lineColor: UIColor.green, lineWidth: 2, animDuration: 1, animDelay: 0)
        //drinking
        let lineModelDrink = ChartLineModel(chartPoints: chartPointDrink, lineColor: UIColor.brown, lineWidth: 2, animDuration: 1, animDelay: 0)
        //flying
        let lineModelFly = ChartLineModel(chartPoints: chartPointFlying, lineColor: UIColor.yellow, lineWidth: 2, animDuration: 1, animDelay: 0)
        //feeding
        let lineModelFeed = ChartLineModel(chartPoints: chartPointFeeding, lineColor: UIColor.orange, lineWidth: 2, animDuration: 1, animDelay: 0)
        
        
        //let chartLines = [lineModel, lineModel1, lineModelEat,lineModelFly,lineModelDrink, lineModelFeed]
        let chartLines = [lineModelEat,lineModelFly,lineModelDrink, lineModelFeed]
        // delayInit parameter is needed by some layers for initial zoom level to work correctly. Setting it to true allows to trigger drawing of layer manually (in this case, after the chart is initialized). This obviously needs improvement. For now it's necessary.
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: chartLines, delayInit: true)
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.3)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer]
        )
        view.addSubview(chart.view)
        // Set scrollable area 2x than the original width, with zooming enabled. This can also be combined with e.g. minZoomX to allow only larger zooming levels.
        //        chart.zoom(scaleX: 2, scaleY: 1, centerX: 0, centerY: 0)
        
        // Now that the chart is zoomed (either with minZoom setting or programmatic zooming), trigger drawing of the line layer. Important: This requires delayInit paramter in line layer to be set to true.
        chartPointsLineLayer.initScreenLines(chart)
        
        
        self.chart = chart
    }
    
    @IBAction func selectMonthBtn(_ sender: Any) {
        
        // selected month
        
        self.chart?.clearView()
        
        let selectedMonth:String = self.dateLabel.text!
        
        //
        
        historys = DBManager.shared.loadMovies(IDqueryOrDatequery: "DATE", certainMonth:" ")
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd.MM.yyyy"
        
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }
        
        let calendar = Calendar.current
        
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.date(from: components)!
        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        /*
         let chartPoints = [
         createChartPoint(dateStr: "Oct 1, 2015", percent: 5, readFormatter: readFormatter, displayFormatter: displayFormatter),
         createChartPoint(dateStr: "Oct 4, 2015", percent: 10, readFormatter: readFormatter, displayFormatter: displayFormatter)
         ]
         
         */
        // eatline
        var chartPointEat:[ChartPoint] = []
        
        for history in historys{
            chartPointEat.append(createChartPoint(dateStr:history.date, percent: Double(history.eatNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
            
        }
        //drink line
        var chartPointDrink:[ChartPoint] = []
        
        for history in historys{
            chartPointDrink.append(createChartPoint(dateStr:history.date, percent: Double(history.drinkNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        //feeding line
        var chartPointFeeding:[ChartPoint] = []
        
        for history in historys{
            chartPointFeeding.append(createChartPoint(dateStr:history.date, percent: Double(history.feedNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        //flying line
        var chartPointFlying:[ChartPoint] = []
        
        for history in historys{
            chartPointFlying.append(createChartPoint(dateStr:history.date, percent: Double(history.flyNum)!, readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        /*
         let chartPoints1 = [
         createChartPoint(dateStr: "Oct 1, 2015", percent: 6, readFormatter: readFormatter, displayFormatter: displayFormatter),
         createChartPoint(dateStr: "Oct 4, 2015", percent: 13, readFormatter: readFormatter, displayFormatter: displayFormatter),
         createChartPoint(dateStr: "Oct 5, 2015", percent: 25, readFormatter: readFormatter, displayFormatter: displayFormatter),
         createChartPoint(dateStr: "Oct 6, 2015", percent: 80, readFormatter: readFormatter, displayFormatter: displayFormatter)
         ]
         */
        let yValues = stride(from: 0, through: 100, by: 10).map {ChartAxisValuePercent($0, labelSettings: labelSettings)}
        
        let xValues = [
            
            createDateAxisValue("\(selectedMonth)-01 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-03 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-05 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-07 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-09 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-11 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-13 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-15 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-17 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-19 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-21 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-23 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-25 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-27 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-29 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("\(selectedMonth)-30 12:00:00", readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Date(Monthly)", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Quantity of herons in different behaviours", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
        var chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        chartSettings.trailing = 80
        
        // Set a fixed (horizontal) scrollable area 2x than the original width, with zooming disabled.
        chartSettings.zoomPan.maxZoomX = 0.5
        chartSettings.zoomPan.minZoomX = 0.5
        chartSettings.zoomPan.minZoomY = 1
        chartSettings.zoomPan.maxZoomY = 1
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        //let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 2, animDuration: 1, animDelay: 0)
        
        //let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.blue, lineWidth: 2, animDuration: 1, animDelay: 0)
        //eating
        let lineModelEat = ChartLineModel(chartPoints: chartPointEat, lineColor: UIColor.green, lineWidth: 2, animDuration: 1, animDelay: 0)
        //drinking
        let lineModelDrink = ChartLineModel(chartPoints: chartPointDrink, lineColor: UIColor.brown, lineWidth: 2, animDuration: 1, animDelay: 0)
        //flying
        let lineModelFly = ChartLineModel(chartPoints: chartPointFlying, lineColor: UIColor.yellow, lineWidth: 2, animDuration: 1, animDelay: 0)
        //feeding
        let lineModelFeed = ChartLineModel(chartPoints: chartPointFeeding, lineColor: UIColor.orange, lineWidth: 2, animDuration: 1, animDelay: 0)
        
        
        //let chartLines = [lineModel, lineModel1, lineModelEat,lineModelFly,lineModelDrink, lineModelFeed]
        let chartLines = [lineModelEat,lineModelFly,lineModelDrink, lineModelFeed]
        // delayInit parameter is needed by some layers for initial zoom level to work correctly. Setting it to true allows to trigger drawing of layer manually (in this case, after the chart is initialized). This obviously needs improvement. For now it's necessary.
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: chartLines, delayInit: true)
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.3)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer]
        )
        view.addSubview(chart.view)
        // Set scrollable area 2x than the original width, with zooming enabled. This can also be combined with e.g. minZoomX to allow only larger zooming levels.
        //        chart.zoom(scaleX: 2, scaleY: 1, centerX: 0, centerY: 0)
        
        // Now that the chart is zoomed (either with minZoom setting or programmatic zooming), trigger drawing of the line layer. Important: This requires delayInit paramter in line layer to be set to true.
        chartPointsLineLayer.initScreenLines(chart)
        
        
        self.chart = chart
        
        
    }
    
    func createDatePicker() {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bur button item
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateLabel.inputAccessoryView = toolbar
        //datePicker.datePickerMode = .date
        dateLabel.inputView = expiryDatePicker

    }
    
    func donePressed() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        //dateFormatter.dateStyle = .short
        //dateFormatter.timeStyle = .medium
        //dateLabel.text = dateFormatter.string(from: dateInfo)
        //dateLabel.text = dateInfo
        self.view.endEditing(true)
    }

    
    func createChartPoint(dateStr: String, percent: Double, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
        return ChartPoint(x: createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValuePercent(percent))
    }
    
    func createDateAxisValue(_ dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
        let date = readFormatter.date(from: dateStr)!
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var description: String {
            return "\(formatter.string(from: NSNumber(value: scalar))!)"
        }
    }
}
