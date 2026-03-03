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

