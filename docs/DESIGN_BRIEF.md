# Admin App — Design Brief for Claude Design

**App:** `expert_support_admin` (Flutter)
**Audience:** Admins, Supervisors, Technicians (three role views in one app)
**Platforms:** iOS 14+ / Android 8+ + tablet optimized
**Direction:** Arabic RTL primary, English LTR secondary
**Paste into Claude Design** to generate the full visual design for this app.

---

## 1. Brand (shared with customer app)

**Name:** مساندة (Mosandah) · Experts Support
**Tone:** operational, authoritative, data-rich — but still warm. This is the back-office, so information density matters more than playfulness.

### Palette
| Role | Hex |
|------|------|
| Plum (primary) | `#5B2C4D` |
| Plum dark | `#3E1E35` |
| Plum light | `#7A3E69` |
| Gold (accent) | `#D9A91F` |
| Gold light | `#F5C940` |
| Cream (surface) | `#FBF6EE` |
| Ink (text) | `#2B2020` |
| Ink-dark (admin headers) | `#1F1616` |
| Success / Danger / Warn / Info | `#2E9E5F` / `#D13C3C` / `#E8A33A` / `#3A6FB0` |

**Admin-specific note:** admin headers use **ink-dark** (`#1F1616`) instead of plum — conveys "back-office" vs the customer plum. Gold highlights remain.

**Dark mode:** Cream → `#1A1216`, Ink → `#F5EEE5`. Never pure black on surfaces.

### Typography
- Arabic: IBM Plex Sans Arabic — 400 / 500 / 600 / 700
- Latin: Inter
- **Tabular nums everywhere** — this is a data-heavy app
- Headings: letter-spacing -0.015em

### Scales
- **Type:** 11 / 12 / 14 / 16 / 20 / 24 / 32
- **Spacing:** 4 / 8 / 12 / 16 / 24 / 32
- **Radius:** 8 / 12 / 16 / 22 / 999
- **Motion:** 160ms (press) / 240ms (state) / 420ms (screen)
- **Easings:** spring `cubic-bezier(.34,1.56,.64,1)`, smooth `cubic-bezier(.22,.61,.36,1)`

### Logo
Hexagonal honeycomb cluster — gold center + plum outer. RTL lockup.

---

## 2. Personas (this app only)

**P3 — Ahmad, 29, technician.** Arabic-speaking, basic English. Needs clear job details, easy navigation, customer ETA. Can't see customer phone numbers.

**P4 — Sara, 38, supervisor.** Dispatches jobs, resolves escalations. Needs overview of all active jobs + quick re-assign.

**P5 — Khalid, 45, admin.** Manages services, pricing, areas, staff. Needs BI + PDF export + revenue tracking.

---

## 3. Role-based information architecture

One app, three role views selected at sign-in:

```
Admin login (email + password)
 └─ ROLE ROUTER
     ├─ ADMIN VIEW
     │   ├─ Dashboard (KPIs, rating distribution, revenue sparkline)
     │   ├─ Customers (search, filter, detail, suspend/activate)
     │   ├─ Orders (filter by status, re-assign, cancel)
     │   ├─ Technicians (list, schedule, rating, active jobs)
     │   ├─ Services (CRUD, pricing, capacity rules)
     │   ├─ Contracts (list, create, export-all PDF)
     │   ├─ Offers & Coupons (CRUD, mutex rules)
     │   ├─ Service Areas (map-based radius)
     │   └─ Reports (revenue, completion rate, CSAT)
     ├─ SUPERVISOR VIEW
     │   ├─ Home (incoming queue, filters)
     │   ├─ Incoming orders (accept/reject + auto-matching hints)
     │   ├─ Assign flow (3 recommended technicians + override + ETA)
     │   ├─ Live tracking (all jobs map, filter by area/tech)
     │   └─ Completion review (approve/send-back)
     └─ TECHNICIAN VIEW
         ├─ Home (today's jobs, earnings, rating, availability toggle)
         ├─ New orders (accept with 60s countdown or decline)
         ├─ Job detail (customer name — phone hidden, location, scope)
         ├─ On-site (start → photos → complete)
         └─ Earnings history
```

---

## 4. Screens to design (24 screens)

### 4.0 Admin sign-in
Ink-dark background with gold hex-logo. Email input + password. "تذكرني" checkbox. "تسجيل الدخول" CTA. Forgot-password link. Footer: "لوحة الإدارة · Admin Panel v1.0.7".

