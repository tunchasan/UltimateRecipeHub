# Checks for rewritten recipes (Recipe Library Cleanup: rewrite rules, rule 9, cookware).
# Usage: python3 check.py DRAFT_DIR OLD_DIR [--json out.json]
# Prints one line per problem: SEVERITY | recipe | what. FAIL must be fixed; CHECK needs a human look.
import json, glob, os, re, sys

DRAFT, OLD = sys.argv[1], sys.argv[2]
OUT = sys.argv[sys.argv.index('--json') + 1] if '--json' in sys.argv else None
SIGN_OFF = "You nailed it! Grab a plate and dig in."
COOKWARE = {'skillet': r'skillet|frying pan|\bpan\b|griddle', 'pot': r'\bpot\b|saucepan|dutch oven|stockpot',
            'baking_sheet': r'baking sheet|sheet pan|baking dish|baking tin|baking pan|loaf pan|casserole dish|roasting pan|tart pan|pie dish|muffin tin',
            'whisk': r'\bwhisk', 'oven': r'\boven\b|\bbroil', 'blender': r'blender|food processor|\bblend\b|\bblitz|\bpuree\b|\bpurée\b',
            'slow_cooker': r'slow cooker|instant pot|pressure cooker', 'mixer': r'\bmixer\b', 'grill': r'\bgrill',
            'microwave': r'microwave', 'wok': r'\bwok\b', 'air_fryer': r'air fryer'}
UNITS = {'', 'tsp', 'tbsp', 'cup', 'fl oz', 'pint', 'quart', 'oz', 'lb', 'g', 'kg', 'ml', 'l', 'inch', 'inch piece', 'clove', 'slice',
         'piece', 'sprig', 'handful', 'pinch', 'dash', 'can', 'tin', 'stick', 'head', 'packet', 'package', 'jar', 'sheet', 'strip',
         'ear', 'stalk', 'leaf', 'drop', 'bunch', 'small', 'medium', 'large', 'whole', 'to taste', 'for serving', 'for garnish',
         'as needed', 'for frying', 'for greasing', 'for drizzling', 'for sprinkling', 'for dusting', 'for brushing', 'splash', 'fillet', 'bar'}
AMOUNT = re.compile(r'(\d+(?:[./]\d+)?|[½¼¾⅓⅔⅛])\s*-?\s*(cups?|tbsp|tablespoons?|tsp|teaspoons?|oz|ounces?|lbs?|pounds?|g|grams?|kg|ml|l|litres?|liters?|pints?|quarts?|sticks?|cloves?|pinch(?:es)?)\b', re.I)
BRANDS = re.compile(r"\b(Nutella|Spam|Rice Krispies|Cholula|Almond Breeze|Smithfield|Mars|Diamond Crystal|Sriracha|Tabasco|Shin Ramyun|Kewpie|Old Bay|Goya|Momofuku|Milk Street|Food52)\b")
PEOPLE = re.compile(r"\b(chef|cookbook|grandm\w+|my (mother|mom|dad|father|family)|inspired by|adapted from|recipe (by|from)|\bI\b|\bI'm\b|\bI've\b|\bmy\b|\bwe\b|\bour\b)", re.I)
NOT_VERBS = {'the', 'a', 'an', 'in', 'on', 'once', 'when', 'after', 'meanwhile', 'while', 'if', 'for', 'to', 'using', 'with', 'then',
             'now', 'next', 'finally', 'first', 'it', 'this', 'your', 'you', 'as', 'at', 'before', 'during', 'each', 'all'}
STOP = {'fresh', 'freshly', 'ground', 'large', 'small', 'medium', 'dried', 'chopped', 'sliced', 'minced', 'grated', 'finely', 'thinly',
        'roughly', 'whole', 'extra', 'virgin', 'unsalted', 'salted', 'kosher', 'plain', 'divided', 'optional', 'taste', 'serving',
        'garnish', 'about', 'into', 'pieces', 'peeled', 'trimmed', 'halved', 'diced', 'cubed', 'cooked', 'drained', 'rinsed', 'with',
        'and', 'the', 'for', 'such', 'like', 'from', 'more', 'plus', 'each', 'inch', 'room', 'temperature', 'cold', 'warm', 'hot',
        'light', 'dark', 'black', 'white', 'green', 'yellow', 'ripe', 'toasted', 'crushed', 'torn', 'removed', 'crumbled',
        'softened', 'melted', 'beaten', 'boneless', 'skinless', 'skin', 'bone', 'thick', 'thin', 'style', 'your', 'choice', 'other'}

