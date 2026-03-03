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

