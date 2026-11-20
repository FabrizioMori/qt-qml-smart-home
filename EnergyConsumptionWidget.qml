import QtQuick
import QtQuick.Layouts

DashboardCard {
    id: energy

    // Demo data. A future C++ model can replace these arrays.
    property int selectedPeriodIndex: 0
    property color accentColor: "#E9B65D"

    property var todaySamples: [
        0.16, 0.20, 0.24, 0.27, 0.23, 0.19,
        0.24, 0.28, 0.35, 0.48, 0.55, 0.52,
        0.65, 0.76, 0.81, 0.77, 0.65, 0.55,
        0.48, 0.41, 0.33, 0.28, 0.30, 0.25, 0.20
    ]
    property var weekSamples: [6.8, 7.6, 8.9, 7.5, 9.8, 8.5, 8.4]
    property var monthSamples: [180, 192, 201, 216, 209, 236, 258, 252, 245, 261, 248, 242]

    readonly property var chartSamples: selectedPeriodIndex === 0
        ? todaySamples : selectedPeriodIndex === 1 ? weekSamples : monthSamples
    readonly property real chartMaximum: selectedPeriodIndex === 0
        ? 1.2 : selectedPeriodIndex === 1 ? 12 : 300
    readonly property var chartTicks: selectedPeriodIndex === 0 ? [
        { i: 0, label: "00:00" }, { i: 4, label: "04:00" },
        { i: 8, label: "08:00" }, { i: 12, label: "12:00" },
        { i: 16, label: "16:00" }, { i: 20, label: "20:00" }
    ] : selectedPeriodIndex === 1 ? [
        { i: 0, label: "Mon" }, { i: 1, label: "Tue" },
        { i: 2, label: "Wed" }, { i: 3, label: "Thu" },
        { i: 4, label: "Fri" }, { i: 5, label: "Sat" },
        { i: 6, label: "Sun" }
    ] : [
        { i: 0, label: "Jan" }, { i: 2, label: "Mar" },
        { i: 4, label: "May" }, { i: 6, label: "Jul" },
        { i: 8, label: "Sep" }, { i: 10, label: "Nov" }
    ]
    readonly property string energyTotal: selectedPeriodIndex === 0
        ? "8.4 kWh" : selectedPeriodIndex === 1 ? "56.8 kWh" : "242 kWh"
    readonly property string comparisonPeriod: selectedPeriodIndex === 0
        ? "vs. yesterday" : selectedPeriodIndex === 1 ? "vs. last week" : "vs. last month"

    implicitWidth: 380
    implicitHeight: 250
    contentMargin: 14
    cornerRadius: 18
    topColor: "#1F3641"
    middleColor: "#172B35"
    bottomColor: "#101C25"
    borderColor: "#3A4F5C"

    ColumnLayout {
        anchors.fill: parent
        spacing: 7

        // Header
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            spacing: 8

            Image {
                Layout.preferredWidth: 22
                Layout.preferredHeight: 22
                source: Qt.resolvedUrl("assets/icons/status/energy.svg")
                sourceSize: Qt.size(44, 44)
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: "Energy Consumption"
                color: "#FFFFFF"
                font.pixelSize: 16
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            AppComboBox {
                Layout.preferredWidth: 88
                Layout.preferredHeight: 30
                model: ["Today", "Week", "Month"]
                currentIndex: energy.selectedPeriodIndex

                onActivated: function(index) {
                    energy.selectedPeriodIndex = index
                }
            }
        }

        // Metric and comparison
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 51
            spacing: 8

            Text {
                text: energy.energyTotal
                color: "#FFFFFF"
                font.pixelSize: 26
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 4

                Text {
                    text: "↓ −12%"
                    color: "#42E99A"
                    font.pixelSize: 12
                }

                Text {
                    text: energy.comparisonPeriod
                    color: "#B6C4CC"
                    font.pixelSize: 11
                }
            }
        }

        // Chart drawn with the Qt Quick Canvas (no Qt Graphs dependency)
        Canvas {
            id: chart
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 105
            renderTarget: Canvas.Image

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()

            Connections {
                target: energy
                function onSelectedPeriodIndexChanged() { chart.requestPaint() }
                function onTodaySamplesChanged() { chart.requestPaint() }
                function onWeekSamplesChanged() { chart.requestPaint() }
                function onMonthSamplesChanged() { chart.requestPaint() }
            }

            function xAt(index, count, left, plotWidth) {
                return left + (index / (count - 1)) * plotWidth
            }

            function yAt(value, maxValue, top, plotHeight) {
                return top + (1 - value / maxValue) * plotHeight
            }

            // Smooth curve through data points using Catmull-Rom control points.
            // The caller sets the start point with moveTo() or lineTo().
            function appendCurve(ctx, values, left, top, plotWidth, plotHeight, maxValue) {
                var last = values.length - 1
                for (var i = 0; i < last; ++i) {
                    var i0 = Math.max(0, i - 1)
                    var i3 = Math.min(last, i + 2)
                    var x0 = xAt(i0, values.length, left, plotWidth)
                    var x1 = xAt(i, values.length, left, plotWidth)
                    var x2 = xAt(i + 1, values.length, left, plotWidth)
                    var x3 = xAt(i3, values.length, left, plotWidth)
                    var y0 = yAt(values[i0], maxValue, top, plotHeight)
                    var y1 = yAt(values[i], maxValue, top, plotHeight)
                    var y2 = yAt(values[i + 1], maxValue, top, plotHeight)
                    var y3 = yAt(values[i3], maxValue, top, plotHeight)

                    ctx.bezierCurveTo(
                        x1 + (x2 - x0) / 6, y1 + (y2 - y0) / 6,
                        x2 - (x3 - x1) / 6, y2 - (y3 - y1) / 6,
                        x2, y2
                    )
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var values = energy.chartSamples
                if (width < 80 || height < 60 || values.length < 2)
                    return

                var left = 36
                var right = 8
                var top = 7
                var bottom = 23
                var plotWidth = width - left - right
                var plotHeight = height - top - bottom
                var baseY = top + plotHeight
                var maxValue = energy.chartMaximum
                if (plotWidth <= 0 || plotHeight <= 0)
                    return

                // Grid and Y axis labels
                ctx.font = "11px sans-serif"
                ctx.textBaseline = "middle"
                ctx.textAlign = "right"
                ctx.lineWidth = 1

                for (var level = 0; level <= 4; ++level) {
                    var value = maxValue * (4 - level) / 4
                    var y = top + plotHeight * level / 4
                    ctx.beginPath()
                    ctx.moveTo(left, y)
                    ctx.lineTo(left + plotWidth, y)
                    ctx.strokeStyle = "#344650"
                    ctx.stroke()
                    ctx.fillStyle = "#B8C7D0"
                    ctx.fillText(maxValue <= 2 ? value.toFixed(1) : value.toFixed(0), left - 9, y)
                }

                // Area gradient under the smooth line
                ctx.beginPath()
                ctx.moveTo(left, baseY)
                ctx.lineTo(left, yAt(values[0], maxValue, top, plotHeight))
                appendCurve(ctx, values, left, top, plotWidth, plotHeight, maxValue)
                ctx.lineTo(left + plotWidth, baseY)
                ctx.closePath()

                var fill = ctx.createLinearGradient(0, top, 0, baseY)
                fill.addColorStop(0.0, "rgba(233, 182, 93, 0.40)")
                fill.addColorStop(1.0, "rgba(233, 182, 93, 0.06)")
                ctx.fillStyle = fill
                ctx.fill()

                // Main energy curve
                ctx.beginPath()
                ctx.moveTo(left, yAt(values[0], maxValue, top, plotHeight))
                appendCurve(ctx, values, left, top, plotWidth, plotHeight, maxValue)
                ctx.strokeStyle = energy.accentColor.toString()
                ctx.lineWidth = 2.7
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.stroke()

                // Selected point, matching the mockup
                var highlight = energy.selectedPeriodIndex === 0 ? 18
                              : energy.selectedPeriodIndex === 1 ? 4 : 8
                var dotX = xAt(highlight, values.length, left, plotWidth)
                var dotY = yAt(values[highlight], maxValue, top, plotHeight)
                ctx.beginPath()
                ctx.arc(dotX, dotY, 8, 0, Math.PI * 2)
                ctx.fillStyle = "rgba(233, 182, 93, 0.22)"
                ctx.fill()
                ctx.beginPath()
                ctx.arc(dotX, dotY, 4.5, 0, Math.PI * 2)
                ctx.fillStyle = energy.accentColor.toString()
                ctx.fill()
                ctx.strokeStyle = "#FFF4D0"
                ctx.lineWidth = 1.4
                ctx.stroke()

                // X axis labels
                ctx.font = "10px sans-serif"
                ctx.fillStyle = "#B8C7D0"
                ctx.textBaseline = "middle"
                var ticks = energy.chartTicks
                for (var t = 0; t < ticks.length; ++t) {
                    var x = xAt(ticks[t].i, values.length, left, plotWidth)
                    ctx.textAlign = t === 0 ? "left" : "center"
                    ctx.fillText(ticks[t].label, x, height - 10)
                }
            }
        }
    }
}
