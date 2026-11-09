import json, glob, os, re, sys
from fractions import Fraction
# Decisions on the 6 ask-list lines (my suggestions, accepted 9 Nov)
OVERRIDES = {
 ('0000000040_1a0','cup plus 1 tbsp'): {'ingredient_amount':5.0,'ingredient_unit':'tbsp'},
 ('0000000053_5','cups (packed)'): {'ingredient_unit':'cup','ingredient_name':'basil leaves, packed'},
 ('0000000086_c0','pounds (about 4 large)'): {'ingredient_unit':'lb','ingredient_name':'globe eggplants (about 4 large), stems removed'},
 ('0000000092_200','to 0.5 cups'): {'ingredient_amount':0.5,'ingredient_unit':'cup'},
 ('00000000c4_c','3-5 oz tins'): {'ingredient_unit':'tin','alt_amount':4.0,'alt_unit':'oz','alt_each':True,'alt_approx':True},
 ('00000000c6_141','pieces (1¾ to 2 pounds total)'): {'ingredient_unit':'piece','alt_amount':2.0,'alt_unit':'lb','alt_approx':True},
}
SRC = os.path.expanduser('~/mnt/Documents/GitHub/Ultimate Recipe Hub/The Ultimate Recipe Hub/Resources/Recipes')
OUT = os.path.expanduser('~/unitpass/out'); os.makedirs(OUT, exist_ok=True)
UNIT = {}
def add(canon, *forms):
    for f in (canon,) + forms: UNIT[f] = canon
add('cup','cups','c'); add('tbsp','tablespoon','tablespoons','tbs','tbl','tbsps','tbsp.'); add('tsp','teaspoon','teaspoons','tsps','tsp.')
add('oz','ounce','ounces','oz.'); add('fl oz','fluid ounce','fluid ounces','fl. oz','fl.oz','fl oz.'); add('lb','lbs','pound','pounds','lb.','lbs.')
add('g','gram','grams','gr','gms'); add('kg','kilogram','kilograms','kgs'); add('ml','milliliter','milliliters','millilitre','millilitres','mls')
add('l','liter','liters','litre','litres','lt'); add('pint','pints'); add('quart','quarts'); add('gallon','gallons')
add('inch','inches','in'); add('cm'); add('pinch','pinches'); add('dash','dashes'); add('clove','cloves'); add('slice','slices')
add('bunch','bunches'); add('small bunch'); add('sprig','sprigs'); add('handful','handfuls'); add('can','cans'); add('piece','pieces')
add('stick','sticks'); add('head','heads'); add('packet','packets'); add('package','packages'); add('jar','jars'); add('sheet','sheets')
add('strip','strips'); add('ear','ears'); add('stalk','stalks'); add('leaf','leaves'); add('drop','drops'); add('splash')
add('bag','bags'); add('box','boxes'); add('bottle','bottles'); add('dozen'); add('fillet','fillets'); add('link','links')
SIZE = {'small','medium','large','extra-large','extra large','big','jumbo'}
PREP = ['finely chopped','roughly chopped','coarsely chopped','thinly sliced','chopped','sliced','minced','diced','beaten','grated','peeled','crushed','halved','quartered','cubed','shredded','juiced','zested','melted','softened','torn','trimmed','drained','rinsed','boiled']
NOTE = ['to taste','for serving','to serve','as needed','as desired','for garnish','to garnish','optional','optional, for serving','for dusting','for drizzling','for topping','for frying','for greasing']
LIQUID = re.compile(r'\b(water|milk|buttermilk|broth|stock|juice|wine|beer|vinegar|oil|syrup|heavy cream|whipping cream|light cream|half-and-half|coconut milk|soy sauce|sake|mirin|rum|vodka|brandy|liqueur|espresso|coffee|tea)\b', re.I)
NOT_LIQUID = re.compile(r'cheese|chocolate|sour cream|ice cream|powder|flakes|bread|solids|mozzarella|ricotta|parmesan|cheddar|feta|yogurt|tuna|sardine|anchov|\bin oil\b|packed in', re.I)
WEIGHT_U = {'oz':('w',28.3495),'lb':('w',453.592),'g':('w',1),'kg':('w',1000)}
NUM = r'(\d+\s+\d+/\d+|\d+/\d+|\d*[½¼¾⅓⅔⅛]|\d+(?:\.\d+)?)'
GLYPH = {'½':0.5,'¼':0.25,'¾':0.75,'⅓':1/3,'⅔':2/3,'⅛':0.125}
def num(t):
    t=t.strip()
    if t and t[-1] in GLYPH: return (float(t[:-1].strip()) if t[:-1].strip() else 0)+GLYPH[t[-1]]
    p=t.split()
    if len(p)==2: return float(p[0])+float(Fraction(p[1]))
    return float(Fraction(t))
