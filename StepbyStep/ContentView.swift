import SwiftUI

// --- 1. PASTEL RENK PALETİ ---
extension Color {
    static let pastelBlue = Color(red: 0.68, green: 0.85, blue: 0.90)
    static let pastelPink = Color(red: 1.00, green: 0.82, blue: 0.86)
    static let pastelGreen = Color(red: 0.76, green: 0.88, blue: 0.77)
    static let pastelPurple = Color(red: 0.87, green: 0.78, blue: 0.94)
    static let pastelOrange = Color(red: 1.00, green: 0.85, blue: 0.73)
    static let pastelYellow = Color(red: 0.99, green: 0.93, blue: 0.70)
}

// --- 2. GÜÇLENDİRİLMİŞ BANKA VERİTABANI ---
struct FinancialApp: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let schemes: [String]
    let searchQuery: String
    let directLink: String
}

let supportedApps: [FinancialApp] = [
    FinancialApp(name: "Seçilmedi", schemes: [], searchQuery: "", directLink: ""),
    FinancialApp(name: "Garanti BBVA", schemes: ["garantibbva://", "garanti://", "com.garantibbva.mobile://"], searchQuery: "Garanti BBVA", directLink: "https://app.adjust.com/v4i62nv"),
    FinancialApp(name: "Akbank", schemes: ["akbank://", "akbankdirekt://"], searchQuery: "Akbank", directLink: "https://apps.apple.com/tr/app/akbank-mobil/id560516360?l=tr"),
    FinancialApp(name: "İşCep (İş Bankası)", schemes: ["iscep://", "isbank://"], searchQuery: "İşCep", directLink: "https://apps.apple.com/tr/app/i-%C5%9Fcep-bankac%C4%B1l%C4%B1k-ve-finans/id308261752?l=tr"),
    FinancialApp(name: "Yapı Kredi", schemes: ["ykb://", "yapikredi://"], searchQuery: "Yapı Kredi", directLink: "https://apps.apple.com/tr/app/yap%C4%B1-kredi-mobil/id458627086?l=tr"),
    FinancialApp(name: "Ziraat Mobil", schemes: ["ziraatmobile://", "ziraat://"], searchQuery: "Ziraat Mobil", directLink: "https://apps.apple.com/tr/app/ziraat-mobil/id885993234?l=tr"),
    FinancialApp(name: "VakıfBank", schemes: ["vakifbank://"], searchQuery: "VakıfBank", directLink: "https://apps.apple.com/tr/app/vak%C4%B1fbank-mobil-bankac%C4%B1l%C4%B1k/id853569450?l=tr"),
    FinancialApp(name: "Halkbank", schemes: ["halkbank://"], searchQuery: "Halkbank", directLink: "https://apps.apple.com/tr/app/halkbank-mobil/id1068841746?l=tr"),
    FinancialApp(name: "Finansbank (QNB)", schemes: ["qnbfinansbank://", "finansbank://"], searchQuery: "QNB Finansbank", directLink: "https://apps.apple.com/tr/app/qnb-mobil-dijital-k%C3%B6pr%C3%BC/id739655617?l=tr"),
    FinancialApp(name: "Enpara.com", schemes: ["enpara://"], searchQuery: "Enpara", directLink: "https://apps.apple.com/tr/app/enpara-bank-cep-%C5%9Fube/id6711348553?l=tr"),
    FinancialApp(name: "DenizBank", schemes: ["mobildeniz://", "denizbank://"], searchQuery: "DenizBank", directLink: "https://apps.apple.com/tr/app/mobildeniz/id1403334281?l=tr"),
    FinancialApp(name: "Binance", schemes: ["binance://"], searchQuery: "Binance", directLink: "https://apps.apple.com/tr/app/binance-bitcoin-kripto/id1436799971?l=tr"),
    FinancialApp(name: "Binance TR", schemes: ["binancetr://"], searchQuery: "Binance TR", directLink: "https://apps.apple.com/tr/app/binance-tr-bitcoin-ve-kripto/id1548636153?l=tr"),
    FinancialApp(name: "Midas", schemes: ["midas://"], searchQuery: "Midas", directLink: "https://apps.apple.com/tr/app/midas-borsa-hisse-al%C4%B1m-sat%C4%B1m/id1554268946?l=tr"),
    FinancialApp(name: "BTCurk", schemes: ["btcurk://"], searchQuery: "BTCurk", directLink: "https://apps.apple.com/tr/app/btcturk-kripto-btc-usdt-xrp/id1471639720?l=tr"),
    FinancialApp(name: "Paribu", schemes: ["paribu://"], searchQuery: "Paribu", directLink: "https://apps.apple.com/tr/app/paribu-bitcoin-kripto-para/id1448200352?l=tr")
]

