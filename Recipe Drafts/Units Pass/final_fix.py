# Units pass, final fixes (9 Nov). Text replacements only, so the files keep their exact formatting.
# Usage: python3 final_fix.py ORIG_DIR RECIPES_DIR BACKUP_DIR [--apply]
import json, glob, os, re, sys, shutil
ORIG, REC, BACKUP = sys.argv[1:4]; APPLY = '--apply' in sys.argv

NAMES = {
    'carrot, cut into 3-inch-long matchsticks': 'carrot, cut into 3-inch-long (7.5 cm) matchsticks',
    'lobster tails, cut into 1-inch pieces': 'lobster tails, cut into 1-inch (2.5 cm) pieces',
    'Eggplant, chopped into 1/2-inch pieces': 'Eggplant, chopped into 1/2-inch (1 cm) pieces',
    'Zucchini, chopped into 1/2-inch pieces': 'Zucchini, chopped into 1/2-inch (1 cm) pieces',
    'Red bell pepper, seeded and chopped into 1/2-inch pieces': 'Red bell pepper, seeded and chopped into 1/2-inch (1 cm) pieces',
    'Yellow bell pepper, seeded and chopped into 1/2-inch pieces': 'Yellow bell pepper, seeded and chopped into 1/2-inch (1 cm) pieces',
    'Russet potatoes, peeled and sliced 1/2-inch thick': 'Russet potatoes, peeled and sliced 1/2-inch (1 cm) thick',
    'carrots, sliced 1/2-inch thick': 'carrots, sliced 1/2-inch (1 cm) thick',
    'celeriac bulb, peeled and diced (or celery stalks, sliced 1/2-inch thick)': 'celeriac bulb, peeled and diced (or celery stalks, sliced 1/2-inch / 1 cm thick)',
    'red onion, cut into 1/2-inch half rings': 'red onion, cut into 1/2-inch (1 cm) half rings',
    'Carrots, peeled and cut into 1-inch pieces': 'Carrots, peeled and cut into 1-inch (2.5 cm) pieces',
    'Celery stalks, cut into 1-inch pieces': 'Celery stalks, cut into 1-inch (2.5 cm) pieces',
    'Oat flour (made from 1¼ cups (110 g) whole rolled oats)': 'Oat flour (made from 1¼ cups / 110 g whole rolled oats)',
}
STEPS = {'Preheat the oven to 120°C (225°F).': 'Preheat the oven to 120°C (250°F).'}
DOUBLE = re.compile(r'(\d+\s*[°º]\s*[CF]) \((\d+\s*°\s*[CF])\) \(')

def enc(s): return json.dumps(s, ensure_ascii=False)
log = []
for path in sorted(glob.glob(REC + '/*.json')):
    b = os.path.basename(path)
    text = open(path, encoding='utf-8').read()
    data = json.loads(text); new = text
    name = data['recipe']['name']
    orig_steps = json.load(open(os.path.join(ORIG, b), encoding='utf-8'))['recipe']['steps']
    for ing in data['recipe']['ingredients']:
        n = ing['ingredient_name']
        if n in NAMES:
            assert new.count(enc(n)) == 1, (b, n)
            new = new.replace(enc(n), enc(NAMES[n])); log.append((name, 'name', n, NAMES[n]))
    for k, s in enumerate(data['recipe']['steps']):
        t = STEPS.get(s, s)
        def fix(m):
            # only conversions the pass added: the original step didn't have "(X°F)"
            if '(' + m.group(2) + ')' in orig_steps[k]: return m.group(0)
            return f'{m.group(1)} / {m.group(2)} ('
        t = DOUBLE.sub(fix, t)
        if t != s:
            assert new.count(enc(s)) == 1, (b, s[:40])
            new = new.replace(enc(s), enc(t)); log.append((name, f'step {k+1}', s, t))
    if new != text:
        after = json.loads(new)   # still valid, and only the strings above changed
        assert len(after['recipe']['ingredients']) == len(data['recipe']['ingredients'])
        if APPLY:
            os.makedirs(BACKUP, exist_ok=True)
            if not os.path.exists(os.path.join(BACKUP, b)): shutil.copy2(path, os.path.join(BACKUP, b))
            open(path, 'w', encoding='utf-8').write(new)
for r in log: print(' | '.join(r)[:300])
print(len(log), 'changes', 'APPLIED' if APPLY else '(dry run)')
json.dump(log, open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'final_fix_log.json'), 'w'), ensure_ascii=False, indent=1)
