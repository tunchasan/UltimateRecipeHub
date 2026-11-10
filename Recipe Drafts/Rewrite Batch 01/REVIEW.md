# Rewrite Batch 01 · riskiest recipes (22)

Review page (old vs new, checks, reviewer notes, Approve / Needs changes): "Recipe Rewrites Batch 1" artifact.
Nothing here is in the app yet. After approval: copy the approved files from `drafts/` over the same names in
`The Ultimate Recipe Hub/Resources/Recipes/`, rename the two image assets below, build, open a few recipes, commit.

## What's in this folder
- `drafts/` the rewritten recipe files (same file names and ids; kept fields unchanged).
  New optional fields: `cookware` and `step_ingredients` (the app ignores them until it shows them).
- `facts/` the fact lists the writers worked from (they never saw the original wording).
- `check.py` the automated checks: `python3 check.py drafts <folder with the current recipe files>`.
- `review_findings.json` the independent reviewer's notes; `state` says what happened to each
  (done = applied, cookware = outside the fixed cookware list, decide = a field the rewrite must not change, open = still a suggestion).

## Checks (all 22 pass)
No 6-word run shared with the old description or steps; no amounts in steps; every °F with °C; steps start with a verb,
at most 2 sentences and 35 words; every ingredient used in exactly one step; ingredient totals unchanged (two deliberate
exceptions: Kimchi Fried Rice's eggs now have no "large" unit, and Lomo Saltado's marinade salt and pepper are 1 tsp each,
as its steps always said); id, tags, macros, servings and times unchanged.
Weights (added 10 Nov): every vegetable or fruit of 1 cup or more has a USDA weight as its second amount, within a third of
USDA's grams per cup.

## Weights added (second amount, "about", from USDA FoodData Central SR Legacy)
| Recipe | Line | Weight | USDA source |
|---|---|---|---|
| Kimchi Fried Rice with Nori | 2 cups very ripe kimchi, chopped | about 300 g | Cabbage, kimchi (FDC 170392): 1 cup = 150 g |
| Potato Scallion Cakes | 1½ cups cold leftover mashed potatoes | about 315 g | Potatoes, mashed, home-prepared, whole milk and butter added (FDC 168555): 1 cup = 210 g |
| Lomo Saltado | 1½ cups grape tomatoes, halved | about 225 g | Tomatoes, red, ripe, raw (FDC 170457): 1 cup cherry tomatoes = 149 g (223.5 g, rounded) |

"Grape tomatoes, halved" is measured whole and then cut, so the whole cherry-tomato cup weight applies.
Metric readers and the grocery list now see the grams. US readers still see cups.

## Renamed (rename the image asset in Assets.xcassets to the new name)
| Id | Old name | New name |
|---|---|---|
| 00000000a5_16 | Honey Cloud Souffle Pancakes | Fluffy Honey Souffle Pancakes |
| 0000000075_110 | Potato Scallion Cakes (Fritterra) | Potato Scallion Cakes |

The dishes didn't change, so the current photos still fit. Image prompts, if you want new photos anyway:
- Fluffy Honey Souffle Pancakes: one tall, golden souffle pancake in a small black skillet, drizzled with honey,
  a light dusting of powdered sugar, a few berries beside it; house style: overhead three-quarter angle, soft daylight,
  light wood table.
- Potato Scallion Cakes: a stack of small golden potato cakes flecked with green scallion on a white plate,
  a little bowl of sour cream beside them; house style as above.

## Decisions for you (fields the rewrite must not change; nothing was changed in them)
- Wrong diet tags shown to users today: Kimchi Fried Rice (vegetarian, halal; has pork luncheon meat),
  Pasta with Chickpeas (vegan; has Parmigiano), Smashed Potatoes With Bacon & Eggs (halal),
  Chocolate Caramel Crispy (vegan; butter and milk chocolate). Likely more across the library.
- Brand in a tag: Kimchi Fried Rice has the tag "Spam".
- Times that look short: Broccoli Frittata, Potato Scallion Cakes, Pork Piccata, Souffle Pancakes, Vegan Waffles;
  Soy Sauce Eggs leaves out the 2-hour soak.
- Lomo Saltado's cuisine is "Spanish"; it is Peruvian.
- Cookware values have no waffle iron: add `waffle_iron`?