def canon(u):
    u=u.strip().lower().rstrip(',')
    return UNIT.get(u)
ask=[]; changes=[]
def rec_change(rid, name, kind, before, after): changes.append({'id':rid,'recipe':name,'kind':kind,'before':before,'after':after})
PROPER={'roma','yukon','thai','italian','english','persian','japanese','chinese','greek','mexican','spanish','french','granny','fuji','honeycrisp','vidalia','kirby','san','castelvetrano','kalamata','medjool','idaho','maui','meyer','key','dijon','tuscan','napa','savoy','asian','korean','indian','turkish','lebanese','cubanelle','anaheim','poblano','serrano','hass'}
def lower_first(n):
    w=n.split(' ',1)[0].strip(',').lower()
    if w in PROPER: return n[:1].upper()+n[1:]
    return n[:1].lower()+n[1:] if n[:1].isupper() and not n[:2].isupper() else n
def show(a,u,n,extra=''):
    a = ('' if not a else (str(int(a)) if float(a).is_integer() else str(a)))
    return ' · '.join(x for x in [ (a+' '+u).strip(), n] if x) + extra
add('inch piece','inch pieces'); add('tin','tins'); add('pod','pods'); add('breast','breasts'); add('fillet')
MEASURE=re.compile(r'\b(cups?|tbsp|tablespoons?|tsp|teaspoons?|oz|ounces?|lbs?|pounds?|grams?|g|kg|ml|milliliters?|l|liters?|litres?|pints?|quarts?|inch(?:es)?)\b', re.I)
OVEN = {200:95,225:110,250:120,275:140,300:150,325:160,350:180,375:190,400:200,425:220,450:230,475:240,500:260,550:290}
C2F = {120:250,130:265,140:275,150:300,160:325,163:325,165:325,170:340,175:350,180:350,190:375,200:400,210:410,220:425,230:450,232:450,240:475,250:480,260:500}
def f2c(f):
    if f in OVEN: return OVEN[f]
    c=(f-32)*5/9
    return int(round(c/5)*5) if f>=250 else int(round(c))
def c2f(c):
    if c in C2F: return C2F[c]
    f=c*9/5+32
    return int(round(f/5)*5) if c>=120 else int(round(f))
ICM={0.125:'3 mm',0.25:'6 mm',1/3:'8 mm',0.5:'1 cm',2/3:'1.5 cm',0.75:'2 cm',1:'2.5 cm',1.5:'4 cm',2:'5 cm',2.5:'6 cm',3:'7.5 cm',4:'10 cm',5:'13 cm',6:'15 cm',7:'18 cm',8:'20 cm',9:'23 cm',10:'25 cm',11:'28 cm',12:'30 cm',13:'33 cm',14:'35 cm',15:'38 cm',16:'40 cm',18:'45 cm',20:'50 cm'}
def inch_cm(x):
    for k,v in ICM.items():
        if abs(k-x)<0.01: return v
    cm=x*2.54
    return f'{int(round(cm*10))} mm' if cm<1 else f'{int(round(cm))} cm'
def join_cm(vals, sep):
    parts=[inch_cm(v) for v in vals]
    if len({p.split()[1] for p in parts})==1: return sep.join(p.split()[0] for p in parts)+' '+parts[0].split()[1]
    return sep.join(parts)
