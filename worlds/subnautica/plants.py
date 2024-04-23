import functools
from typing import Dict, TypedDict, List

class Vector(TypedDict):
    x: float
    y: float
    z: float

class FloraDict(TypedDict):
    name: str
    position: Vector

all_flora: Dict[int, FloraDict] = {
    34500: { 'name': 'Acid Mushroom', 'position': {'x': 0, 'y': 0, 'z': 0} },
    34501: { 'name': 'Anchor Pods', 'position': {'x': -250, 'y': -99, 'z': -690} },
    34502: { 'name': 'Bloodroot', 'position': {'x': -1068, 'y': -378, 'z': -605} },
    34503: { 'name': 'Bloodvine', 'position': {'x': -807, 'y': -219, 'z': 892} },
    34504: { 'name': 'Blue Palm', 'position': {'x': 0, 'y': 0, 'z': 0} },
    34505: { 'name': 'Brine Lily', 'position': {'x': -1264, 'y': -649, 'z': -215} },
    34506: { 'name': 'Bulb Bush', 'position': {'x': 690, 'y': -137, 'z': 835} },
    34507: { 'name': 'Bulbo Tree', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34508: { 'name': 'Cave Bush', 'position': {'x': 358, 'y': -28, 'z': 1067} },
    34509: { 'name': 'Chinese Potato Plant', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34510: { 'name': 'Crab Claw Kelp', 'position': {'x': -1081, 'y': -713, 'z': -588} },
    34511: { 'name': 'Creepvine', 'position': {'x': 0, 'y': 0, 'z': 0} },
    34512: { 'name': 'Creepvine Seeds', 'position': {'x': 0, 'y': 0, 'z': 0} },
    34513: { 'name': 'Deep Shroom', 'position': {'x': -807, 'y': -219, 'z': 892} },
    34514: { 'name': 'Drooping Stingers', 'position': {'x': -318, 'y': -79, 'z': 247} },
    34515: { 'name': 'Eye Stalk', 'position': {'x': -34, 'y': -22, 'z': 411} },
    34516: { 'name': 'Fern Palm', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34517: { 'name': 'Furled Papyrus', 'position': {'x': -496, 'y': -114, 'z': -11} },
    34518: { 'name': "Gabe's Feather", 'position': {'x': -795, 'y': -239, 'z': -360} },
    34519: { 'name': 'Gel Sack', 'position': {'x': 432, 'y': 3, 'z': 1193} },
    34520: { 'name': 'Ghost Weed', 'position': {'x': -780, 'y': -234, 'z': 950} },
    34521: { 'name': 'Giant Cove Tree', 'position': { 'x': -860, 'y': -920, 'z': 340} },
    34522: { 'name': 'Grub Basket' ,'position': {'x': -707, 'y': 1, 'z': -1097} },
    34523: { 'name': 'Jaffa Cup', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34524: { 'name': 'Jellyshroom', 'position': {'x': -350, 'y': -152, 'z': -208} },
    34525: { 'name': 'Lantern Tree', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34526: { 'name': 'Marblemelon Plant', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34527: { 'name': 'Membrain Tre', 'position': {'x': -382, 'y': -133, 'z': -669} },
    34528: { 'name': 'Ming Plant', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34529: { 'name': 'Pink Cap', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34530: { 'name': 'Pygmy Fan', 'position': {'x': -670, 'y': -190, 'z': 714} },
    34531: { 'name': 'Redwort', 'position': {'x': 384, 'y': -87, 'z': 1013} },
    34532: { 'name': 'Regress Shell', 'position': {'x': 384, 'y': -87, 'z': 1013} },
    34533: { 'name': 'Rouge Cradle', 'position': {'x': -496, 'y': 114, 'z': -11} },
    34534: { 'name': 'Sea Crown', 'position': {'x': -797, 'y': -143, 'z': -152} },
    34535: { 'name': 'Speckled Rattler', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34536: { 'name': 'Spiked Horn Grass', 'position': {'x': 334, 'y': -87, 'z': 1013} },
    34537: { 'name': 'Spotted Dockleaf', 'position': {'x': 334, 'y': -87, 'z': 1013} },
    34538: { 'name': 'Sulfer Plant', 'position': {'x': 0, 'y': 0, 'z': 0} },
    34539: { 'name': 'Tiger Plant', 'position': {'x': -100, 'y': -100, 'z': -100} },
    34540: { 'name': 'Tree Leech', 'position': {'x': 363, 'y': -17, 'z': 1050} },
    34541: { 'name': 'Veined Nettle', 'position': {'x': 0, 'y': 0, 'z': 0} },
    34542: { 'name': 'Violet Beau', 'position': {'x': -496, 'y': -114, 'z': -11} },
    34543: { 'name': 'Voxel Shrub', 'position': {'x': -707, 'y': 1, 'z': -1097} },
    34544: { 'name': 'Writhing Weed', 'position': {'x': 0, 'y': 0, 'z': 0} }
}

suffix: str = " Scan"

plant_locations: Dict[str, int] = {
    data["name"] + suffix: loc_id for loc_id, data in all_flora.items()
}
