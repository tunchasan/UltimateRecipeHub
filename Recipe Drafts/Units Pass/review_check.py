# Units pass, final check (9 Nov): applied recipe files vs. the committed originals (c6065c5).
# Usage: python3 review_check.py ORIG_DIR NEW_DIR OUT_DIR
import json, glob, os, re, sys, difflib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import converter_check as cc

ORIG, NEW, OUT = sys.argv[1:4]
problems = []          # (severity, recipe, where, text)
changes = []           # every ingredient/step change, for reading
def P(sev, rec, where, text): problems.append((sev, rec, where, text))

NUM = r'(\d+(?:\.\d+)?(?:\s*[½¼¾⅓⅔⅛⅜⅝⅞])?|[½¼¾⅓⅔⅛⅜⅝⅞]|\d+/\d+|\d+\s+\d+/\d+)'
FRAC = {'½': .5, '¼': .25, '¾': .75, '⅓': 1/3, '⅔': 2/3, '⅛': .125, '⅜': .375, '⅝': .625, '⅞': .875}
def num(t):
    t = t.strip().replace('-', ' ')
    tot = 0
    for part in t.split():
        if part in FRAC: tot += FRAC[part]; continue
        if part[-1] in FRAC: tot += float(part[:-1]) + FRAC[part[-1]]; continue
        if '/' in part:
            a, b = part.split('/'); tot += float(a) / float(b); continue
        tot += float(part)
    return tot

def base(unit, name):
    inf = cc.info(cc.canon(unit), name)
    return inf

def split_unit(u):
    u = u.strip()
    if ',' in u and '(' not in u[:u.index(',')]:
        return u[:u.index(',')].strip(), u[u.index(',') + 1:].strip()
    return u, None