TF=r'(?:°\s*F|º\s*F|degrees\s*F(?:ahrenheit)?|℉)'; TC=r'(?:°\s*C|º\s*C|degrees\s*C(?:elsius)?|℃)'
HAS_C_AFTER=r'(?!\s*[\(/]\s*\d{2,3}\s*(?:°|º|degrees)?\s*C)'; HAS_F_AFTER=r'(?!\s*[\(/]\s*\d{2,3}\s*(?:°|º|degrees)?\s*F)'
FR_RE=re.compile(r'(\d{2,3})\s*(?:°|º)?\s*(?:F\b)?\s*(?:to|-|–)\s*(\d{2,3})\s*'+TF+r'\b'+HAS_C_AFTER, re.I)
F_RE=re.compile(r'(?<![\d–-])(\d{2,3})\s*'+TF+r'\b'+HAS_C_AFTER, re.I)
C_RE=re.compile(r'(?<![\d–-])(\d{2,3})\s*'+TC+r'\b'+HAS_F_AFTER, re.I)
NUMI=r'(?:\d+\s*[½¼¾⅛]|\d+\s+\d+/\d+|\d+/\d+|\d+\.\d+|\d*[½¼¾⅛]|\d+)'
UNI=r'(?:-|\s*)(?:inch(?:es)?|in\.|")(?!\w)'
INCH_RANGE=re.compile(r'(?<![\d/.])('+NUMI+r')(?:-inch|-|\s*")?\s*(?:to|-|–)\s*('+NUMI+r')'+UNI, re.I)
INCH_BY=re.compile(r'(?<![\d/.])('+NUMI+r')(?:-inch|"|\s*inch)?\s*(?:-by-|\s*by\s*|\s*[x×]\s*)('+NUMI+r')'+UNI, re.I)
INCH_ONE=re.compile(r'(?<![\d/.])('+NUMI+r')'+UNI, re.I)
CM_AFTER=re.compile(r'^[^\n.]{0,20}?\b\d[\d.,/ x×–-]*\s*(?:cm|mm)\b')
def fix_text(t, rid, name, where):
    src=t; out=[]; pos=0
    spans=[]
    def inside(i): return src[:i].count('(')>src[:i].count(')')
    def fan_near(m): return re.search(r'fan\s*$', src[max(0,m.start()-6):m.start()], re.I) or re.match(r'\s*\(?\s*fan', src[m.end():m.end()+8], re.I)
    def pre_other(m, unit):
        return re.search(r'\d\s*(?:°|º|degrees)\s*'+unit+r'\s*[\(/]\s*$', src[max(0,m.start()-16):m.start()], re.I)
    both=bool(re.search(r'\d\s*'+TF,src,re.I)) and bool(re.search(r'\d\s*'+TC,src,re.I))
    for m in ([] if both else FR_RE.finditer(src)):
        a,b=int(m.group(1)),int(m.group(2))
        spans.append((m.start(),m.end(),f'{m.group(0)} ({f2c(a)}–{f2c(b)}°C)' if not inside(m.start()) else f'{m.group(0)} / {f2c(a)}–{f2c(b)}°C'))
    for m in ([] if both else F_RE.finditer(src)):
        if any(s<=m.start()<e for s,e,_ in spans) or pre_other(m,'C'): continue
        v=f2c(int(m.group(1))); spans.append((m.start(),m.end(),f'{m.group(0)} / {v}°C' if inside(m.start()) else f'{m.group(0)} ({v}°C)'))
    for m in ([] if both else C_RE.finditer(src)):
        if any(s<=m.start()<e for s,e,_ in spans) or pre_other(m,'F') or fan_near(m) or src[max(0,m.start()-1):m.start()]=='(': continue
        v=c2f(int(m.group(1))); spans.append((m.start(),m.end(),f'{m.group(0)} / {v}°F' if inside(m.start()) else f'{m.group(0)} ({v}°F)'))
    for rx,kind in ((INCH_BY,'by'),(INCH_RANGE,'range'),(INCH_ONE,'one')):
        for m in rx.finditer(src):
            if any(not(m.end()<=s or m.start()>=e) for s,e,_ in spans): continue
            if CM_AFTER.match(src[m.end():]): continue
            lb=src.rfind('(',0,m.start())
            if inside(m.start()) and re.search(r'\d\s*(?:cm|mm)\s*$', src[max(0,lb-12):lb]): continue
            try: vals=[num(g) for g in m.groups()]
            except Exception: continue
            if any(v>40 or v<=0 for v in vals): continue
            txt=join_cm(vals,' x ' if kind=='by' else '–')
            spans.append((m.start(),m.end(),f'{m.group(0)} / {txt}' if inside(m.start()) else f'{m.group(0)} ({txt})'))
    spans.sort()
    for s,e,rep in spans: out.append(src[pos:s]); out.append(rep); pos=e
    out.append(src[pos:]); res=''.join(out)
    if res!=t and where: rec_change(rid,name,where,t,res)
    return res
BR = re.compile(r'^\s*(?P<u>[^()]*?)\s*\((?P<b>[^()]*)\)\s*(?P<rest>.*)$')
def parse_alt(b):
    m=re.match(r'^(about|approx\.?|roughly)?\s*'+NUM+r'\s*-?\s*(?P<u>[a-zA-Z. ]+?)\s*(?P<e>each|total)?$', b.strip(), re.I)
    if not m: return None
    u=canon(m.group('u'))
    if not u: return None
    return {'alt_amount': round(num(m.group(2)),4), 'alt_unit': u, 'each': (m.group('e') or '').lower()=='each', 'about': bool(m.group(1))}
