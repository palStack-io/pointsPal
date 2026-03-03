#!/bin/bash
# Run this from /Users/basestation/Documents/Palstacks/pointsPal
# It will create every file and folder needed for the pointsPal repo.
set -e
echo "Creating pointsPal repo structure..."

mkdir -p ".github/ISSUE_TEMPLATE"
cat > '.github/ISSUE_TEMPLATE/new_card.yml' << 'PALSTACK_EOF'
name: "➕ New Card Submission"
description: "Submit a new credit card to the pointPal database. A maintainer will build the JSON from your info."
title: "Add: [Card Name Here]"
labels: ["new-card", "needs-review"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for contributing to pointPal! Fill in what you know — a maintainer will build the JSON and tag you for review before merging.

        **Comfortable with JSON?** [Submit a PR directly](https://github.com/palStack-io/pointPal/compare) using `programs/_template.json` as a starting point — it's faster.

  - type: input
    id: card_name
    attributes:
      label: Card Name
      description: Full official card name
      placeholder: "e.g. Chase Sapphire Preferred"
    validations:
      required: true

  - type: input
    id: issuer
    attributes:
      label: Card Issuer
      placeholder: "e.g. Chase, American Express, Citi"
    validations:
      required: true

  - type: dropdown
    id: network
    attributes:
      label: Card Network
      options:
        - Visa
        - Mastercard
        - Amex
        - Discover
    validations:
      required: true

  - type: dropdown
    id: currency
    attributes:
      label: Reward Currency
      options:
        - Points
        - Miles
        - Cash Back
    validations:
      required: true

  - type: input
    id: annual_fee
    attributes:
      label: Annual Fee
      placeholder: "e.g. 95 or 0 for no fee"
    validations:
      required: true

  - type: textarea
    id: earn_rates
    attributes:
      label: Earn Rates
      description: List all earn multipliers and the categories they apply to
      placeholder: |
        - 5x travel via Chase Travel
        - 3x dining worldwide
        - 3x online groceries (up to $6,000/yr)
        - 1x everything else
    validations:
      required: true

  - type: textarea
    id: caps
    attributes:
      label: Spending Caps (if any)
      description: Any category earn caps — what's the limit and what period does it reset?
      placeholder: |
        - Groceries: 3x up to $6,000/yr then 1x
        - Gas: 5x up to $500/month then 1%
        - None

  - type: textarea
    id: transfer_partners
    attributes:
      label: Transfer Partners (if applicable)
      description: List transfer partners, ratios, and estimated value if known
      placeholder: |
        - World of Hyatt 1:1
        - United MileagePlus 1:1
        - Air Canada Aeroplan 1:1

  - type: input
    id: tpg_cpp
    attributes:
      label: Estimated Point Value (cents per point)
      description: TPG, NerdWallet, or your own estimate
      placeholder: "e.g. 2.05"

  - type: input
    id: source_url
    attributes:
      label: Source URL
      description: Where did you verify the earn rates? Required if setting a cpp value.
      placeholder: "https://thepointsguy.com/..."

  - type: input
    id: recent_change
    attributes:
      label: Recent Issuer Changes (if any)
      description: Has this card changed recently? Restructured earn rates, new fees, etc.
      placeholder: "e.g. Jun 2025: earn rates restructured. 3x travel removed."

  - type: input
    id: contributor
    attributes:
      label: Your GitHub Username
      description: So we can credit you as contributor
      placeholder: "@your-handle"

PALSTACK_EOF

mkdir -p ".github/ISSUE_TEMPLATE"
cat > '.github/ISSUE_TEMPLATE/update_card.yml' << 'PALSTACK_EOF'
name: "🔄 Update Existing Card"
description: "Report outdated earn rates, caps, or valuations for an existing card."
title: "Update: [Card Name Here]"
labels: ["update", "needs-review"]
body:
  - type: markdown
    attributes:
      value: |
        Earn rates change frequently. Thank you for keeping pointPal accurate!

  - type: input
    id: program_id
    attributes:
      label: program_id (filename without .json)
      placeholder: "e.g. chase_sapphire_reserve"
    validations:
      required: true

  - type: dropdown
    id: change_type
    attributes:
      label: What changed?
      multiple: true
      options:
        - Earn rate changed
        - Spending cap changed or added
        - New category added
        - Category removed
        - Annual fee changed
        - Transfer partner added or removed
        - Point value (cpp) changed
        - Card restructured / renamed
        - Other
    validations:
      required: true

  - type: textarea
    id: what_changed
    attributes:
      label: What specifically changed?
      description: Describe the old value and the new value
      placeholder: |
        Old: 3x on all travel purchases
        New: 1x on general travel (parking, transit, vacation rentals). Only 4x on direct flights and hotels, 8x via Chase portal.

        Effective: October 26, 2025
    validations:
      required: true

  - type: input
    id: effective_date
    attributes:
      label: Effective Date
      description: When did the issuer change take effect? (YYYY-MM-DD)
      placeholder: "2025-10-26"

  - type: input
    id: source_url
    attributes:
      label: Source URL
      description: Link verifying the change (issuer announcement, TPG, NerdWallet, etc.)
      placeholder: "https://..."
    validations:
      required: true

  - type: input
    id: contributor
    attributes:
      label: Your GitHub Username
      placeholder: "@your-handle"

PALSTACK_EOF

mkdir -p ".github"
cat > '.github/PULL_REQUEST_TEMPLATE.md' << 'PALSTACK_EOF'
## pointPal PR — Card Submission

### Type
- [ ] ➕ New card
- [ ] 🔄 Update to existing card (earn rates, caps, cpp)
- [ ] 🐛 Fix (incorrect data, typo)
- [ ] 🔧 Infrastructure (scripts, GitHub Actions, README)

### Card(s) Changed
<!-- List the program_id(s) this PR touches -->
- `program_id_here`

### What Changed
<!-- For updates: describe what was wrong and what the correct value is -->

### Source / Citation
<!-- Required for any earn rate or cpp change. Link to issuer page, TPG, NerdWallet, etc. -->
- 

### Issuer Effective Date
<!-- If the issuer made a change, when did it take effect? YYYY-MM-DD -->

---

### PR Checklist

**File basics**
- [ ] `program_id` is snake_case and matches the filename exactly
- [ ] All required fields are present (`program_id`, `program_name`, `issuer`, `network`, `currency_name`, `annual_fee`, `base_cpp`, `data_as_of`, `earn_categories`)
- [ ] `data_as_of` reflects today's date (or the date you verified the data)
- [ ] No template instruction keys (`_note_*`) left in the file

**Earn categories**
- [ ] All `category` values use only approved slugs from [SLUG_REFERENCE.md](./SLUG_REFERENCE.md)
- [ ] Every card has a base `"other"` catch-all category
- [ ] Spending caps have both `cap_amount` AND `cap_period` set
- [ ] `multiplier_fallback` is set for any capped categories

**Sources**
- [ ] `source_url` is populated if `tpg_cpp` is set
- [ ] Source cited in PR description for any earn rate changes

**Community standards**
- [ ] No affiliate links anywhere in the JSON
- [ ] `review_frequency_months` is appropriate (3 for rotating categories, 6 for recent changes, 12 for stable)
- [ ] `contributor` field has my GitHub username

---

*Maintained by the palStack community · [palstack.io](https://palstack.io)*

PALSTACK_EOF

mkdir -p ".github/workflows"
cat > '.github/workflows/compile.yml' << 'PALSTACK_EOF'
name: Compile Programs

on:
  push:
    branches: [main]
    paths:
      - "programs/**.json"
      - "scripts/compile.js"
      - "scripts/validate.js"

jobs:
  compile:
    name: Validate & compile dist/programs.json
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"

      - name: Validate all programs
        run: node scripts/validate.js

      - name: Compile programs.json
        run: node scripts/compile.js

      - name: Commit compiled output
        run: |
          git config user.name  "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add dist/programs.json dist/index.json
          git diff --staged --quiet && echo "No changes to commit" && exit 0
          git commit -m "chore: recompile programs.json [skip ci]"
          git push

      - name: Summary
        run: |
          COUNT=$(node -e "const d=require('./dist/index.json'); console.log(d.count)")
          STALE=$(node -e "const d=require('./dist/index.json'); console.log(d.stale_programs.length)")
          echo "## Compilation Complete" >> $GITHUB_STEP_SUMMARY
          echo "- **$COUNT** programs compiled to \`dist/programs.json\`" >> $GITHUB_STEP_SUMMARY
          if [ "$STALE" -gt "0" ]; then
            echo "- ⚠️ **$STALE** programs are past their review date" >> $GITHUB_STEP_SUMMARY
          fi
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "finPal instances will pick up changes on their next hourly sync." >> $GITHUB_STEP_SUMMARY

PALSTACK_EOF

mkdir -p ".github/workflows"
cat > '.github/workflows/validate.yml' << 'PALSTACK_EOF'
name: Validate Programs

on:
  pull_request:
    paths:
      - "programs/**.json"
      - "scripts/validate.js"

jobs:
  validate:
    name: Validate JSON files
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"

      - name: Get changed files
        id: changed
        uses: tj-actions/changed-files@v41
        with:
          files: "programs/**.json"

      - name: Validate changed program files
        if: steps.changed.outputs.any_changed == 'true'
        run: |
          echo "Changed files:"
          echo "${{ steps.changed.outputs.all_changed_files }}"
          echo ""
          echo "Running validation..."
          node scripts/validate.js

      - name: Post validation summary
        if: always()
        uses: actions/github-script@v7
        with:
          script: |
            const changed = `${{ steps.changed.outputs.all_changed_files }}`.trim();
            const files = changed ? changed.split(' ').filter(f => f.endsWith('.json') && !f.includes('_template')) : [];

            if (files.length === 0) {
              console.log('No program files changed.');
              return;
            }

            const body = [
              '## pointPal Validation',
              '',
              `**${files.length} program file(s) checked:**`,
              ...files.map(f => `- \`${f}\``),
              '',
              'See the workflow logs above for full validation results.',
            ].join('\n');

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body,
            });

PALSTACK_EOF

cat > '.gitignore' << 'PALSTACK_EOF'
node_modules/
.DS_Store
*.log

PALSTACK_EOF

cat > 'CONTRIBUTING.md' << 'PALSTACK_EOF'
# Contributing to pointPal

Thanks for helping keep the database accurate. Earn rates change constantly — the community is what makes this useful.

---

## Three Ways to Contribute

### 1. From finPal (easiest, no GitHub required)
Add your card in finPal → tap **"Share with community"** → finPal pre-fills the JSON and opens a GitHub PR for you. You just need to add your GitHub username and click submit.

### 2. Submit a PR directly
Best if you're comfortable with JSON. See the [Quick Start in the README](./README.md#quick-start-for-contributors).

### 3. File an issue
Not comfortable with JSON? [Open an issue](https://github.com/palStack-io/pointPal/issues/new?template=new_card.yml) and a maintainer will build the JSON from your info.

---

## What to Contribute

### High-value contributions
- **New cards** not yet in the database
- **Cap data** — many cards are missing `cap_amount`/`cap_period` fields
- **Transfer partner cpp estimates** — help other users know what their points are worth
- **Corrections** when an issuer changes earn rates

### Low-value / not needed
- Cards that are closed to new applicants (unless many people still hold them)
- Debit cards, prepaid cards
- Cards with no rewards
- Promotional rates that expire within 30 days

---

## Quality Standards

| Standard | Detail |
|---|---|
| **Cite your sources** | Any earn rate or cpp value needs a `source_url`. Acceptable sources: issuer's own website, TPG, NerdWallet, Bankrate, The Points Guy valuations page |
| **No affiliate links** | `source_url` and `notes` must be free of affiliate tracking parameters |
| **Be conservative on cpp** | Use median values from reputable sources, not best-case theoretical maximums |
| **Date everything** | `data_as_of` must reflect when you actually verified the rates, not when you submitted the PR |
| **One card per PR** | Makes review faster and history cleaner |
| **Use the validator** | Run `npm run validate` before submitting. The GitHub Action will also catch errors, but fixing them locally is faster |

---

## Review Process

1. You submit a PR
2. GitHub Action runs `validate.js` on your changed files — must pass to merge
3. A palStack maintainer reviews for accuracy (spot-checks source, checks caps, verifies cpp is plausible)
4. Merged PRs trigger `compile.js`, which updates `dist/programs.json`
5. finPal instances pick up changes on their next hourly sync

**Target review time: 24 hours.** PRs with cited sources and passing validation are typically merged same-day.

---

## Staleness Policy

Programs whose `data_as_of` is older than `review_frequency_months` are flagged as stale in `dist/index.json`. If you see a stale card, please re-verify and submit a PR updating `data_as_of` (and any rates that have changed).

Stale data doesn't get automatically removed, but finPal shows users a "rates may be outdated" warning for stale programs.

---

## Code of Conduct

- Be accurate, not promotional
- Credit original sources
- Be patient with maintainers — we're a small team
- If you spot a mistake in someone else's PR, comment constructively

---

*Part of the [palStack](https://palstack.io) open-source ecosystem.*

PALSTACK_EOF

cat > 'README.md' << 'PALSTACK_EOF'
# pointPal 🃏

> Community-maintained credit card points & rewards database — part of the [palStack](https://palstack.io) ecosystem.

[![Validate Programs](https://github.com/palStack-io/pointPal/actions/workflows/validate.yml/badge.svg)](https://github.com/palStack-io/pointPal/actions/workflows/validate.yml)
[![Programs](https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/palStack-io/pointPal/main/dist/index.json&query=$.count&label=programs&color=15803d)](https://github.com/palStack-io/pointPal/tree/main/programs)
[![Last Sync](https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/palStack-io/pointPal/main/dist/index.json&query=$.generated_at&label=last%20compiled&color=fbbf24)](https://github.com/palStack-io/pointPal/blob/main/dist/programs.json)

---

## What is this?

**pointPal** is an open-source database of credit card rewards structures — earn rates, spending caps, cap reset periods, and point valuations. It powers the **finPal** card optimizer, which tells users exactly which card to use for each purchase and when to switch cards before hitting a cap.

Anyone can contribute. PRs are reviewed by the palStack team and merged within 24 hours. Every merged PR automatically compiles `dist/programs.json`, which finPal pulls with a single button tap.

---

## Quick Start for Contributors

### Option A — From finPal (easiest)
Add your card in finPal → tap **"Share with community"** → finPal pre-fills a PR and opens GitHub for you.

### Option B — Directly on GitHub

1. [Fork this repo](https://github.com/palStack-io/pointPal/fork)
2. Copy `programs/_template.json` → `programs/your_program_id.json`
3. Fill in all fields (see [Schema Reference](#schema-reference))
4. Run `npm run validate` locally, or let the GitHub Action catch errors
5. Submit a PR — title format: `Add: Card Name` or `Update: Card Name`

### Option C — File an issue
Not comfortable with JSON? [Open an issue](https://github.com/palStack-io/pointPal/issues/new?template=new_card.yml) with the card details and a maintainer will build the JSON.

---

## File Structure

```
pointPal/
├── programs/
│   ├── _template.json              ← Start here
│   ├── chase_sapphire_reserve.json
│   ├── amex_gold.json
│   ├── citi_strata_premier.json
│   └── ...                         ← One file per card
├── dist/
│   ├── programs.json               ← Compiled on every merge (used by finPal)
│   └── index.json                  ← Metadata + counts
├── scripts/
│   ├── validate.js                 ← JSON schema validator
│   └── compile.js                  ← Builds dist/programs.json
├── .github/
│   ├── workflows/
│   │   ├── validate.yml            ← Runs on every PR
│   │   └── compile.yml             ← Runs on every merge to main
│   └── ISSUE_TEMPLATE/
│       ├── new_card.yml            ← Issue template for new cards
│       └── update_card.yml         ← Issue template for updates
├── CONTRIBUTING.md
├── SLUG_REFERENCE.md               ← Approved category slugs
├── schema.json                     ← JSON Schema for validation
└── package.json
```

---

## Schema Reference

Each card lives in `programs/<program_id>.json`. The `program_id` must be unique and match the filename exactly.

### Required Fields

| Field | Type | Description |
|---|---|---|
| `program_id` | `string` | snake_case slug, e.g. `chase_sapphire_reserve`. Must match filename. |
| `program_name` | `string` | Full card name, e.g. `"Chase Sapphire Reserve"` |
| `issuer` | `string` | Bank/issuer, e.g. `"Chase"` |
| `network` | `string` | `"Visa"`, `"Mastercard"`, `"Amex"`, `"Discover"` |
| `currency_name` | `string` | `"Points"`, `"Miles"`, or `"Cash Back"` |
| `annual_fee` | `number` | Annual fee in USD. `0` for no-fee cards. |
| `base_cpp` | `number` | Baseline cents-per-point (cash/statement credit value) |
| `tpg_cpp` | `number` | TPG/NerdWallet estimated max value. Cite source in PR. |
| `data_as_of` | `string` | `YYYY-MM-DD` — date you verified the data |
| `last_updated` | `string` | `YYYY-MM-DD` — date of most recent edit |
| `earn_categories` | `array` | Category earn rates (see below) |

### Optional but Recommended

| Field | Type | Description |
|---|---|---|
| `portal_cpp` | `number` | Value when booking through issuer's portal |
| `has_transfer_fee` | `boolean` | `true` if issuer charges transfer fees (e.g. Amex US airlines) |
| `expiry_policy` | `string` | `"account_closure"`, `"no_expiry"`, `"inactivity_24mo"`, `"varies"` |
| `transfer_partners` | `array` | Transfer partner objects (see below) |
| `welcome_bonus` | `object` | Welcome offer details |
| `issuer_effective_date` | `string` | Date of last known issuer change (`YYYY-MM-DD`) |
| `known_change_event` | `string` | Plain English description of what changed |
| `review_frequency_months` | `number` | How often rates should be re-verified (3/6/12) |
| `notes` | `string` | Any nuances, caveats, or useful context |
| `source_url` | `string` | URL verifying earn rates/cpp values |
| `contributor` | `string` | Your GitHub username |

### `earn_categories` Array

Each item represents one earn rate for one (or all) cards in the program:

```json
{
  "category": "dining",
  "multiplier": 3.0,
  "cap_amount": null,
  "cap_period": null,
  "multiplier_fallback": 1.0,
  "card_variant": null,
  "notes": "Worldwide restaurants"
}
```

| Field | Required | Description |
|---|---|---|
| `category` | ✅ | Approved slug from [SLUG_REFERENCE.md](./SLUG_REFERENCE.md) |
| `multiplier` | ✅ | Points/miles/$1 at the bonus rate |
| `cap_amount` | — | Dollar cap before fallback kicks in. `null` = no cap. |
| `cap_period` | — | `"monthly"`, `"quarterly"`, `"annual"`. `null` if no cap. |
| `multiplier_fallback` | — | Rate after cap is hit. Defaults to `1.0`. |
| `card_variant` | — | Restrict this rate to one card variant (e.g. `"sapphire_reserve"`) |
| `notes` | — | Any restrictions (e.g. "US supermarkets only", "Up to $6k/yr") |

### `transfer_partners` Array

```json
{
  "partner_name": "World of Hyatt",
  "ratio": "1:1",
  "type": "hotel",
  "est_cpp": 1.7,
  "notes": "Best hotel partner"
}
```

### `welcome_bonus` Object

```json
{
  "points": 125000,
  "spend_requirement": 6000,
  "spend_timeframe_months": 3,
  "notes": "Highest public offer as of Mar 2026"
}
```

---

## Approved Category Slugs

Use only slugs from this list in `earn_categories[].category`. Full descriptions in [SLUG_REFERENCE.md](./SLUG_REFERENCE.md).

| Slug | Label |
|---|---|
| `travel_portal` | Travel via issuer portal |
| `flights_direct` | Flights booked direct with airline |
| `hotels_direct` | Hotels booked direct |
| `dining` | Dining / restaurants |
| `groceries` | Groceries / supermarkets |
| `gas` | Gas stations / EV charging |
| `streaming` | Streaming services |
| `transit` | Transit / rideshare / parking |
| `online_shopping` | Online retail / e-commerce |
| `advertising` | Online advertising (business cards) |
| `drugstores` | Drugstores / pharmacies |
| `home_improvement` | Home improvement stores |
| `office_supplies` | Office supplies (business cards) |
| `phone_internet` | Phone / internet / cable (business cards) |
| `fitness` | Gym / fitness clubs |
| `entertainment` | Entertainment / live events |
| `rotating` | Rotating quarterly categories |
| `mobile_wallet` | Mobile wallet (Apple Pay / Google Pay) |
| `rent_mortgage` | Rent / mortgage payments |
| `other` | All other purchases (base rate) |

---

## How finPal Consumes This Repo

1. User taps **"Sync Community Programs"** in finPal
2. finPal calls `GET /api/points/sync`
3. The endpoint fetches `dist/programs.json` from this repo's `main` branch
4. All programs are upserted into finPal's local PostgreSQL database
5. The card optimizer immediately reflects updated earn rates and caps

The sync is rate-limited to once per hour per instance. Self-hosted finPal users can also pin to a specific commit SHA for reproducibility.

---

## Contribution Guidelines

- **Accuracy first.** Always cite a source URL for earn rates and cpp values.
- **No affiliate links** anywhere in the JSON.
- **Keep `data_as_of` current.** Stale data (>review_frequency_months old) gets flagged for community re-verification.
- **One card per PR** for clean review history.
- **Be conservative with `est_cpp`** on transfer partners — use realistic median values, not theoretical maximums.
- **Use `review_frequency_months: 3`** for rotating-category cards (Freedom Flex, Discover it, Citi Custom Cash, US Bank Cash+).

### What NOT to include
- Debit cards or prepaid cards
- Cards no longer open to new applicants (e.g. US Bank Altitude Reserve — closed Nov 2024)
- Authorized-user-only cards
- Cards with no rewards

---

## License

MIT — free to use, fork, and integrate into any project.

Part of the [palStack](https://palstack.io) open-source ecosystem. *"That's what pals do — they show up and help with the everyday stuff."*

PALSTACK_EOF

cat > 'SLUG_REFERENCE.md' << 'PALSTACK_EOF'
# pointPal — Category Slug Reference

Use **only** these slugs in `earn_categories[].category`. Using unlisted slugs will fail validation.

If you need a category that isn't here, [open an issue](https://github.com/palStack-io/pointPal/issues/new) and we'll add it.

---

## Standard Slugs

| Slug | Label | Common Examples |
|---|---|---|
| `travel_portal` | Travel via issuer portal | Flights, hotels, cars booked through Chase Travel, AmexTravel, CitiTravel, Capital One Travel, etc. |
| `flights_direct` | Flights (direct with airline) | Booked on airline.com or by calling the airline |
| `hotels_direct` | Hotels (direct with hotel) | Booked on hilton.com, marriott.com, etc. |
| `dining` | Dining / restaurants | Restaurants, bars, cafes, fast food, eligible delivery services |
| `groceries` | Groceries / supermarkets | Grocery stores and supermarkets. Note restrictions: some cards exclude superstores (Walmart, Target), or restrict to "US" only |
| `gas` | Gas stations / EV charging | Gas stations and EV charging networks |
| `streaming` | Streaming services | Netflix, Hulu, Spotify, Disney+, Apple TV+, etc. |
| `transit` | Transit / rideshare / parking | Public transit, taxis, rideshare (Uber/Lyft), parking, tolls |
| `online_shopping` | Online retail / e-commerce | General online purchases. Some cards restrict to specific retailers. |
| `advertising` | Online advertising | Google Ads, Meta Ads — primarily business cards |
| `drugstores` | Drugstores / pharmacies | CVS, Walgreens, Rite Aid |
| `home_improvement` | Home improvement stores | Home Depot, Lowe's |
| `office_supplies` | Office supply stores | Staples, Office Depot — primarily business cards |
| `phone_internet` | Phone / internet / cable | Cell phone plans, internet service, cable — primarily business cards |
| `fitness` | Gym / fitness clubs | Gyms, fitness studios, Peloton subscriptions |
| `entertainment` | Entertainment / live events | Concert tickets, sports tickets, movies |
| `rotating` | Rotating quarterly categories | Freedom Flex, Discover it — categories change each quarter. Set `notes` to current quarter's categories. |
| `mobile_wallet` | Mobile wallet | Apple Pay, Google Pay, Samsung Pay — used by US Bank Altitude Reserve |
| `rent_mortgage` | Rent / mortgage payments | Bilt cards only |
| `other` | All other purchases | Catch-all base rate. **Every card must have at least one `other` category without a `card_variant` restriction.** |

---

## Notes on Restrictions

When a category has restrictions, document them in the `notes` field of the earn_category object — **not** by creating new slugs.

### Common restrictions to note:
- **Geographic**: `"US supermarkets only"` / `"US gas stations only"`
- **Merchant exclusions**: `"Excludes superstores like Walmart and Target"`
- **Spending caps**: `"Up to $6,000/yr, then 1x"` — also set `cap_amount` and `cap_period`
- **Retailer-specific**: `"US supermarkets as defined by Amex — does not include warehouse clubs"`
- **Timing**: `"6pm–6am ET only"` (Citi Strata Elite dining)

### Example with restrictions:

```json
{
  "category": "groceries",
  "multiplier": 4.0,
  "cap_amount": 25000,
  "cap_period": "annual",
  "multiplier_fallback": 1.0,
  "card_variant": null,
  "notes": "US supermarkets only. Does not include warehouse clubs (Costco, BJ's) or superstores (Walmart, Target). $25k annual cap."
}
```

---

## Requesting New Slugs

If you have a card with a spend category not covered above, [open an issue](https://github.com/palStack-io/pointPal/issues/new?title=New+category+slug+request) with:
- The card and category you're trying to represent
- Why the existing slugs don't cover it
- Suggested slug name (snake_case)

PALSTACK_EOF

mkdir -p "dist"
cat > 'dist/index.json' << 'PALSTACK_EOF'
{
  "generated_at": "2026-03-03T03:19:05.166Z",
  "schema_version": "1.0",
  "count": 73,
  "issuer_counts": {
    "Bank of America": 5,
    "American Express": 18,
    "Apple / Goldman Sachs": 1,
    "Bilt": 2,
    "Capital One": 5,
    "Chase": 21,
    "Barclays": 5,
    "Citi": 8,
    "Discover": 1,
    "US Bank": 4,
    "Wells Fargo": 3
  },
  "program_ids": [
    "alaska_airlines_visa_signature",
    "amex_blue_cash_everyday",
    "amex_blue_cash_preferred",
    "amex_business_gold",
    "amex_business_platinum",
    "amex_gold",
    "amex_green",
    "amex_platinum",
    "apple_card",
    "bilt_mastercard_obsidian",
    "bilt_palladium",
    "blue_business_plus_amex",
    "bofa_customized_cash_rewards",
    "bofa_premium_rewards",
    "bofa_travel_rewards",
    "capital_one_savor_cash_rewards",
    "capital_one_savorone",
    "capital_one_venture",
    "capital_one_venture_x",
    "capital_one_ventureone",
    "chase_freedom_flex",
    "chase_freedom_unlimited",
    "chase_ink_business_cash",
    "chase_ink_business_preferred",
    "chase_ink_business_unlimited",
    "chase_sapphire_preferred",
    "chase_sapphire_reserve",
    "choice_privileges_visa",
    "choice_privileges_visa_business",
    "citi_aadvantage_executive",
    "citi_aadvantage_mileup",
    "citi_aadvantage_platinum_select",
    "citi_custom_cash",
    "citi_double_cash",
    "citi_prestige_card",
    "citi_strata_elite",
    "citi_strata_premier",
    "delta_skymiles_blue_amex",
    "delta_skymiles_gold_amex",
    "delta_skymiles_platinum_amex",
    "delta_skymiles_reserve_amex",
    "discover_it_cash_back",
    "hilton_honors_amex",
    "hilton_honors_amex_business",
    "hilton_honors_amex_nofee",
    "hilton_honors_aspire_amex",
    "hilton_honors_surpass_amex",
    "hyatt_credit_card_nofee",
    "ihg_one_rewards_premier",
    "ihg_one_rewards_premier_business",
    "ihg_one_rewards_traveler",
    "jetblue_card",
    "jetblue_plus_card",
    "marriott_bonvoy_bold",
    "marriott_bonvoy_boundless",
    "marriott_bonvoy_brilliant_amex",
    "radisson_rewards_premier_visa",
    "southwest_rapid_rewards_plus",
    "southwest_rapid_rewards_premier",
    "southwest_rapid_rewards_priority",
    "united_club_card",
    "united_explorer_card",
    "united_gateway_card",
    "us_bank_altitude_connect",
    "us_bank_altitude_go",
    "us_bank_altitude_reserve",
    "us_bank_cash",
    "wells_fargo_active_cash",
    "wells_fargo_autograph",
    "wells_fargo_autograph_journey",
    "world_of_hyatt_business_card",
    "world_of_hyatt_credit_card",
    "wyndham_rewards_earner"
  ],
  "stale_programs": []
}
PALSTACK_EOF

mkdir -p "dist"
cat > 'dist/programs.json' << 'PALSTACK_EOF'
{
  "generated_at": "2026-03-03T03:19:05.166Z",
  "schema_version": "1.0",
  "count": 73,
  "programs": [
    {
      "program_id": "alaska_airlines_visa_signature",
      "program_name": "Alaska Airlines Visa Signature",
      "issuer": "Bank of America",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.015,
      "tpg_cpp": 0.015,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Free first checked bag (saves $35/bag); companion fare from $23 (taxes/fees); priority boarding; Alaska's Mileage Plan has strongest domestic partner network (Oneworld + partners)",
      "source_url": "https://www.bankofamerica.com/credit-cards/products/alaska-airlines-credit-card/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "50,000 miles"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3x only on Alaska Airlines flights; 2x on dining",
      "redemption_limits": "Miles never expire",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "amex_blue_cash_everyday",
      "program_name": "Amex Blue Cash Everyday",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$7/mo Disney streaming credit; no annual fee; good for everyday spending without managing a premium card",
      "source_url": "https://www.cnbc.com/select/amex-blue-cash-everyday-vs-preferred/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "$200 cash (varies)"
      },
      "earn_categories": [
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": 6000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": 6000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 3,
          "cap_amount": 6000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Each bonus category (grocery, gas, online retail) has its own separate $6k/yr cap; grocery excludes superstores/warehouse clubs",
      "redemption_limits": "Pure cash back only — no transfer partners",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Each of 3 bonus categories independently capped at $6,000/yr"
    },
    {
      "program_id": "amex_blue_cash_preferred",
      "program_name": "Amex Blue Cash Preferred",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Cash Back",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2025-10-01",
      "known_change_event": "Disney streaming credit raised from $7/mo to $10/mo",
      "review_frequency_months": 12,
      "notes": "$10/mo Disney streaming credit (Disney+, Hulu, ESPN+); intro $0 AF first year then $95; best grocery cash-back card; no transfer partners — pure cash back",
      "source_url": "https://wallethub.com/d/american-express-blue-cash-preferred-547c",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "$300 cash (varies)"
      },
      "earn_categories": [
        {
          "category": "groceries",
          "multiplier": 6,
          "cap_amount": 6000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6% only at US supermarkets — excludes superstores (Walmart/Target), warehouse clubs; 3% transit includes taxis/rideshare/parking/trains",
      "redemption_limits": "Reward Dollars redeemable as statement credit or Amazon checkout; no transfer to points programs",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Grocery 6% cap: $6,000/yr; after cap earns 1%"
    },
    {
      "program_id": "amex_business_gold",
      "program_name": "Amex Business Gold",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 375,
      "effective_annual_fee": "375",
      "base_cpp": 0.01,
      "tpg_cpp": 0.02,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$240 FedEx/Grubhub/office supply credit ($20/mo); $155 Walmart+ credit; auto hotel Gold status (Marriott/Hilton) if holding Business Platinum too",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 15000,
        "spend_timeframe_months": 3,
        "notes": "100,000 pts"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 4,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 4,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 4,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 4,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "4x on top 2 categories only — the other 4 earn 1x each billing cycle; category selection is automatic, cannot be manually overridden",
      "redemption_limits": "$150k combined annual cap across both top-2 categories; once-per-lifetime offer",
      "apr": "18.49%–27.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$150,000/yr combined cap on all 4x earning across both auto-selected categories"
    },
    {
      "program_id": "amex_business_platinum",
      "program_name": "Amex Business Platinum",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 695,
      "effective_annual_fee": "695",
      "base_cpp": 0.01,
      "tpg_cpp": 0.02,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$400 Dell tech credit/yr; $360 Indeed credit/yr; $150 Adobe credit/yr; $120 wireless credit; Global Lounge (1,550+ lounges); auto Hilton Gold + Marriott Gold; Global Entry; 35% points rebate on business-class AmexTravel bookings",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 20000,
        "spend_timeframe_months": 3,
        "notes": "200,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": 500000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 5,
          "cap_amount": 500000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "1.5x cap: $2M/yr on purchases ≥$5k; transfer fee to US domestic airlines; 5x flights cap $500k/yr",
      "redemption_limits": "35% rebate only on business/first via AmexTravel; once-per-lifetime offer; credits are complex quarterly/annual use-or-lose",
      "apr": "18.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Hilton Gold + Marriott Gold auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$500k flight cap; $2M cap on 1.5x large purchases; all credits fragmented"
    },
    {
      "program_id": "amex_gold",
      "program_name": "Amex Gold",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 325,
      "effective_annual_fee": "85",
      "base_cpp": 0.01,
      "tpg_cpp": 0.02,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 6,
      "notes": "$120 dining credit ($10/mo, select partners); $120 Uber Cash ($10/mo); $100 Resy credit ($50 semi-annually); The Hotel Collection $100 property credit on 2+ night stays; no foreign transaction fees",
      "source_url": "https://thepointsguy.com/credit-cards/amex-platinum-vs-amex-gold/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 6000,
        "spend_timeframe_months": 3,
        "notes": "100,000 pts (varies)"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 4,
          "cap_amount": 50000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 4,
          "cap_amount": 25000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "4x grocery at US supermarkets only — excludes warehouse clubs, superstores; transfer fee $0.0006/pt (max $99) to US domestic airlines",
      "redemption_limits": "Once-per-lifetime welcome offer; portal redeems at 1cpp — always better to transfer to partners",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Dining cap: $50k/yr; Grocery cap: $25k/yr; credits are monthly/semi-annual use-or-lose"
    },
    {
      "program_id": "amex_green",
      "program_name": "Amex Green",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 150,
      "effective_annual_fee": "1",
      "base_cpp": 0.01,
      "tpg_cpp": 0.02,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$199 CLEAR Plus credit; $100 LoungeBuddy credit; no foreign transaction fees; good entry-level MR card before applying for Gold",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "60,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Transfer fee $0.0006/pt (max $99) to US domestic airlines; 3x on transit — taxis, rideshare, parking, trains",
      "redemption_limits": "Once-per-lifetime offer per card family — apply for Green before Gold (Amex family rules)",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "amex_platinum",
      "program_name": "Amex Platinum",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 895,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.02,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2025-07-01",
      "known_change_event": "Jul 2025 AF raised to $895; new credits: Resy $400/yr, Lululemon $300/yr, entertainment $300/yr, hotel credit raised to $600/yr",
      "review_frequency_months": 6,
      "notes": "$200 airline fee credit; $600 hotel credit (FHR/Hotel Collection); $200 Uber Cash; $400 Resy credit; $300 Equinox; $300 entertainment; $100 Saks; Global Lounge Collection (1,550+ lounges); auto Hilton Gold + Marriott Gold; Global Entry/TSA PreCheck",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 12000,
        "spend_timeframe_months": 3,
        "notes": "175,000 pts (varies)"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": 500000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 5,
          "cap_amount": 500000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "5x only on flights direct with airline or AmexTravel; all other travel 1x; transfer fee on US domestic airline partners ($0.0006/pt max $99)",
      "redemption_limits": "Once-per-lifetime welcome offer per card family; transfer in 1,000-pt increments; $99 max transfer fee to US airlines",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "Y — Hilton Gold + Marriott Gold auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$500,000/yr cap on 5x flight earning; all credits are use-it-or-lose-it monthly/quarterly"
    },
    {
      "program_id": "apple_card",
      "program_name": "Apple Card",
      "issuer": "Apple / Goldman Sachs",
      "network": "Mastercard",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "3% at Apple + select merchants (Nike, Uber, Walgreens, etc.); 2% on all Apple Pay transactions; 1% physical card; Daily Cash deposited daily to Apple Cash; titanium physical card; no fees of any kind",
      "source_url": "https://www.apple.com/apple-card/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "$200 credit"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3% list of merchants is limited and fixed; 2% requires using Apple Pay (not the physical card); cash back deposited daily as Apple Cash",
      "redemption_limits": "Daily Cash redeemable via Apple Pay or Apple Cash balance; no transfer to airline/hotel programs",
      "apr": "15.99%–26.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "Must use Apple Pay for 2%; physical card earns 1% only",
      "bonus_cap_conditional": "3% merchant list is fixed; must use iPhone/Apple Pay"
    },
    {
      "program_id": "bilt_mastercard_obsidian",
      "program_name": "Bilt Mastercard (Obsidian)",
      "issuer": "Bilt",
      "network": "Mastercard",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.022,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-02-07",
      "known_change_event": "Bilt 2.0 launched Feb 7 2026: new Obsidian card, Cardless replaces Wells Fargo as issuer; Bilt Cash earning option added",
      "review_frequency_months": 3,
      "notes": "Earn points on rent + mortgage with no transaction fee (unique to Bilt); 4% Bilt Cash on everyday spend (if Flexible option selected); 5x on Lyft; World of Hyatt + AA + United transfers; highest TPG valuation (2.2cpp) as of Feb 2026",
      "source_url": "https://thepointsguy.com/loyalty-programs/bilt-rewards-guide/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 0,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts + Gold status"
      },
      "earn_categories": [
        {
          "category": "transit",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": 25000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Must choose dining OR groceries for 3x at card setup — cannot earn 3x on both simultaneously; 3x groceries capped at $25k/yr; must make 5+ non-rent transactions/month to earn points on rent",
      "redemption_limits": "Transfer in 1,000-pt increments; rent points transfer at separate rate",
      "apr": "21.24%–29.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "Must make 5+ non-rent purchases/month to earn rent points",
      "bonus_cap_conditional": "Cannot choose both dining AND groceries for 3x; must pick one at signup (changeable annually in January)"
    },
    {
      "program_id": "bilt_palladium",
      "program_name": "Bilt Palladium",
      "issuer": "Bilt",
      "network": "Mastercard",
      "currency_name": "Points",
      "annual_fee": 495,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.022,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-02-07",
      "known_change_event": "Bilt 2.0 launched Feb 7 2026: new Palladium flagship card (Cardless issuer)",
      "review_frequency_months": 3,
      "notes": "$200 Bilt Travel hotel credit 2x/yr (2-night min; $400 annual hotel value); $200 Bilt Cash annually; Priority Pass guest access; Bilt 2.0 flagship card; highest-value transferable points (2.2cpp per TPG Feb 2026)",
      "source_url": "https://thepointsguy.com/loyalty-programs/bilt-rewards-guide/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 0,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts + Gold status"
      },
      "earn_categories": [
        {
          "category": "transit",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "$495 AF partially offset by $400 hotel credit + $200 Bilt Cash = effective $95 if maximized; 2x on rent/mortgage requires spending Bilt Cash to unlock",
      "redemption_limits": "Transfer in 1,000-pt increments; Priority Pass is guest access (not primary membership for non-Palladium), varies by status",
      "apr": "21.24%–29.49% Variable",
      "companion_elite_benefits": "Y — Priority Pass guest access",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — flat 2x on all purchases with no caps"
    },
    {
      "program_id": "blue_business_plus_amex",
      "program_name": "Blue Business Plus (Amex)",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.02,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; expanded purchasing power (no preset spending limit); best no-AF MR earner; part of Amex business trifecta with Gold + Platinum",
      "source_url": "https://www.nerdwallet.com/credit-cards/best/american-express-cards",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "15,000 pts"
      },
      "earn_categories": [
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": 50000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x limited to $50k/yr then drops to 1x on all purchases",
      "redemption_limits": "Transfer to MR partners requires any Membership Rewards-earning card (no additional requirement)",
      "apr": "17.74%–25.74% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$50,000/yr combined cap on all 2x earning"
    },
    {
      "program_id": "bofa_customized_cash_rewards",
      "program_name": "BofA Customized Cash Rewards",
      "issuer": "Bank of America",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-05-27",
      "known_change_event": "BofA Rewards rebrand May 2026: 75% boost now requires $1M balance (was $100k); former Platinum → Preferred Plus (25% boost)",
      "review_frequency_months": 3,
      "notes": "Change 3% category once per month online; BofA Rewards boost stacks on top (10%–75% extra depending on balance tier); first-year 6% on choice category",
      "source_url": "https://www.mymoneyblog.com/bank-of-america-bofa-rewards-changes-2026.html",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": 2500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": 2500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": 2500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": 2500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 3,
          "cap_amount": 2500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "$2,500/quarter COMBINED cap on both the 3% choice cat AND 2% grocery/wholesale together — not separate caps; BofA Rewards boost restructuring May 2026",
      "redemption_limits": "Rewards never expire while account open; $25 minimum for check redemption (no minimum for direct deposit or statement credit)",
      "apr": "18.24%–28.24% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$2,500/quarter combined cap: choice cat + grocery + wholesale clubs all count toward same limit"
    },
    {
      "program_id": "bofa_premium_rewards",
      "program_name": "BofA Premium Rewards",
      "issuer": "Bank of America",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-05-27",
      "known_change_event": "BofA Rewards rebrand May 2026 affects boost tiers",
      "review_frequency_months": 6,
      "notes": "$300 airline incidental credit; $150 lifestyle credit; Global Entry/TSA PreCheck credit; no foreign transaction fees; BofA Rewards boost applies",
      "source_url": "https://frequentmiler.com/negative-bank-of-america-preferred-rewards-upcoming-changes-lower-bonus-rewards-higher-eligibility-requirements/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4000,
        "spend_timeframe_months": 3,
        "notes": "60,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Travel and dining broadly defined; boost percentages changing May 2026",
      "redemption_limits": "No minimum redemption — can redeem for any amount; no transfer to airline/hotel programs",
      "apr": "20.24%–27.24% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — 2x travel/dining uncapped; 1.5x base uncapped"
    },
    {
      "program_id": "bofa_travel_rewards",
      "program_name": "BofA Travel Rewards",
      "issuer": "Bank of America",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-05-27",
      "known_change_event": "BofA Rewards rebrand May 2026",
      "review_frequency_months": 12,
      "notes": "No annual fee; no foreign transaction fees; BofA Rewards boost applicable; redeem against any travel purchase as statement credit",
      "source_url": "https://frequentmiler.com/negative-bank-of-america-preferred-rewards-upcoming-changes-lower-bonus-rewards-higher-eligibility-requirements/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "25,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "No transfer partners; points only redeemable as statement credit against travel purchases; no other redemption options at travel value",
      "redemption_limits": "Minimum redemption $1 for statement credit against travel; 100 pt minimum for other options",
      "apr": "19.24%–29.24% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — flat 1.5x uncapped"
    },
    {
      "program_id": "capital_one_savor_cash_rewards",
      "program_name": "Capital One Savor Cash Rewards",
      "issuer": "Capital One",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "8% on Capital One Entertainment purchases; no annual fee; cash back redeemable at any time with no minimum; no foreign transaction fees",
      "source_url": "https://smartsmssolutions.com/resources/blog/business/best-travel-rewards-credit-cards",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3% grocery excludes superstores like Walmart/Target; streaming 3% applies to most services",
      "redemption_limits": "No minimum redemption",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "capital_one_savorone",
      "program_name": "Capital One SavorOne",
      "issuer": "Capital One",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; 3% dining, groceries (excl. superstores), streaming; 8% Capital One Entertainment; 10% cash back on Uber/Uber Eats through 11/14/2024; no foreign transaction fees",
      "source_url": "https://smartsmssolutions.com/resources/blog/business/best-travel-rewards-credit-cards",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3% grocery excludes superstores (Walmart/Target); streaming 3% on major services",
      "redemption_limits": "No minimum redemption",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — all 3% categories uncapped"
    },
    {
      "program_id": "capital_one_venture",
      "program_name": "Capital One Venture",
      "issuer": "Capital One",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0185,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 6,
      "notes": "$250 Capital One Travel credit first year; up to $120 Global Entry/TSA PreCheck credit; travel eraser option; Lifestyle Collection hotel perks; no foreign transaction fees",
      "source_url": "https://thepointsguy.com/credit-cards/capital-one-miles-vs-chase-ultimate-rewards/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4000,
        "spend_timeframe_months": 3,
        "notes": "75,000 miles + $250 C1 Travel credit"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "5x only via Capital One Travel — not direct bookings; $250 travel credit is first-year only",
      "redemption_limits": "No minimum redemption; travel eraser at 1cpp; transfer in 1,000-mile increments",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$250 first-year travel credit — not recurring annually"
    },
    {
      "program_id": "capital_one_venture_x",
      "program_name": "Capital One Venture X",
      "issuer": "Capital One",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 395,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0185,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 6,
      "notes": "$300 annual travel credit via Capital One Travel; 10,000 anniversary miles (worth ~$100 toward travel); Priority Pass + Capital One Lounge access; up to $120 Global Entry/TSA PreCheck credit; no foreign transaction fees",
      "source_url": "https://wallethub.com/d/capital-one-venture-x-3361c",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4000,
        "spend_timeframe_months": 3,
        "notes": "75,000 miles"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 10,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "10x/5x only via Capital One Travel portal — not direct airline/hotel bookings; $300 credit only for C1 Travel bookings",
      "redemption_limits": "No minimum redemption; travel eraser covers any travel purchase at 1cpp; transfer in 1,000-mile increments",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "Y — Priority Pass + Capital One Lounges",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$300 credit restricted to Capital One Travel bookings only"
    },
    {
      "program_id": "capital_one_ventureone",
      "program_name": "Capital One VentureOne",
      "issuer": "Capital One",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0185,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; entry card for Capital One miles ecosystem; no foreign transaction fees; transfer to 15+ airline partners",
      "source_url": "https://thepointsguy.com/credit-cards/capital-one-miles-vs-chase-ultimate-rewards/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "20,000 miles"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1.25,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "5x only via C1 Travel portal; no Global Entry credit unlike Venture/Venture X",
      "redemption_limits": "Transfer in 1,000-mile increments",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "chase_freedom_flex",
      "program_name": "Chase Freedom Flex",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-01-01",
      "known_change_event": "Q1 2026: dining + NCL + AHA rotating 5x categories",
      "review_frequency_months": 3,
      "notes": "World Elite Mastercard perks: cell phone insurance, Lyft discounts; pairs with Sapphire for full UR value",
      "source_url": "https://www.bankrate.com/credit-cards/cash-back/guide-to-chase-freedom-bonus-categories/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 3,
          "cap_amount": 1,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Must activate quarterly bonus; rotating categories change every 3 months",
      "redemption_limits": "Requires transferable-UR card to unlock transfer partners",
      "apr": "19.49%–28.24% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$1,500/quarter combined cap on all 5x rotating categories; no cap on 3x dining/drugstores"
    },
    {
      "program_id": "chase_freedom_unlimited",
      "program_name": "Chase Freedom Unlimited",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; pairs with Sapphire/Ink Preferred to unlock UR transfer partners; best no-AF personal catch-all",
      "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "None",
      "redemption_limits": "Requires transferable-UR card to unlock transfer partners",
      "apr": "19.49%–28.24% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "chase_ink_business_cash",
      "program_name": "Chase Ink Business Cash",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; pairs with Sapphire/Ink Preferred to unlock transfer partners and full UR value",
      "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 0,
        "spend_timeframe_months": 3,
        "notes": "$350 + $400 tiered cash"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": 25000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": 25000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Wholesale clubs, superstores not included in grocery/office supply bonus",
      "redemption_limits": "Requires a transferable-UR card (Sapphire/Ink Preferred) to transfer points; otherwise redeems at 1cpp",
      "apr": "18.49%–24.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$25,000 annual cap on office supplies + cable/phone combined"
    },
    {
      "program_id": "chase_ink_business_preferred",
      "program_name": "Chase Ink Business Preferred",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Cell phone protection up to $1,000; primary rental car coverage; transfers to all Chase travel partners",
      "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 8000,
        "spend_timeframe_months": 3,
        "notes": "100,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 3,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 3,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": 150000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Non-employee cardholders do not earn UR; $150k combined cap across all 3x categories",
      "redemption_limits": "Transfer in 1,000-pt increments; no minimum cash redemption",
      "apr": "20.49%–26.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$150,000 annual combined cap across all 3x bonus categories — not per-category"
    },
    {
      "program_id": "chase_ink_business_unlimited",
      "program_name": "Chase Ink Business Unlimited",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; best no-AF business catch-all card; pairs with Sapphire/Ink Preferred to unlock UR transfers",
      "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 6000,
        "spend_timeframe_months": 3,
        "notes": "$750 cash"
      },
      "earn_categories": [
        {
          "category": "other",
          "multiplier": 1.5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "None",
      "redemption_limits": "Requires a transferable-UR card to unlock transfer partners",
      "apr": "18.49%–24.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "chase_sapphire_preferred",
      "program_name": "Chase Sapphire Preferred",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "45",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2025-06-23",
      "known_change_event": "Jun 2025 CSR restructure made CSP best card for 2x general travel purchases",
      "review_frequency_months": 6,
      "notes": "$50 annual hotel credit via Chase Travel; 10% anniversary bonus on prior year spend; DashPass complimentary through 12/31/27",
      "source_url": "https://www.cnbc.com/select/chase-sapphire-reserve-review/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 5000,
        "spend_timeframe_months": 3,
        "notes": "75,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "In-store groceries earn 1x only; online grocery cap $6,000/yr",
      "redemption_limits": "No minimum redemption for statement credit; transfer in 1,000-pt increments",
      "apr": "19.74%–26.74% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Points Boost up to 1.75cpp on select portal bookings (hotels/flights) — not all bookings"
    },
    {
      "program_id": "chase_sapphire_reserve",
      "program_name": "Chase Sapphire Reserve",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 795,
      "effective_annual_fee": "495",
      "base_cpp": 0.01,
      "tpg_cpp": 0.0205,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2025-10-26",
      "known_change_event": "Oct 2025: Points Boost activated; fixed 1.5cpp portal removed; 3x general travel → 1x",
      "review_frequency_months": 3,
      "notes": "$300 travel credit; Priority Pass + CSR Lounge access; IHG Platinum Elite (auto); Points Boost up to 2cpp on select portal bookings; no foreign transaction fees",
      "source_url": "https://thepointsguy.com/loyalty-programs/monthly-valuations/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 6000,
        "spend_timeframe_months": 3,
        "notes": "125,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 8,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "General travel (parking, transit, vacation rentals) now 1x as of Oct 2025",
      "redemption_limits": "Points do not expire while account open; transfer to partners in 1,000-pt increments",
      "apr": "17.49%–24.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Points Boost applies to select airlines/hotels only — not all portal bookings"
    },
    {
      "program_id": "choice_privileges_visa",
      "program_name": "Choice Privileges Visa",
      "issuer": "Barclays",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 49,
      "effective_annual_fee": "49",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_18mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto Choice Privileges Gold status; no foreign transaction fees; Choice Hotels entry card",
      "source_url": "https://www.barclays.us/credit-cards/choice-privileges/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 8,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "8x only at Choice brand properties",
      "redemption_limits": "Points expire 18 months inactivity",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "Y — Gold status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "choice_privileges_visa_business",
      "program_name": "Choice Privileges Visa Business",
      "issuer": "Barclays",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 49,
      "effective_annual_fee": "49",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_18mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Business version of Choice card; auto Gold status; no foreign transaction fees",
      "source_url": "https://www.barclays.us/credit-cards/choice-privileges/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 8,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "8x only at Choice brand properties",
      "redemption_limits": "Points expire 18 months inactivity",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "Y — Gold status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "citi_aadvantage_executive",
      "program_name": "Citi AAdvantage Executive",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Miles",
      "annual_fee": 595,
      "effective_annual_fee": "595",
      "base_cpp": 0.015,
      "tpg_cpp": 0.015,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Admirals Club lounge membership; free first + second checked bag for up to 4 companions; priority boarding; preferred boarding; 10,000 Loyalty Points bonus on $40k+ spend",
      "source_url": "https://money.usnews.com/credit-cards/signup-bonus",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 10000,
        "spend_timeframe_months": 3,
        "notes": "100,000 miles"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "4x only on AA-operated flights; all other airlines earn 1x",
      "redemption_limits": "AAdvantage miles expire after 24 months of inactivity",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "Y — Admirals Club membership + priority boarding",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — no annual cap on 4x AA earning"
    },
    {
      "program_id": "citi_aadvantage_mileup",
      "program_name": "Citi AAdvantage MileUp",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Miles",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.014,
      "tpg_cpp": 0.014,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; 25% inflight savings; entry-level AA card; no free checked bag",
      "source_url": "https://money.usnews.com/credit-cards/signup-bonus",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "15,000 miles"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x only on American Airlines-operated flights; 2x on US grocery stores",
      "redemption_limits": "AAdvantage miles expire 24 months inactivity",
      "apr": "20.49%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "citi_aadvantage_platinum_select",
      "program_name": "Citi AAdvantage Platinum Select",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Miles",
      "annual_fee": 99,
      "effective_annual_fee": "99",
      "base_cpp": 0.014,
      "tpg_cpp": 0.014,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Free first checked bag for cardholder + up to 4 companions; priority boarding; $125 AA flight discount after $20k spend/yr; preferred boarding",
      "source_url": "https://money.usnews.com/credit-cards/signup-bonus",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2500,
        "spend_timeframe_months": 3,
        "notes": "50,000 miles"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x only on AA-operated flights; 2x US groceries/gas",
      "redemption_limits": "AAdvantage miles expire 24 months inactivity",
      "apr": "20.49%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "citi_custom_cash",
      "program_name": "Citi Custom Cash",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.019,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-01-01",
      "known_change_event": "Bonus promo: +4% on Citi Travel hotels/cars/attractions through Jun 30 2026 (stacks if travel is top cat → 9%)",
      "review_frequency_months": 3,
      "notes": "Automatically maximizes 5% in your top category — no manual selection needed; eligible categories: grocery, gas, restaurants, select travel, select transit, streaming, drugstores, home improvement, live entertainment; pair with Strata Premier for transfer value",
      "source_url": "https://financebuzz.com/citi-custom-cash-card-review",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 5,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 5,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 5,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": 500,
          "cap_period": "monthly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Only ONE category earns 5% per billing cycle — auto-selected by highest spend; if you split spend evenly across categories you may not maximize it",
      "redemption_limits": "$500/month cap on 5% earning; after cap all purchases earn 1%; must have Strata card to unlock transfer partners",
      "apr": "18.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$500/month = $6,000/year maximum 5x earning"
    },
    {
      "program_id": "citi_double_cash",
      "program_name": "Citi Double Cash",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.019,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Best no-AF catch-all card when paired with Strata Premier — converts cash back to transferable ThankYou points at full value; 18 months 0% intro APR on balance transfers",
      "source_url": "https://upgradedpoints.com/credit-cards/citi-thankyou-rewards-points-faqs/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x requires paying your balance to earn the second 1%; must have a Strata card to unlock TY point transfers",
      "redemption_limits": "Must be combined with a Strata card to access transfer partners; otherwise 1cpp cash redemption only",
      "apr": "18.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — unlimited 2% on all purchases"
    },
    {
      "program_id": "citi_prestige_card",
      "program_name": "Citi Prestige Card",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Points",
      "annual_fee": 495,
      "effective_annual_fee": "495",
      "base_cpp": 0.01,
      "tpg_cpp": 0.019,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2022-01-01",
      "known_change_event": "Closed to new applicants ~2022; existing cardholders grandfathered",
      "review_frequency_months": 12,
      "notes": "CLOSED TO NEW APPLICANTS. Existing cardholders only. 4th night free on hotel bookings of 4+ nights (unlimited); Priority Pass Select; $250 annual travel credit; Global Entry/TSA PreCheck",
      "source_url": "https://upgradedpoints.com/credit-cards/citi-thankyou-rewards-points-faqs/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 5000,
        "spend_timeframe_months": 3,
        "notes": "75,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "No longer available to new applicants — legacy card; 4th night free is per booking, unlimited uses per year",
      "redemption_limits": "Transfer to TY partners in 1,000-pt increments",
      "apr": "19.74%–27.74% Variable",
      "companion_elite_benefits": "Y — Priority Pass + 4th night free",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "4th night free requires 4+ consecutive nights at same property"
    },
    {
      "program_id": "citi_strata_elite",
      "program_name": "Citi Strata Elite",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Points",
      "annual_fee": 595,
      "effective_annual_fee": "595",
      "base_cpp": 0.01,
      "tpg_cpp": 0.019,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2025-06-01",
      "known_change_event": "Citi Strata Elite launched mid-2025 as new premium flagship",
      "review_frequency_months": 6,
      "notes": "Premium Citi card launched 2025; airport lounge access (Priority Pass); $595 AF; strong transfer partner roster including Turkish + EVA Air + AA (restored Jul 2025)",
      "source_url": "https://upgradedpoints.com/credit-cards/citi-thankyou-rewards-points-faqs/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 6000,
        "spend_timeframe_months": 3,
        "notes": "75,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 12,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x dining only applies 6pm–6am ET; 12x portal only at CitiTravel; grocery/gas 3x with no cap",
      "redemption_limits": "Transfer in 1,000-pt increments; no minimum redemption",
      "apr": "20.49%–28.49% Variable",
      "companion_elite_benefits": "Y — Priority Pass Select",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "6x dining time restriction (6pm–6am ET) is a key limitation for lunch/brunch spenders"
    },
    {
      "program_id": "citi_strata_premier",
      "program_name": "Citi Strata Premier",
      "issuer": "Citi",
      "network": "Mastercard",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.01,
      "tpg_cpp": 0.019,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2024-06-01",
      "known_change_event": "Rebranded from Citi Premier; new purchase + travel protections added mid-2024",
      "review_frequency_months": 6,
      "notes": "$100 annual hotel credit ($500+ booking via Citi Travel — single booking only); strong transfer partners (Turkish, EVA Air, AA, Flying Blue); anchor of Citi trifecta (pair with Double Cash)",
      "source_url": "https://www.bankrate.com/credit-cards/reviews/citi-strata-premier-card/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4000,
        "spend_timeframe_months": 3,
        "notes": "60,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 10,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "10x portal only at CitiTravel; $100 hotel credit requires minimum $500 single booking; no lounge access",
      "redemption_limits": "Transfer in 1,000-pt increments; no minimum redemption",
      "apr": "20.49%–28.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$100 hotel credit: requires $500+ single booking — budget stays don't qualify"
    },
    {
      "program_id": "delta_skymiles_blue_amex",
      "program_name": "Delta SkyMiles Blue Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Miles",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.012,
      "tpg_cpp": 0.012,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; entry-level Delta card; no free checked bag; 2x on Delta + 1x everywhere else",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "30,000 miles"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x only on Delta flights",
      "redemption_limits": "SkyMiles never expire but low transfer value",
      "apr": "20.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "delta_skymiles_gold_amex",
      "program_name": "Delta SkyMiles Gold Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Miles",
      "annual_fee": 150,
      "effective_annual_fee": "0",
      "base_cpp": 0.012,
      "tpg_cpp": 0.012,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Free first checked bag (saves $35/bag one-way); priority boarding; 20% back on eligible inflight purchases; up to $200 annual flight credit after $10k spend; intro $0 AF first year then $150",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 5000,
        "spend_timeframe_months": 3,
        "notes": "90,000 miles (tiered thru Apr 1 2026)"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x only at Delta or US supermarkets — all other airlines earn 1x",
      "redemption_limits": "SkyMiles never expire but are worth significantly less than MR/UR when transferred",
      "apr": "20.49%–29.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "delta_skymiles_platinum_amex",
      "program_name": "Delta SkyMiles Platinum Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Miles",
      "annual_fee": 350,
      "effective_annual_fee": "250",
      "base_cpp": 0.012,
      "tpg_cpp": 0.012,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Free first checked bag; annual companion cert (main cabin domestic); Global Entry/TSA PreCheck credit; priority boarding; $100 Delta credit/yr",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4000,
        "spend_timeframe_months": 3,
        "notes": "70,000 miles (tiered thru Apr 1 2026)"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3x only on Delta-operated flights",
      "redemption_limits": "SkyMiles never expire",
      "apr": "20.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "delta_skymiles_reserve_amex",
      "program_name": "Delta SkyMiles Reserve Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Miles",
      "annual_fee": 650,
      "effective_annual_fee": "450",
      "base_cpp": 0.012,
      "tpg_cpp": 0.012,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 6,
      "notes": "Delta Sky Club lounge access when flying Delta; annual domestic companion cert (main cabin); free first + second checked bag; companion cert for companion tickets; 15,000 MQD boost toward Medallion status",
      "source_url": "https://thepointsguy.com/credit-cards/american-express/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 6000,
        "spend_timeframe_months": 3,
        "notes": "100,000 miles + 25,000 (tiered thru Apr 1 2026)"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3x only on Delta purchases — all other airlines earn 1x; Sky Club access only when flying on Delta",
      "redemption_limits": "SkyMiles never expire",
      "apr": "21.49%–30.49% Variable",
      "companion_elite_benefits": "Y — Sky Club + Medallion boost",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "discover_it_cash_back",
      "program_name": "Discover it Cash Back",
      "issuer": "Discover",
      "network": "Discover",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-01-01",
      "known_change_event": "Q1 2026 rotating categories: restaurants + drugstores",
      "review_frequency_months": 3,
      "notes": "Cashback Match first year: if you earn $300 cash back, Discover gives you another $300 — effectively 10% on rotating cats + 2% base in year 1; no annual fee; no foreign transaction fees; freeze card via app",
      "source_url": "https://frequentmiler.com/q1-2026-activation-links-for-cards-offering-5-in-rotating-categories/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 0,
        "spend_timeframe_months": 3,
        "notes": "Cashback Match (all yr1 earnings doubled)"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 5,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 5,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 5,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": 1500,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Must activate bonus each quarter online or via app; rotating categories change quarterly — must track schedule; Q1 2026: restaurants + drugstores",
      "redemption_limits": "No minimum redemption; redeem at any time",
      "apr": "17.49%–26.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$1,500/quarter cap on 5% rotating categories"
    },
    {
      "program_id": "hilton_honors_amex",
      "program_name": "Hilton Honors Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.006,
      "tpg_cpp": 0.006,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto Hilton Silver status; access to American Express Experiences; no annual fee makes it a great keeper card even without heavy Hilton use",
      "source_url": "https://money.usnews.com/credit-cards/american-express",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "70,000 pts + Free Night"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "7x at Hilton only; 5x restricted to US merchants for supermarkets and gas",
      "redemption_limits": "Hilton points expire after 12 months of inactivity",
      "apr": "20.49%–29.49% Variable",
      "companion_elite_benefits": "Y — Silver status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "hilton_honors_amex_business",
      "program_name": "Hilton Honors Amex Business",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 195,
      "effective_annual_fee": "195",
      "base_cpp": 0.006,
      "tpg_cpp": 0.006,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto Gold Elite; $120 Hilton credit/yr ($10/mo); free night after $15k spend/yr; no foreign transaction fees; business version",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "130,000 pts"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 12,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 12,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "12x only at Hilton brands; 6x restricted to US merchants",
      "redemption_limits": "Points expire 12 months inactivity",
      "apr": "20.99%–29.99% Variable",
      "companion_elite_benefits": "Y — Gold status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "hilton_honors_amex_nofee",
      "program_name": "Hilton Honors Amex (no-fee)",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.006,
      "tpg_cpp": 0.006,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; auto Hilton Silver status; access to Amex Experiences; great keeper card for Hilton loyalists",
      "source_url": "https://money.usnews.com/credit-cards/american-express",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "70,000 pts + Free Night"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "7x only at Hilton properties; 5x at US merchants only (not international grocery/gas)",
      "redemption_limits": "Hilton points expire 12 months inactivity",
      "apr": "20.99%–29.99% Variable",
      "companion_elite_benefits": "Y — Silver status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "hilton_honors_aspire_amex",
      "program_name": "Hilton Honors Aspire Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 550,
      "effective_annual_fee": "250",
      "base_cpp": 0.006,
      "tpg_cpp": 0.006,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 6,
      "notes": "Auto Diamond Elite status (best Hilton status); annual Free Night Award (any property, any price); $400 Hilton resort credit/yr ($200 semi-annually); $200 airline fee credit; Priority Pass Select (unlimited visits); no foreign transaction fees",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 6000,
        "spend_timeframe_months": 3,
        "notes": "175,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 14,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 7,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "14x only at Hilton; 7x on direct airline + restaurants + car rentals; grocery/gas earn 3x base only",
      "redemption_limits": "Annual free night has no cap — can be used at any property worldwide",
      "apr": "21.49%–30.49% Variable",
      "companion_elite_benefits": "Y — Diamond Elite auto + unlimited Priority Pass",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Resort credit: must be used at specific Hilton resort properties only"
    },
    {
      "program_id": "hilton_honors_surpass_amex",
      "program_name": "Hilton Honors Surpass Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 150,
      "effective_annual_fee": "150",
      "base_cpp": 0.006,
      "tpg_cpp": 0.006,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$200 Hilton credit/yr ($50/quarter direct at Hilton properties); auto Gold status; free night after $15k spend/yr; 10 Priority Pass lounge visits/yr",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "130,000 pts + Free Night"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 12,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 12,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "12x only at Hilton properties; 6x restricted to US merchants",
      "redemption_limits": "Hilton points expire after 12 months of inactivity",
      "apr": "20.49%–29.49% Variable",
      "companion_elite_benefits": "Y — Gold status auto + 10 Priority Pass visits",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Free night cert requires $15,000 spend/yr"
    },
    {
      "program_id": "hyatt_credit_card_nofee",
      "program_name": "Hyatt Credit Card (no-fee)",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.017,
      "tpg_cpp": 0.017,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; Discoverist status auto; free night cert (Cat 1-4) each anniversary; World of Hyatt entry card",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "30,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "4x only at Hyatt brands",
      "redemption_limits": "Hyatt points don't expire with qualifying activity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Discoverist auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "ihg_one_rewards_premier",
      "program_name": "IHG One Rewards Premier",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 99,
      "effective_annual_fee": "99",
      "base_cpp": 0.005,
      "tpg_cpp": 0.005,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto IHG Platinum Elite; anniversary free night; 4th night free on award stays; $100 IHG credit on 2+ night stays; Global Entry/TSA PreCheck credit",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 5000,
        "spend_timeframe_months": 3,
        "notes": "175,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 26,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "26x only at IHG properties; non-IHG travel earns 5x card rate only",
      "redemption_limits": "IHG points expire after 12 months of inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — IHG Platinum Elite auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "ihg_one_rewards_premier_business",
      "program_name": "IHG One Rewards Premier Business",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 99,
      "effective_annual_fee": "99",
      "base_cpp": 0.005,
      "tpg_cpp": 0.005,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto IHG Platinum Elite; anniversary free night; 4th night free on award stays; Global Entry/TSA PreCheck credit; business card",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "90,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 26,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "26x only at IHG brands",
      "redemption_limits": "IHG points expire 12 months inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — IHG Platinum Elite auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "ihg_one_rewards_traveler",
      "program_name": "IHG One Rewards Traveler",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.005,
      "tpg_cpp": 0.005,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; IHG One Rewards entry card; IHG Silver status; 4th night free on award stays",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "70,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 15,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "15x only at IHG brands",
      "redemption_limits": "IHG points expire after 12 months inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "N — Silver status (not auto Platinum)",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "jetblue_card",
      "program_name": "JetBlue Card",
      "issuer": "Barclays",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.014,
      "tpg_cpp": 0.014,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; no foreign transaction fees; 6x on JetBlue purchases; 50% off inflight food and drinks",
      "source_url": "https://www.barclays.us/credit-cards/jetblue/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "40,000 pts"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x only on JetBlue bookings",
      "redemption_limits": "TrueBlue points never expire",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "jetblue_plus_card",
      "program_name": "JetBlue Plus Card",
      "issuer": "Barclays",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 99,
      "effective_annual_fee": "99",
      "base_cpp": 0.014,
      "tpg_cpp": 0.014,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Free first checked bag; 5,000 anniversary bonus pts; 50% off inflight; upgrade to Mint mosaic status at $50k spend; no foreign transaction fees",
      "source_url": "https://www.barclays.us/credit-cards/jetblue-plus/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "60,000 pts"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x only on JetBlue",
      "redemption_limits": "TrueBlue points never expire",
      "apr": "19.99%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "marriott_bonvoy_bold",
      "program_name": "Marriott Bonvoy Bold",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.007,
      "tpg_cpp": 0.007,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "No annual fee; Marriott Bonvoy entry card; auto Silver Elite; 15 Elite Night Credits/yr",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3x only at Marriott brands",
      "redemption_limits": "Marriott points expire 24 months inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Silver Elite auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "marriott_bonvoy_boundless",
      "program_name": "Marriott Bonvoy Boundless",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.007,
      "tpg_cpp": 0.007,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Annual free night cert (up to 35k points); auto Silver Elite; 15 Elite Night Credits toward next tier; bonus 1 night credit per stay",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "5 Free Night Awards (up to 250k pts total)"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x only at Marriott Bonvoy brands",
      "redemption_limits": "Marriott points expire after 24 months of inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Silver Elite auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "marriott_bonvoy_brilliant_amex",
      "program_name": "Marriott Bonvoy Brilliant Amex",
      "issuer": "American Express",
      "network": "Amex",
      "currency_name": "Points",
      "annual_fee": 650,
      "effective_annual_fee": "350",
      "base_cpp": 0.007,
      "tpg_cpp": 0.007,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto Platinum Elite (top earnable status); annual free night cert (up to 85k pts); 25 Elite Night Credits/yr; $300 Marriott credit/yr; $100 property credit on 2+ night stays; Priority Pass Select",
      "source_url": "https://upgradedpoints.com/credit-cards/american-express-card-levels/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "130,000 pts + Free Night"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x only at Marriott Bonvoy brands",
      "redemption_limits": "Marriott points expire after 24 months of inactivity",
      "apr": "19.49%–28.49% Variable",
      "companion_elite_benefits": "Y — Platinum Elite auto + Priority Pass",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$300 Marriott credit: must be used at Marriott properties directly"
    },
    {
      "program_id": "radisson_rewards_premier_visa",
      "program_name": "Radisson Rewards Premier Visa",
      "issuer": "Bank of America",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 75,
      "effective_annual_fee": "75",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_12mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto Radisson Gold status; annual free night after $10k spend; no foreign transaction fees",
      "source_url": "https://www.bankofamerica.com/credit-cards/products/radisson/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x at Radisson group properties (Park Inn, Country Inn, etc.)",
      "redemption_limits": "Points expire 12 months inactivity",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "Y — Gold status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "southwest_rapid_rewards_plus",
      "program_name": "Southwest Rapid Rewards Plus",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 69,
      "effective_annual_fee": "69",
      "base_cpp": 0.015,
      "tpg_cpp": 0.015,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-01-27",
      "known_change_event": "Southwest assigned seating launched Jan 27 2026; Plus card: standard seat selection only (no preferred)",
      "review_frequency_months": 12,
      "notes": "Lowest-cost Southwest card; 3,000 anniversary pts; first checked bag free; 10,000 Companion Pass qualifying pts boost/yr",
      "source_url": "https://money.usnews.com/credit-cards/chase/southwest-rapid-rewards-plus-credit-card",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "Companion Pass + 20,000 pts"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": 5000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": 5000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Grocery+gas cap: $5,000/yr combined; no preferred seating (Priority only)",
      "redemption_limits": "Points expire 24 months inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$5,000/yr combined cap on 2x groceries+gas"
    },
    {
      "program_id": "southwest_rapid_rewards_premier",
      "program_name": "Southwest Rapid Rewards Premier",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 99,
      "effective_annual_fee": "99",
      "base_cpp": 0.015,
      "tpg_cpp": 0.015,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-01-27",
      "known_change_event": "Southwest assigned seating Jan 2026; Premier: standard boarding (no preferred seat selection)",
      "review_frequency_months": 12,
      "notes": "Mid-tier Southwest card; 6,000 anniversary pts; first checked bag free; A-List preferred boarding; 10,000 Companion Pass qualifying pts boost/yr",
      "source_url": "https://money.usnews.com/credit-cards/chase/southwest-rapid-rewards-plus-credit-card",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "Companion Pass + 20,000 pts"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": 5000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": 5000,
          "cap_period": "annual",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Grocery+gas cap: $5,000/yr combined",
      "redemption_limits": "Points expire 24 months inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$5,000/yr combined cap on 2x groceries+gas"
    },
    {
      "program_id": "southwest_rapid_rewards_priority",
      "program_name": "Southwest Rapid Rewards Priority",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 229,
      "effective_annual_fee": "129",
      "base_cpp": 0.015,
      "tpg_cpp": 0.015,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_24mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-01-27",
      "known_change_event": "Southwest launched assigned seating Jan 27 2026; Priority card gains preferred seat selection perk",
      "review_frequency_months": 6,
      "notes": "$75 Southwest travel credit/yr; 7,500 anniversary points; 4 upgraded boarding passes/yr; 25% back on inflight purchases; 10,000 Companion Pass qualifying pts boost/yr; preferred seat selection (Jan 2026 assigned seating)",
      "source_url": "https://thepointsguy.com/credit-cards/southwest-priority-value/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "Companion Pass + 20,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Points only transferable within Southwest Rapid Rewards; no airline partners",
      "redemption_limits": "Points expire after 24 months of inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Companion Pass qualifying boost",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None for dining/gas/SW; no combined cap on Priority card unlike Plus/Premier"
    },
    {
      "program_id": "united_club_card",
      "program_name": "United Club Card",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 595,
      "effective_annual_fee": "595",
      "base_cpp": 0.012,
      "tpg_cpp": 0.0135,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-04-02",
      "known_change_event": "Apr 2026 MileagePlus changes: Club cardholders earn 6 mi/$1 on United flights base",
      "review_frequency_months": 3,
      "notes": "United Club membership for primary cardholder + immediate family or 2 guests; free first + second checked bag; Premier Access (priority check-in/boarding/security); 10% award discount (Apr 2026)",
      "source_url": "https://awardwallet.com/news/united-mileageplus/mileage-earning-changes-2026/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 5000,
        "spend_timeframe_months": 3,
        "notes": "90,000 miles"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Non-United purchases earn 1x base",
      "redemption_limits": "No expiry while account open and active",
      "apr": "21.49%–28.49% Variable",
      "companion_elite_benefits": "Y — United Club lounge membership",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "united_explorer_card",
      "program_name": "United Explorer Card",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.012,
      "tpg_cpp": 0.0135,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_18mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-04-02",
      "known_change_event": "Apr 2026: cardholder earn on United flights raised to 6 mi/$1 (was 5); basic economy earns 0 mi for non-cardholders; 10% award discount unlocked",
      "review_frequency_months": 3,
      "notes": "Free first checked bag (saves up to $35/bag); 2 United Club one-time passes/yr; priority boarding; 10%+ award discount starting Apr 2026; primary CDW",
      "source_url": "https://awardwallet.com/news/united-mileageplus/mileage-earning-changes-2026/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "70,000 miles"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Non-United purchases earn 1x base",
      "redemption_limits": "Points expire after 18 months of account inactivity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — no annual cap on bonus categories"
    },
    {
      "program_id": "united_gateway_card",
      "program_name": "United Gateway Card",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Miles",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.013,
      "tpg_cpp": 0.013,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_18mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2026-04-02",
      "known_change_event": "Apr 2026: basic economy earns 0 mi without card or elite status",
      "review_frequency_months": 12,
      "notes": "No annual fee; no foreign transaction fees; 2x on United + gas; entry-level United card; basic economy miles earn (requires card after Apr 2026)",
      "source_url": "https://awardwallet.com/news/united-mileageplus/mileage-earning-changes-2026/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "60,000 miles"
      },
      "earn_categories": [
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "2x United + gas only; no free checked bag",
      "redemption_limits": "Miles expire 18 months inactivity",
      "apr": "20.99%–27.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "us_bank_altitude_connect",
      "program_name": "US Bank Altitude Connect",
      "issuer": "US Bank",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0 yr1; $95 thereafter",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$30/yr streaming credit (after 11 consecutive months of streaming purchases); 4 Priority Pass visits/yr; TSA PreCheck/Global Entry credit; no foreign transaction fees; no transfer partners",
      "source_url": "https://financebuzz.com/us-bank-altitude-connect-visa-signature-review",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": 1,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 5,
          "cap_amount": 1,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": 1,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 4,
          "cap_amount": 1000,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": 1,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": 1,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "No transfer partners — Altitude Points fixed at 1cpp; 4x gas capped at $1,000/quarter; 5x only via Altitude Travel Center (not direct airline/hotel bookings)",
      "redemption_limits": "No minimum redemption; Real-Time Rewards lets you redeem instantly via text",
      "apr": "19.24%–29.24% Variable",
      "companion_elite_benefits": "N — 4 Priority Pass visits/yr only",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$1,000/quarter cap on 4x gas earning; all other bonus categories uncapped"
    },
    {
      "program_id": "us_bank_altitude_go",
      "program_name": "US Bank Altitude Go",
      "issuer": "US Bank",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "$15 annual streaming credit (after 11 consecutive months of streaming purchases); no annual fee; no foreign transaction fees",
      "source_url": "https://www.usbank.com/credit-cards/altitude-go-visa-signature-credit-card.html",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "20,000 pts"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "No transfer partners; Altitude Points fixed at 1cpp; dining broadly includes restaurants, food delivery, bars",
      "redemption_limits": "No minimum redemption; Real-Time Rewards instant redemption via text",
      "apr": "19.24%–29.24% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — 4x dining uncapped"
    },
    {
      "program_id": "us_bank_altitude_reserve",
      "program_name": "US Bank Altitude Reserve",
      "issuer": "US Bank",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 400,
      "effective_annual_fee": "75",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2024-11-01",
      "known_change_event": "Closed to new applicants Nov 2024; existing cardholders retain all benefits",
      "review_frequency_months": 12,
      "notes": "CLOSED TO NEW APPLICANTS Nov 2024. Existing cardholders only. $325 annual travel+dining credit; Priority Pass Select (unlimited); Global Entry; 1.5cpp redemption toward travel (best Altitude rate)",
      "source_url": "https://financebuzz.com/us-bank-altitude-reserve-visa-infinite-card-review",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4500,
        "spend_timeframe_months": 3,
        "notes": "50,000 pts"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "3x mobile wallet on up to $5,000/billing cycle; no transfer partners — points fixed value",
      "redemption_limits": "1.5cpp when redeemed for travel via Altitude Rewards Center; no airline/hotel transfers",
      "apr": "19.24%–29.24% Variable",
      "companion_elite_benefits": "Y — Priority Pass unlimited",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "Mobile wallet 3x: up to $5,000/billing cycle"
    },
    {
      "program_id": "us_bank_cash",
      "program_name": "US Bank Cash+",
      "issuer": "US Bank",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 3,
      "notes": "Must choose categories each quarter before activation deadline; 5% categories include niche options not on other cards (gym, ground transport, home utilities); no annual fee; 0% intro APR for 15 months",
      "source_url": "https://www.cnbc.com/select/us-bank-cash-vs-citi-custom-cash/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 5,
          "cap_amount": 2,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 5,
          "cap_amount": 2000,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": "or 2% (depending on chosen categories)"
        },
        {
          "category": "gas",
          "multiplier": 5,
          "cap_amount": 2000,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": "or 2% (depending)"
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": 2,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": 2000,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": 2000,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": 2000,
          "cap_period": "quarterly",
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "Must activate each quarter; if no activation, earns 1% on everything; 5% categories are pre-defined list only — cannot choose arbitrary categories",
      "redemption_limits": "$2,000/quarter cap per 5% category; separate caps for each of the two chosen 5% categories",
      "apr": "19.74%–29.74% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "$2,000/quarter per 5% category = $8,000/yr max per category"
    },
    {
      "program_id": "wells_fargo_active_cash",
      "program_name": "Wells Fargo Active Cash",
      "issuer": "Wells Fargo",
      "network": "Visa",
      "currency_name": "Cash Back",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Cell phone protection up to $600; no annual fee; no foreign transaction fees; 0% intro APR for 15 months",
      "source_url": "https://www.lendingtree.com/credit-cards/articles/what-are-wells-fargo-go-far-rewards-worth/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 500,
        "spend_timeframe_months": 3,
        "notes": "$200 cash"
      },
      "earn_categories": [
        {
          "category": "travel_portal",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "None",
      "redemption_limits": "No minimum cash back redemption",
      "apr": "19.24%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — truly unlimited 2% everywhere"
    },
    {
      "program_id": "wells_fargo_autograph",
      "program_name": "Wells Fargo Autograph",
      "issuer": "Wells Fargo",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 0,
      "effective_annual_fee": "0",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Cell phone protection; Autograph Card Exclusives; no annual fee; no foreign transaction fees; growing transfer partner roster",
      "source_url": "https://www.nerdwallet.com/credit-cards/learn/wells-fargo-autograph-journey-vs-capital-one-venture",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 1000,
        "spend_timeframe_months": 3,
        "notes": "20,000 pts"
      },
      "earn_categories": [
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "hotels_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "1x on groceries and general travel; transfer partners limited vs Chase/Amex",
      "redemption_limits": "No minimum redemption",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None — all 3x categories are uncapped"
    },
    {
      "program_id": "wells_fargo_autograph_journey",
      "program_name": "Wells Fargo Autograph Journey",
      "issuer": "Wells Fargo",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "45",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": "2024-03-01",
      "known_change_event": "Launched March 2024",
      "review_frequency_months": 12,
      "notes": "$50 annual airline statement credit; cell phone protection up to $1,000; Autograph Card Exclusives (live event access); no foreign transaction fees",
      "source_url": "https://www.bankrate.com/credit-cards/reviews/wells-fargo-autograph-journey-comparison/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 4000,
        "spend_timeframe_months": 3,
        "notes": "60,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 5,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 3,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "5x only on direct hotel bookings (not via portal); 4x only on direct airline bookings; grocery/gas/streaming earn 1x",
      "redemption_limits": "No minimum redemption; transfer to international airline partners only (no US domestic partners)",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "N",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "world_of_hyatt_business_card",
      "program_name": "World of Hyatt Business Card",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 199,
      "effective_annual_fee": "199",
      "base_cpp": 0.017,
      "tpg_cpp": 0.017,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Annual free night cert (Cat 1-4); up to 5 Category 1-7 free night cert with $50k spend; Discoverist status; 5 Elite Night Credits/yr toward next tier",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 5000,
        "spend_timeframe_months": 3,
        "notes": "60,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 9,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "9x only at Hyatt properties — non-Hyatt hotels earn 1x",
      "redemption_limits": "Points don't expire with qualifying activity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Discoverist auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "world_of_hyatt_credit_card",
      "program_name": "World of Hyatt Credit Card",
      "issuer": "Chase",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 95,
      "effective_annual_fee": "95",
      "base_cpp": 0.017,
      "tpg_cpp": 0.017,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "account_closure",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Annual free night cert (Cat 1-4, up to 15k pts/night); auto Discoverist status; 2 bonus Qualifying Night Credits per stay; 5 Elite Night Credits/yr toward next status tier",
      "source_url": "https://thepointsguy.com/credit-cards/hotel/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 3000,
        "spend_timeframe_months": 3,
        "notes": "30,000 pts (base)"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 4,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "4x only at Hyatt-branded properties; non-Hyatt hotel stays earn 1x",
      "redemption_limits": "No minimum Hyatt redemption; points don't expire with qualifying activity",
      "apr": "20.49%–27.49% Variable",
      "companion_elite_benefits": "Y — Discoverist status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    },
    {
      "program_id": "wyndham_rewards_earner",
      "program_name": "Wyndham Rewards Earner",
      "issuer": "Barclays",
      "network": "Visa",
      "currency_name": "Points",
      "annual_fee": 75,
      "effective_annual_fee": "75",
      "base_cpp": 0.01,
      "tpg_cpp": 0.01,
      "portal_cpp": null,
      "has_transfer_fee": false,
      "expiry_policy": "inactivity_18mo",
      "data_as_of": "2026-03-02",
      "last_updated": "2026-03-02",
      "issuer_effective_date": null,
      "known_change_event": null,
      "review_frequency_months": 12,
      "notes": "Auto Wyndham Gold status; anniversary free night at entry-tier properties; Wyndham Rewards entry card",
      "source_url": "https://www.barclays.us/credit-cards/wyndham-rewards-earner/",
      "contributor": "palstack-team",
      "welcome_bonus": {
        "points": null,
        "cash_amount": null,
        "spend_requirement": 2000,
        "spend_timeframe_months": 3,
        "notes": "40,000 pts"
      },
      "earn_categories": [
        {
          "category": "hotels_direct",
          "multiplier": 6,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "dining",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "groceries",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "gas",
          "multiplier": 2,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "travel_portal",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "flights_direct",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "streaming",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "transit",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "online_shopping",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "advertising",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "drugstores",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        },
        {
          "category": "other",
          "multiplier": 1,
          "cap_amount": null,
          "cap_period": null,
          "multiplier_fallback": 1,
          "card_variant": null,
          "notes": null
        }
      ],
      "transfer_partners": [],
      "foreign_transaction_fee_pct": 0,
      "category_exceptions": "6x only at Wyndham brands (Days Inn, Super 8, Ramada, La Quinta, etc.)",
      "redemption_limits": "Points expire 18 months inactivity",
      "apr": "20.24%–29.99% Variable",
      "companion_elite_benefits": "Y — Gold status auto",
      "payment_method_requirement": "None",
      "bonus_cap_conditional": "None"
    }
  ]
}
PALSTACK_EOF

cat > 'package.json' << 'PALSTACK_EOF'
{
  "name": "pointpal-community",
  "version": "1.0.0",
  "description": "Community-maintained credit card points & rewards database for the palStack ecosystem",
  "private": true,
  "scripts": {
    "validate": "node scripts/validate.js",
    "validate:file": "node scripts/validate.js",
    "compile": "node scripts/compile.js",
    "build": "npm run validate && npm run compile"
  },
  "keywords": ["credit-cards", "rewards", "points", "palstack", "finpal"],
  "license": "MIT",
  "engines": {
    "node": ">=18"
  }
}

PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/_template.json' << 'PALSTACK_EOF'
{
  "_instructions": "Copy this file to programs/<program_id>.json. Delete all keys starting with underscore before submitting your PR.",

  "program_id": "your_program_id_here",
  "_note_program_id": "snake_case only. Must exactly match the filename. Example: chase_sapphire_reserve",

  "program_name": "Full Card Name Here",
  "issuer": "Bank or Issuer Name",
  "network": "Visa",
  "_note_network": "One of: Visa, Mastercard, Amex, Discover",

  "currency_name": "Points",
  "_note_currency": "One of: Points, Miles, Cash Back",

  "annual_fee": 0,
  "_note_annual_fee": "USD. Use 0 for no-fee cards.",

  "base_cpp": 1.0,
  "_note_base_cpp": "Cents-per-point at the simplest redemption (cash/statement credit). Usually 1.0.",

  "tpg_cpp": null,
  "_note_tpg_cpp": "Estimated max value per TPG, NerdWallet, or equivalent. Cite your source_url.",

  "portal_cpp": 1.0,
  "_note_portal_cpp": "Value when booking through the issuer's own travel portal.",

  "has_transfer_fee": false,
  "_note_transfer_fee": "true if the issuer charges a fee on transfers (e.g. Amex charges $0.0006/pt to US airlines, max $99).",

  "expiry_policy": "account_closure",
  "_note_expiry": "One of: account_closure, no_expiry, inactivity_18mo, inactivity_24mo, varies",

  "data_as_of": "YYYY-MM-DD",
  "_note_data_as_of": "The date you verified these earn rates. Format: YYYY-MM-DD",

  "last_updated": "YYYY-MM-DD",
  "_note_last_updated": "Date of your most recent edit to this file.",

  "issuer_effective_date": null,
  "_note_issuer_effective_date": "If the issuer made a recent known change, put that date here. Otherwise null.",

  "known_change_event": null,
  "_note_known_change_event": "Plain English description of the last issuer change. e.g. 'Jun 2025: earn rates restructured, 3x travel removed'",

  "review_frequency_months": 12,
  "_note_review_frequency": "How often this card's rates should be re-verified. Use 3 for rotating-category cards, 6 for recent launches, 12 for stable cards.",

  "notes": null,
  "_note_notes": "Any nuances, restrictions, or context. No affiliate links.",

  "source_url": "",
  "_note_source_url": "URL verifying the earn rates and/or cpp values. Required if tpg_cpp is set.",

  "contributor": "",
  "_note_contributor": "Your GitHub username.",

  "welcome_bonus": {
    "points": 0,
    "_note_points": "Welcome bonus amount. Use 0 if cash (e.g. $200 bonus → use cash_amount instead).",
    "cash_amount": null,
    "_note_cash_amount": "For cash-back cards, the dollar value of the welcome bonus.",
    "spend_requirement": 0,
    "spend_timeframe_months": 3,
    "notes": null
  },

  "earn_categories": [
    {
      "category": "other",
      "_note_category": "Use ONLY approved slugs from SLUG_REFERENCE.md. See README for full list.",
      "multiplier": 1.0,
      "_note_multiplier": "Points or percent per $1 spent. e.g. 3.0 for 3x points, or 3.0 for 3% cash back.",
      "cap_amount": null,
      "_note_cap_amount": "Dollar cap before fallback rate kicks in. null = no cap.",
      "cap_period": null,
      "_note_cap_period": "One of: monthly, quarterly, annual. null if no cap.",
      "multiplier_fallback": 1.0,
      "_note_fallback": "Rate after cap is hit. Usually 1.0.",
      "card_variant": null,
      "_note_card_variant": "If this rate only applies to one version of the card, put its identifier here. null = applies to all.",
      "notes": null
    }
  ],

  "transfer_partners": [
    {
      "partner_name": "Airline or Hotel Program Name",
      "ratio": "1:1",
      "_note_ratio": "Transfer ratio as from:to. e.g. '1:2' means 1 program point = 2 partner points.",
      "type": "airline",
      "_note_type": "One of: airline, hotel",
      "est_cpp": null,
      "_note_est_cpp": "Estimated cents per point when redeemed via this partner. Cite source_url.",
      "notes": null
    }
  ]
}

PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/alaska_airlines_visa_signature.json' << 'PALSTACK_EOF'
{
  "program_id": "alaska_airlines_visa_signature",
  "program_name": "Alaska Airlines Visa Signature",
  "issuer": "Bank of America",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.015,
  "tpg_cpp": 0.015,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Free first checked bag (saves $35/bag); companion fare from $23 (taxes/fees); priority boarding; Alaska's Mileage Plan has strongest domestic partner network (Oneworld + partners)",
  "source_url": "https://www.bankofamerica.com/credit-cards/products/alaska-airlines-credit-card/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 miles"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3x only on Alaska Airlines flights; 2x on dining",
  "redemption_limits": "Miles never expire",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_blue_cash_everyday.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_blue_cash_everyday",
  "program_name": "Amex Blue Cash Everyday",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$7/mo Disney streaming credit; no annual fee; good for everyday spending without managing a premium card",
  "source_url": "https://www.cnbc.com/select/amex-blue-cash-everyday-vs-preferred/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash (varies)"
  },
  "earn_categories": [
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": 6000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": 6000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 3.0,
      "cap_amount": 6000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Each bonus category (grocery, gas, online retail) has its own separate $6k/yr cap; grocery excludes superstores/warehouse clubs",
  "redemption_limits": "Pure cash back only \u2014 no transfer partners",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Each of 3 bonus categories independently capped at $6,000/yr"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_blue_cash_preferred.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_blue_cash_preferred",
  "program_name": "Amex Blue Cash Preferred",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Cash Back",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2025-10-01",
  "known_change_event": "Disney streaming credit raised from $7/mo to $10/mo",
  "review_frequency_months": 12,
  "notes": "$10/mo Disney streaming credit (Disney+, Hulu, ESPN+); intro $0 AF first year then $95; best grocery cash-back card; no transfer partners \u2014 pure cash back",
  "source_url": "https://wallethub.com/d/american-express-blue-cash-preferred-547c",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "$300 cash (varies)"
  },
  "earn_categories": [
    {
      "category": "groceries",
      "multiplier": 6.0,
      "cap_amount": 6000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6% only at US supermarkets \u2014 excludes superstores (Walmart/Target), warehouse clubs; 3% transit includes taxis/rideshare/parking/trains",
  "redemption_limits": "Reward Dollars redeemable as statement credit or Amazon checkout; no transfer to points programs",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Grocery 6% cap: $6,000/yr; after cap earns 1%"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_business_gold.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_business_gold",
  "program_name": "Amex Business Gold",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 375.0,
  "effective_annual_fee": "375",
  "base_cpp": 0.01,
  "tpg_cpp": 0.02,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$240 FedEx/Grubhub/office supply credit ($20/mo); $155 Walmart+ credit; auto hotel Gold status (Marriott/Hilton) if holding Business Platinum too",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 15000.0,
    "spend_timeframe_months": 3,
    "notes": "100,000 pts"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 4.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 4.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 4.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 4.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "4x on top 2 categories only \u2014 the other 4 earn 1x each billing cycle; category selection is automatic, cannot be manually overridden",
  "redemption_limits": "$150k combined annual cap across both top-2 categories; once-per-lifetime offer",
  "apr": "18.49%\u201327.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$150,000/yr combined cap on all 4x earning across both auto-selected categories"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_business_platinum.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_business_platinum",
  "program_name": "Amex Business Platinum",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 695.0,
  "effective_annual_fee": "695",
  "base_cpp": 0.01,
  "tpg_cpp": 0.02,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$400 Dell tech credit/yr; $360 Indeed credit/yr; $150 Adobe credit/yr; $120 wireless credit; Global Lounge (1,550+ lounges); auto Hilton Gold + Marriott Gold; Global Entry; 35% points rebate on business-class AmexTravel bookings",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 20000.0,
    "spend_timeframe_months": 3,
    "notes": "200,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": 500000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 5.0,
      "cap_amount": 500000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "1.5x cap: $2M/yr on purchases \u2265$5k; transfer fee to US domestic airlines; 5x flights cap $500k/yr",
  "redemption_limits": "35% rebate only on business/first via AmexTravel; once-per-lifetime offer; credits are complex quarterly/annual use-or-lose",
  "apr": "18.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Hilton Gold + Marriott Gold auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$500k flight cap; $2M cap on 1.5x large purchases; all credits fragmented"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_gold.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_gold",
  "program_name": "Amex Gold",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 325.0,
  "effective_annual_fee": "85",
  "base_cpp": 0.01,
  "tpg_cpp": 0.02,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 6,
  "notes": "$120 dining credit ($10/mo, select partners); $120 Uber Cash ($10/mo); $100 Resy credit ($50 semi-annually); The Hotel Collection $100 property credit on 2+ night stays; no foreign transaction fees",
  "source_url": "https://thepointsguy.com/credit-cards/amex-platinum-vs-amex-gold/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 6000.0,
    "spend_timeframe_months": 3,
    "notes": "100,000 pts (varies)"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 4.0,
      "cap_amount": 50000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 4.0,
      "cap_amount": 25000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "4x grocery at US supermarkets only \u2014 excludes warehouse clubs, superstores; transfer fee $0.0006/pt (max $99) to US domestic airlines",
  "redemption_limits": "Once-per-lifetime welcome offer; portal redeems at 1cpp \u2014 always better to transfer to partners",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Dining cap: $50k/yr; Grocery cap: $25k/yr; credits are monthly/semi-annual use-or-lose"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_green.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_green",
  "program_name": "Amex Green",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 150.0,
  "effective_annual_fee": "1",
  "base_cpp": 0.01,
  "tpg_cpp": 0.02,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$199 CLEAR Plus credit; $100 LoungeBuddy credit; no foreign transaction fees; good entry-level MR card before applying for Gold",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Transfer fee $0.0006/pt (max $99) to US domestic airlines; 3x on transit \u2014 taxis, rideshare, parking, trains",
  "redemption_limits": "Once-per-lifetime offer per card family \u2014 apply for Green before Gold (Amex family rules)",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/amex_platinum.json' << 'PALSTACK_EOF'
{
  "program_id": "amex_platinum",
  "program_name": "Amex Platinum",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 895.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.02,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2025-07-01",
  "known_change_event": "Jul 2025 AF raised to $895; new credits: Resy $400/yr, Lululemon $300/yr, entertainment $300/yr, hotel credit raised to $600/yr",
  "review_frequency_months": 6,
  "notes": "$200 airline fee credit; $600 hotel credit (FHR/Hotel Collection); $200 Uber Cash; $400 Resy credit; $300 Equinox; $300 entertainment; $100 Saks; Global Lounge Collection (1,550+ lounges); auto Hilton Gold + Marriott Gold; Global Entry/TSA PreCheck",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 12000.0,
    "spend_timeframe_months": 3,
    "notes": "175,000 pts (varies)"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": 500000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 5.0,
      "cap_amount": 500000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "5x only on flights direct with airline or AmexTravel; all other travel 1x; transfer fee on US domestic airline partners ($0.0006/pt max $99)",
  "redemption_limits": "Once-per-lifetime welcome offer per card family; transfer in 1,000-pt increments; $99 max transfer fee to US airlines",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "Y \u2014 Hilton Gold + Marriott Gold auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$500,000/yr cap on 5x flight earning; all credits are use-it-or-lose-it monthly/quarterly"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/apple_card.json' << 'PALSTACK_EOF'
{
  "program_id": "apple_card",
  "program_name": "Apple Card",
  "issuer": "Apple / Goldman Sachs",
  "network": "Mastercard",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "3% at Apple + select merchants (Nike, Uber, Walgreens, etc.); 2% on all Apple Pay transactions; 1% physical card; Daily Cash deposited daily to Apple Cash; titanium physical card; no fees of any kind",
  "source_url": "https://www.apple.com/apple-card/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 credit"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3% list of merchants is limited and fixed; 2% requires using Apple Pay (not the physical card); cash back deposited daily as Apple Cash",
  "redemption_limits": "Daily Cash redeemable via Apple Pay or Apple Cash balance; no transfer to airline/hotel programs",
  "apr": "15.99%\u201326.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "Must use Apple Pay for 2%; physical card earns 1% only",
  "bonus_cap_conditional": "3% merchant list is fixed; must use iPhone/Apple Pay"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/bilt_mastercard_obsidian.json' << 'PALSTACK_EOF'
{
  "program_id": "bilt_mastercard_obsidian",
  "program_name": "Bilt Mastercard (Obsidian)",
  "issuer": "Bilt",
  "network": "Mastercard",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.022,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-02-07",
  "known_change_event": "Bilt 2.0 launched Feb 7 2026: new Obsidian card, Cardless replaces Wells Fargo as issuer; Bilt Cash earning option added",
  "review_frequency_months": 3,
  "notes": "Earn points on rent + mortgage with no transaction fee (unique to Bilt); 4% Bilt Cash on everyday spend (if Flexible option selected); 5x on Lyft; World of Hyatt + AA + United transfers; highest TPG valuation (2.2cpp) as of Feb 2026",
  "source_url": "https://thepointsguy.com/loyalty-programs/bilt-rewards-guide/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts + Gold status"
  },
  "earn_categories": [
    {
      "category": "transit",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": 25000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Must choose dining OR groceries for 3x at card setup \u2014 cannot earn 3x on both simultaneously; 3x groceries capped at $25k/yr; must make 5+ non-rent transactions/month to earn points on rent",
  "redemption_limits": "Transfer in 1,000-pt increments; rent points transfer at separate rate",
  "apr": "21.24%\u201329.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "Must make 5+ non-rent purchases/month to earn rent points",
  "bonus_cap_conditional": "Cannot choose both dining AND groceries for 3x; must pick one at signup (changeable annually in January)"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/bilt_palladium.json' << 'PALSTACK_EOF'
{
  "program_id": "bilt_palladium",
  "program_name": "Bilt Palladium",
  "issuer": "Bilt",
  "network": "Mastercard",
  "currency_name": "Points",
  "annual_fee": 495.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.022,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-02-07",
  "known_change_event": "Bilt 2.0 launched Feb 7 2026: new Palladium flagship card (Cardless issuer)",
  "review_frequency_months": 3,
  "notes": "$200 Bilt Travel hotel credit 2x/yr (2-night min; $400 annual hotel value); $200 Bilt Cash annually; Priority Pass guest access; Bilt 2.0 flagship card; highest-value transferable points (2.2cpp per TPG Feb 2026)",
  "source_url": "https://thepointsguy.com/loyalty-programs/bilt-rewards-guide/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts + Gold status"
  },
  "earn_categories": [
    {
      "category": "transit",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "$495 AF partially offset by $400 hotel credit + $200 Bilt Cash = effective $95 if maximized; 2x on rent/mortgage requires spending Bilt Cash to unlock",
  "redemption_limits": "Transfer in 1,000-pt increments; Priority Pass is guest access (not primary membership for non-Palladium), varies by status",
  "apr": "21.24%\u201329.49% Variable",
  "companion_elite_benefits": "Y \u2014 Priority Pass guest access",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 flat 2x on all purchases with no caps"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/blue_business_plus_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "blue_business_plus_amex",
  "program_name": "Blue Business Plus (Amex)",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.02,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; expanded purchasing power (no preset spending limit); best no-AF MR earner; part of Amex business trifecta with Gold + Platinum",
  "source_url": "https://www.nerdwallet.com/credit-cards/best/american-express-cards",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "15,000 pts"
  },
  "earn_categories": [
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": 50000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x limited to $50k/yr then drops to 1x on all purchases",
  "redemption_limits": "Transfer to MR partners requires any Membership Rewards-earning card (no additional requirement)",
  "apr": "17.74%\u201325.74% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$50,000/yr combined cap on all 2x earning"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/bofa_customized_cash_rewards.json' << 'PALSTACK_EOF'
{
  "program_id": "bofa_customized_cash_rewards",
  "program_name": "BofA Customized Cash Rewards",
  "issuer": "Bank of America",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-05-27",
  "known_change_event": "BofA Rewards rebrand May 2026: 75% boost now requires $1M balance (was $100k); former Platinum \u2192 Preferred Plus (25% boost)",
  "review_frequency_months": 3,
  "notes": "Change 3% category once per month online; BofA Rewards boost stacks on top (10%\u201375% extra depending on balance tier); first-year 6% on choice category",
  "source_url": "https://www.mymoneyblog.com/bank-of-america-bofa-rewards-changes-2026.html",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": 2500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": 2500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": 2500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": 2500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 3.0,
      "cap_amount": 2500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "$2,500/quarter COMBINED cap on both the 3% choice cat AND 2% grocery/wholesale together \u2014 not separate caps; BofA Rewards boost restructuring May 2026",
  "redemption_limits": "Rewards never expire while account open; $25 minimum for check redemption (no minimum for direct deposit or statement credit)",
  "apr": "18.24%\u201328.24% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$2,500/quarter combined cap: choice cat + grocery + wholesale clubs all count toward same limit"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/bofa_premium_rewards.json' << 'PALSTACK_EOF'
{
  "program_id": "bofa_premium_rewards",
  "program_name": "BofA Premium Rewards",
  "issuer": "Bank of America",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-05-27",
  "known_change_event": "BofA Rewards rebrand May 2026 affects boost tiers",
  "review_frequency_months": 6,
  "notes": "$300 airline incidental credit; $150 lifestyle credit; Global Entry/TSA PreCheck credit; no foreign transaction fees; BofA Rewards boost applies",
  "source_url": "https://frequentmiler.com/negative-bank-of-america-preferred-rewards-upcoming-changes-lower-bonus-rewards-higher-eligibility-requirements/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Travel and dining broadly defined; boost percentages changing May 2026",
  "redemption_limits": "No minimum redemption \u2014 can redeem for any amount; no transfer to airline/hotel programs",
  "apr": "20.24%\u201327.24% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 2x travel/dining uncapped; 1.5x base uncapped"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/bofa_travel_rewards.json' << 'PALSTACK_EOF'
{
  "program_id": "bofa_travel_rewards",
  "program_name": "BofA Travel Rewards",
  "issuer": "Bank of America",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-05-27",
  "known_change_event": "BofA Rewards rebrand May 2026",
  "review_frequency_months": 12,
  "notes": "No annual fee; no foreign transaction fees; BofA Rewards boost applicable; redeem against any travel purchase as statement credit",
  "source_url": "https://frequentmiler.com/negative-bank-of-america-preferred-rewards-upcoming-changes-lower-bonus-rewards-higher-eligibility-requirements/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "25,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "No transfer partners; points only redeemable as statement credit against travel purchases; no other redemption options at travel value",
  "redemption_limits": "Minimum redemption $1 for statement credit against travel; 100 pt minimum for other options",
  "apr": "19.24%\u201329.24% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 flat 1.5x uncapped"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/capital_one_savor_cash_rewards.json' << 'PALSTACK_EOF'
{
  "program_id": "capital_one_savor_cash_rewards",
  "program_name": "Capital One Savor Cash Rewards",
  "issuer": "Capital One",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "8% on Capital One Entertainment purchases; no annual fee; cash back redeemable at any time with no minimum; no foreign transaction fees",
  "source_url": "https://smartsmssolutions.com/resources/blog/business/best-travel-rewards-credit-cards",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3% grocery excludes superstores like Walmart/Target; streaming 3% applies to most services",
  "redemption_limits": "No minimum redemption",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/capital_one_savorone.json' << 'PALSTACK_EOF'
{
  "program_id": "capital_one_savorone",
  "program_name": "Capital One SavorOne",
  "issuer": "Capital One",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; 3% dining, groceries (excl. superstores), streaming; 8% Capital One Entertainment; 10% cash back on Uber/Uber Eats through 11/14/2024; no foreign transaction fees",
  "source_url": "https://smartsmssolutions.com/resources/blog/business/best-travel-rewards-credit-cards",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3% grocery excludes superstores (Walmart/Target); streaming 3% on major services",
  "redemption_limits": "No minimum redemption",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 all 3% categories uncapped"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/capital_one_venture.json' << 'PALSTACK_EOF'
{
  "program_id": "capital_one_venture",
  "program_name": "Capital One Venture",
  "issuer": "Capital One",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0185,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 6,
  "notes": "$250 Capital One Travel credit first year; up to $120 Global Entry/TSA PreCheck credit; travel eraser option; Lifestyle Collection hotel perks; no foreign transaction fees",
  "source_url": "https://thepointsguy.com/credit-cards/capital-one-miles-vs-chase-ultimate-rewards/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4000.0,
    "spend_timeframe_months": 3,
    "notes": "75,000 miles + $250 C1 Travel credit"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "5x only via Capital One Travel \u2014 not direct bookings; $250 travel credit is first-year only",
  "redemption_limits": "No minimum redemption; travel eraser at 1cpp; transfer in 1,000-mile increments",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$250 first-year travel credit \u2014 not recurring annually"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/capital_one_venture_x.json' << 'PALSTACK_EOF'
{
  "program_id": "capital_one_venture_x",
  "program_name": "Capital One Venture X",
  "issuer": "Capital One",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 395.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0185,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 6,
  "notes": "$300 annual travel credit via Capital One Travel; 10,000 anniversary miles (worth ~$100 toward travel); Priority Pass + Capital One Lounge access; up to $120 Global Entry/TSA PreCheck credit; no foreign transaction fees",
  "source_url": "https://wallethub.com/d/capital-one-venture-x-3361c",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4000.0,
    "spend_timeframe_months": 3,
    "notes": "75,000 miles"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 10.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "10x/5x only via Capital One Travel portal \u2014 not direct airline/hotel bookings; $300 credit only for C1 Travel bookings",
  "redemption_limits": "No minimum redemption; travel eraser covers any travel purchase at 1cpp; transfer in 1,000-mile increments",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Priority Pass + Capital One Lounges",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$300 credit restricted to Capital One Travel bookings only"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/capital_one_ventureone.json' << 'PALSTACK_EOF'
{
  "program_id": "capital_one_ventureone",
  "program_name": "Capital One VentureOne",
  "issuer": "Capital One",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0185,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; entry card for Capital One miles ecosystem; no foreign transaction fees; transfer to 15+ airline partners",
  "source_url": "https://thepointsguy.com/credit-cards/capital-one-miles-vs-chase-ultimate-rewards/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "20,000 miles"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.25,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "5x only via C1 Travel portal; no Global Entry credit unlike Venture/Venture X",
  "redemption_limits": "Transfer in 1,000-mile increments",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_freedom_flex.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_freedom_flex",
  "program_name": "Chase Freedom Flex",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-01-01",
  "known_change_event": "Q1 2026: dining + NCL + AHA rotating 5x categories",
  "review_frequency_months": 3,
  "notes": "World Elite Mastercard perks: cell phone insurance, Lyft discounts; pairs with Sapphire for full UR value",
  "source_url": "https://www.bankrate.com/credit-cards/cash-back/guide-to-chase-freedom-bonus-categories/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 3.0,
      "cap_amount": 1.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Must activate quarterly bonus; rotating categories change every 3 months",
  "redemption_limits": "Requires transferable-UR card to unlock transfer partners",
  "apr": "19.49%\u201328.24% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$1,500/quarter combined cap on all 5x rotating categories; no cap on 3x dining/drugstores"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_freedom_unlimited.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_freedom_unlimited",
  "program_name": "Chase Freedom Unlimited",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; pairs with Sapphire/Ink Preferred to unlock UR transfer partners; best no-AF personal catch-all",
  "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "None",
  "redemption_limits": "Requires transferable-UR card to unlock transfer partners",
  "apr": "19.49%\u201328.24% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_ink_business_cash.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_ink_business_cash",
  "program_name": "Chase Ink Business Cash",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; pairs with Sapphire/Ink Preferred to unlock transfer partners and full UR value",
  "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 0,
    "spend_timeframe_months": 3,
    "notes": "$350 + $400 tiered cash"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": 25000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": 25000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Wholesale clubs, superstores not included in grocery/office supply bonus",
  "redemption_limits": "Requires a transferable-UR card (Sapphire/Ink Preferred) to transfer points; otherwise redeems at 1cpp",
  "apr": "18.49%\u201324.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$25,000 annual cap on office supplies + cable/phone combined"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_ink_business_preferred.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_ink_business_preferred",
  "program_name": "Chase Ink Business Preferred",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Cell phone protection up to $1,000; primary rental car coverage; transfers to all Chase travel partners",
  "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 8000.0,
    "spend_timeframe_months": 3,
    "notes": "100,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 3.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 3.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": 150000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Non-employee cardholders do not earn UR; $150k combined cap across all 3x categories",
  "redemption_limits": "Transfer in 1,000-pt increments; no minimum cash redemption",
  "apr": "20.49%\u201326.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$150,000 annual combined cap across all 3x bonus categories \u2014 not per-category"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_ink_business_unlimited.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_ink_business_unlimited",
  "program_name": "Chase Ink Business Unlimited",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; best no-AF business catch-all card; pairs with Sapphire/Ink Preferred to unlock UR transfers",
  "source_url": "https://thepointsguy.com/loyalty-programs/chase-ultimate-rewards/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 6000.0,
    "spend_timeframe_months": 3,
    "notes": "$750 cash"
  },
  "earn_categories": [
    {
      "category": "other",
      "multiplier": 1.5,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "None",
  "redemption_limits": "Requires a transferable-UR card to unlock transfer partners",
  "apr": "18.49%\u201324.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_sapphire_preferred.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_sapphire_preferred",
  "program_name": "Chase Sapphire Preferred",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "45",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2025-06-23",
  "known_change_event": "Jun 2025 CSR restructure made CSP best card for 2x general travel purchases",
  "review_frequency_months": 6,
  "notes": "$50 annual hotel credit via Chase Travel; 10% anniversary bonus on prior year spend; DashPass complimentary through 12/31/27",
  "source_url": "https://www.cnbc.com/select/chase-sapphire-reserve-review/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 5000.0,
    "spend_timeframe_months": 3,
    "notes": "75,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "In-store groceries earn 1x only; online grocery cap $6,000/yr",
  "redemption_limits": "No minimum redemption for statement credit; transfer in 1,000-pt increments",
  "apr": "19.74%\u201326.74% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Points Boost up to 1.75cpp on select portal bookings (hotels/flights) \u2014 not all bookings"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/chase_sapphire_reserve.json' << 'PALSTACK_EOF'
{
  "program_id": "chase_sapphire_reserve",
  "program_name": "Chase Sapphire Reserve",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 795.0,
  "effective_annual_fee": "495",
  "base_cpp": 0.01,
  "tpg_cpp": 0.0205,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2025-10-26",
  "known_change_event": "Oct 2025: Points Boost activated; fixed 1.5cpp portal removed; 3x general travel \u2192 1x",
  "review_frequency_months": 3,
  "notes": "$300 travel credit; Priority Pass + CSR Lounge access; IHG Platinum Elite (auto); Points Boost up to 2cpp on select portal bookings; no foreign transaction fees",
  "source_url": "https://thepointsguy.com/loyalty-programs/monthly-valuations/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 6000.0,
    "spend_timeframe_months": 3,
    "notes": "125,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 8.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "General travel (parking, transit, vacation rentals) now 1x as of Oct 2025",
  "redemption_limits": "Points do not expire while account open; transfer to partners in 1,000-pt increments",
  "apr": "17.49%\u201324.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Points Boost applies to select airlines/hotels only \u2014 not all portal bookings"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/choice_privileges_visa.json' << 'PALSTACK_EOF'
{
  "program_id": "choice_privileges_visa",
  "program_name": "Choice Privileges Visa",
  "issuer": "Barclays",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 49.0,
  "effective_annual_fee": "49",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_18mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto Choice Privileges Gold status; no foreign transaction fees; Choice Hotels entry card",
  "source_url": "https://www.barclays.us/credit-cards/choice-privileges/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 8.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "8x only at Choice brand properties",
  "redemption_limits": "Points expire 18 months inactivity",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Gold status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/choice_privileges_visa_business.json' << 'PALSTACK_EOF'
{
  "program_id": "choice_privileges_visa_business",
  "program_name": "Choice Privileges Visa Business",
  "issuer": "Barclays",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 49.0,
  "effective_annual_fee": "49",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_18mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Business version of Choice card; auto Gold status; no foreign transaction fees",
  "source_url": "https://www.barclays.us/credit-cards/choice-privileges/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 8.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "8x only at Choice brand properties",
  "redemption_limits": "Points expire 18 months inactivity",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Gold status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_aadvantage_executive.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_aadvantage_executive",
  "program_name": "Citi AAdvantage Executive",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Miles",
  "annual_fee": 595.0,
  "effective_annual_fee": "595",
  "base_cpp": 0.015,
  "tpg_cpp": 0.015,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Admirals Club lounge membership; free first + second checked bag for up to 4 companions; priority boarding; preferred boarding; 10,000 Loyalty Points bonus on $40k+ spend",
  "source_url": "https://money.usnews.com/credit-cards/signup-bonus",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 10000.0,
    "spend_timeframe_months": 3,
    "notes": "100,000 miles"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "4x only on AA-operated flights; all other airlines earn 1x",
  "redemption_limits": "AAdvantage miles expire after 24 months of inactivity",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "Y \u2014 Admirals Club membership + priority boarding",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 no annual cap on 4x AA earning"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_aadvantage_mileup.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_aadvantage_mileup",
  "program_name": "Citi AAdvantage MileUp",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Miles",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.014,
  "tpg_cpp": 0.014,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; 25% inflight savings; entry-level AA card; no free checked bag",
  "source_url": "https://money.usnews.com/credit-cards/signup-bonus",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "15,000 miles"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x only on American Airlines-operated flights; 2x on US grocery stores",
  "redemption_limits": "AAdvantage miles expire 24 months inactivity",
  "apr": "20.49%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_aadvantage_platinum_select.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_aadvantage_platinum_select",
  "program_name": "Citi AAdvantage Platinum Select",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Miles",
  "annual_fee": 99.0,
  "effective_annual_fee": "99",
  "base_cpp": 0.014,
  "tpg_cpp": 0.014,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Free first checked bag for cardholder + up to 4 companions; priority boarding; $125 AA flight discount after $20k spend/yr; preferred boarding",
  "source_url": "https://money.usnews.com/credit-cards/signup-bonus",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2500.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 miles"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x only on AA-operated flights; 2x US groceries/gas",
  "redemption_limits": "AAdvantage miles expire 24 months inactivity",
  "apr": "20.49%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_custom_cash.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_custom_cash",
  "program_name": "Citi Custom Cash",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.019,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-01-01",
  "known_change_event": "Bonus promo: +4% on Citi Travel hotels/cars/attractions through Jun 30 2026 (stacks if travel is top cat \u2192 9%)",
  "review_frequency_months": 3,
  "notes": "Automatically maximizes 5% in your top category \u2014 no manual selection needed; eligible categories: grocery, gas, restaurants, select travel, select transit, streaming, drugstores, home improvement, live entertainment; pair with Strata Premier for transfer value",
  "source_url": "https://financebuzz.com/citi-custom-cash-card-review",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 5.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 5.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 5.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": 500,
      "cap_period": "monthly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Only ONE category earns 5% per billing cycle \u2014 auto-selected by highest spend; if you split spend evenly across categories you may not maximize it",
  "redemption_limits": "$500/month cap on 5% earning; after cap all purchases earn 1%; must have Strata card to unlock transfer partners",
  "apr": "18.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$500/month = $6,000/year maximum 5x earning"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_double_cash.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_double_cash",
  "program_name": "Citi Double Cash",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.019,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Best no-AF catch-all card when paired with Strata Premier \u2014 converts cash back to transferable ThankYou points at full value; 18 months 0% intro APR on balance transfers",
  "source_url": "https://upgradedpoints.com/credit-cards/citi-thankyou-rewards-points-faqs/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x requires paying your balance to earn the second 1%; must have a Strata card to unlock TY point transfers",
  "redemption_limits": "Must be combined with a Strata card to access transfer partners; otherwise 1cpp cash redemption only",
  "apr": "18.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 unlimited 2% on all purchases"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_prestige_card.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_prestige_card",
  "program_name": "Citi Prestige Card",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Points",
  "annual_fee": 495.0,
  "effective_annual_fee": "495",
  "base_cpp": 0.01,
  "tpg_cpp": 0.019,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2022-01-01",
  "known_change_event": "Closed to new applicants ~2022; existing cardholders grandfathered",
  "review_frequency_months": 12,
  "notes": "CLOSED TO NEW APPLICANTS. Existing cardholders only. 4th night free on hotel bookings of 4+ nights (unlimited); Priority Pass Select; $250 annual travel credit; Global Entry/TSA PreCheck",
  "source_url": "https://upgradedpoints.com/credit-cards/citi-thankyou-rewards-points-faqs/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 5000.0,
    "spend_timeframe_months": 3,
    "notes": "75,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "No longer available to new applicants \u2014 legacy card; 4th night free is per booking, unlimited uses per year",
  "redemption_limits": "Transfer to TY partners in 1,000-pt increments",
  "apr": "19.74%\u201327.74% Variable",
  "companion_elite_benefits": "Y \u2014 Priority Pass + 4th night free",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "4th night free requires 4+ consecutive nights at same property"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_strata_elite.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_strata_elite",
  "program_name": "Citi Strata Elite",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Points",
  "annual_fee": 595.0,
  "effective_annual_fee": "595",
  "base_cpp": 0.01,
  "tpg_cpp": 0.019,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2025-06-01",
  "known_change_event": "Citi Strata Elite launched mid-2025 as new premium flagship",
  "review_frequency_months": 6,
  "notes": "Premium Citi card launched 2025; airport lounge access (Priority Pass); $595 AF; strong transfer partner roster including Turkish + EVA Air + AA (restored Jul 2025)",
  "source_url": "https://upgradedpoints.com/credit-cards/citi-thankyou-rewards-points-faqs/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 6000.0,
    "spend_timeframe_months": 3,
    "notes": "75,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 12.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x dining only applies 6pm\u20136am ET; 12x portal only at CitiTravel; grocery/gas 3x with no cap",
  "redemption_limits": "Transfer in 1,000-pt increments; no minimum redemption",
  "apr": "20.49%\u201328.49% Variable",
  "companion_elite_benefits": "Y \u2014 Priority Pass Select",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "6x dining time restriction (6pm\u20136am ET) is a key limitation for lunch/brunch spenders"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/citi_strata_premier.json' << 'PALSTACK_EOF'
{
  "program_id": "citi_strata_premier",
  "program_name": "Citi Strata Premier",
  "issuer": "Citi",
  "network": "Mastercard",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.01,
  "tpg_cpp": 0.019,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2024-06-01",
  "known_change_event": "Rebranded from Citi Premier; new purchase + travel protections added mid-2024",
  "review_frequency_months": 6,
  "notes": "$100 annual hotel credit ($500+ booking via Citi Travel \u2014 single booking only); strong transfer partners (Turkish, EVA Air, AA, Flying Blue); anchor of Citi trifecta (pair with Double Cash)",
  "source_url": "https://www.bankrate.com/credit-cards/reviews/citi-strata-premier-card/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 10.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "10x portal only at CitiTravel; $100 hotel credit requires minimum $500 single booking; no lounge access",
  "redemption_limits": "Transfer in 1,000-pt increments; no minimum redemption",
  "apr": "20.49%\u201328.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$100 hotel credit: requires $500+ single booking \u2014 budget stays don't qualify"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/delta_skymiles_blue_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "delta_skymiles_blue_amex",
  "program_name": "Delta SkyMiles Blue Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Miles",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.012,
  "tpg_cpp": 0.012,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; entry-level Delta card; no free checked bag; 2x on Delta + 1x everywhere else",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "30,000 miles"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x only on Delta flights",
  "redemption_limits": "SkyMiles never expire but low transfer value",
  "apr": "20.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/delta_skymiles_gold_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "delta_skymiles_gold_amex",
  "program_name": "Delta SkyMiles Gold Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Miles",
  "annual_fee": 150.0,
  "effective_annual_fee": "0",
  "base_cpp": 0.012,
  "tpg_cpp": 0.012,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Free first checked bag (saves $35/bag one-way); priority boarding; 20% back on eligible inflight purchases; up to $200 annual flight credit after $10k spend; intro $0 AF first year then $150",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 5000.0,
    "spend_timeframe_months": 3,
    "notes": "90,000 miles (tiered thru Apr 1 2026)"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x only at Delta or US supermarkets \u2014 all other airlines earn 1x",
  "redemption_limits": "SkyMiles never expire but are worth significantly less than MR/UR when transferred",
  "apr": "20.49%\u201329.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/delta_skymiles_platinum_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "delta_skymiles_platinum_amex",
  "program_name": "Delta SkyMiles Platinum Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Miles",
  "annual_fee": 350.0,
  "effective_annual_fee": "250",
  "base_cpp": 0.012,
  "tpg_cpp": 0.012,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Free first checked bag; annual companion cert (main cabin domestic); Global Entry/TSA PreCheck credit; priority boarding; $100 Delta credit/yr",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4000.0,
    "spend_timeframe_months": 3,
    "notes": "70,000 miles (tiered thru Apr 1 2026)"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3x only on Delta-operated flights",
  "redemption_limits": "SkyMiles never expire",
  "apr": "20.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/delta_skymiles_reserve_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "delta_skymiles_reserve_amex",
  "program_name": "Delta SkyMiles Reserve Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Miles",
  "annual_fee": 650.0,
  "effective_annual_fee": "450",
  "base_cpp": 0.012,
  "tpg_cpp": 0.012,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 6,
  "notes": "Delta Sky Club lounge access when flying Delta; annual domestic companion cert (main cabin); free first + second checked bag; companion cert for companion tickets; 15,000 MQD boost toward Medallion status",
  "source_url": "https://thepointsguy.com/credit-cards/american-express/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 6000.0,
    "spend_timeframe_months": 3,
    "notes": "100,000 miles + 25,000 (tiered thru Apr 1 2026)"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3x only on Delta purchases \u2014 all other airlines earn 1x; Sky Club access only when flying on Delta",
  "redemption_limits": "SkyMiles never expire",
  "apr": "21.49%\u201330.49% Variable",
  "companion_elite_benefits": "Y \u2014 Sky Club + Medallion boost",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/discover_it_cash_back.json' << 'PALSTACK_EOF'
{
  "program_id": "discover_it_cash_back",
  "program_name": "Discover it Cash Back",
  "issuer": "Discover",
  "network": "Discover",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-01-01",
  "known_change_event": "Q1 2026 rotating categories: restaurants + drugstores",
  "review_frequency_months": 3,
  "notes": "Cashback Match first year: if you earn $300 cash back, Discover gives you another $300 \u2014 effectively 10% on rotating cats + 2% base in year 1; no annual fee; no foreign transaction fees; freeze card via app",
  "source_url": "https://frequentmiler.com/q1-2026-activation-links-for-cards-offering-5-in-rotating-categories/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 0,
    "spend_timeframe_months": 3,
    "notes": "Cashback Match (all yr1 earnings doubled)"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 5.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 5.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 5.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": 1500,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Must activate bonus each quarter online or via app; rotating categories change quarterly \u2014 must track schedule; Q1 2026: restaurants + drugstores",
  "redemption_limits": "No minimum redemption; redeem at any time",
  "apr": "17.49%\u201326.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$1,500/quarter cap on 5% rotating categories"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/hilton_honors_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "hilton_honors_amex",
  "program_name": "Hilton Honors Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.006,
  "tpg_cpp": 0.006,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto Hilton Silver status; access to American Express Experiences; no annual fee makes it a great keeper card even without heavy Hilton use",
  "source_url": "https://money.usnews.com/credit-cards/american-express",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "70,000 pts + Free Night"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "7x at Hilton only; 5x restricted to US merchants for supermarkets and gas",
  "redemption_limits": "Hilton points expire after 12 months of inactivity",
  "apr": "20.49%\u201329.49% Variable",
  "companion_elite_benefits": "Y \u2014 Silver status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/hilton_honors_amex_business.json' << 'PALSTACK_EOF'
{
  "program_id": "hilton_honors_amex_business",
  "program_name": "Hilton Honors Amex Business",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 195.0,
  "effective_annual_fee": "195",
  "base_cpp": 0.006,
  "tpg_cpp": 0.006,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto Gold Elite; $120 Hilton credit/yr ($10/mo); free night after $15k spend/yr; no foreign transaction fees; business version",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "130,000 pts"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 12.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 12.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "12x only at Hilton brands; 6x restricted to US merchants",
  "redemption_limits": "Points expire 12 months inactivity",
  "apr": "20.99%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Gold status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/hilton_honors_amex_nofee.json' << 'PALSTACK_EOF'
{
  "program_id": "hilton_honors_amex_nofee",
  "program_name": "Hilton Honors Amex (no-fee)",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.006,
  "tpg_cpp": 0.006,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; auto Hilton Silver status; access to Amex Experiences; great keeper card for Hilton loyalists",
  "source_url": "https://money.usnews.com/credit-cards/american-express",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "70,000 pts + Free Night"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "7x only at Hilton properties; 5x at US merchants only (not international grocery/gas)",
  "redemption_limits": "Hilton points expire 12 months inactivity",
  "apr": "20.99%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Silver status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/hilton_honors_aspire_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "hilton_honors_aspire_amex",
  "program_name": "Hilton Honors Aspire Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 550.0,
  "effective_annual_fee": "250",
  "base_cpp": 0.006,
  "tpg_cpp": 0.006,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 6,
  "notes": "Auto Diamond Elite status (best Hilton status); annual Free Night Award (any property, any price); $400 Hilton resort credit/yr ($200 semi-annually); $200 airline fee credit; Priority Pass Select (unlimited visits); no foreign transaction fees",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 6000.0,
    "spend_timeframe_months": 3,
    "notes": "175,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 14.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 7.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "14x only at Hilton; 7x on direct airline + restaurants + car rentals; grocery/gas earn 3x base only",
  "redemption_limits": "Annual free night has no cap \u2014 can be used at any property worldwide",
  "apr": "21.49%\u201330.49% Variable",
  "companion_elite_benefits": "Y \u2014 Diamond Elite auto + unlimited Priority Pass",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Resort credit: must be used at specific Hilton resort properties only"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/hilton_honors_surpass_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "hilton_honors_surpass_amex",
  "program_name": "Hilton Honors Surpass Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 150.0,
  "effective_annual_fee": "150",
  "base_cpp": 0.006,
  "tpg_cpp": 0.006,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$200 Hilton credit/yr ($50/quarter direct at Hilton properties); auto Gold status; free night after $15k spend/yr; 10 Priority Pass lounge visits/yr",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "130,000 pts + Free Night"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 12.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 12.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "12x only at Hilton properties; 6x restricted to US merchants",
  "redemption_limits": "Hilton points expire after 12 months of inactivity",
  "apr": "20.49%\u201329.49% Variable",
  "companion_elite_benefits": "Y \u2014 Gold status auto + 10 Priority Pass visits",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Free night cert requires $15,000 spend/yr"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/hyatt_credit_card_nofee.json' << 'PALSTACK_EOF'
{
  "program_id": "hyatt_credit_card_nofee",
  "program_name": "Hyatt Credit Card (no-fee)",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.017,
  "tpg_cpp": 0.017,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; Discoverist status auto; free night cert (Cat 1-4) each anniversary; World of Hyatt entry card",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "30,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "4x only at Hyatt brands",
  "redemption_limits": "Hyatt points don't expire with qualifying activity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Discoverist auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/ihg_one_rewards_premier.json' << 'PALSTACK_EOF'
{
  "program_id": "ihg_one_rewards_premier",
  "program_name": "IHG One Rewards Premier",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 99.0,
  "effective_annual_fee": "99",
  "base_cpp": 0.005,
  "tpg_cpp": 0.005,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto IHG Platinum Elite; anniversary free night; 4th night free on award stays; $100 IHG credit on 2+ night stays; Global Entry/TSA PreCheck credit",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 5000.0,
    "spend_timeframe_months": 3,
    "notes": "175,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 26.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "26x only at IHG properties; non-IHG travel earns 5x card rate only",
  "redemption_limits": "IHG points expire after 12 months of inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 IHG Platinum Elite auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/ihg_one_rewards_premier_business.json' << 'PALSTACK_EOF'
{
  "program_id": "ihg_one_rewards_premier_business",
  "program_name": "IHG One Rewards Premier Business",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 99.0,
  "effective_annual_fee": "99",
  "base_cpp": 0.005,
  "tpg_cpp": 0.005,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto IHG Platinum Elite; anniversary free night; 4th night free on award stays; Global Entry/TSA PreCheck credit; business card",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "90,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 26.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "26x only at IHG brands",
  "redemption_limits": "IHG points expire 12 months inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 IHG Platinum Elite auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/ihg_one_rewards_traveler.json' << 'PALSTACK_EOF'
{
  "program_id": "ihg_one_rewards_traveler",
  "program_name": "IHG One Rewards Traveler",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.005,
  "tpg_cpp": 0.005,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; IHG One Rewards entry card; IHG Silver status; 4th night free on award stays",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "70,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 15.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "15x only at IHG brands",
  "redemption_limits": "IHG points expire after 12 months inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "N \u2014 Silver status (not auto Platinum)",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/jetblue_card.json' << 'PALSTACK_EOF'
{
  "program_id": "jetblue_card",
  "program_name": "JetBlue Card",
  "issuer": "Barclays",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.014,
  "tpg_cpp": 0.014,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; no foreign transaction fees; 6x on JetBlue purchases; 50% off inflight food and drinks",
  "source_url": "https://www.barclays.us/credit-cards/jetblue/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "40,000 pts"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x only on JetBlue bookings",
  "redemption_limits": "TrueBlue points never expire",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/jetblue_plus_card.json' << 'PALSTACK_EOF'
{
  "program_id": "jetblue_plus_card",
  "program_name": "JetBlue Plus Card",
  "issuer": "Barclays",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 99.0,
  "effective_annual_fee": "99",
  "base_cpp": 0.014,
  "tpg_cpp": 0.014,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Free first checked bag; 5,000 anniversary bonus pts; 50% off inflight; upgrade to Mint mosaic status at $50k spend; no foreign transaction fees",
  "source_url": "https://www.barclays.us/credit-cards/jetblue-plus/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 pts"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x only on JetBlue",
  "redemption_limits": "TrueBlue points never expire",
  "apr": "19.99%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/marriott_bonvoy_bold.json' << 'PALSTACK_EOF'
{
  "program_id": "marriott_bonvoy_bold",
  "program_name": "Marriott Bonvoy Bold",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.007,
  "tpg_cpp": 0.007,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "No annual fee; Marriott Bonvoy entry card; auto Silver Elite; 15 Elite Night Credits/yr",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3x only at Marriott brands",
  "redemption_limits": "Marriott points expire 24 months inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Silver Elite auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/marriott_bonvoy_boundless.json' << 'PALSTACK_EOF'
{
  "program_id": "marriott_bonvoy_boundless",
  "program_name": "Marriott Bonvoy Boundless",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.007,
  "tpg_cpp": 0.007,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Annual free night cert (up to 35k points); auto Silver Elite; 15 Elite Night Credits toward next tier; bonus 1 night credit per stay",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "5 Free Night Awards (up to 250k pts total)"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x only at Marriott Bonvoy brands",
  "redemption_limits": "Marriott points expire after 24 months of inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Silver Elite auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/marriott_bonvoy_brilliant_amex.json' << 'PALSTACK_EOF'
{
  "program_id": "marriott_bonvoy_brilliant_amex",
  "program_name": "Marriott Bonvoy Brilliant Amex",
  "issuer": "American Express",
  "network": "Amex",
  "currency_name": "Points",
  "annual_fee": 650.0,
  "effective_annual_fee": "350",
  "base_cpp": 0.007,
  "tpg_cpp": 0.007,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto Platinum Elite (top earnable status); annual free night cert (up to 85k pts); 25 Elite Night Credits/yr; $300 Marriott credit/yr; $100 property credit on 2+ night stays; Priority Pass Select",
  "source_url": "https://upgradedpoints.com/credit-cards/american-express-card-levels/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "130,000 pts + Free Night"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x only at Marriott Bonvoy brands",
  "redemption_limits": "Marriott points expire after 24 months of inactivity",
  "apr": "19.49%\u201328.49% Variable",
  "companion_elite_benefits": "Y \u2014 Platinum Elite auto + Priority Pass",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$300 Marriott credit: must be used at Marriott properties directly"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/radisson_rewards_premier_visa.json' << 'PALSTACK_EOF'
{
  "program_id": "radisson_rewards_premier_visa",
  "program_name": "Radisson Rewards Premier Visa",
  "issuer": "Bank of America",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 75.0,
  "effective_annual_fee": "75",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_12mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto Radisson Gold status; annual free night after $10k spend; no foreign transaction fees",
  "source_url": "https://www.bankofamerica.com/credit-cards/products/radisson/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x at Radisson group properties (Park Inn, Country Inn, etc.)",
  "redemption_limits": "Points expire 12 months inactivity",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Gold status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/southwest_rapid_rewards_plus.json' << 'PALSTACK_EOF'
{
  "program_id": "southwest_rapid_rewards_plus",
  "program_name": "Southwest Rapid Rewards Plus",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 69.0,
  "effective_annual_fee": "69",
  "base_cpp": 0.015,
  "tpg_cpp": 0.015,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-01-27",
  "known_change_event": "Southwest assigned seating launched Jan 27 2026; Plus card: standard seat selection only (no preferred)",
  "review_frequency_months": 12,
  "notes": "Lowest-cost Southwest card; 3,000 anniversary pts; first checked bag free; 10,000 Companion Pass qualifying pts boost/yr",
  "source_url": "https://money.usnews.com/credit-cards/chase/southwest-rapid-rewards-plus-credit-card",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "Companion Pass + 20,000 pts"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": 5000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": 5000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Grocery+gas cap: $5,000/yr combined; no preferred seating (Priority only)",
  "redemption_limits": "Points expire 24 months inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$5,000/yr combined cap on 2x groceries+gas"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/southwest_rapid_rewards_premier.json' << 'PALSTACK_EOF'
{
  "program_id": "southwest_rapid_rewards_premier",
  "program_name": "Southwest Rapid Rewards Premier",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 99.0,
  "effective_annual_fee": "99",
  "base_cpp": 0.015,
  "tpg_cpp": 0.015,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-01-27",
  "known_change_event": "Southwest assigned seating Jan 2026; Premier: standard boarding (no preferred seat selection)",
  "review_frequency_months": 12,
  "notes": "Mid-tier Southwest card; 6,000 anniversary pts; first checked bag free; A-List preferred boarding; 10,000 Companion Pass qualifying pts boost/yr",
  "source_url": "https://money.usnews.com/credit-cards/chase/southwest-rapid-rewards-plus-credit-card",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "Companion Pass + 20,000 pts"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": 5000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": 5000,
      "cap_period": "annual",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Grocery+gas cap: $5,000/yr combined",
  "redemption_limits": "Points expire 24 months inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$5,000/yr combined cap on 2x groceries+gas"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/southwest_rapid_rewards_priority.json' << 'PALSTACK_EOF'
{
  "program_id": "southwest_rapid_rewards_priority",
  "program_name": "Southwest Rapid Rewards Priority",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 229.0,
  "effective_annual_fee": "129",
  "base_cpp": 0.015,
  "tpg_cpp": 0.015,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_24mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-01-27",
  "known_change_event": "Southwest launched assigned seating Jan 27 2026; Priority card gains preferred seat selection perk",
  "review_frequency_months": 6,
  "notes": "$75 Southwest travel credit/yr; 7,500 anniversary points; 4 upgraded boarding passes/yr; 25% back on inflight purchases; 10,000 Companion Pass qualifying pts boost/yr; preferred seat selection (Jan 2026 assigned seating)",
  "source_url": "https://thepointsguy.com/credit-cards/southwest-priority-value/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "Companion Pass + 20,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Points only transferable within Southwest Rapid Rewards; no airline partners",
  "redemption_limits": "Points expire after 24 months of inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Companion Pass qualifying boost",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None for dining/gas/SW; no combined cap on Priority card unlike Plus/Premier"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/united_club_card.json' << 'PALSTACK_EOF'
{
  "program_id": "united_club_card",
  "program_name": "United Club Card",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 595.0,
  "effective_annual_fee": "595",
  "base_cpp": 0.012,
  "tpg_cpp": 0.0135,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-04-02",
  "known_change_event": "Apr 2026 MileagePlus changes: Club cardholders earn 6 mi/$1 on United flights base",
  "review_frequency_months": 3,
  "notes": "United Club membership for primary cardholder + immediate family or 2 guests; free first + second checked bag; Premier Access (priority check-in/boarding/security); 10% award discount (Apr 2026)",
  "source_url": "https://awardwallet.com/news/united-mileageplus/mileage-earning-changes-2026/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 5000.0,
    "spend_timeframe_months": 3,
    "notes": "90,000 miles"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Non-United purchases earn 1x base",
  "redemption_limits": "No expiry while account open and active",
  "apr": "21.49%\u201328.49% Variable",
  "companion_elite_benefits": "Y \u2014 United Club lounge membership",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/united_explorer_card.json' << 'PALSTACK_EOF'
{
  "program_id": "united_explorer_card",
  "program_name": "United Explorer Card",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.012,
  "tpg_cpp": 0.0135,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_18mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-04-02",
  "known_change_event": "Apr 2026: cardholder earn on United flights raised to 6 mi/$1 (was 5); basic economy earns 0 mi for non-cardholders; 10% award discount unlocked",
  "review_frequency_months": 3,
  "notes": "Free first checked bag (saves up to $35/bag); 2 United Club one-time passes/yr; priority boarding; 10%+ award discount starting Apr 2026; primary CDW",
  "source_url": "https://awardwallet.com/news/united-mileageplus/mileage-earning-changes-2026/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "70,000 miles"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Non-United purchases earn 1x base",
  "redemption_limits": "Points expire after 18 months of account inactivity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 no annual cap on bonus categories"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/united_gateway_card.json' << 'PALSTACK_EOF'
{
  "program_id": "united_gateway_card",
  "program_name": "United Gateway Card",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Miles",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.013,
  "tpg_cpp": 0.013,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_18mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2026-04-02",
  "known_change_event": "Apr 2026: basic economy earns 0 mi without card or elite status",
  "review_frequency_months": 12,
  "notes": "No annual fee; no foreign transaction fees; 2x on United + gas; entry-level United card; basic economy miles earn (requires card after Apr 2026)",
  "source_url": "https://awardwallet.com/news/united-mileageplus/mileage-earning-changes-2026/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 miles"
  },
  "earn_categories": [
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "2x United + gas only; no free checked bag",
  "redemption_limits": "Miles expire 18 months inactivity",
  "apr": "20.99%\u201327.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/us_bank_altitude_connect.json' << 'PALSTACK_EOF'
{
  "program_id": "us_bank_altitude_connect",
  "program_name": "US Bank Altitude Connect",
  "issuer": "US Bank",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0 yr1; $95 thereafter",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$30/yr streaming credit (after 11 consecutive months of streaming purchases); 4 Priority Pass visits/yr; TSA PreCheck/Global Entry credit; no foreign transaction fees; no transfer partners",
  "source_url": "https://financebuzz.com/us-bank-altitude-connect-visa-signature-review",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": 1.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 5.0,
      "cap_amount": 1.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": 1.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 4.0,
      "cap_amount": 1000,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": 1.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": 1.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "No transfer partners \u2014 Altitude Points fixed at 1cpp; 4x gas capped at $1,000/quarter; 5x only via Altitude Travel Center (not direct airline/hotel bookings)",
  "redemption_limits": "No minimum redemption; Real-Time Rewards lets you redeem instantly via text",
  "apr": "19.24%\u201329.24% Variable",
  "companion_elite_benefits": "N \u2014 4 Priority Pass visits/yr only",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$1,000/quarter cap on 4x gas earning; all other bonus categories uncapped"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/us_bank_altitude_go.json' << 'PALSTACK_EOF'
{
  "program_id": "us_bank_altitude_go",
  "program_name": "US Bank Altitude Go",
  "issuer": "US Bank",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "$15 annual streaming credit (after 11 consecutive months of streaming purchases); no annual fee; no foreign transaction fees",
  "source_url": "https://www.usbank.com/credit-cards/altitude-go-visa-signature-credit-card.html",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "20,000 pts"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "No transfer partners; Altitude Points fixed at 1cpp; dining broadly includes restaurants, food delivery, bars",
  "redemption_limits": "No minimum redemption; Real-Time Rewards instant redemption via text",
  "apr": "19.24%\u201329.24% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 4x dining uncapped"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/us_bank_altitude_reserve.json' << 'PALSTACK_EOF'
{
  "program_id": "us_bank_altitude_reserve",
  "program_name": "US Bank Altitude Reserve",
  "issuer": "US Bank",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 400.0,
  "effective_annual_fee": "75",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2024-11-01",
  "known_change_event": "Closed to new applicants Nov 2024; existing cardholders retain all benefits",
  "review_frequency_months": 12,
  "notes": "CLOSED TO NEW APPLICANTS Nov 2024. Existing cardholders only. $325 annual travel+dining credit; Priority Pass Select (unlimited); Global Entry; 1.5cpp redemption toward travel (best Altitude rate)",
  "source_url": "https://financebuzz.com/us-bank-altitude-reserve-visa-infinite-card-review",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4500.0,
    "spend_timeframe_months": 3,
    "notes": "50,000 pts"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "3x mobile wallet on up to $5,000/billing cycle; no transfer partners \u2014 points fixed value",
  "redemption_limits": "1.5cpp when redeemed for travel via Altitude Rewards Center; no airline/hotel transfers",
  "apr": "19.24%\u201329.24% Variable",
  "companion_elite_benefits": "Y \u2014 Priority Pass unlimited",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "Mobile wallet 3x: up to $5,000/billing cycle"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/us_bank_cash.json' << 'PALSTACK_EOF'
{
  "program_id": "us_bank_cash",
  "program_name": "US Bank Cash+",
  "issuer": "US Bank",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 3,
  "notes": "Must choose categories each quarter before activation deadline; 5% categories include niche options not on other cards (gym, ground transport, home utilities); no annual fee; 0% intro APR for 15 months",
  "source_url": "https://www.cnbc.com/select/us-bank-cash-vs-citi-custom-cash/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 5.0,
      "cap_amount": 2.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 5.0,
      "cap_amount": 2000,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": "or 2% (depending on chosen categories)"
    },
    {
      "category": "gas",
      "multiplier": 5.0,
      "cap_amount": 2000,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": "or 2% (depending)"
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": 2.0,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": 2000,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": 2000,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": 2000,
      "cap_period": "quarterly",
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "Must activate each quarter; if no activation, earns 1% on everything; 5% categories are pre-defined list only \u2014 cannot choose arbitrary categories",
  "redemption_limits": "$2,000/quarter cap per 5% category; separate caps for each of the two chosen 5% categories",
  "apr": "19.74%\u201329.74% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "$2,000/quarter per 5% category = $8,000/yr max per category"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/wells_fargo_active_cash.json' << 'PALSTACK_EOF'
{
  "program_id": "wells_fargo_active_cash",
  "program_name": "Wells Fargo Active Cash",
  "issuer": "Wells Fargo",
  "network": "Visa",
  "currency_name": "Cash Back",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Cell phone protection up to $600; no annual fee; no foreign transaction fees; 0% intro APR for 15 months",
  "source_url": "https://www.lendingtree.com/credit-cards/articles/what-are-wells-fargo-go-far-rewards-worth/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 500.0,
    "spend_timeframe_months": 3,
    "notes": "$200 cash"
  },
  "earn_categories": [
    {
      "category": "travel_portal",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "None",
  "redemption_limits": "No minimum cash back redemption",
  "apr": "19.24%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 truly unlimited 2% everywhere"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/wells_fargo_autograph.json' << 'PALSTACK_EOF'
{
  "program_id": "wells_fargo_autograph",
  "program_name": "Wells Fargo Autograph",
  "issuer": "Wells Fargo",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 0,
  "effective_annual_fee": "0",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Cell phone protection; Autograph Card Exclusives; no annual fee; no foreign transaction fees; growing transfer partner roster",
  "source_url": "https://www.nerdwallet.com/credit-cards/learn/wells-fargo-autograph-journey-vs-capital-one-venture",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 1000.0,
    "spend_timeframe_months": 3,
    "notes": "20,000 pts"
  },
  "earn_categories": [
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "hotels_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "1x on groceries and general travel; transfer partners limited vs Chase/Amex",
  "redemption_limits": "No minimum redemption",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None \u2014 all 3x categories are uncapped"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/wells_fargo_autograph_journey.json' << 'PALSTACK_EOF'
{
  "program_id": "wells_fargo_autograph_journey",
  "program_name": "Wells Fargo Autograph Journey",
  "issuer": "Wells Fargo",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "45",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": "2024-03-01",
  "known_change_event": "Launched March 2024",
  "review_frequency_months": 12,
  "notes": "$50 annual airline statement credit; cell phone protection up to $1,000; Autograph Card Exclusives (live event access); no foreign transaction fees",
  "source_url": "https://www.bankrate.com/credit-cards/reviews/wells-fargo-autograph-journey-comparison/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 4000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 5.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 3.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "5x only on direct hotel bookings (not via portal); 4x only on direct airline bookings; grocery/gas/streaming earn 1x",
  "redemption_limits": "No minimum redemption; transfer to international airline partners only (no US domestic partners)",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "N",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/world_of_hyatt_business_card.json' << 'PALSTACK_EOF'
{
  "program_id": "world_of_hyatt_business_card",
  "program_name": "World of Hyatt Business Card",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 199.0,
  "effective_annual_fee": "199",
  "base_cpp": 0.017,
  "tpg_cpp": 0.017,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Annual free night cert (Cat 1-4); up to 5 Category 1-7 free night cert with $50k spend; Discoverist status; 5 Elite Night Credits/yr toward next tier",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 5000.0,
    "spend_timeframe_months": 3,
    "notes": "60,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 9.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "9x only at Hyatt properties \u2014 non-Hyatt hotels earn 1x",
  "redemption_limits": "Points don't expire with qualifying activity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Discoverist auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/world_of_hyatt_credit_card.json' << 'PALSTACK_EOF'
{
  "program_id": "world_of_hyatt_credit_card",
  "program_name": "World of Hyatt Credit Card",
  "issuer": "Chase",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 95.0,
  "effective_annual_fee": "95",
  "base_cpp": 0.017,
  "tpg_cpp": 0.017,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "account_closure",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Annual free night cert (Cat 1-4, up to 15k pts/night); auto Discoverist status; 2 bonus Qualifying Night Credits per stay; 5 Elite Night Credits/yr toward next status tier",
  "source_url": "https://thepointsguy.com/credit-cards/hotel/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 3000.0,
    "spend_timeframe_months": 3,
    "notes": "30,000 pts (base)"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 4.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "4x only at Hyatt-branded properties; non-Hyatt hotel stays earn 1x",
  "redemption_limits": "No minimum Hyatt redemption; points don't expire with qualifying activity",
  "apr": "20.49%\u201327.49% Variable",
  "companion_elite_benefits": "Y \u2014 Discoverist status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "programs"
cat > 'programs/wyndham_rewards_earner.json' << 'PALSTACK_EOF'
{
  "program_id": "wyndham_rewards_earner",
  "program_name": "Wyndham Rewards Earner",
  "issuer": "Barclays",
  "network": "Visa",
  "currency_name": "Points",
  "annual_fee": 75.0,
  "effective_annual_fee": "75",
  "base_cpp": 0.01,
  "tpg_cpp": 0.01,
  "portal_cpp": null,
  "has_transfer_fee": false,
  "expiry_policy": "inactivity_18mo",
  "data_as_of": "2026-03-02",
  "last_updated": "2026-03-02",
  "issuer_effective_date": null,
  "known_change_event": null,
  "review_frequency_months": 12,
  "notes": "Auto Wyndham Gold status; anniversary free night at entry-tier properties; Wyndham Rewards entry card",
  "source_url": "https://www.barclays.us/credit-cards/wyndham-rewards-earner/",
  "contributor": "palstack-team",
  "welcome_bonus": {
    "points": null,
    "cash_amount": null,
    "spend_requirement": 2000.0,
    "spend_timeframe_months": 3,
    "notes": "40,000 pts"
  },
  "earn_categories": [
    {
      "category": "hotels_direct",
      "multiplier": 6.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "dining",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "groceries",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "gas",
      "multiplier": 2.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "travel_portal",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "flights_direct",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "streaming",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "transit",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "online_shopping",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "advertising",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "drugstores",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    },
    {
      "category": "other",
      "multiplier": 1.0,
      "cap_amount": null,
      "cap_period": null,
      "multiplier_fallback": 1.0,
      "card_variant": null,
      "notes": null
    }
  ],
  "transfer_partners": [],
  "foreign_transaction_fee_pct": 0,
  "category_exceptions": "6x only at Wyndham brands (Days Inn, Super 8, Ramada, La Quinta, etc.)",
  "redemption_limits": "Points expire 18 months inactivity",
  "apr": "20.24%\u201329.99% Variable",
  "companion_elite_benefits": "Y \u2014 Gold status auto",
  "payment_method_requirement": "None",
  "bonus_cap_conditional": "None"
}
PALSTACK_EOF

mkdir -p "scripts"
cat > 'scripts/compile.js' << 'PALSTACK_EOF'
#!/usr/bin/env node
/**
 * pointPal — Compiler
 * Reads all programs/*.json and writes dist/programs.json + dist/index.json
 * Run: node scripts/compile.js
 */

const fs   = require('fs');
const path = require('path');

const PROGRAMS_DIR = path.join(__dirname, '..', 'programs');
const DIST_DIR     = path.join(__dirname, '..', 'dist');

function main() {
  // Ensure dist dir exists
  if (!fs.existsSync(DIST_DIR)) fs.mkdirSync(DIST_DIR, { recursive: true });

  // Load all valid program files
  const files = fs.readdirSync(PROGRAMS_DIR)
    .filter(f => f.endsWith('.json') && !f.startsWith('_'))
    .sort();

  const programs    = [];
  const errors      = [];
  const issuerCounts = {};

  for (const file of files) {
    const filePath = path.join(PROGRAMS_DIR, file);
    try {
      const raw  = fs.readFileSync(filePath, 'utf8');
      const prog = JSON.parse(raw);

      // Strip any leftover template instruction keys
      const cleaned = Object.fromEntries(
        Object.entries(prog).filter(([k]) => !k.startsWith('_'))
      );

      // Also strip from nested arrays
      if (Array.isArray(cleaned.earn_categories)) {
        cleaned.earn_categories = cleaned.earn_categories.map(ec =>
          Object.fromEntries(Object.entries(ec).filter(([k]) => !k.startsWith('_')))
        );
      }
      if (Array.isArray(cleaned.transfer_partners)) {
        cleaned.transfer_partners = cleaned.transfer_partners.map(tp =>
          Object.fromEntries(Object.entries(tp).filter(([k]) => !k.startsWith('_')))
        );
      }

      programs.push(cleaned);
      issuerCounts[cleaned.issuer] = (issuerCounts[cleaned.issuer] || 0) + 1;
      console.log(`  ✓ ${file}`);
    } catch (e) {
      errors.push({ file, error: e.message });
      console.error(`  ✗ ${file}: ${e.message}`);
    }
  }

  if (errors.length > 0) {
    console.error(`\n${errors.length} file(s) failed to compile. Fix JSON errors first.`);
    process.exit(1);
  }

  const generatedAt = new Date().toISOString();

  // Write programs.json — the main file finPal fetches
  const programsOut = {
    generated_at:  generatedAt,
    schema_version: '1.0',
    count:         programs.length,
    programs,
  };
  fs.writeFileSync(
    path.join(DIST_DIR, 'programs.json'),
    JSON.stringify(programsOut, null, 2)
  );

  // Write index.json — lightweight metadata for badges + quick checks
  const indexOut = {
    generated_at:  generatedAt,
    schema_version: '1.0',
    count:         programs.length,
    issuer_counts: issuerCounts,
    program_ids:   programs.map(p => p.program_id),
    stale_programs: programs
      .filter(p => {
        if (!p.data_as_of || !p.review_frequency_months) return false;
        const asOf   = new Date(p.data_as_of);
        const cutoff = new Date();
        cutoff.setMonth(cutoff.getMonth() - p.review_frequency_months);
        return asOf < cutoff;
      })
      .map(p => ({
        program_id: p.program_id,
        program_name: p.program_name,
        data_as_of: p.data_as_of,
        review_frequency_months: p.review_frequency_months,
      })),
  };
  fs.writeFileSync(
    path.join(DIST_DIR, 'index.json'),
    JSON.stringify(indexOut, null, 2)
  );

  console.log(`\n✅ Compiled ${programs.length} programs → dist/programs.json`);
  console.log(`✅ Index written → dist/index.json`);
  if (indexOut.stale_programs.length > 0) {
    console.log(`\n⚠  ${indexOut.stale_programs.length} stale programs (past review date):`);
    indexOut.stale_programs.forEach(p =>
      console.log(`   ${p.program_id} (as of ${p.data_as_of}, review every ${p.review_frequency_months}mo)`)
    );
  }
}

main();

PALSTACK_EOF

mkdir -p "scripts"
cat > 'scripts/validate.js' << 'PALSTACK_EOF'
#!/usr/bin/env node
/**
 * pointPal — Program Validator
 * Validates all JSON files in /programs against the schema rules.
 * Run: node scripts/validate.js
 * Run single file: node scripts/validate.js programs/my_card.json
 */

const fs   = require('fs');
const path = require('path');

const PROGRAMS_DIR = path.join(__dirname, '..', 'programs');

// ── Approved slugs ──────────────────────────────────────────────────────────
const VALID_CATEGORY_SLUGS = new Set([
  'travel_portal', 'flights_direct', 'hotels_direct', 'dining', 'groceries',
  'gas', 'streaming', 'transit', 'online_shopping', 'advertising', 'drugstores',
  'home_improvement', 'office_supplies', 'phone_internet', 'fitness',
  'entertainment', 'rotating', 'mobile_wallet', 'rent_mortgage', 'other',
]);

const VALID_NETWORKS     = new Set(['Visa', 'Mastercard', 'Amex', 'Discover']);
const VALID_CURRENCIES   = new Set(['Points', 'Miles', 'Cash Back']);
const VALID_EXPIRY       = new Set(['account_closure', 'no_expiry', 'inactivity_18mo', 'inactivity_24mo', 'varies']);
const VALID_CAP_PERIODS  = new Set(['monthly', 'quarterly', 'annual']);
const VALID_PARTNER_TYPES = new Set(['airline', 'hotel']);
const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

// ── Validator ────────────────────────────────────────────────────────────────
function validateProgram(filePath, data) {
  const errors   = [];
  const warnings = [];
  const file = path.basename(filePath);

  const err  = (msg) => errors.push(`  ✗ ${msg}`);
  const warn = (msg) => warnings.push(`  ⚠ ${msg}`);

  // Check for leftover template keys
  const templateKeys = Object.keys(data).filter(k => k.startsWith('_'));
  if (templateKeys.length > 0)
    err(`Template instruction keys found (delete before submitting): ${templateKeys.join(', ')}`);

  // program_id must match filename
  const expectedId = file.replace('.json', '');
  if (!data.program_id)          err('Missing required field: program_id');
  else if (data.program_id !== expectedId)
    err(`program_id "${data.program_id}" does not match filename "${expectedId}"`);
  if (!/^[a-z0-9_]+$/.test(data.program_id || ''))
    err('program_id must be snake_case (lowercase letters, numbers, underscores only)');

  // Required string fields
  for (const field of ['program_name', 'issuer', 'currency_name', 'network']) {
    if (!data[field]) err(`Missing required field: ${field}`);
  }

  // Network / currency
  if (data.network && !VALID_NETWORKS.has(data.network))
    err(`Invalid network "${data.network}". Must be one of: ${[...VALID_NETWORKS].join(', ')}`);
  if (data.currency_name && !VALID_CURRENCIES.has(data.currency_name))
    err(`Invalid currency_name "${data.currency_name}". Must be one of: ${[...VALID_CURRENCIES].join(', ')}`);

  // Numeric fields
  if (typeof data.annual_fee !== 'number' || data.annual_fee < 0)
    err('annual_fee must be a non-negative number');
  if (typeof data.base_cpp !== 'number' || data.base_cpp <= 0)
    err('base_cpp must be a positive number');

  // Date fields
  if (!data.data_as_of)          err('Missing required field: data_as_of (YYYY-MM-DD)');
  else if (!DATE_RE.test(data.data_as_of)) err(`data_as_of must be YYYY-MM-DD format, got: "${data.data_as_of}"`);
  if (!data.last_updated)        warn('last_updated is missing — add YYYY-MM-DD');
  else if (!DATE_RE.test(data.last_updated)) err(`last_updated must be YYYY-MM-DD format`);
  if (data.issuer_effective_date && !DATE_RE.test(data.issuer_effective_date))
    err(`issuer_effective_date must be YYYY-MM-DD format`);

  // Check data_as_of is not in the future
  if (data.data_as_of && new Date(data.data_as_of) > new Date())
    err(`data_as_of "${data.data_as_of}" is in the future`);

  // Warn if data is stale (> review_frequency_months old)
  if (data.data_as_of && data.review_frequency_months) {
    const asOf   = new Date(data.data_as_of);
    const cutoff = new Date();
    cutoff.setMonth(cutoff.getMonth() - data.review_frequency_months);
    if (asOf < cutoff)
      warn(`data_as_of is older than ${data.review_frequency_months} months — please re-verify earn rates`);
  }

  // Expiry policy
  if (data.expiry_policy && !VALID_EXPIRY.has(data.expiry_policy))
    warn(`Unusual expiry_policy "${data.expiry_policy}". Common values: ${[...VALID_EXPIRY].join(', ')}`);

  // earn_categories — required
  if (!Array.isArray(data.earn_categories) || data.earn_categories.length === 0) {
    err('earn_categories must be a non-empty array');
  } else {
    const hasBaseRate = data.earn_categories.some(ec => ec.category === 'other' && !ec.card_variant);
    if (!hasBaseRate)
      warn('No base "other" earn category found. Consider adding a catch-all rate.');

    data.earn_categories.forEach((ec, i) => {
      const prefix = `earn_categories[${i}]`;
      if (!ec.category)               err(`${prefix}: missing category`);
      else if (!VALID_CATEGORY_SLUGS.has(ec.category))
        err(`${prefix}: unknown category slug "${ec.category}". See SLUG_REFERENCE.md for valid slugs.`);
      if (typeof ec.multiplier !== 'number' || ec.multiplier <= 0)
        err(`${prefix}: multiplier must be a positive number`);
      if (ec.cap_amount !== null && ec.cap_amount !== undefined) {
        if (typeof ec.cap_amount !== 'number' || ec.cap_amount <= 0)
          err(`${prefix}: cap_amount must be a positive number or null`);
        if (!ec.cap_period)
          err(`${prefix}: cap_amount is set but cap_period is missing`);
        else if (!VALID_CAP_PERIODS.has(ec.cap_period))
          err(`${prefix}: cap_period must be one of: ${[...VALID_CAP_PERIODS].join(', ')}`);
        if (typeof ec.multiplier_fallback !== 'number')
          err(`${prefix}: multiplier_fallback must be a number when cap_amount is set`);
      }
      // Check for leftover template keys inside earn_categories
      const ecTemplateKeys = Object.keys(ec).filter(k => k.startsWith('_'));
      if (ecTemplateKeys.length > 0)
        err(`${prefix}: template instruction keys found: ${ecTemplateKeys.join(', ')}`);
    });
  }

  // transfer_partners
  if (data.transfer_partners) {
    if (!Array.isArray(data.transfer_partners))
      err('transfer_partners must be an array (use [] if none)');
    else data.transfer_partners.forEach((tp, i) => {
      const prefix = `transfer_partners[${i}]`;
      if (!tp.partner_name) err(`${prefix}: missing partner_name`);
      if (!tp.type)         err(`${prefix}: missing type`);
      else if (!VALID_PARTNER_TYPES.has(tp.type))
        err(`${prefix}: type must be "airline" or "hotel"`);
      if (!tp.ratio)        warn(`${prefix}: ratio is missing (assume 1:1?)`);
      if (tp.est_cpp !== null && tp.est_cpp !== undefined && typeof tp.est_cpp !== 'number')
        err(`${prefix}: est_cpp must be a number or null`);
    });
  }

  // tpg_cpp warning without source
  if (data.tpg_cpp && !data.source_url)
    warn('tpg_cpp is set but source_url is empty — please add a citation');

  return { errors, warnings };
}

// ── Main ─────────────────────────────────────────────────────────────────────
function main() {
  const targetFile = process.argv[2]; // optional single-file mode
  let files;

  if (targetFile) {
    files = [path.resolve(targetFile)];
  } else {
    files = fs.readdirSync(PROGRAMS_DIR)
      .filter(f => f.endsWith('.json') && !f.startsWith('_'))
      .map(f => path.join(PROGRAMS_DIR, f));
  }

  let totalErrors   = 0;
  let totalWarnings = 0;
  let passed        = 0;
  let failed        = 0;

  for (const filePath of files) {
    const file = path.basename(filePath);
    let data;
    try {
      data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    } catch (e) {
      console.log(`\n❌ ${file}`);
      console.log(`  ✗ JSON parse error: ${e.message}`);
      failed++;
      totalErrors++;
      continue;
    }

    const { errors, warnings } = validateProgram(filePath, data);

    if (errors.length === 0 && warnings.length === 0) {
      console.log(`✅ ${file}`);
      passed++;
    } else if (errors.length === 0) {
      console.log(`✅ ${file} (${warnings.length} warning${warnings.length > 1 ? 's' : ''})`);
      warnings.forEach(w => console.log(w));
      passed++;
    } else {
      console.log(`\n❌ ${file}`);
      errors.forEach(e => console.log(e));
      if (warnings.length) warnings.forEach(w => console.log(w));
      failed++;
    }

    totalErrors   += errors.length;
    totalWarnings += warnings.length;
  }

  console.log(`\n${'─'.repeat(60)}`);
  console.log(`Validated ${files.length} file${files.length !== 1 ? 's' : ''}: ${passed} passed, ${failed} failed`);
  if (totalWarnings) console.log(`${totalWarnings} warning${totalWarnings !== 1 ? 's' : ''} (non-blocking)`);

  if (totalErrors > 0) {
    console.log(`\n${totalErrors} error${totalErrors !== 1 ? 's' : ''} found. Fix before submitting your PR.`);
    process.exit(1);
  } else {
    console.log('\nAll validations passed ✨');
    process.exit(0);
  }
}

main();

PALSTACK_EOF

echo ""
echo "✅ Done! $(ls programs/*.json | wc -l | tr -d " ") program files created."
echo "Run: node scripts/validate.js  to verify"
echo "Then: git add . && git commit -m \"feat: initial seed\" && git push -u origin main"