// --- RENK YARDIMCILARI ---
struct ThemeColor: Identifiable {
    let id = UUID(); let name: String; let color: Color; let accentColor: Color
}
let availableThemes: [ThemeColor] = [
    ThemeColor(name: "Beyaz", color: Color.white, accentColor: Color.blue),
    ThemeColor(name: "Mavi", color: Color.blue.opacity(0.3), accentColor: Color.blue),
    ThemeColor(name: "Kırmızı", color: Color.red.opacity(0.3), accentColor: Color.red),
    ThemeColor(name: "Yeşil", color: Color.green.opacity(0.3), accentColor: Color.green),
    ThemeColor(name: "Turuncu", color: Color.orange.opacity(0.3), accentColor: Color.orange),
    ThemeColor(name: "Mor", color: Color.purple.opacity(0.3), accentColor: Color.purple),
    ThemeColor(name: "Pembe", color: Color.pink.opacity(0.3), accentColor: Color.pink)
]
func getColorForTheme(_ name: String) -> ThemeColor { return availableThemes.first(where: { $0.name == name }) ?? availableThemes[0] }

// --- 3. VERİ MODELİ ---
struct Goal: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var icon: String
    var currentAmount: Double
    var targetAmount: Double
    var link: String
    var startDate: Date
    var targetDate: Date
    var colorTheme: String = "Beyaz"
    var bankName: String = "Seçilmedi"
    
    var isCompleted: Bool { return currentAmount >= targetAmount }
}

// --- 4. ANA YAPI (TAB BAR) ---
struct ContentView: View {
    @AppStorage("goalsData", store: UserDefaults(suiteName: "group.com.melis.closer")) private var goalsData: Data = Data()
    @State private var goals: [Goal] = []
    
    // Sekme rengi ayarı
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray6
    }
    
    var body: some View {
        TabView {
            HomeView(goals: $goals)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Hedefler")
                }
            
            AnalyticsView(goals: $goals)
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Analiz")
                }
        }
        .accentColor(.blue) // Seçili sekme rengi
        .onAppear {
            if let decodedGoals = try? JSONDecoder().decode([Goal].self, from: goalsData) {
                goals = decodedGoals
            }
        }
        .onChange(of: goals) { _, newValue in
            if let encoded = try? JSONEncoder().encode(newValue) {
                goalsData = encoded
            }
        }
    }
}

// --- 5. ANALİZ SAYFASI (YENİ VE RENKLİ) ---
struct AnalyticsView: View {
    @Binding var goals: [Goal]
    
    var totalSaved: Double { goals.reduce(0) { $0 + $1.currentAmount } }
    var totalTarget: Double { goals.reduce(0) { $0 + $1.targetAmount } }
    var progress: Double { totalTarget > 0 ? totalSaved / totalTarget : 0 }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // 1. ÜST KART: GENEL DURUM
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.pastelBlue, Color.pastelPurple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: Color.pastelPurple.opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            HStack(spacing: 20) {
                                // Halka Grafik
                                ZStack {
                                    Circle().stroke(Color.white.opacity(0.3), lineWidth: 15)
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                                        .stroke(Color.white, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                                        .rotationEffect(Angle(degrees: 270.0))
                                        .animation(.spring(), value: progress)
                                    
                                    Text("%\(Int(progress * 100))")
                                        .font(.title).bold().foregroundColor(.white)
                                }
                                .frame(width: 100, height: 100)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Genel Durum").font(.headline).foregroundColor(.white.opacity(0.8))
                                    Text("\(totalSaved.formattedWithDot()) ₺")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Hedef: \(totalTarget.formattedWithDot()) ₺")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                Spacer()
                            }
                            .padding(25)
                        }
                        .frame(height: 180)
                        .padding(.horizontal)
                        