### ADMIN VIEW

#### 4.1 Dashboard (flagship)
- Header: ink-dark, "لوحة الإدارة", notification bell with badge
- **KPI grid 2×2**, each card:
  - Colored top border accent (plum / gold / success / warn)
  - Label (10px UPPERCASE, tracked +0.5px)
  - Value (22/700, **animated count-up over 900ms ease-out-cubic**)
  - Trend indicator ↑ 12% (green) or ↓ 3 (red)
  - Inline SVG sparkline 100×30, stroke 2px
- KPIs: طلبات اليوم / مكتملة / قيد التنفيذ / إيراد اليوم (ر.س)
- **Rating distribution card:** 5 horizontal bars ★5 → ★1 with gold fill by %, percentage on right
- **Admin nav grid 2×4** below: Customers / Orders / Technicians / Services / Contracts / Offers / Areas / Reports. Each tile: soft background, icon chip 40px, Arabic label 14/500.

#### 4.2 Customers
Search input (🔍 بحث عن عميل...). Filter chips row: الكل / نشط / قطاع أعمال / موقوف. Customer rows:
- Top row: name (left) + status chip (right, with colored dot)
- Meta row: phone (partially masked) · order count
- Tap → customer detail

#### 4.3 Customer detail
Avatar + name header. Tabs: الطلبات / العقود / ملاحظات / الإعدادات. Stat cards: total orders / avg rating given / total spent / member since. Actions: تعليق الحساب (destructive), حظر, تحرير.

#### 4.4 Orders (all)
Filter chips row: الكل / جديد / قيد التعيين / قيد التنفيذ / مكتمل / ملغي (each with count badge).
Order rows:
- Top: service name + customer + status chip
- ID: `#MSD-001 • الآن` (tabular, muted)
- Right-border color accent by status

#### 4.5 Order detail (admin)
Header with order ID + status chip. Map (120px) with customer + tech pins.
**Full timeline** (same timeline component as customer but with admin annotations + technician change log).
Cards: customer info, technician info, service breakdown, payment status, cancellation log.
Actions: إعادة تعيين / إلغاء / استرداد / تعديل.

#### 4.6 Technicians
Grid 2×2 cards each: avatar, name, rating (⭐ 4.9), specialty chip, status (متاح / مشغول / غير متصل — with colored dot), current jobs count.

#### 4.7 Technician detail
Header: avatar + name + rating + specialty.
Availability toggle. Stats: completed jobs / avg rating / attendance % / earnings this month.
**Performance chart:** 30-day ratings line chart.
Tabs: الطلبات الحالية / السجل / الوثائق / التقييمات.

#### 4.8 Services management
List of service categories with CRUD. Each row: service icon + name + sub-services count + active/inactive toggle + price range + edit button.
FAB: + خدمة جديدة.

#### 4.9 Service edit (wizard)
Fields: name (ar/en), category, description, price, duration estimate, capacity (max concurrent jobs), required tech specialties, service areas, images upload.

#### 4.10 Contracts (admin)
Same as customer contracts list but with creator admin name, total contract value, and admin-only actions: approve, suspend, edit, regenerate PDF, export all as zip.

#### 4.11 Offers & Coupons
Two tabs: العروض / الكوبونات.
Offers list: title, discount %, active period, applicable services, usage count, toggle active/inactive.
Coupons list: code (monospace), discount, expires, max uses, used count.
**Mutex banner:** "⚠️ العروض والكوبونات لا يمكن الجمع بينهما — عند تفعيل أحدهما يُلغى الآخر تلقائياً".

#### 4.12 Service areas
Full-screen map with drawn polygons (plum translucent fill). Legend on right listing areas with toggle + tech count per area. FAB: + منطقة. Draw-polygon tool + radius-circle tool.

#### 4.13 Reports
Date range picker top. 4 large KPI cards (revenue / orders / completion rate / CSAT) with trend comparisons. **Revenue chart** (30-day area chart). **Service breakdown** donut (which services earn most). **Top technicians** leaderboard. Export PDF button gold.

### SUPERVISOR VIEW

#### 4.14 Supervisor home
Header with "الإشراف" + notification bell.
**Queue card at top:** "8 طلبات جديدة بانتظار التعيين" with gold accent + "ابدأ" CTA.
Stats row: today's assigned / active now / completed today.
Filter chips by area: كل المناطق / الروضة / الصفا / السلامة... (each with count).
**Incoming orders list** — compact cards, tap to assign.