stats = dict(files=0, changed_files=0, ing_changes=0, step_changes=0, name_changes=0, alt=0)
for nf in sorted(glob.glob(NEW + '/*.json')):
    b = os.path.basename(nf); stats['files'] += 1
    try:
        n = json.load(open(nf, encoding='utf-8'))
    except Exception as e:
        P('BLOCKER', b, 'file', f'JSON does not parse: {e}'); continue
    o = json.load(open(os.path.join(ORIG, b), encoding='utf-8'))
    rec = n['recipe']['name']
    oi, ni = o['recipe']['ingredients'], n['recipe']['ingredients']
    changed = False
    # --- decoding, as Swift does
    for k, ing in enumerate(ni):
        for key, typ in (('ingredient_name', str), ('ingredient_unit', str)):
            if not isinstance(ing.get(key), typ): P('BLOCKER', rec, f'ingredient {k+1}', f'{key} missing or not text')
        a = ing.get('ingredient_amount')
        if isinstance(a, bool) or not isinstance(a, (int, float)): P('BLOCKER', rec, f'ingredient {k+1}', 'ingredient_amount not a number')
        if 'alt_amount' in ing:
            stats['alt'] += 1
            if isinstance(ing['alt_amount'], bool) or not isinstance(ing['alt_amount'], (int, float)) or ing['alt_amount'] <= 0:
                P('BLOCKER', rec, f'ingredient {k+1}', 'alt_amount not a positive number')
            if not isinstance(ing.get('alt_unit'), str) or not ing['alt_unit'].strip():
                P('BLOCKER', rec, f'ingredient {k+1}', 'alt_unit missing')
        for key in ('alt_each', 'alt_approx'):
            if key in ing and not isinstance(ing[key], bool): P('BLOCKER', rec, f'ingredient {k+1}', f'{key} not true/false')
        extra = set(ing) - {'ingredient_name', 'ingredient_amount', 'ingredient_unit', 'alt_amount', 'alt_unit', 'alt_each', 'alt_approx'}
        if extra: P('CHECK', rec, f'ingredient {k+1}', f'unknown keys {extra}')
    if len(oi) != len(ni):
        P('BLOCKER', rec, 'ingredients', f'count changed {len(oi)} -> {len(ni)}'); continue
    # --- ingredient by ingredient
    for k, (a, c) in enumerate(zip(oi, ni)):
        if a == c: continue
        changed = True; stats['ing_changes'] += 1
        before = f"{a['ingredient_amount']:g} | {a['ingredient_unit']} | {a['ingredient_name']}"
        after = f"{c['ingredient_amount']:g} | {c['ingredient_unit']} | {c['ingredient_name']}"
        if 'alt_amount' in c:
            after += f"  [alt {c['alt_amount']:g} {c['alt_unit']}{' each' if c.get('alt_each') else ''}{' about' if c.get('alt_approx') else ''}]"
        changes.append(('ING', rec, k + 1, before, after))
        oname = re.sub(r'\s*\([^)]*\)', '', a['ingredient_name']).strip().lower()
        nname = re.sub(r'\s*\([^)]*\)', '', c['ingredient_name']).strip().lower()
        if a['ingredient_name'] != c['ingredient_name']:
            stats['name_changes'] += 1
            if oname != nname: P('CHECK', rec, f'ingredient {k+1}', f'name changed beyond brackets: "{a["ingredient_name"]}" -> "{c["ingredient_name"]}"')
        # quantity kept?
        ou, onote = split_unit(a['ingredient_unit']); nu, nnote = split_unit(c['ingredient_unit'])
        oinf, ninf = base(ou, a['ingredient_name']), base(nu, c['ingredient_name'])
        oq, nq = a['ingredient_amount'], c['ingredient_amount']
        if onote != nnote and not (onote and nnote and onote.lower() == nnote.lower()):
            P('CHECK', rec, f'ingredient {k+1}', f'unit note changed: {onote!r} -> {nnote!r}')
        if oinf and ninf:
            if oinf[1] != ninf[1]: P('ERROR', rec, f'ingredient {k+1}', f'dimension changed: {before} -> {after}')
            elif abs(oq * oinf[2] - nq * ninf[2]) > 0.02 * max(oq * oinf[2], 1e-9) and not (cc.canon(ou) == 'oz' and cc.canon(nu) == 'fl oz'):
                P('ERROR', rec, f'ingredient {k+1}', f'quantity changed: {before} -> {after}')
        elif oq != nq:
            # amount moved only when a package size became a second amount: the old text must hold the new numbers
            old_text = f"{oq:g} {a['ingredient_unit']} {a['ingredient_name']}"
            if f'{nq:g}' not in old_text and not (nq == 1 and oq != 0):
                P('ERROR', rec, f'ingredient {k+1}', f'amount changed: {before} -> {after}')
        if 'alt_amount' in c:
            old_text = f"{oq:g} {a['ingredient_unit']} {a['ingredient_name']}".replace('1/2', '0.5').replace('3/4', '0.75').replace('1/4', '0.25').replace('1/3', '0.3333')
            if f"{c['alt_amount']:g}" not in old_text and f"{c['alt_amount']:g}".lstrip('0') not in old_text:
                P('CHECK', rec, f'ingredient {k+1}', f'second amount not found in the original text: {before} -> {after}')
    # --- steps
    os_, ns = o['recipe']['steps'], n['recipe']['steps']
    if len(os_) != len(ns): P('BLOCKER', rec, 'steps', f'count changed {len(os_)} -> {len(ns)}'); continue
    for k, (s1, s2) in enumerate(zip(os_, ns)):
        if s1 == s2: continue
        changed = True; stats['step_changes'] += 1
        sm = difflib.SequenceMatcher(None, s1, s2, autojunk=False)
        ins = []
        for op, i1, i2, j1, j2 in sm.get_opcodes():
            if op in ('delete', 'replace'):
                P('ERROR', rec, f'step {k+1}', f'text removed or replaced: "{s1[max(0,i1-25):i2+25]}" -> "{s2[max(0,j1-25):j2+25]}"')
            if op in ('insert', 'replace'):
                ins.append((j1, s2[j1:j2]))
        changes.append(('STEP', rec, k + 1, s1, s2))
    # whole-step sanity on the new text
    for k, s in enumerate(ns):
        for m in re.finditer(r'(\d+)\s*°\s*F\s*\((\d+)\s*°\s*C\)', s):
            f, c = int(m.group(1)), int(m.group(2)); exact = (f - 32) * 5 / 9
            tol = 1.5 if f < 230 else 6
            if abs(c - exact) > tol: P('ERROR', rec, f'step {k+1}', f'{f}°F shown as {c}°C (exact {exact:.0f}°C)')
        for m in re.finditer(r'(\d+)\s*°\s*C\s*\((\d+)\s*°\s*F\)', s):
            c, f = int(m.group(1)), int(m.group(2)); exact = c * 9 / 5 + 32
            tol = 3 if c < 110 else 12
            if abs(f - exact) > tol: P('ERROR', rec, f'step {k+1}', f'{c}°C shown as {f}°F (exact {exact:.0f}°F)')
        for m in re.finditer(r'(\d+(?:\.\d+)?)\s*°\s*([FC])\b(?!\s*\(\s*\d)', s):
            # a temperature with no other system after it: fine when the other system comes before it
            before_txt = s[max(0, m.start() - 14):m.start()]
            if not re.search(r'°\s*[FC]\s*\($', before_txt) and not re.search(r'°\s*[FC]\s*/\s*$', before_txt):
                ctx = s[max(0, m.start() - 30):m.end() + 20]
                if 'fan' not in ctx.lower() and 'gas' not in ctx.lower():
                    P('CHECK', rec, f'step {k+1}', f'temperature in one system only: "…{ctx}…"')
        for m in re.finditer(r'\((\d+(?:\.\d+)?)\s*°\s*C\)\s*\((\d+)', s):
            P('ERROR', rec, f'step {k+1}', 'two conversions in a row')
        for m in re.finditer(r'(\d+(?:\.\d+)?|[½¼¾⅓⅔⅛]|\d+/\d+)\s*(?:-|\s)?\s*(?:inch|inches|")(?:es)?\s*\((\d+(?:\.\d+)?)\s*(cm|mm)\)', s):
            try: inch = num(m.group(1))
            except Exception: continue
            cm = float(m.group(2)) / (10 if m.group(3) == 'mm' else 1); exact = inch * 2.54
            if abs(cm - exact) > max(0.15 * exact, 0.2): P('ERROR', rec, f'step {k+1}', f'{m.group(0)} (exact {exact:.1f} cm)')
        if re.search(r'\)\(|\(\s*\)|\s{2,}\(', s): P('CHECK', rec, f'step {k+1}', 'odd brackets or spacing: "' + s[:80] + '…"')
        if s.count('(') != s.count(')'): P('ERROR', rec, f'step {k+1}', 'brackets do not pair up')
    if changed: stats['changed_files'] += 1

