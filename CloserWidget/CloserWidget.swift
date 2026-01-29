import WidgetKit
import SwiftUI
import AppIntents

// --- 1. AYARLAR ---
let appGroup = "group.com.melis.closer" // KENDİ GRUP İSMİNİ YAZ

// --- 2. VERİ MODELİ ---
struct Goal: Identifiable, Codable, AppEntity {
    var id: UUID
    var title: String
    var icon: String
    var currentAmount: Double
    var targetAmount: Double
    var colorTheme: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Hedef"
    static var defaultQuery = GoalQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(icon) \(title)")
    }
    
    static let placeholder = Goal(id: UUID(), title: "Örnek", icon: "✨", currentAmount: 3500, targetAmount: 5000, colorTheme: "Mavi")
    static let placeholder2 = Goal(id: UUID(), title: "Tatil", icon: "🏖️", currentAmount: 1200, targetAmount: 10000, colorTheme: "Turuncu")
}

// --- 3. VERİ ÇEKME ---
struct GoalQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [Goal] {
        let allGoals = GoalDataProvider.loadGoals()
        return allGoals.filter { identifiers.contains($0.id) }
    }
    func suggestedEntities() async throws -> [Goal] { return GoalDataProvider.loadGoals() }
    func defaultResult() async -> Goal? { return GoalDataProvider.loadGoals().first }
}

struct GoalDataProvider {
    static func loadGoals() -> [Goal] {
        guard let defaults = UserDefaults(suiteName: appGroup),
              let data = defaults.data(forKey: "goalsData"),
              let decoded = try? JSONDecoder().decode([GoalData].self, from: data) else { return [] }
        
        return decoded.map {
            Goal(id: $0.id, title: $0.title, icon: $0.icon, currentAmount: $0.currentAmount, targetAmount: $0.targetAmount, colorTheme: $0.colorTheme)
        }
    }
}

struct GoalData: Codable {
    var id: UUID; var title: String; var icon: String; var currentAmount: Double; var targetAmount: Double; var link: String; var startDate: Date; var targetDate: Date; var colorTheme: String
}

// --- 4. AYAR EKRANI ---
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Hedef Seç"
    static var description = IntentDescription("Küçük widget için hedef seçin.")
    @Parameter(title: "Öncelikli Hedef")
    var selectedGoal: Goal?
}

// --- 5. WIDGET MOTORU ---
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), selectedGoal: Goal.placeholder, topGoals: [Goal.placeholder, Goal.placeholder2])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let allGoals = GoalDataProvider.loadGoals()
        let selected = configuration.selectedGoal ?? allGoals.first ?? Goal.placeholder
        let topTwo = Array(allGoals.prefix(2))
        return SimpleEntry(date: Date(), selectedGoal: selected, topGoals: topTwo.isEmpty ? [Goal.placeholder, Goal.placeholder2] : topTwo)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let allGoals = GoalDataProvider.loadGoals()
        let selected = configuration.selectedGoal ?? allGoals.first
        let topTwoGoals = Array(allGoals.prefix(2))
        let entry = SimpleEntry(date: Date(), selectedGoal: selected, topGoals: topTwoGoals)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let selectedGoal: Goal?
    let topGoals: [Goal]
}

// --- 6. TASARIM ---
struct CloserWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            if let goal = entry.selectedGoal {
                SmallCleanWidget(goal: goal)
            } else {
                EmptyStateView(message: "Hedef Yok")
            }
        case .systemMedium:
            if !entry.topGoals.isEmpty {
                MediumCleanWidget(goals: entry.topGoals)
            } else {
                EmptyStateView(message: "Henüz Hedef Eklenmedi")
            }
        default:
            Text("Desteklenmiyor")
        }
    }
}

// --- YENİ KÜÇÜK WIDGET (Halkasız, Büyük Yazı) ---
struct SmallCleanWidget: View {
    let goal: Goal
    var themeInfo: ThemeInfo { getThemeInfo(goal.colorTheme) }
    var progress: Double { goal.targetAmount > 0 ? min(goal.currentAmount / goal.targetAmount, 1.0) : 0 }
    let darkTextColor = Color.black.opacity(0.85) // Biraz daha koyu yaptım
    