#### 4.15 Incoming order (assign flow)
Map (200px) with customer pin.
Customer card: name, service, time requested, preferred window.
**"Recommended technicians"** — 3 tech cards ranked by score:
- Avatar + name + rating
- Distance from customer ("2.3 كم")
- ETA to arrival ("18 د")
- Current load ("2 طلبات نشطة")
- "اختر" CTA on each
Override: "فني آخر" link opens full list.
After pick → "تأكيد التعيين" confirmation sheet.

#### 4.16 Supervisor live tracking
Full-screen map showing all active jobs as pins (color by status). Filter pills: الكل / قيد التنفيذ / في الطريق / تأخر. Side panel (collapsible) lists active jobs with mini cards. Tap pin → tooltip with quick actions (message tech, re-assign).

#### 4.17 Completion review
Job cards awaiting supervisor approval. Each shows: final photos grid, tech notes, customer signature, price breakdown. Actions: موافقة (green) / إعادة (yellow with reason) / تصعيد (red).

### TECHNICIAN VIEW

#### 4.18 Tech home
Header: "مرحباً أحمد" + availability toggle (prominent gold switch: "متاح / غير متاح").
Earnings card: today / this week / this month (tabular).
Rating card: current rating ⭐ 4.9, "120+ خدمة هذا الشهر".
**Today's jobs list** — compact cards with time + service + address + status.

#### 4.19 New order request (incoming)
Full-screen takeover. Customer name (phone HIDDEN). Service + sub-services. Location map + address. Estimated price share. **60-second countdown** on accept button: "قبول (58ث)". Decline button (ghost, red text).

#### 4.20 Job detail (tech)
Customer name + avatar (phone hidden). Map with directions deep-link. Service checklist. Estimated duration. Materials list. "بدأت العمل" primary CTA.

#### 4.21 On-site work
Status indicator: "أنت في موقع العمل". Checklist of tasks to mark complete. Photo upload (before / during / after). Timer showing duration. "إنهاء العمل" button (disabled until checklist complete).

#### 4.22 Job complete
Summary: tasks done, duration, photos attached. Customer signature capture. Tech notes textarea. "إرسال للمراجعة" CTA → sent to supervisor review → success screen.

#### 4.23 Earnings history
Date picker. Earnings chart (30-day bars). Payouts list with status (paid / pending / next payout date).

#### 4.24 Tech profile
Avatar (editable). Name, ID, specialty chips, rating, stats. Documents section (ID, license, certifications — each with expiry warning). Contact support button. Logout.

---

## 5. Admin-specific components

Beyond the shared library, admin app needs:

- **Data table** (sortable columns, pagination, row actions)
- **KPI card** with sparkline SVG + animated count-up + trend indicator
- **Sparkline** (inline SVG, 100×30, single-path)
- **Line chart** (30-day area chart for reports)
- **Donut chart** (service breakdown)
- **Horizontal bar chart** (rating distribution, leaderboard)
- **Map with polygons** (service areas drawing tool)
- **Map with pins** (supervisor live tracking)
- **Countdown button** (tech new-order accept with visible timer)
- **Draw tools** (polygon, circle-radius for areas)
- **Availability toggle** (large gold switch)
- **Photo uploader** (drag/drop + preview grid + compress)
- **Signature pad**
- **Action sheet** (confirm destructive actions with reason input)
- **Filter panel** (multi-chip row with count badges)
- **Date range picker**

---

## 6. Motion specs (hero moments)

| Moment | Duration | Easing | What animates |
|--------|----------|--------|---------------|
| KPI count-up | 900ms | ease-out-cubic | Numbers tick up from 0 to target |
| Assign tech | 500ms | spring | Selected tech card scales + glows, confirmation sheet rises |
| Accept countdown | every 1s | linear | Countdown number decrements, progress ring depletes |
| Map pin pulse | 2s loop | ease-in-out | Active pins gently scale 1.0 → 1.15 |
| Chart reveal | 800ms | ease-out | Bars/lines draw from origin |
| Role switch | 320ms | smooth | Cross-fade + theme accent shift |

**Respect `prefers-reduced-motion: reduce` — collapse to 10ms.**

---

## 7. Accessibility

- All icon-only controls have Arabic `aria-label`
- 48dp minimum tap targets
- Focus-visible 3px blue halo on keyboard nav
- Data tables support arrow-key cell navigation
- Charts have text alternatives (screen-reader summaries)
- Status chips pair color with dot prefix
- Contrast ≥ 4.5:1 body text, ≥ 3:1 large, both modes
- Destructive actions require 2-step confirm with typed reason

