#!/usr/bin/env python3
"""UI/UX Pro Max - Design Intelligence Search Tool"""
import sys, json, argparse, re

# ── EMBEDDED DESIGN DATABASE ──────────────────────────────────────────────────

STYLES = [
    {"name":"Glassmorphism","keywords":["glass","blur","transparent","modern","saas","fintech"],"effects":"backdrop-filter:blur(20px);background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.2)","radius":"16-24px","shadows":"0 8px 32px rgba(0,0,0,0.12)"},
    {"name":"Neumorphism","keywords":["soft","3d","subtle","light","pastel"],"effects":"box-shadow: 6px 6px 12px #b8b8b8, -6px -6px 12px #ffffff","radius":"12-20px","shadows":"dual soft shadow"},
    {"name":"Flat Minimal","keywords":["minimal","clean","simple","saas","tool","productivity"],"effects":"no shadows, solid borders","radius":"8-12px","shadows":"none or 0 1px 3px rgba(0,0,0,0.1)"},
    {"name":"Dark Premium","keywords":["dark","luxury","premium","crypto","gaming","entertainment"],"effects":"gradient accents, glow effects","radius":"12-16px","shadows":"0 0 40px rgba(accent,0.3)"},
    {"name":"Warm Earthy","keywords":["warm","natural","gold","luxury","jewelry","food","wellness"],"effects":"warm tones, cream backgrounds","radius":"16-20px","shadows":"0 4px 24px rgba(brown,0.15)"},
    {"name":"Clay/3D","keywords":["playful","fun","kids","gaming","mobile","app","colorful"],"effects":"inflated 3D look, pastel colors","radius":"20-30px","shadows":"0 20px 60px rgba(0,0,0,0.15), inset 0 -4px 0 rgba(0,0,0,0.1)"},
    {"name":"Brutalism","keywords":["bold","editorial","creative","portfolio","fashion"],"effects":"thick borders, high contrast","radius":"0-4px","shadows":"4px 4px 0 #000"},
    {"name":"Skeuomorphic","keywords":["realistic","texture","craft","vintage","food","beverage"],"effects":"textures, gradients, realistic materials","radius":"varies","shadows":"complex multi-layer"},
    {"name":"Frosted Glass","keywords":["ios","apple","mobile","dashboard","overlay"],"effects":"backdrop-filter:saturate(180%) blur(20px)","radius":"14-20px","shadows":"0 2px 20px rgba(0,0,0,0.1)"},
    {"name":"Gradient Mesh","keywords":["vibrant","creative","ai","tech","startup","saas"],"effects":"mesh gradients, aurora","radius":"16px","shadows":"colored shadows matching gradient"},
]

COLORS = [
    {"name":"Gold Luxury","palette":["#b8922a","#d4a83c","#f0c84a","#fdf6ed","#1a0f04"],"keywords":["gold","luxury","jewelry","premium","warm"],"usage":"jewelry, gold price, luxury goods"},
    {"name":"Ocean Blue","palette":["#0ea5e9","#0284c7","#075985","#f0f9ff","#0c4a6e"],"keywords":["blue","tech","saas","fintech","trust","medical"],"usage":"tech, finance, healthcare"},
    {"name":"Forest Green","palette":["#16a34a","#15803d","#14532d","#f0fdf4","#052e16"],"keywords":["green","nature","health","organic","growth"],"usage":"health, organic, sustainability"},
    {"name":"Sunset Coral","palette":["#f97316","#ea580c","#c2410c","#fff7ed","#7c2d12"],"keywords":["orange","energy","food","sport","fun"],"usage":"food delivery, fitness, entertainment"},
    {"name":"Royal Purple","palette":["#9333ea","#7c3aed","#6d28d9","#faf5ff","#3b0764"],"keywords":["purple","creative","beauty","ai","premium"],"usage":"beauty, AI products, creative tools"},
    {"name":"Slate Minimal","palette":["#64748b","#475569","#334155","#f8fafc","#0f172a"],"keywords":["gray","minimal","corporate","tool","productivity"],"usage":"productivity tools, B2B, SaaS"},
    {"name":"Rose Gold","palette":["#f43f5e","#e11d48","#9f1239","#fff1f2","#4c0519"],"keywords":["pink","rose","fashion","beauty","feminine"],"usage":"fashion, beauty, lifestyle"},
    {"name":"Dark Midnight","palette":["#1e293b","#0f172a","#020617","#334155","#94a3b8"],"keywords":["dark","night","gaming","crypto","premium"],"usage":"gaming, crypto, premium dark mode"},
    {"name":"Warm Cream","palette":["#fdf6ed","#f5ede0","#ede0cc","#b8922a","#1a0f04"],"keywords":["cream","warm","natural","cozy","arabic","gulf"],"usage":"Arabic sites, gold markets, warm brands"},
    {"name":"Electric Neon","palette":["#06b6d4","#0891b2","#0e7490","#083344","#ecfeff"],"keywords":["neon","cyber","tech","gaming","ai","modern"],"usage":"AI, tech, cybersecurity, gaming"},
]

