#!/usr/bin/env python3
"""Reproduce pinned NewGold patch-manifest mappings without editing either checkout.

Usage: python3 inventory.py SOURCE_CHECKOUT TARGET_CHECKOUT XMAP OUTPUT_DIRECTORY
The map must be heartgoldus.xMAP from pret xmap commit ea4460e154ddaaca5a6deebd4b5254c2a3d484ae.
Only manifest declarations are inventoried: ARMIPS/generated data/new unhooked logic need a separate ledger.
"""
import collections
import csv
import hashlib
import json
from functools import lru_cache
import subprocess
from pathlib import Path
import re
import sys

SOURCE_COMMIT = '1b872926eaa0363816d4e376fad1531435b04b9c'
TARGET_COMMIT = 'e97c7fc975a7447f288c42acc2e155f5a673e30f'
MAP_COMMIT = 'ea4460e154ddaaca5a6deebd4b5254c2a3d484ae'
MAP_SHA256 = 'f3a80da12ae51e2cc90123a2838c79c53a2ff422cc4bf1378cdf2c465cf0a611'
MANIFESTS = ('hooks', 'armhooks', 'bytereplacement', 'repoints', 'routinepointers')
ENCOUNTER_SYMBOLS = {'EncounterSlot_WildMonSlotRoll_' + x for x in ('Land', 'Surfing', 'Fishing', 'RockSmash', 'Headbutt')}


class Snapshot:
    """Read only the pinned commit, even after the working checkout gains port commits."""
    def __init__(self, root, commit):
        self.root, self.commit = root, commit
        self.paths = set(subprocess.check_output(['git', '-C', str(root), 'ls-tree', '-r', '--name-only', commit], text=True).splitlines())

    @lru_cache(maxsize=None)
    def read(self, path):
        return subprocess.check_output(['git', '-C', str(self.root), 'show', self.commit + ':' + str(path)]).decode(errors='replace')


def manifests(source):
    # Mirrors scripts/make.py TryProcessFileInclusion and conditional handling.
    # Includes deliberately collect every column-zero #define, not C-preprocessor output.
    # No additional -D command-line flags are assumed.
    for name in MANIFESTS:
        defines = set()
        conditionals = []
        for number, raw in enumerate(source.read(name).splitlines(), 1):
            if raw.startswith('#include "'):
                included = raw.split('"')[1]
                defines.update(m[1] for m in re.finditer(r'^#define\s+(\S+)', source.read(included), re.M))
                continue
            line = raw.strip()
            if line.startswith('#ifdef '):
                conditionals.append((line.split()[1], True))
            elif line.startswith('#ifndef '):
                conditionals.append((line.split()[1], False))
            elif line == '#else':
                macro, positive = conditionals.pop()
                conditionals.append((macro, not positive))
            elif line == '#endif':
                conditionals.pop()
            elif re.match(r'^(arm9|\d{4})\s', line):
                fields = line.split()
                if name == 'bytereplacement':
                    region, address, *payload = fields
                    symbol = ''
                else:
                    region, symbol, address, *payload = fields
                yield dict(manifest=name, line=number, declaration=line,
                           enabled=all((macro in defines) == positive for macro, positive in conditionals),
                           region=region, source_symbol=symbol, address=int(address, 16), payload=' '.join(payload),
                           conditions=' && '.join(('' if positive else '!') + macro for macro, positive in conditionals))
        assert not conditionals, name


def parse_map(text):
    overlay_ids = {m[2]: int(m[1], 16) for m in re.finditer(r'#>([0-9A-F]{8})\s+SDK_OVERLAY_(\w+)_ID', text)}
    bases = {m[2]: int(m[1], 16) for m in re.finditer(r'#>([0-9A-F]{8})\s+SDK_OVERLAY\.(\w+)\.START', text)}
    symbols = collections.defaultdict(list)
    section = None
    for number, line in enumerate(text.splitlines(), 1):
        if line.startswith('# .'):
            section = line[3:].strip()
        m = re.match(r'\s+([0-9A-F]{8}) ([0-9A-F]{8}) (\S+)\s+(\S+)\s+\(([^)]+)\)', line)
        if m and int(m[2], 16) and not m[4].startswith('$'):
            symbols[section].append(dict(section=section, start=int(m[1], 16), size=int(m[2], 16),
                                         kind=m[3], name=m[4], object=m[5].strip(), map_line=number))
    return overlay_ids, bases, symbols


