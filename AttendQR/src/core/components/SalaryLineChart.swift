import SwiftUI
import Charts

/// Yearly salary projection line chart with summary statistics.
struct SalaryLineChart: View {
    let sales: [SaleModel]
    @Environment(\.colorScheme) var colorScheme
    private var isDark: Bool { colorScheme == .dark }
    
    // Group sales by year
    private var yearlyData: [(year: String, amount: Double)] {
        let grouped = Dictionary(grouping: sales) { 
            Calendar.current.component(.year, from: $0.dateReceived)
        }
        
        let sortedYears = grouped.keys.sorted()
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Ensure at least 5 years are shown (mocking range if data is sparse)
        var displayYears: [Int] = []
        if sortedYears.isEmpty {
            displayYears = Array((currentYear-4)...currentYear)
        } else if sortedYears.count < 5 {
            let start = sortedYears.first!
            displayYears = Array(start...(max(start + 4, currentYear)))
        } else {
            // Last 5 years available in data
            displayYears = Array(sortedYears.suffix(5))
        }
        
        return displayYears.map { year in
            let amount = grouped[year]?.reduce(0) { $0 + $1.amount } ?? 0.0
            return (year: String(year), amount: amount)
        }
    }
    
    private var hasData: Bool {
        !sales.isEmpty
    }
    
    private var totalEarned: Double {
        sales.reduce(0) { $0 + $1.amount }
    }
    
    private var maxAmount: Double {
        let maxVal = yearlyData.map { $0.amount }.max() ?? 0
        return max(1000, maxVal * 1.2)
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Salary Projection by Year")
                .font(.custom("ElmsSans", size: 18).weight(.bold))
                .foregroundColor(isDark ? .white : AppColors.textPrimary)
            
            Text("Total income per year")
                .font(.custom("ElmsSans", size: 14))
                .foregroundColor(isDark ? .white.opacity(0.7) : AppColors.textSecondary.opacity(0.7))
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text("No salary data available")
                .font(.custom("ElmsSans", size: 16))
                .foregroundColor(AppColors.textSecondary.opacity(0.7))
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
    }
    
    private var chartArea: some View {
        Chart {
            ForEach(yearlyData, id: \.year) { item in
                LineMark(
                    x: .value("Year", item.year),
                    y: .value("Amount", item.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isDark ? AppColors.blue400 : AppColors.primary)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                
                AreaMark(
                    x: .value("Year", item.year),
                    y: .value("Amount", item.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            (isDark ? AppColors.blue400 : AppColors.primary).opacity(0.1),
                            (isDark ? AppColors.blue400 : AppColors.primary).opacity(0.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                PointMark(
                    x: .value("Year", item.year),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(isDark ? AppColors.blue400 : AppColors.primary)
                .symbol {
                    Circle()
                        .fill(isDark ? AppColors.blue400 : AppColors.primary)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(AppColors.surface, lineWidth: 2)
                        )
                }
            }
        }
        .frame(height: 250)
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let year = value.as(String.self) {
                        Text(year)
                            .font(.custom("ElmsSans", size: 12).weight(.medium))
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
            StatItem(label: "Total Years", value: String(Array(Set(sales.map { Calendar.current.component(.year, from: $0.dateReceived) })).count))
            Spacer()
            StatItem(label: "Highest Year", value: getHighestYear())
            Spacer()
            StatItem(label: "Total Earned", value: formatCurrency(totalEarned))
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
    
    private func getHighestYear() -> String {
        let grouped = Dictionary(grouping: sales) { Calendar.current.component(.year, from: $0.dateReceived) }
        if let maxYear = grouped.max(by: { a, b in 
            a.value.reduce(0) { $0 + $1.amount } < b.value.reduce(0) { $0 + $1.amount }
        }) {
            return String(maxYear.key)
        }
        return "N/A"
    }
}

// MARK: - Preview
struct SalaryLineChart_Previews: PreviewProvider {
    static var previews: some View {
        let currentYear = Calendar.current.component(.year, from: Date())
        let mockSales = (0...4).flatMap { yearOffset -> [SaleModel] in
            let year = currentYear - yearOffset
            return [
                SaleModel(id: UUID().uuidString, amount: Double.random(in: 400000...600000), dateReceived: Calendar.current.date(from: DateComponents(year: year, month: 6))!, serviceType: "Freelancing Software Service")
            ]
        }
        
        ScrollView {
            VStack(spacing: 20) {
                Text("Salary Projection Chart")
                    .font(.title.bold())
                    .padding(.top)
                
                SalaryLineChart(sales: mockSales)
                    .padding()
                
                Text("Empty State")
                    .font(.headline)
                
                SalaryLineChart(sales: [])
                    .padding()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