# Weights (added 10 Nov): vegetables and fruit of 1 cup or more carry a USDA weight as their second amount.
PRODUCE = re.compile(r"\b(tomato(es)?|kimchi|potato(es)?|onions?|shallots?|carrots?|peppers?|broccoli|cauliflower|mushrooms?|zucchini|"
    r"squash|pumpkin|corn|peas|cabbage|celery|cucumbers?|eggplants?|beets?|leeks?|radish(es)?|green beans|edamame|okra|asparagus|"
    r"berr(y|ies)|strawberr(y|ies)|blueberr(y|ies)|raspberr(y|ies)|blackberr(y|ies)|cherr(y|ies)|grapes?|apples?|pears?|peach(es)?|"
    r"plums?|mango(es)?|pineapple|bananas?|melon|watermelon|papaya|kiwi|fruit|vegetables?|veggies)\b", re.I)
LEAVES = re.compile(r"\b(basil|parsley|cilantro|coriander|mint|dill|chives|tarragon|herbs?|spinach|arugula|rocket|lettuce|greens|kale|chard|leaves|leaf|sprouts)\b", re.I)
NOT_PRODUCE = re.compile(r"\b(flour|starch|sauce|paste|juice|broth|stock|oil|vinegar|powder|flakes|chips|jam|puree|purée)\b", re.I)
# grams per cup from USDA FoodData Central SR Legacy, for the foods the rewrites use; others get the broad band
CUP_GRAMS = [(r"(cherry|grape) tomato", 149, 'FDC 170457, 1 cup cherry tomatoes'),
             (r"kimchi", 150, 'FDC 170392, 1 cup'),
             (r"mashed potato", 210, 'FDC 168555, 1 cup')]
WEIGHT_G = {'g': 1, 'kg': 1000, 'oz': 28.35, 'lb': 453.6}

def words(t): return re.findall(r"[a-z0-9½¼¾⅓⅔⅛°']+", t.lower())
def runs(t, n=6):
    w = words(t); return {' '.join(w[i:i + n]) for i in range(len(w) - n + 1)}
def keys(name):
    main = re.sub(r'\([^)]*\)', ' ', name.lower()).split(',')[0]
    ks = [w for w in re.findall(r'[a-zà-ÿ]+', main) if len(w) >= 3 and w not in STOP]
    return ks or re.findall(r'[a-zà-ÿ]+', main)
def mentioned(name, text):
    t = text.lower()
    for k in keys(name):
        stem = k[:-2] if k.endswith('es') and len(k) > 4 else k[:-1] if k.endswith('s') and len(k) > 3 else k
        if stem in t: return True
    return False

problems = []
def P(sev, rec, what): problems.append((sev, rec, what))

