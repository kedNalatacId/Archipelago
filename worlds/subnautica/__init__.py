from __future__ import annotations

import logging
import itertools
from typing import List, Dict, Any, cast

from BaseClasses import Region, Location, Item, Tutorial, ItemClassification
from worlds.AutoWorld import World, WebWorld
from . import items
from . import locations
from . import creatures
from . import plants
from . import options
from .items import item_table, base_item_table, non_vehicle_depth_table, seamoth_table, prawn_table, cyclops_table, group_items, items_by_type, ItemType
from .rules import set_rules

logger = logging.getLogger("Subnautica")


class SubnaticaWeb(WebWorld):
    tutorials = [Tutorial(
        "Multiworld Setup Guide",
        "A guide to setting up the Subnautica randomizer connected to an Archipelago Multiworld",
        "English",
        "setup_en.md",
        "setup/en",
        ["Berserker"]
    )]


all_locations = {data["name"]: loc_id for loc_id, data in locations.location_table.items()}
all_locations.update(creatures.creature_locations)
all_locations.update(plants.plant_locations)


class SubnauticaWorld(World):
    """
    Subnautica is an undersea exploration game. Stranded on an alien world, you become infected by
    an unknown bacteria. The planet's automatic quarantine will shoot you down if you try to leave.
    You must find a cure for yourself, build an escape rocket, and leave the planet.
    """
    game = "Subnautica"
    web = SubnaticaWeb()

    item_name_to_id = {data.name: item_id for item_id, data in items.item_table.items()}
    location_name_to_id = all_locations
    options_dataclass = options.SubnauticaOptions
    options: options.SubnauticaOptions
    data_version = 10
    required_client_version = (0, 4, 1)

    creatures_to_scan: List[str]
    plants_to_scan: List[str]

    def generate_early(self) -> None:
        if not self.options.filler_items_distribution.weights_pair[1][-1]:
            raise Exception("Filler Items Distribution needs at least one positive weight.")
        if self.options.early_seaglide:
            self.multiworld.local_early_items[self.player]["Seaglide Fragment"] = 2

        scan_option: options.AggressiveScanLogic = self.options.creature_scan_logic
        creature_pool = scan_option.get_pool()
        plant_pool = self.options.plant_scans.get_pool()

        self.options.creature_scans.value = min(
            len(creature_pool),
            self.options.creature_scans.value
        )

        self.options.plant_scans.value = min(
            len(plants.all_flora),
            self.options.plant_scans.value
        )

        self.creatures_to_scan = self.random.sample(
            creature_pool, self.options.creature_scans.value)

        self.plants_to_scan = self.random.sample(
            plant_pool, self.options.plant_scans.value)

    def create_regions(self):
        # Create Regions
        menu_region = Region("Menu", self.player, self.multiworld)
        planet_region = Region("Planet 4546B", self.player, self.multiworld)

        # Link regions together
        menu_region.connect(planet_region, "Lifepod 5")

        # Create regular locations
        location_names = itertools.chain((location["name"] for location in locations.location_table.values()),
                                         (creature + creatures.suffix for creature in self.creatures_to_scan),
                                         (plant for plant in self.plants_to_scan))
        for location_name in location_names:
            loc_id = self.location_name_to_id[location_name]
            location = SubnauticaLocation(self.player, location_name, loc_id, planet_region)
            planet_region.locations.append(location)

        # Create events
        goal_event_name = self.options.goal.get_event_name()

        # only create one event (the victory)
        for event in locations.events:
            if event == goal_event_name:
                location = SubnauticaLocation(self.player, event, None, planet_region)
                location.place_locked_item(
                    SubnauticaItem(event, ItemClassification.progression, None, player=self.player))
                location.item.name = "Victory"
                planet_region.locations.append(location)

        # Register regions to multiworld
        self.multiworld.regions += [
            menu_region,
            planet_region
        ]

    # refer to rules.py
    set_rules = set_rules

    def get_theoretical_swim_depth(self):
        depth: int = self.options.swim_rule.value
        consider_items: bool = self.options.consider_items.value
        seaglide_depth: int = self.options.seaglide_depth.value

        if consider_items:
            return depth + seaglide_depth + 150
        return depth

    def create_items(self):
        # Generate item pool
        pool: List[SubnauticaItem] = []
        extras = self.options.creature_scans.value + self.options.plant_scans.value

        grouped = set(itertools.chain.from_iterable(group_items.values()))

        for item_id, item in base_item_table.items():
            if item_id in grouped:
                extras += item.count
            else:
                for i in range(item.count):
                    subnautica_item = self.create_item(item.name)
                    if item.name == "Neptune Launch Platform":
                        if self.options.goal.get_event_name() == "Neptune Launch":
                            self.get_location("Aurora - Captain Data Terminal", self.player).place_locked_item(
                                subnautica_item)
                        else:
                            pool.append(subnautica_item)
                    elif item.name == "Cyclops Shield Generator":
                        if self.options.include_cyclops.value == 2 and self.options.goal.get_event_name() != "Neptune Launch":
                            extras += 1
                        else:
                            pool.append(subnautica_item)
                    else:
                        pool.append(subnautica_item)

        for item_id, item in seamoth_table.items():
            if self.options.include_seamoth.value < 2:
                for i in range(item.count):
                    pool.append(self.create_item(item.name))
            else:
                extras += item.count

        for item_id, item in prawn_table.items():
            if self.options.include_prawn.value < 2:
                for i in range(item.count):
                    pool.append(self.create_item(item.name))
            else:
                extras += item.count

        for item_id, item in cyclops_table.items():
            if self.options.include_cyclops.value < 2:
                for i in range(item.count):
                    pool.append(self.create_item(item.name))
            else:
                extras += item.count

        # If we can't make the necessary depth by traditional (vehicle) means, use the alternates
        # Shift the items to progression as part of that change
        seamoth_can_make_it: bool = False
        if self.options.include_seamoth.value == 0 and get_theoreitcal_swim_depth(self) + 900 > 1443:
            seamoth_can_make_it = True

        for item_id, item in non_vehicle_depth_table.items():
            for i in range(item.count):
                if seamoth_can_make_it == False and self.options.include_prawn.value > 0 and self.options.include_cyclops.value > 0:
                    pool.append(self.create_shifted_item(item.name, ItemClassification.progression))
                else:
                    pool.append(self.create_item(item.name))

        group_amount: int = 2
        assert len(group_items) * group_amount <= extras
        for item_id in group_items:
            name = item_table[item_id].name
            for _ in range(group_amount):
                pool.append(self.create_item(name))
            extras -= group_amount

        # list of high-count important fragments as priority filler
        num = 2
        priority_filler: List[str] = [
            "Modification Station Fragment",
            "Laser Cutter Fragment",
        ]

        # There are edge cases where we don't need these; don't make extra priority filler if we don't need them
        # We're wasting a single item here with moonpool fragments for the Cyclops... meh
        if self.options.include_seamoth.value < 2 or \
                self.options.include_prawn.value < 2 or \
                self.options.include_cyclops.value < 2 or \
                self.options.goal.get_event_name() == "Neptune Launch":
            num += 2
            priority_filler.append("Mobile Vehicle Bay Fragment")
            priority_filler.append("Moonpool Fragment")

        # Vehicle priority filler
        if self.options.include_seamoth.value < 2:
            priority_filler.append("Seamoth Fragment")
            num += 1
        if self.options.include_prawn.value < 2:
            priority_filler.append("Prawn Suit Fragment")
            num += 1
        if self.options.include_cyclops.value < 2:
            priority_filler.append("Cyclops Engine Fragment")
            priority_filler.append("Cyclops Hull Fragment")
            priority_filler.append("Cyclops Bridge Fragment")
            num += 3

        for item_name in self.random.sample(priority_filler, k=min(extras, num)):
            item = self.create_item(item_name)
            pool.append(item)
            extras -= 1

        # resource bundle filler
        for _ in range(extras):
            item = self.create_filler()
            item = cast(SubnauticaItem, item)
            pool.append(item)

        self.multiworld.itempool += pool

    def fill_slot_data(self) -> Dict[str, Any]:
        vanilla_tech: List[str] = []

        slot_data: Dict[str, Any] = {
            "goal": self.options.goal.current_key,
            "swim_rule": self.options.swim_rule.value,
            "consider_items": self.options.consider_items.value,
            "early_seaglide": self.options.early_seaglide.value,
            "seaglide_depth": self.options.seaglide_depth.value,
            "pre_seaglide_distance": self.options.pre_seaglide_distance.value,
            "include_seamoth": self.options.include_seamoth.value,
            "include_prawn": self.options.include_prawn.value,
            "include_cyclops": self.options.include_cyclops.value,
            "vanilla_tech": vanilla_tech,
            "creatures_to_scan": self.creatures_to_scan,
            "plants_to_scan": self.plants_to_scan,
            "death_link": self.options.death_link.value,
            "free_samples": self.options.free_samples.value,
            "ignore_radiation": self.options.ignore_radiation.value,
            "can_slip_through": self.options.can_slip_through.value,
        }

        return slot_data

    def create_item(self, name: str) -> SubnauticaItem:
        item_id: int = self.item_name_to_id[name]

        return SubnauticaItem(name,
                              item_table[item_id].classification,
                              item_id, player=self.player)

    def create_shifted_item(self, name: str, cls) -> SubnauticaItem:
        item_id: int = self.item_name_to_id[name]
        return SubnauticaItem(name, cls, item_id, player=self.player)

    def create_region(self, name: str, region_locations=None, exits=None):
        ret = Region(name, self.player, self.multiworld)
        if region_locations:
            for location in region_locations:
                loc_id = self.location_name_to_id.get(location, None)
                location = SubnauticaLocation(self.player, location, loc_id, ret)
                ret.locations.append(location)
        if exits:
            for region_exit in exits:
                ret.exits.append(Entrance(self.player, region_exit, ret))
        return ret

    def get_filler_item_name(self) -> str:
        item_names, cum_item_weights = self.options.filler_items_distribution.weights_pair
        return self.random.choices(item_names, cum_weights=cum_item_weights, k=1)[0]


class SubnauticaLocation(Location):
    game: str = "Subnautica"


class SubnauticaItem(Item):
    game: str = "Subnautica"