                        // 2. KAYDIRILABİLİR HEDEF KARTLARI
                        VStack(alignment: .leading) {
                            Text("Hedef Detayları").font(.title3).bold().padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(goals) { goal in
                                        GoalAnalyticsCard(goal: goal)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                        }
                        
                        // 3. MOTİVASYON KARTI
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.orange).font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text("Harika Gidiyorsun!").font(.headline)
                                Text("Toplam \(goals.filter{$0.isCompleted}.count) hedef tamamladın.").font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Analizler")
        }
    }
}

// Analiz Sayfası İçin Özel Kart
struct GoalAnalyticsCard: View {
    let goal: Goal
    var progress: Double { goal.targetAmount > 0 ? goal.currentAmount / goal.targetAmount : 0 }
    
    // Rastgele pastel renk seçimi için basit bir mantık
    var cardColor: Color {
        let colors: [Color] = [.pastelPink, .pastelGreen, .pastelOrange, .pastelYellow, .pastelBlue]
        // İsmin uzunluğuna göre renk seçelim ki her seferinde değişmesin
        let index = goal.title.count % colors.count
        return colors[index]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(goal.icon).font(.largeTitle)
                Spacer()
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
            }
            
            Text(goal.title)
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.black.opacity(0.7))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(goal.currentAmount.formattedWithDot()) ₺").font(.title3).bold().foregroundColor(.black)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule().frame(width: geometry.size.width, height: 8).opacity(0.2).foregroundColor(.black)
                        Capsule().frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 8)
                            .foregroundColor(.black.opacity(0.6))
                    }
                }.frame(height: 8)
                
                HStack {
                    Text("%\(Int(progress * 100))").font(.caption).bold()
                    Spacer()
                    Text(goal.bankName).font(.caption2).padding(4).background(Color.white.opacity(0.5)).cornerRadius(4)
                }.foregroundColor(.black.opacity(0.6))
            }
        }
        .padding()
        .frame(width: 180, height: 200)
        .background(cardColor)
        .cornerRadius(20)
        .shadow(color: cardColor.opacity(0.5), radius: 8, x: 0, y: 5)
    }
}