# converter in both systems at the servings people pick
conv_problems = 0
for nf in sorted(glob.glob(NEW + '/*.json')):
    r = json.load(open(nf, encoding='utf-8'))['recipe']
    for ing in r['ingredients']:
        u, _ = split_unit(ing['ingredient_unit'])
        for system in ('us', 'metric'):
            for scale in (0.5, 1, 1.5, 2):
                try:
                    m = cc.measure(ing['ingredient_amount'], u, ing['ingredient_name'], ing.get('alt_amount'), ing.get('alt_unit'),
                                   bool(ing.get('alt_each')), bool(ing.get('alt_approx')), scale, system)
                except Exception as e:
                    P('ERROR', r['name'], 'converter', f'{ing} {system} x{scale}: {e}'); conv_problems += 1; continue
                if not m: continue
                t = cc.combined(m)
                if re.search(r'\b0 (g|ml|oz|cup|tbsp|tsp|lb)\b|nan|inf|\d{5,}', t):
                    P('ERROR', r['name'], 'converter', f'{ing["ingredient_amount"]:g} {u} {ing["ingredient_name"]} -> {t} ({system} x{scale})'); conv_problems += 1
                if system == 'metric' and re.search(r'\b(cups?|oz|lb|fl oz)\b', m[0]):
                    P('CHECK', r['name'], 'converter', f'metric reader still sees US: {ing["ingredient_amount"]:g} {u} {ing["ingredient_name"]} -> {t} x{scale}')
                if system == 'us' and re.search(r'\b(g|kg|ml|L)\b', m[0]) and not re.search(r'\(\d+ (g|ml)\)', m[0]):
                    P('CHECK', r['name'], 'converter', f'US reader still sees metric: {ing["ingredient_amount"]:g} {u} {ing["ingredient_name"]} -> {t} x{scale}')

os.makedirs(OUT, exist_ok=True)
json.dump(dict(stats=stats, problems=problems), open(os.path.join(OUT, 'final_check.json'), 'w'), ensure_ascii=False, indent=1)
with open(os.path.join(OUT, 'all_changes.txt'), 'w', encoding='utf-8') as fh:
    for c in changes: fh.write('\t'.join(str(x) for x in c) + '\n')
from collections import Counter
print(stats)
print(Counter(p[0] for p in problems))
print(Counter((p[0], p[3].split(':')[0][:40]) for p in problems).most_common(25))
