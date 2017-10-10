//
//  ChartView.swift
//  BirdMonitorSystem
//
//  Created by 白云松 on 3/10/17.
//  Copyright © 2017 bys. All rights reserved.
//

import UIKit
import SwiftCharts

class ChartView: UIViewController {
    
    fileprivate var chart: Chart? // arc

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //line chart
        
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 2, to: 14, by: 2),
            yAxisConfig: ChartAxisConfig(from: 0, to: 14, by: 2)
        )
        
        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
        
        let chart = LineChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            lines: [
                (chartPoints: [(2.0, 10.6), (4.2, 5.1), (7.3, 3.0), (8.1, 5.5), (14.0, 8.0)], color: UIColor.red),
                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.blue)
            ]
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
        
        let date = DateFormatter()
        date.dateStyle = .medium
        //date.timeStyle = .medium
        date.timeZone = NSTimeZone(name:"UTC") as TimeZone!
        let datea = date.date(from: "Sep 1, 2017")
        
        
        print(datea ?? "s")
        
        
        
        
        
        /*

        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let chartPoints = [(0, 0), (4, 4), (8, 11), (9, 2), (11, 10), (12, 3), (15, 18), (18, 10), (20, 15)].map{ChartPoint(x: ChartAxisValueInt($0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
        
        let xValues = chartPoints.map{$0.x}
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.purple, lineWidth: 2, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], pathGenerator: CatmullPathGenerator()) // || CubicLinePathGenerator
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer
            ]
        )
        
        view.addSubview(chart.view)
        self.chart = chart
        
        */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