FONTS = [
    {"heading":"Playfair Display","body":"Source Serif 4","keywords":["luxury","editorial","elegant","serif"],"style":"classic editorial"},
    {"heading":"Inter","body":"Inter","keywords":["minimal","saas","tech","clean","modern","tool"],"style":"system-like modern"},
    {"heading":"Almarai","body":"Almarai","keywords":["arabic","gulf","rtl","arabic-ui"],"style":"Arabic premium"},
    {"heading":"Montserrat","body":"Open Sans","keywords":["corporate","brand","professional","clean"],"style":"corporate friendly"},
    {"heading":"Space Grotesk","body":"DM Sans","keywords":["startup","tech","modern","saas","bold"],"style":"modern tech startup"},
    {"heading":"Cormorant Garamond","body":"Lato","keywords":["luxury","fashion","elegant","refined"],"style":"high-fashion elegant"},
    {"heading":"Plus Jakarta Sans","body":"Plus Jakarta Sans","keywords":["fintech","dashboard","data","professional"],"style":"modern fintech"},
    {"heading":"Nunito","body":"Nunito","keywords":["friendly","app","mobile","rounded","playful"],"style":"friendly rounded"},
    {"heading":"Bebas Neue","body":"Roboto","keywords":["bold","sport","gym","impact","gaming"],"style":"bold impact"},
    {"heading":"Noto Sans Arabic","body":"Noto Sans Arabic","keywords":["arabic","multilingual","rtl","international"],"style":"Arabic multi-language"},
]

PRODUCTS = [
    {"type":"Gold Price Tracker","style":"Warm Earthy","color":"Gold Luxury","font":"Almarai","keywords":["gold","price","currency","financial","arabic","gulf","jewelry"],"patterns":["live ticker","price grid","calculator modal","weekly table","TradingView chart"]},
    {"type":"SaaS Dashboard","style":"Flat Minimal","color":"Ocean Blue","font":"Inter","keywords":["saas","dashboard","analytics","admin","b2b"],"patterns":["sidebar nav","data cards","charts","data tables","filters"]},
    {"type":"E-commerce","style":"Flat Minimal","color":"Slate Minimal","font":"Montserrat","keywords":["shop","store","product","cart","buy","ecommerce"],"patterns":["product grid","filters","cart","checkout","reviews"]},
    {"type":"Fintech App","style":"Dark Premium","color":"Dark Midnight","font":"Plus Jakarta Sans","keywords":["crypto","finance","wallet","banking","investment"],"patterns":["balance card","transaction list","chart","quick actions"]},
    {"type":"Beauty/Wellness","style":"Warm Earthy","color":"Rose Gold","font":"Cormorant Garamond","keywords":["beauty","spa","wellness","skincare","luxury"],"patterns":["hero product","testimonials","booking","gallery"]},
    {"type":"Food/Restaurant","style":"Flat Minimal","color":"Sunset Coral","font":"Nunito","keywords":["food","restaurant","delivery","menu","cafe"],"patterns":["menu grid","hero image","order flow","map"]},
    {"type":"Portfolio/Creative","style":"Brutalism","color":"Slate Minimal","font":"Space Grotesk","keywords":["portfolio","creative","designer","agency","art"],"patterns":["full-screen hero","project grid","about","contact"]},
    {"type":"Health/Medical","style":"Flat Minimal","color":"Forest Green","font":"Inter","keywords":["health","medical","clinic","doctor","fitness"],"patterns":["appointment booking","stats cards","progress tracking"]},
    {"type":"AI/Tech Product","style":"Gradient Mesh","color":"Electric Neon","font":"Space Grotesk","keywords":["ai","ml","tech","saas","tool","automation"],"patterns":["hero with demo","features grid","pricing","waitlist"]},
    {"type":"Entertainment/Gaming","style":"Dark Premium","color":"Electric Neon","font":"Bebas Neue","keywords":["game","entertainment","streaming","music","video"],"patterns":["content grid","hero banner","social proof","dark theme"]},
]

