# Python mirror of UnitConverter.swift (1.4), to check every ingredient in both systems at several servings.
# Keep in step with the Swift file: same tables, same order of rules.
import json, glob, os, re, sys, math

UNITS = {  # unit: (system, dimension, base)   system None = spoon
 'tsp': (None,'volume',5), 'tbsp': (None,'volume',15), 'cup': ('us','volume',240), 'fl oz': ('us','volume',29.5735),
 'pint': ('us','volume',473.176), 'quart': ('us','volume',946.353), 'gallon': ('us','volume',3785.41),
 'oz': ('us','weight',28.3495), 'lb': ('us','weight',453.592), 'ml': ('metric','volume',1), 'l': ('metric','volume',1000),
 'g': ('metric','weight',1), 'kg': ('metric','weight',1000), 'inch': ('us','length',2.54), 'inch piece': ('us','length',2.54),
 'cm': ('metric','length',1), 'mm': ('metric','length',0.1)}
BUTTER_STICK = ('us','weight',113)
PLURALS = {"cup":"cups","pint":"pints","quart":"quarts","gallon":"gallons","clove":"cloves","slice":"slices","piece":"pieces","sprig":"sprigs","handful":"handfuls","pinch":"pinches","dash":"dashes","can":"cans","tin":"tins","stick":"sticks","head":"heads","packet":"packets","package":"packages","jar":"jars","sheet":"sheets","strip":"strips","ear":"ears","stalk":"stalks","leaf":"leaves","drop":"drops","bag":"bags","box":"boxes","bottle":"bottles","fillet":"fillets","link":"links","bunch":"bunches","small bunch":"small bunches","pod":"pods","breast":"breasts","splash":"splashes"}
ALIASES = {"cups":"cup","c":"cup","tablespoon":"tbsp","tablespoons":"tbsp","tbs":"tbsp","tbl":"tbsp","teaspoon":"tsp","teaspoons":"tsp","ounce":"oz","ounces":"oz","fluid ounce":"fl oz","fluid ounces":"fl oz","pound":"lb","pounds":"lb","lbs":"lb","gram":"g","grams":"g","gr":"g","kilogram":"kg","kilograms":"kg","milliliter":"ml","milliliters":"ml","millilitre":"ml","millilitres":"ml","liter":"l","liters":"l","litre":"l","litres":"l","inches":"inch","pints":"pint","quarts":"quart","gallons":"gallon"}
def canon(raw):
    u=raw.strip().lower()
    if u in ALIASES: return ALIASES[u]
    for s,p in PLURALS.items():
        if p==u: return s
    return u
def info(unit,name):
    if unit=='stick': return BUTTER_STICK if 'butter' in name.lower() else None
    return UNITS.get(unit)
TABLE=[("almond (flour|meal)",96),("oat flour",92),("(sweet|glutinous) rice flour",120),("(white )?rice flour",142),("semolina( flour)?",163),("whole wheat pastry flour|whole-wheat pastry flour|graham flour",96),("whole wheat flour|whole-wheat flour",113),("(white )?rye flour",106),("(bread|cake) flour",120),("(all-purpose|plain|ap)( white)? flour|flour",120),("(cornstarch|corn starch|cornflour)",112),("potato starch",152),("(light |dark )?brown sugar",213),("(confectioners'?|confectioners’|powdered|icing) sugar",113),("(granulated |white |caster |cane )?sugar",198),("butter",226),("(unsweetened )?(dutch-process(ed)? )?(cocoa|cocoa powder|cacao powder)",84),("(old-fashioned |quick |quick-cooking )?(rolled )?oats",89),("(long-grain|basmati|jasmine)( white)? rice",198),("quinoa",177),("panko( bread ?crumbs)?",50),("(dried |dry |plain )?bread ?crumbs",112),("(parmesan|parmigiano-reggiano|parmigiano|pecorino|pecorino romano)( cheese)?",100),("(cheddar|mozzarella|monterey jack|jack|swiss|gruyère|gruyere)( cheese)?",113),("feta( cheese)?",114),("(whole[- ]milk )?ricotta( cheese)?",227),("cream cheese",227),("(mayonnaise|mayo)",226),("sour cream",227),("(semisweet |semi-sweet |bittersweet |dark |milk |white )?chocolate chips",170),("(plain |greek |whole[- ]milk |full-fat )*yogurt",227),("walnuts|walnut halves",128),("sliced almonds",86),("(whole )?almonds",142),("cashews",113),("(diced )?pecans",114),("sunflower seeds",140),("(pepitas|pumpkin seeds)",160),("dried cranberries",114),("dried apricots",128),("raisins",149),("unsweetened (shredded |flaked )?coconut",53),("sweetened (shredded |flaked )?coconut",85),("(creamy |smooth |crunchy )?peanut butter",270),("tomato paste",232)]
TABLE_RE=[(re.compile('^(?:'+p+')$'),g) for p,g in TABLE]
IGNORED={"unsalted","salted","softened","melted","cold","room-temperature","packed","firmly","lightly","sifted","unbleached","organic","raw","toasted","grated","shredded","crumbled","freshly","finely","good-quality","store-bought"}
def gpc(name):
    m=re.sub(r'\s*\([^)]*\)','',name.lower()); m=m.split(',')[0]
    phrase=' '.join(w for w in m.split(' ') if w and w not in IGNORED)
    for r,g in TABLE_RE:
        if r.match(phrase): return g
    return None