def main():
    source, target, xmap, output = map(Path, sys.argv[1:])
    output.mkdir(parents=True, exist_ok=True)
    assert hashlib.sha256(xmap.read_bytes()).hexdigest() == MAP_SHA256, 'Unexpected xMAP revision/content'
    source = Snapshot(source, SOURCE_COMMIT)
    target = Snapshot(target, TARGET_COMMIT)
    map_text = xmap.read_text()
    overlay_ids, bases, symbols = parse_map(map_text)
    sections = {str(number).zfill(4): section for section, number in overlay_ids.items()}
    sections['arm9'] = 'main'
    bases['main'] = 0x02000000
    objects = collections.defaultdict(set)
    for match in re.finditer(r'Object\s+(\S+\.o)', target.read('main.lsf')):
        objects[Path(match[1]).name].add(match[1])
    source_texts = {p: source.read(p) for p in sorted(source.paths) if (p.startswith('src/') and p.endswith('.c')) or (p.startswith('asm/') and p.endswith('.s'))}
    target_cache = {}

    def target_source(symbol):
        paths = set()
        for obj in objects.get(symbol['object'], ()):
            stem = Path(obj[:-2])
            for suffix in ('.c', '.s'):
                if str(stem.with_suffix(suffix)) in target.paths:
                    paths.add(str(stem.with_suffix(suffix)))
        # Libraries are commonly archives in main.lsf; resolve the member by basename.
        if not paths:
            for suffix in ('.c', '.s'):
                paths.update(p for p in target.paths if p.startswith('lib/') and Path(p).name == symbol['object'][:-2] + suffix)
        matching = []
        for path in sorted(paths):
            data = target_cache.setdefault(path, target.read(path))
            name = re.escape(symbol['name'])
            definition = re.search(r'^[^\n;{}]*\b' + name + r'\s*\([^;{}]*\)\s*\{', data, re.M) if path.endswith('.c') else re.search(r'^' + name + r':', data, re.M)
            if definition:
                state = 'ASM' if path.endswith('.s') or re.search(r'\basm\b', definition[0]) else 'C'
                matching.append((path, state, data[:definition.start()].count('\n') + 1))
        if len(matching) == 1:
            return matching[0]
        if len(paths) == 1:
            path = next(iter(paths))
            return path, ('ASM' if path.endswith('.s') else 'UNRESOLVED'), ''
        return ';'.join(sorted(paths)), 'UNRESOLVED', ''

    def newgold_source(name):
        if not name:
            return ''
        name = re.escape(name.split('+')[0].split('-')[0])
        locations = []
        for path, text in source_texts.items():
            pattern = r'^[^\n;{}]*\b' + name + r'\s*\([^;{}]*\)\s*\{' if path.endswith('.c') else r'^' + name + r':'
            for match in re.finditer(pattern, text, re.M):
                locations.append(path + ':' + str(text[:match.start()].count('\n') + 1))
        return ';'.join(locations)

    ledger = []
    for entry in manifests(source):
        section = sections.get(entry['region'])
        address = entry['address'] if entry['address'] & 0x02000000 else bases.get(section, 0) + entry['address'] - 0x08000000
        candidates = [r for r in symbols.get(section, ()) if r['start'] <= address < r['start'] + r['size']]
        if entry['manifest'] in ('hooks', 'armhooks'):
            candidates = [r for r in candidates if r['kind'] == '.text']
        note = ''
        intended = False
        if not candidates and entry['source_symbol'] in ENCOUNTER_SYMBOLS:
            candidates = [r for r in symbols['OVY_2'] if r['start'] == address and r['name'] == entry['source_symbol']]
            assert len(candidates) == 1
            intended = True
            note = 'Exact name/address identify OVY_2, but manifest declares arm9; source installer writes arm9.bin. Bodies match vanilla C. Intended semantic target resolved; source installation anomaly, no behavioral change inferred.'
        candidates = sorted(candidates, key=lambda r: r['size'])
        match = candidates[0] if len(candidates) == 1 or (len(candidates) > 1 and candidates[0]['size'] < candidates[1]['size']) else None
        row = {**entry, 'address': f"0x{entry['address']:08X}", 'resolved_address': f'0x{address:08X}',
               'newgold_definition': newgold_source(entry['source_symbol']), 'original_function': '', 'target_file': '',
               'target_line': '', 'original_state': 'UNRESOLVED', 'target_section': section or '',
               'target_start': '', 'mapping': 'UNRESOLVED', 'category': 'executable logic' if entry['manifest'] in ('hooks', 'armhooks', 'routinepointers') else 'unclassified patch/data',
               'current_port_state': 'NOT STARTED', 'dependency': 'Feature-level semantic/dependency analysis required',
               'validation': 'NOT RUN', 'map_line': '', 'notes': note or '-'}
        if match:
            path, state, line = target_source(match)
            if match['kind'] != '.text':
                state = 'DATA'
                row['category'] = 'data'
            row.update(original_function=match['name'], target_file=path, target_line=line,
                       original_state=state, target_section=match['section'], target_start=f"0x{match['start']:08X}",
                       mapping='SEMANTIC TARGET; SOURCE REGION ERROR' if intended else 'SYMBOL RANGE',
                       current_port_state='MAPPED', map_line=match['map_line'])
        ledger.append(row)

    hooks = [r for r in ledger if r['manifest'] in ('hooks', 'armhooks') and r['enabled']]
    dedup = lambda rows: {(r['target_section'], r['target_start'], r['original_function']): r for r in rows if r['original_function']}
    strict = dedup(r for r in hooks if r['mapping'] == 'SYMBOL RANGE')
    resolved = dedup(hooks)
    assert len(hooks) == 370
    assert collections.Counter(r['original_state'] for r in strict.values()) == {'C': 302, 'ASM': 42}
    assert collections.Counter(r['original_state'] for r in resolved.values()) == {'C': 307, 'ASM': 42}
    assert sum(r['mapping'].endswith('SOURCE REGION ERROR') for r in hooks) == 5

    def function_body(text, name):
        match = re.search(r'\b' + re.escape(name) + r'\([^;{}]*\)\s*\{', text)
        start, depth = match.end(), 1
        end = start
        while depth:
            depth += (text[end] == '{') - (text[end] == '}')
            end += 1
        return re.sub(r'\s+', '', text[start:end - 1])

    for name in ENCOUNTER_SYMBOLS:
        assert function_body(source.read('src/field/encounter_check.c'), name) == function_body(target.read('src/field/encounter_check.c'), name), name

    summary = dict(source_commit=SOURCE_COMMIT, target_commit=TARGET_COMMIT, map_commit=MAP_COMMIT,
                   xmap_sha256=hashlib.sha256(xmap.read_bytes()).hexdigest(),
                   manifest_rows={p: sum(r['manifest'] == p for r in ledger) for p in MANIFESTS},
                   enabled_manifest_rows={p: sum(r['manifest'] == p and r['enabled'] for r in ledger) for p in MANIFESTS},
                   enabled_hook_rows=len(hooks), enabled_hook_sites=len({(r['region'], r['resolved_address']) for r in hooks}),
                   strict_mapped_functions=len(strict), strict_states=dict(collections.Counter(r['original_state'] for r in strict.values())),
                   intended_mapped_functions=len(resolved), intended_states=dict(collections.Counter(r['original_state'] for r in resolved.values())),
                   unresolved_hook_rows=sum(r['mapping'] == 'UNRESOLVED' for r in hooks),
                   source_region_error_rows=sum(r['mapping'].endswith('SOURCE REGION ERROR') for r in hooks),
                   asm_targets_converted_to_c=0, hooks_eliminated=0, binary_patches_eliminated=0,
                   features_ported=0, features_verified=0)
    with (output / 'manifest-ledger.tsv').open('w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=list(ledger[0]), delimiter='\t', lineterminator='\n')
        writer.writeheader()
        writer.writerows(ledger)
    (output / 'inventory-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    report = [
        '# NewGold baseline manifest inventory', '',
        'This is a pinned, reproducible **baseline mapping**, not a progress claim. Current milestone status and counters belong in the migration document; regenerating this inventory must not reset that progress.', '',
        f'- NewGold: `{SOURCE_COMMIT}`.',
        f'- pokeheartgold: `{TARGET_COMMIT}`.',
        f'- xMAP branch: `{MAP_COMMIT}`; `heartgoldus.xMAP` SHA-256 `{MAP_SHA256}`.', '',
        'The script reads committed blobs using `git show`, so subsequent working-tree edits or port commits do not change the original-state classification. It evaluates manifest conditionals like NewGold scripts/make.py, with the checked-in configuration and no additional `-D` flags. All declarations, including disabled declarations, remain in the TSV.', '',
        '| Measure | Count |', '|---|---:|',
        f"| Enabled hook declarations (Thumb + ARM) | {len(hooks)} |",
        f"| Distinct declared hook sites, normalized to RAM | {summary['enabled_hook_sites']} |",
        f"| Strictly matched original functions | {len(strict)} |",
        '| Strict matches already C | 302 |', '| Strict matches still ASM | 42 |',
        '| Originally unresolved declarations | 5 |',
        f"| Intended original functions after resolving the five | {len(resolved)} |",
        '| Intended targets already C | 307 |', '| Intended targets still ASM | 42 |',
        '| Semantically unidentified active hook targets | 0 |',
        '| Source declarations with an incorrect region | 5 |', '',
        'These are original functions, not features, lines of code, or port completion. Multiple hooks may intercept one function; file-offset and RAM spellings are normalized before site deduplication. Inline ASM is checked at the function definition, not inferred solely from the .c extension. The three inline-ASM functions in battle_hp_bar.c are not among these active hook targets.', '',
        '| Manifest | All declarations | Enabled declarations |', '|---|---:|---:|',
    ]
    report.extend(f"| {name} | {summary['manifest_rows'][name]} | {summary['enabled_manifest_rows'][name]} |" for name in MANIFESTS)
    report.extend(['', 'For byte replacements and pointer patches, a containing symbol identifies location only; it does not establish semantics, dependencies, or whether the patched bytes are executable. Such rows remain `unclassified patch/data` until inspected. This inventory does not cover every ARMIPS edit, generated asset, field/battle script, or newly introduced unhooked function. Those require the feature-level migration ledger.', '',
                   '## Resolution of the five encounter targets', '',
                   'The pinned xMAP identifies all five exact names and starting addresses in overlay 2 (`OVY_2`, RAM base `0x02245B80`). `main.lsf` places src/field/encounter_check.o in that overlay; src/field/encounter_check.c defines each function. The five NewGold function bodies in src/field/encounter_check.c are identical to the vanilla bodies after whitespace normalization (asserted by the script).', '',
                   '| NewGold declaration | Exact symbol / address | Target source |', '|---|---|---|'])
    for row in hooks:
        if row['source_symbol'] in ENCOUNTER_SYMBOLS:
            report.append(f"| {row['manifest']}:{row['line']} ({row['region']}) | {row['original_function']} / {row['resolved_address']} | {row['target_file']}:{row['target_line']} |")
    report.extend(['', '**Source anomaly:** the declarations say `arm9`, whereas the exact symbols are in overlay 2. NewGold scripts/make.py:360–368 chooses base/arm9.bin for an arm9 entry and subtracts 0x02000000; it does not infer an overlay from the address. Hence the written file offsets are 0x24768C, 0x247720, 0x247764, 0x24779C and 0x2477C0. This is evidence of an installation error in the reference source, not permission to silently reinterpret its behavior. Mapping the intended functions resolves their identity; it does not prove a produced NewGold ROM executes these five replacements. They require no gameplay change in the native port because the current replacement bodies preserve vanilla slot probabilities.', '',
                   '## Original ASM target backlog', '',
                   'Each row is an original function requiring feature-level investigation and, if it needs modification, vanilla ASM-to-C conversion before NewGold behavior is applied. This is the baseline backlog; later converted functions remain listed here as originally ASM.', '',
                   '| Original function | Baseline target | Example NewGold implementation |', '|---|---|---|'])
    for row in sorted((r for r in resolved.values() if r['original_state'] == 'ASM'), key=lambda r: (r['target_file'], r['target_start'])):
        report.append(f"| {row['original_function']} | {row['target_file']}:{row['target_line']} | {row['newgold_definition'] or row['source_symbol']} |")
    report.extend(['', '## Reproduce', '',
                   'Download the map from https://raw.githubusercontent.com/pret/pokeheartgold/' + MAP_COMMIT + '/heartgoldus.xMAP (the script checks the hash), then run:', '',
                   '```sh', 'python3 inventory.py /path/to/hg-engine-newgold /path/to/pokeheartgold /path/to/heartgoldus.xMAP /path/to/output', '```', '',
                   'Only the output directory is written. Git repositories must contain the two pinned commits. Python standard library and git are the only requirements. The script asserts the baseline totals and the five equal encounter bodies; these checks verify the mapping method, not gameplay or a built ROM.', ''])
    (output / 'INVENTORY.md').write_text('\n'.join(report))
    print(json.dumps(summary, indent=2))
    print('Unclassified active hooks:', [(r['source_symbol'], r['target_file'], r['original_function']) for r in hooks if r['original_state'] == 'UNRESOLVED'])


if __name__ == '__main__':
    main()