UX_RULES = {
    "accessibility":["Contrast 4.5:1 for normal text","Visible focus rings 2-4px","Descriptive alt text","aria-label on icon-only buttons","Tab order matches visual order","label with for attribute","Skip to main content link","Sequential h1→h6 heading hierarchy","Support prefers-reduced-motion","Don't rely on color alone to convey info"],
    "touch":["Min 44×44pt touch target","8px gap between touch targets","Use click/tap not hover-only","Disable button during async, show spinner","cursor: pointer on clickable elements","touch-action: manipulation to reduce 300ms delay","Visual feedback within 100ms of tap"],
    "performance":["Use WebP/AVIF for images","Declare width/height to prevent CLS","font-display: swap to avoid FOIT","Lazy load below-fold images","Code splitting by route","Skeleton screens for >300ms loads","Keep input latency <100ms","Debounce scroll/resize/input handlers"],
    "layout":["Mobile-first breakpoints: 375/768/1024/1440","Min 16px body text on mobile","No horizontal scroll on mobile","8dp spacing system","max-w-6xl container on desktop","min-h-dvh not 100vh","Respect safe areas (notch/gesture bar)"],
    "typography":["Line-height 1.5-1.75 for body","65-75 chars per line max","Semantic type scale: 12 14 16 18 24 32","Bold headings (600-700), Regular body (400)","Tabular figures for prices/numbers","Min 16px on mobile to prevent iOS zoom"],
    "animation":["Duration 150-300ms for micro-interactions","Use transform/opacity only (not width/height)","ease-out entering, ease-in exiting","Respect prefers-reduced-motion","Animations must be interruptible","Scale 0.95-1.05 on press for cards"],
    "forms":["Visible label per input (not placeholder-only)","Error below related field","Required field asterisk","Loading then success/error on submit","Validate on blur not keystroke","Semantic input types (email, tel, number)","Auto-focus first invalid field on error"],
    "navigation":["Bottom nav max 5 items","Predictable back behavior","Both icon + label in nav items","Active state visually highlighted","Modals must have clear close/dismiss","Search reachable from top bar"],
    "charts":["Match chart type to data (trend→line, compare→bar)","Always show legend near chart","Tooltips on hover/tap with exact values","Label axes with units","Skeleton while loading","Accessible colors (not red/green only)","Min 44pt tap area on chart elements"],
    "loading":["Skeleton/shimmer for >300ms","Never block UI during animation","Progressive loading not blocking spinner","Show error with retry on failure","Progress indicator for multi-step"],
}

CHART_TYPES = [
    {"type":"Line Chart","use":"Trends over time, price movement","keywords":["trend","time","price","history","stock","gold"]},
    {"type":"Bar Chart","use":"Comparison between categories","keywords":["compare","category","rank","sales","bar"]},
    {"type":"Donut Chart","use":"Proportions (max 5 categories)","keywords":["proportion","percentage","share","pie","donut"]},
    {"type":"Area Chart","use":"Volume trends with emphasis on quantity","keywords":["area","volume","cumulative","range"]},
    {"type":"Candlestick","use":"Financial OHLC price data","keywords":["ohlc","stock","crypto","financial","candlestick","trading"]},
    {"type":"Sparkline","use":"Compact trend in small space","keywords":["mini","compact","inline","sparkline","ticker"]},
    {"type":"Heatmap","use":"Density / frequency over 2D grid","keywords":["density","frequency","calendar","heatmap"]},
    {"type":"Gauge/Radial","use":"Single metric vs target","keywords":["gauge","progress","meter","kpi","target"]},
    {"type":"Table","use":"Detailed data with sorting/filtering","keywords":["table","data","list","sort","filter","compare"]},
    {"type":"Scatter Plot","use":"Correlation between two variables","keywords":["correlation","scatter","relationship","distribution"]},
]