GLYPHS=[(0.125,'⅛'),(0.25,'¼'),(1/3,'⅓'),(0.375,'⅜'),(0.5,'½'),(0.625,'⅝'),(2/3,'⅔'),(0.75,'¾'),(0.875,'⅞')]
EIGHTH=[0,0.125,0.25,1/3,0.375,0.5,0.625,2/3,0.75,0.875,1]
CUP=[0,0.25,1/3,0.5,2/3,0.75,1]; QUARTER=[0,0.25,0.5,0.75,1]; HALF=[0,0.5,1]; TSP=[0,0.125,0.25,0.5,0.75,1]
def snap(v,steps,minimum=None):
    whole=math.floor(v); frac=v-whole; best=steps[0]
    for s in steps:
        if abs(s-frac)<abs(best-frac): best=s
    if best>=1: whole+=1; best=0
    sn=whole+best
    if sn<=0:
        sn=minimum if minimum is not None else next(s for s in steps if s>0); whole=math.floor(sn); best=sn-whole
    g=next((gl for val,gl in GLYPHS if abs(val-best)<0.001),'')
    t=(str(int(whole)) if whole>0 else '')+g
    return sn,(t or '0')
def fmtnum(v):  # GroceryFormatter.format
    whole=int(v); f=v-whole
    if f<0.02: return str(whole)
    if f>0.98: return str(whole+1)
    for val,gl in GLYPHS:
        if abs(val-f)<0.03: return (gl if whole==0 else f'{whole}{gl}')
    t=f'{v:.2f}'.rstrip('0').rstrip('.'); return t
def label(u,v): return PLURALS.get(u,u) if v>1 else u
def dunit(u,v):
    if u=='l': return 'L'
    if u=='inch': return 'inches' if v>1 else 'inch'
    if u=='inch piece': return 'inch piece'
    return label(u,v)
def trimmed(v): return str(int(v)) if v==int(v) else f'{v:.1f}'
def round_metric(v):
    step=1 if v<10 else 5 if v<100 else 10 if v<500 else 25
    return max(1, round_half_away(v/step)*step)
def round_half_away(x): return math.floor(x+0.5) if x>=0 else -math.floor(-x+0.5)   # Swift .rounded()
INCH_CM=[(0.125,'3 mm'),(0.25,'6 mm'),(1/3,'8 mm'),(0.5,'1 cm'),(2/3,'1.5 cm'),(0.75,'2 cm'),(1,'2.5 cm'),(1.5,'4 cm'),(2,'5 cm'),(2.5,'6 cm'),(3,'7.5 cm'),(4,'10 cm'),(5,'13 cm'),(6,'15 cm'),(7,'18 cm'),(8,'20 cm'),(9,'23 cm'),(10,'25 cm'),(11,'28 cm'),(12,'30 cm'),(13,'33 cm')]
def cm_text(cm):
    inches=cm/2.54
    for i,t in INCH_CM:
        if abs(i-inches)<0.02: return t
    if cm<1: return f'{max(1,round_half_away(cm*10))} mm'
    return (trimmed(round_half_away(cm*2)/2) if cm<5 else str(round_half_away(cm)))+' cm'
def inch_text(cm,piece):
    v,t=snap(cm/2.54,QUARTER,0.25)
    return f'{t}-inch piece' if piece else f'{t} {"inches" if v>1 else "inch"}'