// --- 6. ESKİ LİSTE GÖRÜNÜMÜ (HOMEVIEW OLARAK AYARLANDI) ---
struct HomeView: View {
    @Binding var goals: [Goal]
    @State private var showingAddGoalSheet = false
    @State private var editMode: EditMode = .inactive
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                if goals.isEmpty {
                    VStack(spacing: 15) {
                        Text("🎯").font(.system(size: 80))
                        Text("Henüz hedefin yok!").font(.title2).bold()
                        Text("İlk hedefini ekle ve\nhangi bankada biriktirdiğini seç.").multilineTextAlignment(.center).foregroundColor(.gray)
                        Button(action: { showingAddGoalSheet = true }) {
                            Text("Yeni Hedef Ekle").bold().foregroundColor(.white).padding().background(Color.blue).cornerRadius(12)
                        }.padding(.top, 10)
                    }
                } else {
                    List {
                        Section(header: Text("Devam Eden Hedefler").font(.headline).foregroundColor(.gray)) {
                            ForEach($goals) { $goal in
                                if !goal.isCompleted {
                                    ZStack {
                                        GoalCard(goal: $goal, impactMed: impactMed)
                                        NavigationLink(destination: GoalDetailView(goal: $goal, onDelete: { goals.removeAll { $0.id == goal.id } })) { EmptyView() }.opacity(0)
                                    }
                                    .listRowSeparator(.hidden).listRowBackground(Color.clear).listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                }
                            }
                            .onMove(perform: move)
                        }
                        if goals.contains(where: { $0.isCompleted }) {
                            Section(header: Text("🎉 Tamamlananlar").font(.headline).foregroundColor(.green)) {
                                ForEach($goals) { $goal in
                                    if goal.isCompleted {
                                        ZStack {
                                            GoalCard(goal: $goal, impactMed: impactMed)
                                            NavigationLink(destination: GoalDetailView(goal: $goal, onDelete: { goals.removeAll { $0.id == goal.id } })) { EmptyView() }.opacity(0)
                                        }
                                        .listRowSeparator(.hidden).listRowBackground(Color.clear).listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .environment(\.editMode, $editMode)
                }
            }
            .navigationTitle("Closer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { if !goals.isEmpty { Button(action: { withAnimation { editMode = editMode.isEditing ? .inactive : .active } }) { Text(editMode.isEditing ? "Bitti" : "Düzenle").bold() } } }
                ToolbarItem(placement: .navigationBarTrailing) { Button(action: { showingAddGoalSheet = true }) { Image(systemName: "plus.circle.fill").font(.title2) }.disabled(editMode.isEditing) }
            }
            .sheet(isPresented: $showingAddGoalSheet) { AddGoalView(goals: $goals, isShowing: $showingAddGoalSheet) }
        }
    }
    func move(from source: IndexSet, to destination: Int) { goals.move(fromOffsets: source, toOffset: destination) }
}

// --- 7. DİĞER EKRANLAR VE YARDIMCILAR (AYNI KALDI) ---

// (GoalDetailView, EditGoalView, AddGoalView, GoalCard kodları tamamen aynı şekilde aşağıya eklenmelidir.
// Kodun bütünlüğü bozulmasın diye buraya hepsini ekliyorum.)

struct GoalDetailView: View {
    @Binding var goal: Goal
    var onDelete: () -> Void
    @State private var customAmount: String = ""
    @State private var showingEditSheet = false
    @Environment(\.presentationMode) var presentationMode
    
    var appData: FinancialApp? { supportedApps.first(where: { $0.name == goal.bankName }) }
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Text(goal.icon).font(.system(size: 80))
                        Text(goal.title).font(.largeTitle).bold().multilineTextAlignment(.center)
                        if goal.isCompleted {
                            HStack { Image(systemName: "checkmark.seal.fill"); Text("HEDEF TAMAMLANDI") }
                                .font(.headline).foregroundColor(.green).padding(.horizontal, 20).padding(.vertical, 10).background(Color.green.opacity(0.15)).cornerRadius(20).padding(.top, 5)
                        }
                    }
                    if let app = appData, !app.name.isEmpty, app.name != "Seçilmedi" {
                        if !app.directLink.isEmpty, let url = URL(string: app.directLink) {
                            Link(destination: url) { HStack { Image(systemName: "arrow.up.forward.app.fill"); Text("\(app.name) Uygulamasını Aç") }.font(.headline).foregroundColor(.white).padding().frame(maxWidth: .infinity).background(Color.blue.opacity(0.8)).cornerRadius(15).shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3) }
                        } else {
                            Button(action: { tryOpenBankApp(app: app) }) { HStack { Image(systemName: "building.columns.fill"); Text("\(app.name) Uygulamasını Aç"); Image(systemName: "arrow.up.right.square.fill") }.font(.headline).foregroundColor(.white).padding().frame(maxWidth: .infinity).background(Color.gray).cornerRadius(15) }
                        }
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 5) { Text("Başlangıç").font(.caption).foregroundColor(.gray); Text(goal.startDate.toTurkishDate()).font(.subheadline).bold() }
                        Spacer()
                        if !goal.isCompleted { VStack(spacing: 5) { Text("KALAN SÜRE").font(.caption).foregroundColor(.gray); Text("\(daysRemaining()) Gün").font(.title3).bold().foregroundColor(.blue) }; Spacer() }
                        VStack(alignment: .trailing, spacing: 5) { Text("Hedef Tarih").font(.caption).foregroundColor(.gray); Text(goal.targetDate.toTurkishDate()).font(.subheadline).bold() }
                    }.padding().background(Color.white).cornerRadius(15)
                    VStack(spacing: 10) {
                        Text("Mevcut Birikim").font(.subheadline).foregroundColor(.gray)
                        Text("\(goal.currentAmount.formattedWithDot()) ₺").font(.system(size: 40, weight: .heavy)).contentTransition(.numericText())
                        ProgressView(value: min(goal.currentAmount / goal.targetAmount, 1.0)).progressViewStyle(LinearProgressViewStyle(tint: .blue)).scaleEffect(x: 1, y: 2, anchor: .center).padding(.top, 10)
                        Text("Hedef: \(goal.targetAmount.formattedWithDot()) ₺").font(.caption).foregroundColor(.gray)
                    }.padding().background(Color.white).cornerRadius(20)
                    if !goal.link.isEmpty, let url = URL(string: goal.link) { Link(destination: url) { HStack { Image(systemName: "safari"); Text("İlana / Ürüne Git") }.font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.black).cornerRadius(15) } }
                    if !goal.isCompleted {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Özel İşlem").font(.headline)
                            TextField("Miktar Girin (₺)", text: $customAmount).keyboardType(.numberPad).padding().background(Color(.systemGray5)).cornerRadius(10)
                                .onChange(of: customAmount) { _, newValue in customAmount = FormatHelper.formatInput(newValue) }
                            HStack(spacing: 15) {
                                Button(action: { updateAmount(isAdding: false) }) { Text("- Çıkar").bold().frame(maxWidth: .infinity).padding().background(Color.red.opacity(0.1)).foregroundColor(.red).cornerRadius(10) }
                                Button(action: { updateAmount(isAdding: true) }) { Text("+ Ekle").bold().frame(maxWidth: .infinity).padding().background(Color.green.opacity(0.1)).foregroundColor(.green).cornerRadius(10) }
                            }
                        }.padding().background(Color.white).cornerRadius(20)
                    }
                }.padding()
            }
        }
        .navigationTitle("Detaylar").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Düzenle") { showingEditSheet = true } } }
        .sheet(isPresented: $showingEditSheet) { EditGoalView(goal: $goal, isShowing: $showingEditSheet, onDelete: { presentationMode.wrappedValue.dismiss(); onDelete() }) }
    }
    func tryOpenBankApp(app: FinancialApp) {
        var opened = false
        for scheme in app.schemes { if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url); opened = true; break } }
        if !opened { let encodedQuery = app.searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""; let searchURLString = "itms-apps://search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?term=\(encodedQuery)"; if let searchURL = URL(string: searchURLString) { UIApplication.shared.open(searchURL) } }
    }
    func updateAmount(isAdding: Bool) {
        let cleanAmount = Double(customAmount.replacingOccurrences(of: ".", with: "")) ?? 0
        if cleanAmount > 0 { withAnimation(.spring()) { if isAdding { goal.currentAmount = min(goal.targetAmount, goal.currentAmount + cleanAmount) } else { goal.currentAmount = max(0, goal.currentAmount - cleanAmount) } }; customAmount = "" }
    }
    func daysRemaining() -> Int { let calendar = Calendar.current; let components = calendar.dateComponents([.day], from: Date(), to: goal.targetDate); return max(0, components.day ?? 0) }
}