# ── SEARCH ENGINE ─────────────────────────────────────────────────────────────

def score(item_keywords, query_words):
    item_kw = " ".join(item_keywords).lower()
    return sum(1 for w in query_words if w in item_kw)

def search_domain(query, domain, n=5):
    words = query.lower().split()
    results = []

    db_map = {
        "style": STYLES,
        "color": COLORS,
        "typography": FONTS,
        "product": PRODUCTS,
        "chart": CHART_TYPES,
        "ux": [(k, v) for k, v in UX_RULES.items()],
    }

    if domain not in db_map:
        return [f"Unknown domain: {domain}. Use: style, color, typography, product, chart, ux"]

    db = db_map[domain]

    if domain == "ux":
        for cat, rules in db:
            s = score([cat] + [r.lower() for r in rules], words)
            results.append((s, cat, rules))
        results.sort(key=lambda x: -x[0])
        out = []
        for s, cat, rules in results[:n]:
            out.append(f"\n{'═'*50}")
            out.append(f"  {cat.upper()} RULES")
            out.append(f"{'═'*50}")
            for r in rules:
                out.append(f"  ✓ {r}")
        return out

    for item in db:
        kws = item.get("keywords", [])
        s = score(kws, words)
        results.append((s, item))

    results.sort(key=lambda x: -x[0])
    out = []
    for s, item in results[:n]:
        out.append(f"\n{'─'*50}")
        if domain == "style":
            out.append(f"  🎨 {item['name']}")
            out.append(f"  Effects : {item['effects']}")
            out.append(f"  Radius  : {item['radius']}")
            out.append(f"  Shadows : {item['shadows']}")
        elif domain == "color":
            palette_str = "  ".join(item['palette'])
            out.append(f"  🎨 {item['name']}")
            out.append(f"  Palette : {palette_str}")
            out.append(f"  Usage   : {item['usage']}")
        elif domain == "typography":
            out.append(f"  🔤 {item['heading']} / {item['body']}")
            out.append(f"  Style   : {item['style']}")
        elif domain == "product":
            out.append(f"  📦 {item['type']}")
            out.append(f"  Style   : {item['style']}")
            out.append(f"  Color   : {item['color']}")
            out.append(f"  Font    : {item['font']}")
            out.append(f"  Patterns: {', '.join(item['patterns'])}")
        elif domain == "chart":
            out.append(f"  📊 {item['type']}")
            out.append(f"  Use For : {item['use']}")
    return out