def metric_text(v,dim,fine=False):
    if dim=='length': return cm_text(v)
    if fine and v<1000: st=1 if v<10 else 5; r=max(1,round_half_away(v/st)*st)
    else: r=round_metric(v)
    if r>=1000: return trimmed(round_half_away(v/100)/10)+(' kg' if dim=='weight' else ' L')
    return f'{int(r)}'+(' g' if dim=='weight' else ' ml')
def too_small_for_oz(g):
    oz=g/28.3495
    if not (0<oz<1): return False
    q=max(0.25,round_half_away(oz*4)/4); return abs(q-oz)/oz>0.25
def us_weight(g):
    oz=g/28.3495
    if oz<15.5:
        if oz<1: return snap(oz,QUARTER,0.25)[1]+' oz'
        step=0.5 if oz<4 else 1
        return snap(round_half_away(oz/step)*step,HALF)[1]+' oz'
    lb=g/453.592; q=round_half_away(lb*4)/4
    if abs(q-lb)/lb<=0.05: return snap(q,QUARTER)[1]+' lb'
    return trimmed(round_half_away(lb*10)/10)+' lb'
def us_volume(ml):
    t=ml/5
    if t<2.9: return snap(t,TSP,0.125)[1]+' tsp'
    if t<11.5: return snap(t/3,HALF)[1]+' tbsp'
    ex=t/48; v,tx=snap(ex,CUP)
    if abs(v-ex)/ex<=0.05: return tx+' '+label('cup',v)
    tb=t/3
    if tb<=8.25: return snap(tb,HALF)[1]+' tbsp'
    whole=math.floor(ex); part=max([c for c in CUP if c<1 and c<=ex-whole+0.0001] or [0])
    bv,bt=snap(whole+part,CUP); rv,rt=snap((ex-bv)*16,HALF)
    if rv<0.5 or rt=='0': return bt+' '+label('cup',bv)
    return bt+' '+label('cup',bv)+' + '+rt+' tbsp' 
def numtext(v):
    n=fmtnum(v)
    return snap(v,EIGHTH)[1] if ('.' in n and v<100) else n
def original(v,u): return f'{numtext(v)} {dunit(u,v)}'
def count_text(v,u): n=numtext(v); return n if not u else f'{n} {dunit(u,v)}'
def same_system(v,u,inf):
    base=v*inf[2]
    if inf[0]=='metric':
        return cm_text(base) if inf[1]=='length' else metric_text(base,inf[1])
    if u=='cup': return us_volume(base)
    if u in('oz','lb'): return us_weight(base)
    if u in('inch','inch piece'): return inch_text(base,u=='inch piece')
    sv,st=snap(v,QUARTER,0.25); return st+' '+dunit(u,sv)
def scaled_spoon(t,allow_cups):
    if allow_cups and t>=12:
        cups=t/48; sv,st=snap(cups,CUP)
        if abs(sv-cups)/cups<=0.03: return st+' '+label('cup',sv)
    if t>=2.9: return snap(t/3,HALF)[1]+' tbsp'
    return snap(t,TSP,0.125)[1]+' tsp'
def spoon_text(v,u,inf,name,system,orig):
    ml=v*inf[2]; g=gpc(name); grams=ml/240*g if g else None
    if system=='metric' and not orig and ml>60:
        return metric_text(grams,'weight') if grams is not None else metric_text(ml,'volume')
    sp=original(v,u) if orig else scaled_spoon(ml/5, system=='us')
    if not(system=='metric' and ml>=15 and not sp.endswith('tsp')): return sp
    extra=metric_text(grams,'weight') if grams is not None else metric_text(ml,'volume')
    return f'{sp} ({extra})'
def fmt(v,u,inf,name,system,orig,converting):
    if inf[0] is None: return spoon_text(v,u,inf,name,system,orig),False,(system=='metric' and v*inf[2]>=15)
    if inf[0]==system or not converting:
        return (original(v,u) if orig else same_system(v,u,inf)),False,False
    base=v*inf[2]; dim=inf[1]
    if dim=='volume' and system=='metric':
        g=gpc(name); return (metric_text(base/240*g,'weight') if g else metric_text(base,'volume')),True,False
    if dim=='weight' and system=='metric': return metric_text(base,'weight'),True,False
    if dim=='weight' and system=='us':
        g=gpc(name)
        if g: return us_volume(base/g*240),True,False
        if too_small_for_oz(base): return (original(v,u) if orig else metric_text(base,'weight')),False,False   # a few grams stay grams
        return us_weight(base),True,False
    if dim=='volume' and system=='us': return us_volume(base),True,False
    if dim=='length' and system=='metric': return cm_text(base)+(' piece' if u=='inch piece' else ''),True,False
    return inch_text(base,u=='inch piece'),True,False
