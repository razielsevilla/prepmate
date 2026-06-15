# PrepMate 🥦
### Prep Smart, Waste Less.

PrepMate is an offline-first mobile application that helps individuals, students, and households eliminate food waste through intelligent pantry tracking and AI-powered meal prep planning. It works with how people actually shop — across supermarkets, local markets, and sari-sari stores — and builds a personalized weekly prep plan around what they already have.

---

## Table of Contents

1. [The Problem](#the-problem)
2. [The Solution](#the-solution)
3. [Who It's For](#who-its-for)
4. [What Makes It Different](#what-makes-it-different)
5. [Core Features](#core-features)
6. [App Outputs](#app-outputs)
7. [Technical Architecture](#technical-architecture)
8. [Tech Stack](#tech-stack)
9. [On-Device Logic](#on-device-logic)
10. [Offline-First Design](#offline-first-design)
11. [Project Structure](#project-structure)
12. [Roadmap](#roadmap)

---

## The Problem

Food waste is a persistent household issue — not because people are careless, but because managing a pantry across multiple shopping sources is genuinely hard. In many Philippine households, groceries come from a mix of supermarkets (with receipts), palengkes, and sari-sari stores (with nothing). Items get forgotten, expiry dates go unnoticed, and by the time someone decides what to cook for the week, half the ingredients are already spoiled.

At the same time, meal prepping has grown as a practice among students and young professionals who want to eat well without thinking about it every day. But most meal planning tools assume you start from a recipe and go buy ingredients. No one accounts for what's already sitting in your ref.

The result: food gets wasted, money is lost, and the effort of planning meals from scratch every week burns people out.

---

## The Solution

PrepMate flips the meal planning model.

Instead of starting from recipes and shopping lists, it starts from **what you already have**. Users log their pantry — however they shop — and the app builds a smart weekly meal prep plan that prioritizes expiring ingredients, minimizes cooking complexity through batching, and tracks waste over time to help users shop smarter.

It runs fully offline, so it works regardless of internet access. When a connection is available, it silently upgrades with higher-accuracy OCR and richer AI-generated recipe suggestions.

---

## Who It's For

| User Type | Pain Point Addressed |
|---|---|
| Students living independently | No structure for weekly meals; ingredients expire unnoticed |
| Young professionals | Want to meal prep but don't know where to start |
| Households with elderly members | Need gentle routines and waste reduction without complexity |
| General Filipino households | Shop across supermarkets, palengkes, and sari-sari stores with no unified tracking |

---

## What Makes It Different

Most pantry and meal planning apps have one of these limitations:

- They require internet to function
- They only support barcode or receipt scanning (ignoring informal market purchases)
- They start from recipes, not from what you already have
- They don't integrate expiry urgency into meal planning

PrepMate addresses all four. It is **input-flexible**, **expiry-driven**, **prep-oriented**, and **offline-first by default**.

---

## Core Features

### 1. Multi-Modal Pantry Logging
Users can add items through multiple input methods of equal standing, designed to match how Filipinos actually shop — not just at supermarkets:

- **Receipt OCR** — photograph a supermarket receipt; on-device text recognition extracts item names, quantities, and purchase dates, then passes the raw strings through a Fuzzy Match Normalization Pipeline before committing to the pantry (see [On-Device Logic](#on-device-logic))
- **Barcode Scanning** — scan packaged goods to auto-populate item details
- **Voice Input + Quick-Tap Templates** — long-press the mic and say "Bought chicken, garlic, and sitaw" for palengke and sari-sari runs; common local ingredients are also available as quick-tap icons for even faster entry

All inputs are routed through the **Inbox Staging Area** — a temporary holding zone where newly added items appear unassigned. Users then sort each item into a storage zone (Fridge, Freezer, or Dry Pantry) with a single swipe before it is committed to the main inventory. This keeps data entry frictionless without sacrificing the storage context the expiry engine depends on.

### 2. Expiry Intelligence
- Each pantry item's spoilage risk is calculated by an **on-device Expiry Engine** powered by a localized shelf-life matrix, dynamically calculating real-time degradation metrics based on storage zone and item type (e.g., Leafy Greens in a Dry Pantry = 2 days; in a Refrigerator = 5 days)
- The matrix is stored as a lookup table in SQLite and queried via a simple `JOIN` against the pantry inventory — no neural network required
- Color-coded urgency indicators: **Use Today** (red) / **Use This Week** (amber) / **Safe** (green)
- Push notifications alert users before items expire

### 3. AI Meal Prep Planner
- Users select how many days they want to prep for (e.g., a 5-day workweek)
- The planner generates a weekly prep schedule that:
  - Prioritizes ingredients with the highest spoilage risk
  - Groups ingredients for batch cooking (e.g., cook all proteins together)
  - Specifies what to refrigerate vs. freeze
  - Estimates prep time per session
- Recipes are suggested from a bundled local database, with richer AI-generated alternatives available when online

### 4. Waste Tracker
- Users log items that were discarded
- The app surfaces weekly insights: most wasted categories, estimated cost of waste, and trend over time
- Gamification layer: weekly waste reduction score with progress over time
- Long-term patterns inform smarter shopping suggestions (e.g., "You consistently waste spinach — consider buying less")

### 5. Batch Consumption Tracking
- Prepped meals can be logged as "Batches" (e.g., 5 portions of Chicken Adobo)
- Batch portions can be decremented with a single tap as they are consumed
- Cooked batches automatically apply a 3-to-4 day expiry window to track cooked food spoilage

### 6. Smart Shopping List (Bonus)
- After generating a meal prep plan, the app identifies ingredient gaps
- Outputs a shopping list for what still needs to be purchased, grouped by store type (supermarket vs. market)

---

## App Outputs

| Output | Description |
|---|---|
| **Pantry Inventory View** | Live list of all items with expiry urgency indicators |
| **Batch Inventory View** | Live list of cooked meal batches and remaining portions |
| **Weekly Meal Prep Plan** | Day-by-day prep schedule built around expiring ingredients |
| **Recipe Cards** | Step-by-step instructions per meal with ingredient quantities |
| **Expiry Alerts** | Push notifications and in-app warnings before spoilage |
| **Waste Insights Dashboard** | Analytics on weekly waste score, patterns, and savings |
| **Shopping List** | Auto-generated gap list from meal plan vs. current pantry |

---

## Technical Architecture

PrepMate follows an **offline-first architecture** with optional cloud enhancement. All core functionality is available without an internet connection. Cloud services are used to improve accuracy and richness when connectivity is present.

```
┌─────────────────────────────────────────────────────────────┐
│                        MOBILE CLIENT                        │
│                                                             │
│  ┌──────────────┐  ┌───────────────┐  ┌───────────────┐    │
│  │  Pantry UI   │  │  Prep Planner │  │   Insights    │    │
│  └──────┬───────┘  └──────┬────────┘  └──────┬────────┘    │
│         │                 │                  │             │
│  ┌──────▼─────────────────▼──────────────────▼──────────┐  │
│  │                Local Database (SQLite / Drift)        │  │
│  │  • Pantry & Batch inventory  • Shelf-life matrix      │  │
│  │  • Grocery item dictionary   • Recipe schemas (JSON)  │  │
│  └──────────────────────────┬───────────────────────────┘  │
│                             │                              │
│  ┌──────────────────────────▼───────────────────────────┐  │
│  │              On-Device Logic Layer                    │  │
│  │  • ML Kit OCR → Fuzzy Match Normalization Pipeline   │  │
│  │  • ML Kit Barcode Scanning                           │  │
│  │  • Expiry Engine (shelf-life matrix JOIN query)      │  │
│  │  • Constraint-based Meal Prep Planner (Dart)         │  │
│  │  • Inbox Staging Area (swipe-to-sort)                │  │
│  └──────────────────────────┬───────────────────────────┘  │
└─────────────────────────────┼───────────────────────────────┘
                              │ (when online)
┌─────────────────────────────▼───────────────────────────────┐
│                    CLOUD LAYER (Optional)                    │
│  • High-accuracy receipt OCR fallback (Cloud Vision API)    │
│  • Natural language meal instructions (Gemini Flash)        │
│  • Data sync & backup (FastAPI + PostgreSQL)                │
└─────────────────────────────────────────────────────────────┘
```

---

## Tech Stack

### Mobile App
| Layer | Technology | Reason |
|---|---|---|
| Framework | **Flutter** | Single codebase for Android & iOS; strong plugin ecosystem |
| Local Database | **SQLite (via Drift)** | Relational joins power expiry lookups, recipe matching, and gap analysis natively at the DB layer |
| State Management | **Riverpod** | Scalable and testable state architecture |
| Navigation | **Go Router** | Declarative routing for Flutter |

### On-Device Logic
| Feature | Technology |
|---|---|
| Receipt OCR | **Google ML Kit Text Recognition** |
| Fuzzy Match Normalization | **Levenshtein Distance** matching against a pre-seeded local grocery dictionary |
| Barcode Scanning | **Google ML Kit Barcode Scanning** |
| Expiry Engine | **SQLite JOIN query** against shelf-life matrix lookup table |
| Meal Plan Logic | Constraint-based engine (Dart) |
| Recipe Schemas | Bundled local JSON database |

### Backend (Cloud Enhancement)
| Layer | Technology | Reason |
|---|---|---|
| API Server | **FastAPI (Python)** | Lightweight, async, great ecosystem |
| Enhanced OCR | **Google Cloud Vision API** | Higher accuracy for complex or low-quality receipts |
| Recipe Generation | **Gemini Flash** | Natural language meal instructions wrapping structured planner output |
| Database | **PostgreSQL** | For synced user data when online |
| Hosting | **Railway** or **Render** | Simple deployment for MVP |

### Deterministic Data Layer
| Component | Stack |
|---|---|
| Shelf-life matrix | Pre-seeded SQLite table (category × storage zone → days remaining) |
| Grocery item dictionary | Pre-seeded SQLite lookup table for Fuzzy Match normalization |
| Receipt text cleanup | Levenshtein Distance (string_similarity Dart package or custom implementation) |
| Recipe recommendation | Constraint-based ingredient overlap matching against bundled JSON schemas |

---

## On-Device Logic

### Expiry Engine (Shelf-Life Matrix)
Food spoilage is highly predictable by category and storage zone. Rather than a trained ML model, PrepMate uses a pre-seeded **shelf-life lookup table** stored in SQLite. When a user assigns an item to a storage zone via the Inbox Staging Area, the expiry engine fires a `JOIN` query that returns the estimated days remaining and urgency label instantly.

**Example matrix rows:**

| Category | Storage Zone | Days Remaining |
|---|---|---|
| Leafy Greens | Dry Pantry | 2 |
| Leafy Greens | Refrigerator | 5 |
| Raw Chicken | Refrigerator | 2 |
| Raw Chicken | Freezer | 90 |
| Canned Goods | Dry Pantry | 730 |

This approach eliminates binary size overhead, battery drain, and model maintenance associated with a TFLite classifier — for a problem where deterministic rules are equally accurate.

### Fuzzy Match Normalization Pipeline
When on-device OCR extracts raw text from a receipt (e.g., `SMO BLU 500M`), the string is not committed to the pantry directly. It passes through a **Levenshtein Distance matching function** that compares the raw string against a pre-seeded dictionary of common local grocery items and returns the closest match above a confidence threshold.

```
Raw OCR string:  "SMO BLU 500M"
Dictionary match: "Selecta Blue Vanilla Ice Cream, 500mL"  (score: 0.87)
→ Staged in Inbox for user confirmation before committing
```

Items that fall below the confidence threshold are flagged for manual correction in the Inbox Staging Area rather than silently committed with wrong data.

### Meal Prep Constraint Planner
A deterministic engine written in Dart that:
1. Ranks pantry items by spoilage urgency (from the expiry engine)
2. Groups items into batch-cookable clusters (proteins, carbohydrates, vegetables)
3. Runs a constraint set intersection against local JSON recipe schemas to find compatible meals
4. Maps clusters to meal slots across the target prep days
5. Outputs a structured prep schedule

When online, Gemini Flash wraps this structured output into natural language cooking instructions and step-by-step recipes.

### Waste Pattern Analysis
Time-series aggregation on user-logged waste events stored in SQLite. Surfaces trends by category and week, and feeds back into shopping suggestions over time.

---

## Offline-First Design

PrepMate is designed to be fully functional without internet access. The offline-first principle is applied as follows:

| Capability | Offline | Online Enhancement |
|---|---|---|
| Pantry logging (voice, barcode, manual) | ✅ Full | — |
| Receipt OCR + Fuzzy Match normalization | ✅ Basic (ML Kit + Levenshtein) | ⬆️ Higher accuracy (Cloud Vision) |
| Expiry prediction (shelf-life matrix) | ✅ Full (SQLite JOIN) | — |
| Meal prep plan generation | ✅ Full (constraint engine) | ⬆️ Natural language recipes (Gemini Flash) |
| Waste tracking & insights | ✅ Full | — |
| Data backup & sync | ❌ Not available | ✅ When connected |

Data is stored locally first. Sync to the cloud backend occurs opportunistically when a connection is available, using a last-write-wins conflict resolution strategy for MVP simplicity.

---

## Project Structure

```
prepmate/
├── mobile/                  # Flutter app
│   ├── lib/
│   │   ├── features/
│   │   │   ├── pantry/      # Inventory management + Inbox Staging Area
│   │   │   ├── batches/     # Batch consumption tracking
│   │   │   ├── planner/     # Meal prep constraint engine
│   │   │   ├── scanner/     # OCR, barcode, fuzzy match pipeline
│   │   │   ├── insights/    # Waste tracker & analytics
│   │   │   └── shopping/    # Shopping list output
│   │   ├── core/
│   │   │   ├── db/          # Drift schema: pantry, shelf-life matrix, item dictionary
│   │   │   ├── services/    # Expiry engine, fuzzy matcher, planner logic
│   │   │   └── state/       # Riverpod providers
│   │   └── main.dart
│   └── assets/
│       └── recipes/         # Bundled recipe schemas (JSON)
│
└── backend/                 # FastAPI server (cloud enhancement)
    ├── app/
    │   ├── routes/          # OCR fallback, Gemini recipe, sync endpoints
    │   └── db/              # PostgreSQL models & queries
    └── requirements.txt
```

---

## Roadmap

| Phase | Milestone | Status |
|---|---|---|
| **Phase 1** | Pantry logging (manual + barcode), SQLite schema, shelf-life matrix seeding | 🔲 Planned |
| **Phase 2** | Expiry engine (JOIN query), urgency indicators, push notifications | 🔲 Planned |
| **Phase 3** | Inbox Staging Area (voice input, quick-tap templates, swipe-to-sort) | 🔲 Planned |
| **Phase 4** | Receipt OCR + Fuzzy Match Normalization Pipeline | 🔲 Planned |
| **Phase 5** | Constraint-based meal prep planner + bundled recipe JSON schemas | 🔲 Planned |
| **Phase 6** | Batch consumption tracking + cooked food expiry | 🔲 Planned |
| **Phase 7** | Waste tracker, insights dashboard, shopping list output | 🔲 Planned |
| **Phase 8** | Cloud sync, Gemini Flash recipe generation, user accounts | 🔲 Planned |

---

## License

This project is developed as an academic capstone project. License to be determined upon completion.

---

*PrepMate — because the best meal plan starts with what's already in your kitchen.*
