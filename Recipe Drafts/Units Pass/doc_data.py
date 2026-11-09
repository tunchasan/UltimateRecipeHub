# Builds the data for the Units Pass Review doc from the files as they are now (originals: c6065c5).
# Usage: python3 doc_data.py ORIG_DIR NEW_DIR OUT_JSON
import json, glob, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import converter_check as cc
ORIG, NEW, OUT = sys.argv[1:4]
here = os.path.dirname(os.path.abspath(__file__))
fixed = json.load(open(os.path.join(here, 'final_fix_log.json'), encoding='utf-8'))
fixed_names = {(r[0], r[3]) for r in fixed if r[1] == 'name'}
fixed_steps = {(r[0], r[3]) for r in fixed if r[1] != 'name'}
ASK = {('Korean Rice Lasagna', 'gochujang'), ('Chicken & Basil Pasta (Sopa Seca)', 'basil leaves'),
       ('Oven-Roasted Egyptian Mesaka’a', 'globe eggplants (stems removed)'),
       ('Walnut-Lentil Lettuce Wraps', 'finely chopped pickled or fermented vegetables'),
       ('Lemony Pasta With Sardines & Escarole', 'tinned sardines packed in olive oil'),
       ('One-Skillet Bacon-Wrapped Chicken', 'skinless, boneless chicken breasts')}

def line(i):
    t = f"{i['ingredient_amount']:g} · {i['ingredient_unit']} · {i['ingredient_name']}" if i['ingredient_unit'] else f"{i['ingredient_amount']:g} · {i['ingredient_name']}"
    if 'alt_amount' in i:
        t += f"   [second amount: {'about ' if i.get('alt_approx') else ''}{i['alt_amount']:g} {i['alt_unit']}{' each' if i.get('alt_each') else ''}]"
    return t

def split_unit(u):
    u = u.strip()
    if ',' in u and '(' not in u[:u.index(',')]: return u[:u.index(',')].strip()
    return u

groups = {k: [] for k in ('ask', 'notes', 'floz', 'alt', 'names', 'steps')}
spell, left = {}, {}
files_changed = 0
for nf in sorted(glob.glob(NEW + '/*.json')):
    b = os.path.basename(nf)
    n = json.load(open(nf, encoding='utf-8'))['recipe']; o = json.load(open(os.path.join(ORIG, b), encoding='utf-8'))['recipe']
    rec = n['name']; changed = False
    for a, c in zip(o['ingredients'], n['ingredients']):
        if a == c:
            u = split_unit(c['ingredient_unit'])
            if u and c['ingredient_amount'] > 0 and not cc.info(cc.canon(u), c['ingredient_name']):
                g = left.setdefault(u.lower(), [0, line(c)]); g[0] += 1
            continue
        changed = True
        row = dict(r=rec, b=line(a), a=line(c))
        if (rec, a['ingredient_name']) in ASK: k = 'ask'
        elif a['ingredient_amount'] != c['ingredient_amount'] and (a['ingredient_amount'] == 0 or c['ingredient_amount'] == 0): k = 'notes'
        elif cc.canon(split_unit(a['ingredient_unit'])) == 'oz' and cc.canon(split_unit(c['ingredient_unit'])) == 'fl oz': k = 'floz'
        elif 'alt_amount' in c: k = 'alt'
        elif a['ingredient_name'] != c['ingredient_name']:
            k = 'names'; row['fix'] = (rec, c['ingredient_name']) in fixed_names
        else:
            key = (a['ingredient_unit'], c['ingredient_unit'])
            g = spell.setdefault(key, [0, f"{a['ingredient_amount']:g} {a['ingredient_unit']} {a['ingredient_name']}"]); g[0] += 1
            continue
        groups[k].append(row)
    for k, (s1, s2) in enumerate(zip(o['steps'], n['steps'])):
        if s1 != s2:
            changed = True
            groups['steps'].append(dict(r=rec, n=k + 1, b=s1, a=s2, fix=(rec, s2) in fixed_steps))
    files_changed += changed
out = dict(files=len(glob.glob(NEW + '/*.json')), files_changed=files_changed, groups=groups,
           spell=sorted(([k[0], k[1], v[0], v[1]] for k, v in spell.items()), key=lambda x: -x[2]),
           left=sorted(([k, v[0], v[1]] for k, v in left.items()), key=lambda x: -x[1]),
           fixed=fixed, check=json.load(open(os.path.expanduser('~/review/final_check.json')))['stats'])
json.dump(out, open(OUT, 'w', encoding='utf-8'), ensure_ascii=False)
print({k: len(v) for k, v in groups.items()}, 'spell lines', sum(x[2] for x in out['spell']), 'groups', len(out['spell']),
      'left lines', sum(x[1] for x in out['left']), 'groups', len(out['left']), 'files changed', files_changed)