pass_through=[]
def A(rid,rname,before,why,sug): ask.append({'id':rid,'recipe':rname,'line':before,'why':why,'sug':sug})
PKG=re.compile(r'^(?P<s>\d+(?:\.\d+)?)[- ]?(?P<u>oz|ounces?|grams?|g)\.?\s*(?P<c>cans?|tins?|packets?|packages?|fillets?|pieces?|each)?$', re.I)
def do_ing(ing, rid, rname):
    a=ing.get('ingredient_amount') or 0; u=(ing.get('ingredient_unit') or '').strip(); n=ing.get('ingredient_name') or ''
    before=show(a,u,n); new=dict(ing); kinds=[]; ul=u.lower()
    if (rid,u) in OVERRIDES:
        new.update(OVERRIDES[(rid,u)])
        extra=(f"   [second amount: {'about ' if new.get('alt_approx') else ''}{new['alt_amount']:g} {new['alt_unit']}{' each' if new.get('alt_each') else ''}]" if new.get('alt_amount') else '')
        rec_change(rid,rname,'Decided from the ask list',before,show(new['ingredient_amount'],new['ingredient_unit'],new['ingredient_name'],extra)); return new
    def setalt(alt):
        new['alt_amount']=alt['alt_amount']; new['alt_unit']=alt['alt_unit']
        if alt.get('each'): new['alt_each']=True
        if alt.get('about'): new['alt_approx']=True
    m0=re.match(r'^'+NUM+r'\s+(.+)$',u) if not a else None
    pk=PKG.match(u)
    if m0 and canon(m0.group(2)):
        new['ingredient_amount']=num(m0.group(1)); new['ingredient_unit']=canon(m0.group(2)); kinds.append('Amount was in the unit field')
    elif '(' in u:
        m=BR.match(u); alt=parse_alt(m.group('b')) if m else None; cu=canon(m.group('u')) if m else None
        if m and alt and cu and not m.group('rest'):
            new['ingredient_unit']=cu; setalt(alt); kinds.append('Second amount kept')
        else:
            sug={'cups (packed)':'Unit cup; "packed" goes after the name: "Basil leaves, packed"',
                 'pounds (about 4 large)':'Unit lb; "(about 4 large)" goes into the name',
                 'pieces (1¾ to 2 pounds total)':'Unit piece; second amount about 2 lb in total',
                 'for the buns (optional)':'Leave as written: a note, nothing to convert'}.get(ul,'Leave as written')
            if sug.startswith('Leave as written'): pass_through.append({'id':rid,'recipe':rname,'line':before}); return ing
            A(rid,rname,before,"Bracket in the unit the script can't read safely",sug); return ing
    elif pk and (a or pk.group('c') not in (None,'each')):
        if not a: new['ingredient_amount']=1.0
        c=(pk.group('c') or '').lower(); cu='' if c in ('','each') else canon(c)
        new['ingredient_unit']=cu; setalt({'alt_amount':float(pk.group('s')),'alt_unit':canon(pk.group('u')),'each':True}); kinds.append('Package size kept as a second amount')
    elif a and re.match(r'^(oz|ounces?|g|grams?)\s+(cans?|packets?|tins?|jars?|packages?)$',ul):
        w,c=ul.split(None,1); new['ingredient_amount']=1.0; new['ingredient_unit']=canon(c)
        setalt({'alt_amount':a,'alt_unit':canon(w),'each':True}); kinds.append('Package size kept as a second amount')
    elif re.match(r'^(\d+(?:\.\d+)?)-inch pieces?$',ul) and a==1:
        new['ingredient_amount']=float(re.match(r'^(\d+(?:\.\d+)?)',ul).group(1)); new['ingredient_unit']='inch piece'; kinds.append('Spelling')
    elif ul=='': pass
    elif canon(ul):
        cu=canon(ul)
        if cu=='oz' and LIQUID.search(n) and not NOT_LIQUID.search(n): cu='fl oz'; kinds.append('oz on a liquid → fl oz')
        elif cu!=u: kinds.append('Spelling')
        new['ingredient_unit']=cu
    elif ',' in ul and canon(ul.split(',',1)[0]):
        p=u.split(',',1); cu=canon(p[0])
        if cu!=p[0].strip(): new['ingredient_unit']=cu+','+p[1]; kinds.append('Spelling')
    elif ul in NOTE and a:
        new['ingredient_amount']=0.0; kinds.append('Note with a stray amount → 0')
    elif MEASURE.search(ul) and not all(re.match(r'(tsp|tbsp|teaspoons?|tablespoons?)$',w.lower()) for w in MEASURE.findall(ul)):
        sug='Leave as written'
        if 'plus' in ul and 'cup' in ul: sug='One amount: ¼ cup + 1 tbsp = 5 tbsp (75 ml)'
        elif 'plus' in ul: sug='Leave as written: spoons stay spoons in both systems'
        elif ul.startswith('to '): sug='Use the top of the range (½ cup), or keep as written with no conversion'
        elif 'tins' in ul: sug='Unit tin, second amount about 4 oz each'
        elif 'each' in ul and re.search(r'tsp|tbsp',ul): sug='Leave as written: spoons stay spoons in both systems'
        elif 'heaping' in ul: sug='Leave as written: spoons stay spoons in both systems'
        A(rid,rname,before,"Unit with a measurement the script can't read",sug); return ing
    else:
        pass_through.append({'id':rid,'recipe':rname,'line':before}); return ing
    nm=new['ingredient_name']; bm=re.search(r'\(([^()]*\d[^()]*)\)', nm)
    if bm and not re.search(r'\b(cans?|or|inch|thick|from|made|blend|lean|%)\b|%|/', bm.group(1), re.I):
        alt=parse_alt(bm.group(1))
        if alt and alt['alt_unit'] in WEIGHT_U and not new.get('alt_amount'):
            setalt(alt); nm=re.sub(r'\s+,',',',(nm[:bm.start()].rstrip()+nm[bm.end():])).strip(); new['ingredient_name']=nm
            kinds.append('Count plus weight kept (from the name)')
    nm=new['ingredient_name']
    def can_sub(m):
        g=int(round(num(m.group(1))*28.3495/5)*5); ins=nm[:m.start()].count('(')>nm[:m.start()].count(')')
        return f'{m.group(0)} / {g} g' if ins else f'{m.group(0)} ({g} g)'
    nm2=re.sub(r'(\d+(?:\.\d+)?)[- ]ounce(?= cans?\b)', can_sub, nm)
    nm2=re.sub(r'(\d+(?:\s+\d+/\d+|\.\d+|/\d+)?|\d*[½¼¾])\s+cups?(?= whole rolled oats)', lambda m: m.group(0)+' (110 g)', nm2) if 'rolled oats' in nm2 and 'g)' not in nm2 else nm2
    nm2=fix_text(nm2, rid, rname, None)
    if nm2!=nm: new['ingredient_name']=nm2; kinds.append('Sizes in the name, both systems')
    extra=(f"   [second amount: {'about ' if new.get('alt_approx') else ''}{new['alt_amount']:g} {new['alt_unit']}{' each' if new.get('alt_each') else ''}]" if new.get('alt_amount') else '')
    after=show(new.get('ingredient_amount'),new.get('ingredient_unit',''),new['ingredient_name'],extra)
    if kinds and after!=before: rec_change(rid,rname,' + '.join(dict.fromkeys(kinds)),before,after)
    elif not kinds and u and not canon(ul): pass_through.append({'id':rid,'recipe':rname,'line':before})
    return new