---

## 8. Business rules shaping UI

- **Assign flow:** must pick from top 3 or explicitly override
- **Tech accept:** 60s countdown → auto-decline → next tech
- **Supervisor approval:** required before order closes (business rule 2.6)
- **Mutex offers/coupons:** enforced in offer editor with warning
- **Area coverage:** if customer outside any area, block order creation
- **Tech privacy:** customer phone NEVER shown to tech (masked as `[رقم محجوب]`)
- **Admin cancel:** always allowed but requires reason + notifies customer
- **PDF export:** all contracts + monthly invoices + reports exportable

---

## 9. Copy samples (Arabic)

- Titles: "لوحة الإدارة" / "الإشراف" / "طلباتي اليوم"
- Actions: "تعيين" / "إعادة التعيين" / "موافقة" / "إعادة" / "تصعيد" / "تعليق الحساب"
- Status: "قيد التعيين" / "في الطريق" / "قيد التنفيذ" / "مكتمل" / "متأخر"
- Empty: "لا توجد طلبات جديدة — استمتع بفنجان قهوة ☕"
- Warnings: "⚠️ هذه العملية لا يمكن التراجع عنها" / "🔒 رقم العميل محجوب لأسباب الخصوصية"

---

## 10. Anti-patterns

- ❌ Customer phone numbers visible to tech
- ❌ Destructive actions without confirm
- ❌ Charts without text alt
- ❌ Data tables without keyboard nav
- ❌ Pure black surfaces
- ❌ Dense tables on phone (use cards instead, tables on tablet only)
- ❌ Loading spinners (use skeleton rows)
- ❌ Arbitrary data refresh cadences (always pull-to-refresh + live socket where possible)

---

## 11. Deliverables expected

1. All 24 unique screens designed (light + dark for top 8)
2. Component library sheet including data-table, chart set, signature pad, photo uploader
3. Role switch / sign-in flow prototype
4. Motion spec for the 6 hero moments in Section 6
5. Accessibility overlay for 3 flagship screens (dashboard, assign, tech new-order)
6. Tablet optimization for admin dashboard + supervisor live tracking (split-panel layouts)

Aspect: 2x (780×1688 phone, 1536×2048 tablet) with device chrome.

File naming: `admin-[role]-[screen]-[mode].png` (e.g., `admin-admin-dashboard-light.png`, `admin-tech-new-order.png`).

---

## 12. Claude Design prompts (ready to paste)

**Full admin app sweep:**
> Using the Mosandah brand (plum #5B2C4D, gold #D9A91F, ink-dark #1F1616 admin headers, IBM Plex Sans Arabic, RTL, hexagonal logo), design the 24-screen **admin app** covering Admin / Supervisor / Technician roles as specified in Section 4 of this brief. Include tablet layouts for dashboard + supervisor live tracking. Data-dense but warm.

**Admin dashboard only:**
> Design the Mosandah admin **dashboard** (Section 4.1). 390×844 phone + 1536×2048 tablet. KPI grid with animated count-up numbers, sparklines, rating distribution bars, 2×4 admin nav grid. Show realistic data for a Saudi home-services app. Light + dark.

**Supervisor assign flow:**
> Design the Mosandah supervisor **assign flow** (Section 4.15). Show the 3 recommended technicians ranked by ETA + distance + load. Include the confirmation sheet on pick. Arabic RTL.

**Technician accept countdown:**
> Design the Mosandah technician **new-order request** screen (Section 4.19) with 60-second countdown on the accept button. Customer phone must be hidden/masked. Show the state at t=58s and t=5s.

**Data components:**
> Produce the admin-specific component library: data-table (sortable, paginated), KPI card with sparkline, line chart, donut chart, horizontal bar chart, map-with-polygons (area drawing), availability toggle, countdown button, photo uploader, signature pad. All states + RTL.

---

## 13. Reference files in this repo

- Working prototype: `../mosandah_prototype.html` (admin + supervisor + tech views included)
- Customer app brief: `../export_support_customer/docs/DESIGN_BRIEF.md`
- Product spec: `../full_project_spec.docx`
- Flow logic: `../New Text Document.txt`
- Contract requirements: `../experts_support_contract2006-4.pdf`
- Yammak UX comparison: `../yammak_comparison.md`
