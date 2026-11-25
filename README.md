<div align="center">
  <h1>pointsPal</h1>
  <p><strong>An open database of credit card rewards: earn rates, caps and point values.</strong></p>

  <p>
    <a href="https://github.com/palStack-io/pointsPal/actions/workflows/validate.yml"><img alt="Validate" src="https://github.com/palStack-io/pointsPal/actions/workflows/validate.yml/badge.svg"></a>
    <a href="https://github.com/palStack-io/pointsPal/tree/main/programs"><img alt="Programs" src="https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/palStack-io/pointsPal/main/dist/index.json&query=$.count&label=programs&color=15803d"></a>
    <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-blue"></a>
  </p>
</div>

pointsPal is a structured, open dataset of US credit card rewards programs: what each card earns per category,
spending caps and when they reset, transfer partners, and what a point is worth. Each card is one JSON file,
validated on every pull request and compiled into a single file that anyone can use.

It powers the card optimiser in [finPal](https://github.com/palStack-io/finpal-core), which tells you which card to
pay with and when you are about to hit a cap. You can use the data in your own projects too.

## Use the data

The compiled dataset is a single JSON file:

```
https://raw.githubusercontent.com/palStack-io/pointsPal/main/dist/programs.json
```

`dist/index.json` holds the program count and when the file was compiled. finPal fetches `programs.json` once a
night and upserts it into its own database; self-hosters can point `POINTSPAL_SYNC_URL` at a fork or a pinned commit.

## Repository layout

```
programs/           one JSON file per card (start from _template.json)
dist/programs.json  every program, compiled
dist/index.json     count and compile time
scripts/validate.js checks every file against the rules below
scripts/compile.js  builds dist/
SLUG_REFERENCE.md   approved earn-category slugs
```

Validate and compile locally (Node 18 or later): `npm run validate`, `npm run compile`.

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
| `category` | Yes | Approved slug from [SLUG_REFERENCE.md](./SLUG_REFERENCE.md) |
| `multiplier` | Yes | Points/miles/$1 at the bonus rate |
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

## Data guidelines

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

## Contributing

Corrections matter most: earn rates change often. To report a wrong rate or suggest a card, open an issue with the
[new card](https://github.com/palStack-io/pointsPal/issues/new?template=new_card.yml) or
[update card](https://github.com/palStack-io/pointsPal/issues/new?template=update_card.yml) template and include a
link to the issuer's page. We have paused pull requests for now while we work out how to review contributions well;
see [CONTRIBUTING.md](CONTRIBUTING.md) for the data rules. Questions: [Discord](https://discord.gg/mcgcp7RdYs).

## License

[MIT](LICENSE). Use the data and scripts in any project. Card names and trademarks belong to their issuers; this
dataset is not affiliated with or endorsed by any issuer, and it is not financial advice. Check the issuer's terms
before you rely on a rate.

---

<div align="center">
  <sub>Part of <a href="https://palstack.io">palStack.io</a>: everyday tools for food, money, home and friends.</sub>
</div>
