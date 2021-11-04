import glob
import re
import os

colors= []
artworks = []
palette = []

def palette_to_bytes(palette):
    tokens = []
    for color in palette:
        tokens.append(f'{color[0:2]}')
        tokens.append(f'{color[2:4]}')
        tokens.append(f'{color[4:6]}')
    return ''.join(tokens)

def artworks_to_bytes(artworks):
    tokens = []
    for a in artworks:
        if a != 16:
            tokens.append(f'{a:x}')
        else:
            tokens.append('X')
    return ''.join(tokens)

for path in sorted(glob.glob("./svg/*.svg")):
    filename = os.path.basename(path)
    name = os.path.splitext(filename)[0]
    id = int(name.split('-')[1])
    src = open(path, 'r').read()

    color1 = '000000'
    color2 = '000000'

    # Note: the smart contract composes the SVG differently,
    # that's why the two classes are swapped.
    re1 = re.compile('cls-2{fill:#(......)')
    re2 = re.compile('cls-1{fill:#(......)')

    match1 = re1.search(src)
    match2 = re2.search(src)

    if match1:
        color1 = match1.group(1)
    if match2:
        color2 = match2.group(1)

    if color1 not in palette:
        palette.append(color1)
    
    if color2 not in palette:
        palette.append(color2)

    artworks.append(palette.index(color1))
    artworks.append(palette.index(color2))
    colors.append(color1)
    colors.append(color2)

print(palette_to_bytes(palette))
print(artworks_to_bytes(artworks))
print(colors)