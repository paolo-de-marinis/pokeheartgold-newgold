"""Paolo's ChatGPT pictures of Bramblin -> the game's formats (2026-10-07).

The first conversion of docs/newgold/DEVKIT-PROMPTS.md's flow, kept as it ran:
battle front and back with their normal and shiny palettes, the party icon in
the closest shared icon palette, the follower's eight frames at HeartGold's
size for the species' Dex height, with its two palettes. It reads the eight
pictures as img1..img8.png from S and writes into the tree at W (a test
worktree, never Paolo's saves). The sprite editor generalises it: the species,
the picture files and the frame grid become its inputs.
"""
import sys, io, json, collections
from PIL import Image, ImageChops
W = '/home/paolo/hgss-worktrees/extra2'
S = '/home/paolo/hgss-worktrees/.rounds/sprites-test/set2'
sys.path.insert(0, W + '/tools/newgold/import')

def mask_of(im):
    r, g, b = im.split()
    bg = ImageChops.multiply(ImageChops.multiply(r.point(lambda v: 255 if v > 190 else 0),
                                                 b.point(lambda v: 255 if v > 190 else 0)),
                             g.point(lambda v: 255 if v < 90 else 0))
    return ImageChops.invert(bg)

def shrink(im, size, crop=True):
    """dict (x,y)->rgb555-ish colour of the picture scaled to `size` (w,h);
    crop to the picture's bbox first when crop (battle), else the whole cell."""
    m = mask_of(im)
    if crop:
        box = m.getbbox(); im, m = im.crop(box), m.crop(box)
        w = size[0]; h = round(im.height * w / im.width); size = (w, h)
    pre = ImageChops.multiply(im, Image.merge('RGB', (m,) * 3)).resize(size, Image.BOX)
    cov = m.resize(size, Image.BOX)
    pp, cv, out = pre.load(), cov.load(), {}
    for y in range(size[1]):
        for x in range(size[0]):
            if cv[x, y] >= 128:
                out[x, y] = tuple(min(255, v * 255 // cv[x, y]) & 0xF8 for v in pp[x, y])
    return out, size

def quantize(dicts, n=15):
    pts = [c for d in dicts for c in d.values()]
    strip = Image.new('RGB', (len(pts), 1)); strip.putdata(pts)
    q = strip.quantize(n, method=Image.Quantize.LIBIMAGEQUANT, dither=Image.Dither.NONE)
    pal = q.getpalette()[:3 * n]; pal += [0] * (3 * n - len(pal))
    idx = list(q.tobytes()); out, k = [], 0
    for d in dicts:
        out.append({p: idx[k + i] + 1 for i, p in enumerate(d)}); k += len(d)
    return out, [tuple(pal[3 * i:3 * i + 3]) for i in range(n)]

def shiny_palette(index_maps, shiny_dicts, normal):
    votes = collections.defaultdict(collections.Counter)
    for im_, sd in zip(index_maps, shiny_dicts):
        for p, i in im_.items():
            if p in sd: votes[i][sd[p]] += 1
    return [votes[i + 1].most_common(1)[0][0] if votes[i + 1] else normal[i] for i in range(len(normal))]

def flat(pal):
    return [v for c in pal for v in c]

def load(n): return Image.open(f'{S}/img{n}.png').convert('RGB')

# A. battle: 6 front, 5 back; shiny 8 front, 7 back
fr, _ = shrink(load(6), (42, 0)); bk, _ = shrink(load(5), (42, 0))
sfr, _ = shrink(load(8), (42, 0)); sbk, _ = shrink(load(7), (42, 0))
(ifr, ibk), pal = quantize([fr, bk])
spal = shiny_palette([ifr, ibk], [sfr, sbk], pal)
def sheet(imap, palette):
    w = max(x for x, y in imap) + 1; h = max(y for x, y in imap) + 1
    frame = Image.new('P', (80, 80), 0); x0, y0 = (80 - w) // 2, 79 - h
    for (x, y), i in imap.items(): frame.putpixel((x0 + x, y0 + y), i)
    s = Image.new('P', (160, 80), 0); s.paste(frame, (0, 0)); s.paste(frame, (80, 0))
    s.putpalette([255, 0, 255] + flat(palette)); return s
for g in ('male', 'female'):
    sheet(ifr, pal).save(f'{W}/files/poketool/pokegra/pokegra/0967/{g}/front.png', transparency=0)
    sheet(ibk, spal).save(f'{W}/files/poketool/pokegra/pokegra/0967/{g}/back.png', transparency=0)

# B. icon: img4, two frames side by side -> 32x64, one shared palette
import import_icons as ic
icon = load(4); cw = icon.width // 2
frames = [shrink(icon.crop((k * cw, 0, k * cw + cw, icon.height)), (32, 32), crop=False)[0] for k in range(2)]
shared = ic.shared_palettes()
def err(c, p): return sum((a - b) ** 2 for a, b in zip(c, p))
best = min(range(3), key=lambda k: sum(min(err(c, shared[k][i]) for i in range(1, 16)) for f in frames for c in f.values()))
ip = Image.new('P', (32, 64), 0)
for k, f in enumerate(frames):
    for (x, y), c in f.items():
        ip.putpixel((x, y + 32 * k), min(range(1, 16), key=lambda i: err(c, shared[best][i])))
ip.putpalette(flat(shared[best]))
ip.save(f'{W}/files/poketool/icongra/poke_icon/poke_icon_00001010.png')
print('icon palette', best, 'current', ic.drawn_in(f'{S}/../icon_orig_1010.png', shared) if False else '?')

# C. follower: img3 normal, img1 shiny; grid 2x4 -> frames up,up,down,down,left,left,right,right
def follower_height(dm):
    """HGSS's rule, measured: the median drawn height of retail's 32x32
    followers whose Dex height is within 1 dm of this one."""
    rows = json.load(open('/home/paolo/hgss-worktrees/.rounds/sprites-test/follower_sizes.json'))
    near = sorted(r[2] for r in rows if r[1] == 32 and abs(r[0] - dm) <= 1)
    return near[len(near) // 2]

def cells(im, target):
    cw, ch = im.width // 2, im.height // 4
    raw = [[im.crop((c * cw, r * ch, c * cw + cw, r * ch + ch)) for c in range(2)] for r in range(4)]
    boxes = [[mask_of(x).getbbox() for x in row] for row in raw]
    tall = max(b[3] - b[1] for row in boxes for b in row)
    scale = target / tall                     # one factor for every frame
    out = []
    for row, brow in zip(raw, boxes):
        line = []
        for x, b in zip(row, brow):
            x = x.crop(b)
            w, h = max(1, round(x.width * scale)), max(1, round(x.height * scale))
            d, _ = shrink(x, (w, h), crop=False)
            frame = {(16 - w // 2 + px, 30 - h + py): c for (px, py), c in d.items()
                     if 0 <= 16 - w // 2 + px < 32 and 0 <= 30 - h + py < 32}
            line.append(frame)
        out.append(line)
    return [out[1][0], out[1][1], out[0][0], out[0][1], out[2][0], out[2][1], out[3][0], out[3][1]]
zk = json.load(open(W + "/files/application/zukanlist/zkn_data/zukan_data.json"))["mon_stats"]
target = follower_height(zk[967]["height"]); print("follower height", target)
nf, sf = cells(load(3), target), cells(load(1), target)
imaps, opal = quantize(nf)
ospal = shiny_palette(imaps, sf, opal)
ow = Image.new('P', (32, 256), 0)
for k, m in enumerate(imaps):
    for (x, y), i in m.items(): ow.putpixel((x, y + 32 * k), i)
ow.putpalette([255, 0, 255] + flat(opal))
buf = io.BytesIO(); ow.save(buf, 'PNG'); ow.save(f'{S}/overworld_new.png')
def jasc(p): return ('JASC-PAL\r\n0100\r\n16\r\n' + ''.join(f'{r} {g} {b}\r\n' for r, g, b in [(255, 0, 255)] + list(p))).encode()
import import_followers as f
real = f.show
files = {'NEW/overworld.png': buf.getvalue(), 'NEW/overworld-tsure_poke0.pal': jasc(opal), 'NEW/overworld-tsure_poke1.pal': jasc(ospal)}
def show(path, reference=f.REFERENCE):
    if path in files: return files[path]
    if path.startswith('NEW/'): return real('data/graphics/sprites/bramblin/' + path[4:], reference)
    return real(path, reference)
f.show = show
meta = json.loads(show('NEW/overworld.json')); print('palettes', [p['fileName'] for p in meta['palettes'].values()])
open(f'{W}/files/data/mmodel/mmodel/mmodel_00001322.NSBTX', 'wb').write(f.nsbtx('NEW'))
print('done')
