import SwiftUI
import Charts

/// Monthly salary breakdown line chart with summary statistics.
struct MonthlySalaryLineChart: View {
    let sales: [SaleModel]
    @Environment(\.colorScheme) var colorScheme
    private var isDark: Bool { colorScheme == .dark }
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    // Grouped data for the chart
    private var monthlyData: [(month: String, index: Int, amount: Double)] {
        var data: [(month: String, index: Int, amount: Double)] = []
        let grouped = Dictionary(grouping: sales.filter { 
            Calendar.current.component(.year, from: $0.dateReceived) == currentYear 
        }) { 
            Calendar.current.component(.month, from: $0.dateReceived)
        }
        
        for month in 1...12 {
            let amount = grouped[month]?.reduce(0) { $0 + $1.amount } ?? 0.0
            data.append((month: monthNames[month - 1], index: month - 1, amount: amount))
        }
        return data
    }
    
    private var hasData: Bool {
        monthlyData.contains { $0.amount > 0 }
    }
    
    private var totalAnnualSalary: Double {
        monthlyData.reduce(0) { $0 + $1.amount }
    }
    
    private var maxMonthlyValue: Double {
        let maxValue = monthlyData.map { $0.amount }.max() ?? 0
        return max(1000, maxValue * 1.2)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            
            if !hasData {
                emptyState
            } else {
                chartArea
                summaryStats
            }
        }
        .padding(20)
        .background(isDark ? AppColors.cardDark : AppColors.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(isDark ? 0.3 : 0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.border.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Monthly Salary - \(String(currentYear))")
                    .font(.custom("ElmsSans", size: 18).weight(.bold))
                    .foregroundColor(isDark ? .white : AppColors.textPrimary)
                
                Text("Income breakdown by month")
                    .font(.custom("ElmsSans", size: 14))
                    .foregroundColor(isDark ? .white.opacity(0.7) : AppColors.textSecondary.opacity(0.7))
            }
            
            Spacer()
            
            if hasData {
                Text(formatCurrency(totalAnnualSalary))
                    .font(.custom("ElmsSans", size: 14).weight(.bold))
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.primary.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text("No salary data for \(String(currentYear))")
                .font(.custom("ElmsSans", size: 16))
                .foregroundColor(AppColors.textSecondary.opacity(0.7))
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
    }
    
    private var chartArea: some View {
        Chart {
            ForEach(monthlyData, id: \.index) { item in
                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isDark ? AppColors.blue400 : AppColors.success)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            (isDark ? AppColors.blue400 : AppColors.success).opacity(0.15),
                            (isDark ? AppColors.blue400 : AppColors.success).opacity(0.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                if item.amount > 0 {
                    PointMark(
                        x: .value("Month", item.month),
                        y: .value("Amount", item.amount)
                    )
                    .foregroundStyle(isDark ? AppColors.blue400 : AppColors.success)
                    .symbol {
                        Circle()
                            .fill(isDark ? AppColors.blue400 : AppColors.success)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .stroke(AppColors.surface, lineWidth: 2)
                            )
                    }
                }
            }
        }
        .frame(height: 250)
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) { value in
                AxisValueLabel {
                    if let month = value.as(String.self) {
                        Text(month)
                            .font(.custom("ElmsSans", size: 11).weight(.medium))
                            .foregroundColor(isDark ? .white.opacity(0.7) : AppColors.textSecondary.opacity(0.7))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(AppColors.border.opacity(0.2))
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text("₱\(Int(amount/1000))k")
                            .font(.custom("ElmsSans", size: 11).weight(.medium))
                            .foregroundColor(isDark ? .white.opacity(0.7) : AppColors.textSecondary.opacity(0.7))
                    }
                }
            }
        }
    }
    
    private var summaryStats: some View {
        HStack(alignment: .center) {
            Spacer()
            StatItem(label: "This Month", value: formatCurrentMonthSalary())
            Spacer()
            StatItem(label: "Best Month", value: getBestMonth())
            Spacer()
            StatItem(label: "Avg/Month", value: formatAvgMonthlySalary())
            Spacer()
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₱"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "₱\(Int(value))"
    }
    
    private func formatCurrentMonthSalary() -> String {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let amount = monthlyData[currentMonth - 1].amount
        return formatCurrency(amount)
    }
    
    private func getBestMonth() -> String {
        if let maxData = monthlyData.max(by: { $0.amount < $1.amount }), maxData.amount > 0 {
            return maxData.month
        }
        return "N/A"
    }
    
    private func formatAvgMonthlySalary() -> String {
        let monthsWithData = monthlyData.filter { $0.amount > 0 }
        guard !monthsWithData.isEmpty else { return "₱0" }
        let avg = totalAnnualSalary / Double(monthsWithData.count)
        return formatCurrency(avg)
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let label: String
    let value: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom("ElmsSans", size: 14).weight(.bold))
                .foregroundColor(colorScheme == .dark ? .white : AppColors.primary)
            
            Text(label)
                .font(.custom("ElmsSans", size: 11))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : AppColors.textSecondary.opacity(0.7))
        }
    }
}

// MARK: - Preview
struct MonthlySalaryLineChart_Previews: PreviewProvider {
    static var previews: some View {
        let currentYear = Calendar.current.component(.year, from: Date())
        let mockSales = [
            SaleModel(id: "1", amount: 45000, dateReceived: Calendar.current.date(from: DateComponents(year: currentYear, month: 1))!, serviceType: "Freelancing Software Service"),
            SaleModel(id: "2", amount: 48000, dateReceived: Calendar.current.date(from: DateComponents(year: currentYear, month: 2))!, serviceType: "Freelancing Software Service"),
            SaleModel(id: "3", amount: 52000, dateReceived: Calendar.current.date(from: DateComponents(year: currentYear, month: 3))!, serviceType: "Freelancing Software Service"),
            SaleModel(id: "4", amount: 50000, dateReceived: Calendar.current.date(from: DateComponents(year: currentYear, month: 4))!, serviceType: "Freelancing Software Service"),
            SaleModel(id: "5", amount: 65000, dateReceived: Calendar.current.date(from: DateComponents(year: currentYear, month: 5))!, serviceType: "Cloud Services"),
            SaleModel(id: "6", amount: 55000, dateReceived: Calendar.current.date(from: DateComponents(year: currentYear, month: 6))!, serviceType: "Freelancing Software Service")
        ]
        
        ScrollView {
            VStack(spacing: 20) {
                Text("Monthly Salary Chart")
                    .font(.title.bold())
                    .padding(.top)
                
                MonthlySalaryLineChart(sales: mockSales)
                    .padding()
                
                Text("Empty State")
                    .font(.headline)
                
                MonthlySalaryLineChart(sales: [])
                    .padding()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