def other(s): return 'metric' if s=='us' else 'us'
def measure(amount,unit,name,alt_amount=None,alt_unit=None,alt_each=False,alt_approx=False,scale=1,system='us'):
    u=canon(unit); v=amount*scale
    if v<=0: return None
    orig=abs(scale-1)<0.0001; inf=info(u,name); alt=None
    if alt_amount and alt_amount>0 and alt_unit:
        au=canon(alt_unit); alt=(alt_amount if alt_each else alt_amount*scale, au, info(au,name))
    alt_orig=orig or alt_each
    def alt_detail(converting):
        if not alt: return None
        pre='about ' if alt_approx else ''; suf=' each' if alt_each else ''
        if alt[2] is None: return pre+count_text(alt[0],alt[1])+suf, False
        if alt_each and not alt_approx and converting and alt[2][0]!=system and alt[2][1]=='weight' and system=='metric':
            return metric_text(alt[0]*alt[2][2],'weight',True)+suf, True
        t,c,_=fmt(alt[0],alt[1],alt[2],name,system,alt_orig,converting)
        if alt[2][0] is None: t=t.split(' (')[0]   # a spoon as the second amount needs no ml
        return pre+t+suf, c
    if inf is None:
        if not(u in PLURALS or (u=='' and alt)): return None
        d=alt_detail(True)
        return (count_text(v,u), d[0] if d else None, d[1] if d else False)
    if inf[0] is None or inf[0]==system:
        t,c,own=fmt(v,u,inf,name,system,orig,False); detail=None
        if alt and ((alt[2][0] if alt[2] else None)!=other(system) or (alt[2] is not None and alt[2][0] is None)):
            d=alt_detail(False); detail=d[0] if d else None
        if own: detail=None
        return (t,detail,c)
    if alt and alt[2] is not None and (alt[2][0]==system or alt[2][0] is None):
        t,_,_=fmt(alt[0],alt[1],alt[2],name,system,alt_orig,False)
        return (('about ' if alt_approx else '')+t+(' each' if alt_each else ''),None,True)
    if system=='metric' and inf[1]=='volume' and alt and alt[2] is not None and alt[2][0]=='us' and alt[2][1]=='weight':
        return (('about ' if alt_approx else '')+metric_text(alt[0]*alt[2][2],'weight'),None,True)
    t,_,_=fmt(v,u,inf,name,system,False,True); detail=None
    if alt and alt[2] is None:
        d=alt_detail(False); detail=d[0] if d else None
    return (t,detail,True)
def combined(m): return f'{m[0]} ({m[1]})' if m[1] else m[0]

if __name__=='__main__':
    SRC=sys.argv[1]
    odd=re.compile(r'(^|\s)0(\s|$)|\d\.\d{2}|\b0 [a-z]'); meas=re.compile(r'\b(cups?|tbsp|tsp|oz|lb|g|kg|ml|l|inch)\b')
    n=0; problems=[]; samples={}
    for f in sorted(glob.glob(SRC+'/*.json')):
        r=json.load(open(f))['recipe']
        for i in r['ingredients']:
            raw=i['ingredient_unit'].split(',')[0]
            for system in ('us','metric'):
                for sc in (0.5,1,1.5,2,3):
                    n+=1
                    m=measure(i['ingredient_amount'],raw,i['ingredient_name'],i.get('alt_amount'),i.get('alt_unit'),i.get('alt_each',False),i.get('alt_approx',False),sc,system)
                    line=f"{r['name'][:28]} | {i['ingredient_amount']:g} {i['ingredient_unit']} {i['ingredient_name'][:40]} ×{sc} {system}"
                    if m is None:
                        if i['ingredient_amount']>0 and meas.search(canon(raw)): problems.append('UNREAD '+line)
                        continue
                    if odd.search(combined(m)): problems.append('ODD '+line+' → '+combined(m))
                    if sc==1: samples.setdefault((canon(raw),system),[]).append((line,combined(m),m[2]))
    print(n,'conversions',len(problems),'problems')
    for p in problems[:80]: print(p)
    json.dump({k[0]+'|'+k[1]:v for k,v in samples.items()},open('converter_samples.json','w'),ensure_ascii=False,indent=0)