files=sorted(glob.glob(SRC+'/*.json')); stats={'files':0,'changed':0}
for f in files:
    raw=open(f,encoding='utf-8').read(); d=json.loads(raw); stats['files']+=1; fmt=None
    for ind in (2,4,'\t'):
        for ea in (True,False):
            if json.dumps(d,indent=ind,ensure_ascii=ea)+('\n' if raw.endswith('\n') else '')==raw: fmt=(ind,ea)
    r=d['recipe']; rid=d['id']; nm=r['name']
    r['ingredients']=[do_ing(i,rid,nm) for i in r['ingredients']]
    r['steps']=[fix_text(s,rid,nm,'Step: temperature or size in both systems') for s in r.get('steps') or []]
    out=json.dumps(d,indent=fmt[0],ensure_ascii=fmt[1])+('\n' if raw.endswith('\n') else '')
    if out!=raw: stats['changed']+=1
    open(os.path.join(OUT,os.path.basename(f)),'w',encoding='utf-8').write(out)
json.dump({'stats':stats,'changes':changes,'ask':ask,'pass':pass_through},open(os.path.expanduser('~/unitpass/report.json'),'w'),ensure_ascii=False,indent=1)
from collections import Counter
print(stats, len(changes),'changes', len(ask),'ask', len(pass_through),'pass-through'); print(Counter(c['kind'] for c in changes).most_common())