struct EditGoalView: View {
    @Binding var goal: Goal
    @Binding var isShowing: Bool
    var onDelete: () -> Void
    @State private var title = ""; @State private var icon = ""; @State private var currentAmount = ""; @State private var targetAmount = ""; @State private var link = ""; @State private var startDate = Date(); @State private var targetDate = Date(); @State private var themeName = "Beyaz"
    @State private var selectedBank = "Seçilmedi"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hedef Bilgileri")) {
                    TextField("Hedefin Adı", text: $title)
                    TextField("Simge (Emoji)", text: $icon)
                    VStack(alignment: .leading) { Text("Mevcut Birikim (₺)").font(.caption).foregroundColor(.gray); TextField("0", text: $currentAmount).keyboardType(.numberPad).onChange(of: currentAmount) { _, newValue in currentAmount = FormatHelper.formatInput(newValue) } }
                    VStack(alignment: .leading) { Text("Hedef Miktar (₺)").font(.caption).foregroundColor(.gray); TextField("0", text: $targetAmount).keyboardType(.numberPad).onChange(of: targetAmount) { _, newValue in targetAmount = FormatHelper.formatInput(newValue) } }
                }
                Section(header: Text("Para Nerede Birikiyor?")) {
                    Picker("Banka / Platform", selection: $selectedBank) { ForEach(supportedApps, id: \.self) { app in Text(app.name).tag(app.name) } }.pickerStyle(MenuPickerStyle())
                }
                Section(header: Text("Renk Teması")) { ScrollView(.horizontal, showsIndicators: false) { HStack(spacing: 15) { ForEach(availableThemes) { theme in Circle().fill(theme.color).frame(width: 40, height: 40).overlay(Circle().stroke(themeName == theme.name ? Color.gray : Color.gray.opacity(0.3), lineWidth: themeName == theme.name ? 3 : 1)).onTapGesture { withAnimation { themeName = theme.name } } } }.padding(.vertical, 5) } }
                Section(header: Text("Zaman Planı")) { DatePicker("Başlangıç", selection: $startDate, displayedComponents: .date); DatePicker("Bitiş", selection: $targetDate, in: startDate..., displayedComponents: .date) }
                Section(header: Text("İlham & Bağlantı")) { TextField("https://...", text: $link).keyboardType(.URL).autocapitalization(.none) }
                Section { Button(role: .destructive, action: { isShowing = false; onDelete() }) { HStack { Spacer(); Text("Hedefi Sil").bold(); Spacer() } } }
            }
            .navigationTitle("Düzenle").navigationBarTitleDisplayMode(.inline).environment(\.locale, Locale(identifier: "tr_TR"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("İptal") { isShowing = false } }
                ToolbarItem(placement: .navigationBarTrailing) { Button("Kaydet") { let cleanTarget = Double(targetAmount.replacingOccurrences(of: ".", with: "")) ?? 0; let cleanCurrent = Double(currentAmount.replacingOccurrences(of: ".", with: "")) ?? 0; if cleanTarget > 0 && !title.isEmpty { goal.title = title; goal.icon = icon; goal.currentAmount = cleanCurrent; goal.targetAmount = cleanTarget; goal.link = link; goal.startDate = startDate; goal.targetDate = targetDate; goal.colorTheme = themeName; goal.bankName = selectedBank; isShowing = false } }.bold() }
            }
            .onAppear { title = goal.title; icon = goal.icon; currentAmount = goal.currentAmount.formattedWithDot(); targetAmount = goal.targetAmount.formattedWithDot(); link = goal.link; startDate = goal.startDate; targetDate = goal.targetDate; themeName = goal.colorTheme; selectedBank = goal.bankName }
        }
    }
}