    var body: some View {
        ZStack {
            themeInfo.backgroundGradient
            
            VStack(spacing: 6) { // Spacing biraz azaldı
                Spacer()
                
                // İlerleme Halkası
                ZStack {
                    Circle().stroke(Color.black.opacity(0.05), lineWidth: 11)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            themeInfo.progressGradient,
                            style: StrokeStyle(lineWidth: 11, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .shadow(color: themeInfo.accentColor.opacity(0.25), radius: 4, x: 0, y: 0)
                    
                    Text(goal.icon).font(.system(size: 38)) // İkon Büyüdü (34 -> 38)
                }
                .frame(width: 88, height: 88) // Halka alanı büyüdü
                
                // Bilgiler
                VStack(spacing: 3) {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded)) // Yazı Büyüdü (15 -> 16)
                        .lineLimit(1)
                        .foregroundColor(darkTextColor)
                    
                    Text("%\(Int(progress * 100))")
                        .font(.system(size: 15, weight: .heavy, design: .monospaced)) // Yazı Büyüdü (13 -> 15)
                        .foregroundColor(themeInfo.accentColor)
                }
                
                Spacer()
            }
        }
        .containerBackground(for: .widget) { themeInfo.backgroundGradient }
    }
}

// --- YENİ ORTA WIDGET (Halkasız, Büyük Yazı, İkili) ---
struct MediumCleanWidget: View {
    let goals: [Goal]
    
    var body: some View {
        ZStack {
            let mainTheme = getThemeInfo(goals.first?.colorTheme ?? "Beyaz")
            mainTheme.backgroundGradient
            
            HStack(spacing: 0) {
                if let firstGoal = goals.first {
                    GoalSummaryCell(goal: firstGoal)
                }
                
                if goals.count > 1 {
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                        .frame(width: 1)
                        .padding(.vertical, 12)
                }
                
                if goals.count > 1 {
                    GoalSummaryCell(goal: goals[1])
                } else if goals.count == 1 {
                    Spacer()
                }
            }
            .padding(.horizontal, 10)
        }
        .containerBackground(for: .widget) {
            getThemeInfo(goals.first?.colorTheme ?? "Beyaz").backgroundGradient
        }
    }
}

struct GoalSummaryCell: View {
    let goal: Goal
    var themeInfo: ThemeInfo { getThemeInfo(goal.colorTheme) }
    var progress: Double { goal.targetAmount > 0 ? min(goal.currentAmount / goal.targetAmount, 1.0) : 0 }
    let darkTextColor = Color.black.opacity(0.85)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) { // Spacing düzenlendi
            HStack {
                Text(goal.icon).font(.system(size: 26)) // İkon büyüdü
                Spacer()
                Text("%\(Int(progress * 100))")
                    .font(.system(size: 14, weight: .bold, design: .monospaced)) // Yazı büyüdü (12 -> 14)
                    .foregroundColor(themeInfo.accentColor)
            }
            
            Text(goal.title)
                .font(.system(size: 16, weight: .bold, design: .rounded)) // Başlık büyüdü (14 -> 16)
                .foregroundColor(darkTextColor)
                .lineLimit(1)
            
            // Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.black.opacity(0.06))
                    Capsule()
                        .fill(themeInfo.progressGradient)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 10) // Bar kalınlaştı (8 -> 10)
            
            Text("\(formatMoney(goal.currentAmount))₺") // Sadece mevcut parayı göster (Daha temiz)
                .font(.system(size: 12, weight: .semibold)) // Yazı büyüdü (10 -> 12)
                .foregroundColor(Color.black.opacity(0.6))
                .lineLimit(1)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
    }
}

// --- YARDIMCILAR ---
struct EmptyStateView: View {
    let message: String
    var body: some View {
        VStack { Text("🌱").font(.largeTitle); Text(message).font(.headline).bold().foregroundColor(.gray) }
        .containerBackground(for: .widget) { Color.white }
    }
}

struct ThemeInfo { let accentColor: Color; let backgroundGradient: LinearGradient; let progressGradient: LinearGradient }

func getThemeInfo(_ name: String) -> ThemeInfo {
    let main: Color, sec: Color
    switch name {
    case "Mavi":    main = .blue; sec = .cyan
    case "Kırmızı": main = .red; sec = .orange
    case "Yeşil":   main = .green; sec = .mint
    case "Turuncu": main = .orange; sec = .yellow
    case "Mor":     main = .purple; sec = .indigo
    case "Pembe":   main = .pink; sec = .purple
    default:        main = Color(uiColor: .systemBlue); sec = Color(uiColor: .systemTeal)
    }
    
    // Daha temiz, dokusuz arka plan
    let bgGrad = LinearGradient(colors: [main.opacity(0.12), sec.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
    let progGrad = LinearGradient(colors: [main, sec], startPoint: .leading, endPoint: .trailing)
    return ThemeInfo(accentColor: main, backgroundGradient: bgGrad, progressGradient: progGrad)
}

func formatMoney(_ amount: Double) -> String {
    let f = NumberFormatter(); f.numberStyle = .decimal; f.maximumFractionDigits = 0; return f.string(from: NSNumber(value: amount)) ?? "0"
}

@main
struct CloserWidget: Widget {
    let kind: String = "CloserWidget"
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CloserWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Closer")
        .description("Hedeflerini takip et.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