for path in sorted(glob.glob(os.path.join(DRAFT, '*.json'))):
    b = os.path.basename(path)
    try: d = json.load(open(path, encoding='utf-8'))
    except Exception as e: P('FAIL', b, f'JSON does not parse: {e}'); continue
    op = os.path.join(OLD, b)
    if not os.path.exists(op): P('FAIL', b, 'no original with this file name (ids must be kept)'); continue
    o = json.load(open(op, encoding='utf-8')); r, orr = d.get('recipe', {}), o['recipe']; rec = f"{b[:-5]} {r.get('name', '?')}"
    # schema and kept fields
    if set(d) != set(o): P('FAIL', rec, f'top-level keys differ: {sorted(set(d) ^ set(o))}')
    if d.get('id') != o['id']: P('FAIL', rec, 'id changed')
    if d.get('processed_informations') != o.get('processed_informations'): P('FAIL', rec, 'processed_informations changed')
    extra = set(r) - set(orr) - {'cookware', 'step_ingredients'}; missing = set(orr) - set(r)
    if extra or missing: P('FAIL', rec, f'recipe keys: extra {sorted(extra)}, missing {sorted(missing)}')
    for k in orr:
        if k in ('name', 'description', 'steps', 'ingredients', 'prep_time', 'cook_time'): continue
        if r.get(k) != orr[k]: P('FAIL', rec, f'"{k}" must stay as it was')
    for k in ('prep_time', 'cook_time'):
        if r.get(k) != orr[k]: P('CHECK', rec, f'{k} changed: {orr[k]} -> {r.get(k)}')
    if r.get('name') != orr['name']: P('CHECK', rec, f'renamed from "{orr["name"]}" (image asset must be renamed too)')
    steps, ings = r.get('steps', []), r.get('ingredients', [])
    if not isinstance(steps, list) or not all(isinstance(s, str) for s in steps) or len(steps) < 3: P('FAIL', rec, 'steps missing'); continue
    # ingredients
    for k, i in enumerate(ings):
        if set(i) - {'ingredient_name', 'ingredient_amount', 'ingredient_unit', 'alt_amount', 'alt_unit', 'alt_each', 'alt_approx'} or \
           not isinstance(i.get('ingredient_name'), str) or not isinstance(i.get('ingredient_unit'), str) or \
           isinstance(i.get('ingredient_amount'), bool) or not isinstance(i.get('ingredient_amount'), (int, float)):
            P('FAIL', rec, f'ingredient {k}: wrong fields or types'); continue
        if i['ingredient_unit'].split(',')[0].strip() not in UNITS: P('CHECK', rec, f'ingredient {k}: unusual unit "{i["ingredient_unit"]}"')
        if re.search(r'\bdivided\b|plus more|plus extra', i['ingredient_name'], re.I): P('FAIL', rec, f'ingredient {k}: "divided" / "plus more" in the name')
        if BRANDS.search(i['ingredient_name']): P('FAIL', rec, f'ingredient {k}: brand name "{i["ingredient_name"]}"')
        # weights for big cup-measured produce
        if i['ingredient_unit'].strip().lower() in ('cup', 'cups') and i['ingredient_amount'] >= 1:
            main = re.sub(r'\([^)]*\)', ' ', i['ingredient_name']).split(',')[0]
            if PRODUCE.search(main) and not LEAVES.search(main) and not NOT_PRODUCE.search(main):
                au = str(i.get('alt_unit', '')).strip().lower()
                if au not in WEIGHT_G or not i.get('alt_amount'):
                    P('FAIL', rec, f'ingredient {k}: {i["ingredient_amount"]:g} cup of "{i["ingredient_name"]}" needs a USDA weight as its second amount')
                else:
                    if i.get('alt_approx') is not True: P('CHECK', rec, f'ingredient {k}: a weight from the USDA table should have alt_approx true')
                    gpc = i['alt_amount'] * WEIGHT_G[au] / i['ingredient_amount']
                    ref = next(((g, src) for rx, g, src in CUP_GRAMS if re.search(rx, main, re.I)), None)
                    if ref and abs(gpc - ref[0]) > ref[0] / 3: P('FAIL', rec, f'ingredient {k}: {gpc:.0f} g per cup, USDA says {ref[0]} ({ref[1]})')
                    elif not ref and not 40 <= gpc <= 250: P('CHECK', rec, f'ingredient {k}: {gpc:.0f} g per cup looks off for "{main}"')
    def totals(lst):
        t = {}
        for i in lst:
            u = i['ingredient_unit'].split(',')[0].strip().lower()
            if i['ingredient_amount'] > 0: t[u] = round(t.get(u, 0) + i['ingredient_amount'], 3)
        return t
    try:
        to, tn = totals(orr['ingredients']), totals(ings)
        for u in set(to) | set(tn):
            a, c = to.get(u, 0), tn.get(u, 0)
            if abs(a - c) > 0.02 * max(a, c, 1e-9): P('CHECK', rec, f'total of "{u or "(count)"}" amounts changed: {a:g} -> {c:g}')
    except Exception as e: P('FAIL', rec, f'ingredient totals: {e}')
    # steps
    if steps[-1] != SIGN_OFF: P('FAIL', rec, 'last step must be the sign-off line')
    body = steps[:-1]
    for k, s in enumerate(body):
        n = len(s.split()); sents = len(re.findall(r'[.!?](?:\s|$)', re.sub(r'°\s*[FC]\.', '°X', s)))
        if n > 35: P('FAIL', rec, f'step {k+1}: {n} words (max 35)')
        elif n > 30: P('CHECK', rec, f'step {k+1}: {n} words (aim for 30)')
        if sents > 2: P('FAIL', rec, f'step {k+1}: {sents} sentences (max 2)')
        if s.split()[0].lower().strip(',') in NOT_VERBS: P('FAIL', rec, f'step {k+1}: must start with a verb ("{s.split()[0]}")')
        m = AMOUNT.search(s)
        if m: P('FAIL', rec, f'step {k+1}: amount in a step ("{m.group(0)}")')
        for m in re.finditer(r'(\d+)\s*°\s*F(?!\s*\(\s*\d+\s*°\s*C\))', s): P('FAIL', rec, f'step {k+1}: {m.group(0)} has no °C beside it')
        for m in re.finditer(r'(\d+)\s*°\s*C(?!\))', s):
            if not re.search(r'\(\s*\d+\s*°\s*F\s*\)', s[m.end():m.end() + 12]): P('FAIL', rec, f'step {k+1}: {m.group(0)} has no °F beside it')
        for m in re.finditer(r'(\d+)\s*°\s*F\s*\(\s*(\d+)\s*°\s*C\)', s):
            f, c = int(m.group(1)), int(m.group(2))
            if abs((f - 32) * 5 / 9 - c) > (2 if f < 230 else 8): P('FAIL', rec, f'step {k+1}: {f}°F is not {c}°C')
        if BRANDS.search(s): P('FAIL', rec, f'step {k+1}: brand name')
        if PEOPLE.search(s): P('FAIL', rec, f'step {k+1}: a person or story ("{PEOPLE.search(s).group(0)}")')
    desc = r.get('description', '')
    if not desc or len(re.findall(r'[.!?](?:\s|$)', desc)) > 2 or len(desc.split()) > 45: P('FAIL', rec, 'description: 1–2 sentences, at most 45 words')
    if BRANDS.search(desc) or PEOPLE.search(desc): P('FAIL', rec, 'description: brand, person or story')
    # no overlap with the old text
    old_runs = runs(orr['description']) | set().union(*[runs(s) for s in orr['steps']])
    for where, text in [('description', desc)] + [(f'step {k+1}', s) for k, s in enumerate(body)]:
        hit = runs(text) & old_runs
        if hit: P('FAIL', rec, f'{where}: shares 6+ words with the original ("{sorted(hit)[0]}")')
    # rule 9: step_ingredients
    si = r.get('step_ingredients')
    if not isinstance(si, list) or len(si) != len(steps) or not all(isinstance(x, list) for x in si): P('FAIL', rec, 'step_ingredients: one list per step'); continue
    if si[-1] != []: P('FAIL', rec, 'step_ingredients: the sign-off step gets []')
    flat = [x for lst in si for x in lst]
    if sorted(flat) != list(range(len(ings))): P('FAIL', rec, f'step_ingredients: every ingredient position exactly once (missing {sorted(set(range(len(ings))) - set(flat))}, repeated {sorted({x for x in flat if flat.count(x) > 1})})')
    else:
        for k, lst in enumerate(si[:-1]):
            for x in lst:
                if not mentioned(ings[x]['ingredient_name'], steps[k]): P('CHECK', rec, f'step {k+1} lists "{ings[x]["ingredient_name"]}" but does not seem to name it')
    # cookware
    cw = r.get('cookware'); text = ' '.join(body).lower()
    if not isinstance(cw, list) or not cw or set(cw) - set(COOKWARE): P('FAIL', rec, f'cookware: values from the fixed list only ({cw})'); continue
    for c in cw:
        if not re.search(COOKWARE[c], text): P('CHECK', rec, f'cookware "{c}" is not named in the steps')
    for c, rx in COOKWARE.items():
        if c not in cw and re.search(rx, text): P('CHECK', rec, f'steps mention {c} gear but cookware does not list it')
    # times
    mins = sum(int(m.group(2) or m.group(1)) * (60 if m.group(3).startswith('h') else 1) for m in re.finditer(r'(\d+)(?:\s*(?:–|-|to)\s*(\d+))?\s*(minutes?|mins?|hours?)', text))
    total = orr['prep_time']['duration'] * (60 if 'hour' in orr['prep_time']['time_unit'] else 1) + orr['cook_time']['duration'] * (60 if 'hour' in orr['cook_time']['time_unit'] else 1)
    if mins > total * 1.3 + 10: P('CHECK', rec, f'step times add up to {mins} min, the recipe says {total} min')

for p in problems: print(' | '.join(p))
from collections import Counter
print(len(glob.glob(os.path.join(DRAFT, '*.json'))), 'drafts;', dict(Counter(p[0] for p in problems)) or 'no problems')
if OUT: json.dump(problems, open(OUT, 'w'), ensure_ascii=False, indent=1)