struct AddGoalView: View {
    @Binding var goals: [Goal]
    @Binding var isShowing: Bool
    @State private var title = ""; @State private var icon = "🎯"; @State private var targetAmount = ""; @State private var link = ""; @State private var startDate = Date(); @State private var targetDate = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date(); @State private var themeName = "Beyaz"
    @State private var selectedBank = "Seçilmedi"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hedef Bilgileri")) { TextField("Hedefin Adı", text: $title); TextField("Simge (Emoji)", text: $icon); TextField("Hedef Miktar (₺)", text: $targetAmount).keyboardType(.numberPad).onChange(of: targetAmount) { _, newValue in targetAmount = FormatHelper.formatInput(newValue) } }
                Section(header: Text("Para Nerede Birikecek?")) { Picker("Banka / Platform", selection: $selectedBank) { ForEach(supportedApps, id: \.self) { app in Text(app.name).tag(app.name) } }.pickerStyle(MenuPickerStyle()) }
                Section(header: Text("Renk Teması")) { ScrollView(.horizontal, showsIndicators: false) { HStack(spacing: 15) { ForEach(availableThemes) { theme in Circle().fill(theme.color).frame(width: 40, height: 40).overlay(Circle().stroke(themeName == theme.name ? Color.gray : Color.gray.opacity(0.3), lineWidth: themeName == theme.name ? 3 : 1)).onTapGesture { withAnimation { themeName = theme.name } } } }.padding(.vertical, 5) } }
                Section(header: Text("Zaman Planı")) { DatePicker("Başlangıç", selection: $startDate, displayedComponents: .date); DatePicker("Bitiş", selection: $targetDate, in: startDate..., displayedComponents: .date) }
                Section(header: Text("İlham & Bağlantı")) { TextField("https://...", text: $link).keyboardType(.URL).autocapitalization(.none) }
            }
            .navigationTitle("Yeni Hedef").navigationBarTitleDisplayMode(.inline).environment(\.locale, Locale(identifier: "tr_TR"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("İptal") { isShowing = false } }
                ToolbarItem(placement: .navigationBarTrailing) { Button("Kaydet") { let cleanTarget = Double(targetAmount.replacingOccurrences(of: ".", with: "")) ?? 0; if cleanTarget > 0 && !title.isEmpty { goals.append(Goal(title: title, icon: icon, currentAmount: 0, targetAmount: cleanTarget, link: link, startDate: startDate, targetDate: targetDate, colorTheme: themeName, bankName: selectedBank)); isShowing = false } }.bold() }
            }
        }
    }
}