def design_system(query, project=""):
    words = query.lower().split()

    # Find best product match
    prod_scores = [(score(p["keywords"], words), p) for p in PRODUCTS]
    prod_scores.sort(key=lambda x: -x[0])
    product = prod_scores[0][1]

    # Find matching style
    style_match = next((s for s in STYLES if s["name"] == product["style"]), STYLES[0])

    # Find matching color
    color_match = next((c for c in COLORS if c["name"] == product["color"]), COLORS[0])

    # Find matching font
    font_match = next((f for f in FONTS if f["heading"] == product["font"]), FONTS[1])

    # Find relevant chart
    chart_scores = [(score(c["keywords"], words), c) for c in CHART_TYPES]
    chart_scores.sort(key=lambda x: -x[0])
    chart = chart_scores[0][1]

    title = f" {project} — Design System " if project else " Design System "

    lines = [
        "",
        "╔" + "═"*60 + "╗",
        f"║{title.center(60)}║",
        "╠" + "═"*60 + "╣",
        f"║  📦 PRODUCT TYPE : {product['type']:<38}║",
        f"║  🎨 STYLE        : {style_match['name']:<38}║",
        f"║  🌈 COLOR PALETTE: {color_match['name']:<38}║",
        f"║  🔤 TYPOGRAPHY   : {font_match['heading']} / {font_match['body']:<25}║",
        f"║  📊 CHART TYPE   : {chart['type']:<38}║",
        "╠" + "═"*60 + "╣",
        "║  STYLE EFFECTS                                             ║",
        f"║  {style_match['effects'][:56]:<56}  ║",
        f"║  Radius: {style_match['radius']:<50}║",
        f"║  Shadow: {style_match['shadows'][:50]:<50}║",
        "╠" + "═"*60 + "╣",
        "║  COLOR PALETTE                                             ║",
    ]
    palette_line = "  ".join(color_match["palette"])
    lines.append(f"║  {palette_line:<58}║")
    lines += [
        "╠" + "═"*60 + "╣",
        "║  UI PATTERNS                                               ║",
    ]
    for p in product["patterns"]:
        lines.append(f"║  • {p:<56}║")
    lines += [
        "╠" + "═"*60 + "╣",
        "║  TOP UX RULES (CRITICAL)                                   ║",
        "║  ✓ Contrast ≥4.5:1 for all text                           ║",
        "║  ✓ Touch targets ≥44×44px                                  ║",
        "║  ✓ Skeleton screens for loads >300ms                       ║",
        "║  ✓ Mobile-first, 16px min body text                        ║",
        "║  ✓ No emoji icons — use SVG (Lucide/Heroicons)             ║",
        "║  ✓ Animation 150-300ms, transform/opacity only             ║",
        "╠" + "═"*60 + "╣",
        "║  ANTI-PATTERNS TO AVOID                                    ║",
        "║  ✗ Hover-only interactions (no mobile equivalent)          ║",
        "║  ✗ Animating width/height (use transform)                  ║",
        "║  ✗ Placeholder-only labels on inputs                       ║",
        "║  ✗ Random shadow/radius values                             ║",
        "║  ✗ Color as the only indicator (add icon/text)             ║",
        "╚" + "═"*60 + "╝",
        "",
    ]
    return lines

# ── CLI ───────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="UI/UX Pro Max Design Intelligence")
    parser.add_argument("query", nargs="?", default="", help="Search query")
    parser.add_argument("--design-system", action="store_true", help="Generate full design system")
    parser.add_argument("--domain", default=None, help="Domain: style|color|typography|product|chart|ux")
    parser.add_argument("--stack", default=None, help="Stack: react-native")
    parser.add_argument("-p", "--project", default="", help="Project name")
    parser.add_argument("-n", default=5, type=int, help="Max results")
    parser.add_argument("--persist", action="store_true", help="Save design system to files")
    parser.add_argument("-f", "--format", default="ascii", choices=["ascii","markdown"])
    args = parser.parse_args()

    query = args.query

    if args.design_system:
        lines = design_system(query, args.project)
        print("\n".join(lines))
        if args.persist:
            import os; os.makedirs("design-system/pages", exist_ok=True)
            with open("design-system/MASTER.md", "w") as f:
                f.write("# Design System Master\n\n")
                f.write("\n".join(lines))
            print("✓ Saved to design-system/MASTER.md")
        return

    if args.domain:
        results = search_domain(query, args.domain, args.n)
        print("\n".join(results))
        return

    if args.stack == "react-native":
        print("\n📱 REACT NATIVE BEST PRACTICES")
        print("─"*50)
        for rule in ["Use FlatList/FlashList for lists >20 items",
                     "React.memo + useCallback to prevent rerenders",
                     "expo-image for optimized image loading (WebP)",
                     "react-navigation with native stack for performance",
                     "SafeAreaView on every screen",
                     "Avoid StyleSheet.create in render — define outside",
                     "Use Pressable not TouchableOpacity (React Native 0.63+)",
                     "Reanimated 3 for 60fps animations on UI thread",
                     "expo-haptics for tactile feedback on important actions",
                     "Test on real devices, not just simulator"]:
            print(f"  ✓ {rule}")
        return

    # Default: show help
    print("\n🎨 UI/UX Pro Max — Design Intelligence")
    print("─"*50)
    print("Usage:")
    print('  python3 search.py "gold price tracker" --design-system -p "النقيب"')
    print('  python3 search.py "animation loading" --domain ux')
    print('  python3 search.py "luxury warm" --domain color')
    print('  python3 search.py "minimal serif" --domain typography')
    print('  python3 search.py "trend financial" --domain chart')
    print('  python3 search.py "" --stack react-native')

if __name__ == "__main__":
    main()