struct GoalCard: View {
    @Binding var goal: Goal
    let impactMed: UIImpactFeedbackGenerator
    var theme: ThemeColor { getColorForTheme(goal.colorTheme) }
    var remainingAmount: Double { return goal.targetAmount - goal.currentAmount }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack { Text(goal.icon).font(.largeTitle); Text(goal.title).font(.title3).bold(); Spacer() }
            HStack { Text("\(goal.currentAmount.formattedWithDot()) ₺").font(.title2).fontWeight(.bold).contentTransition(.numericText()); Spacer(); Text("Hedef: \(goal.targetAmount.formattedWithDot()) ₺").font(.subheadline).foregroundColor(.black.opacity(0.6)) }
            ProgressView(value: min(goal.currentAmount / goal.targetAmount, 1.0)).progressViewStyle(LinearProgressViewStyle(tint: theme.accentColor)).scaleEffect(x: 1, y: 2, anchor: .center)
            if remainingAmount > 0 {
                Button(action: { impactMed.impactOccurred(); withAnimation(.spring()) { if remainingAmount <= 500 { goal.currentAmount = goal.targetAmount } else { goal.currentAmount += 500 } } }) {
                    ZStack { RoundedRectangle(cornerRadius: 12).fill(theme.accentColor.opacity(0.3)).offset(y: 4); RoundedRectangle(cornerRadius: 12).fill(Color.white); Text(remainingAmount <= 500 ? "Hedefi Tamamla 🚀" : "+500₺ Ekle").font(.subheadline).bold().foregroundColor(theme.name == "Beyaz" ? .blue : theme.accentColor) }.frame(height: 44).frame(maxWidth: .infinity)
                }.buttonStyle(BorderlessButtonStyle()).padding(.bottom, 4)
            } else { HStack { Spacer(); Image(systemName: "checkmark.seal.fill"); Text("Tamamlandı!").bold(); Spacer() }.font(.subheadline).foregroundColor(.green).padding(10).background(Color.green.opacity(0.1)).cornerRadius(10) }
        }.padding().background(theme.color).cornerRadius(15).shadow(color: theme.accentColor.opacity(0.1), radius: 5, x: 0, y: 2).foregroundColor(.black)
    }
}

struct FormatHelper { static func formatInput(_ text: String) -> String { let filtered = text.filter { "0123456789".contains($0) }; if let number = Int(filtered) { let formatter = NumberFormatter(); formatter.numberStyle = .decimal; formatter.groupingSeparator = "."; return formatter.string(from: NSNumber(value: number)) ?? "" }; return "" } }
extension Double { func formattedWithDot() -> String { let formatter = NumberFormatter(); formatter.numberStyle = .decimal; formatter.groupingSeparator = "."; formatter.maximumFractionDigits = 0; return formatter.string(from: NSNumber(value: self)) ?? "0" } }
extension Date { func toTurkishDate() -> String { let formatter = DateFormatter(); formatter.locale = Locale(identifier: "tr_TR"); formatter.dateFormat = "d MMM yyyy"; return formatter.string(from: self) } }
struct BorderlessButtonStyle: ButtonStyle { func makeBody(configuration: Configuration) -> some View { configuration.label } }

#Preview { ContentView() }
