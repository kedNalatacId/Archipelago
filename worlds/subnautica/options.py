import typing
from dataclasses import dataclass
from functools import cached_property

from Options import (
    Choice, Range, DeathLink, Toggle, DefaultOnToggle,
    StartInventoryPool, ItemDict, PerGameCommonOptions
)

from .creatures import all_creatures, Definitions
from .items import ItemType, item_names_by_type
from .plants import all_flora, plant_locations


class SwimRule(Range):
    """What logic considers ok swimming distances.
    Easy: 100-200 depth from any max vehicle depth.
    Normal: 200-400 depth from any max vehicle depth.
    Hard: 400+ depth from any max vehicle depth.

    Warning: Depths above 200m may have a very small sphere one (this may make generation difficult).
             Depths below 200m may expect you to death run to a location (No viable return trip).
             Depths below 400m may require bases, deaths, glitches, multi-tank inventory or other depth extending means.
    """
    display_name = "Swim Rule"
    range_start = 100
    default = 200
    range_end = 600


class ConsiderItems(Toggle):
    """Whether expected depth is extended by items like seaglide, ultra glide fins and capacity tanks."""
    display_name = "Consider Items"


class PreSeaglideDistance(Range):
    """Maximum distance away from origin for locations to be in logic without seaglide. Default is 800m"""
    display_name = "Pre-Seaglide Distance"
    range_start  = 600
    default      = 800
    range_end    = 2500


class EarlySeaglide(DefaultOnToggle):
    """Make sure 2 of the Seaglide Fragments are available in or near the Safe Shallows (Sphere 1 Locations)."""
    display_name = "Early Seaglide"

class SeaglideDepth(Range):
    """ How much additional depth the seaglide allows vs no-seaglide"""
    display_name = "Seaglide Depth"
    range_start  = 100
    default      = 200
    range_end    = 400


class IncludeSeamoth(Choice):
    """Whether to include the Seamoth or not.
    Include: Include the Seamoth both logically and really.
    Exclude from Logic: Include the Seamoth, but don't count it towards depth or distance calculations.
    Exclude: Do not include any Seamoth fragments. The Seamoth will be unobtainable in game."""
    display_name = "Seamoth"
    option_include = 0
    option_exclude_logically = 1
    option_exclude = 2


class IncludePrawnSuit(Choice):
    """Whether to include the Prawn Suit or not.
    Include: Include the Prawn Suit both logically and really.
    Exclude from Logic: Include the Prawn Suit, but don't count it towards depth or distance calculations.
    Exclude: Do not include any Prawn Suit fragments. The Prawn Suit will be unobtainable in game."""
    display_name = "Prawn Suit"
    option_include = 0
    option_exclude_logically = 1
    option_exclude = 2


class IncludeCyclops(Choice):
    """Whether to include the Cyclops or not.
    Include: Include the Cyclops both logically and really.
    Exclude from Logic: Include the Cyclops, but don't count it towards depth or distance calculations.
    Exclude: Do not include any Cyclops fragments. The Cyclops will be unobtainable in game."""
    display_name = "Cyclops"
    option_include = 0
    option_exclude_logically = 1
    option_exclude = 2


class FreeSamples(Toggle):
    """Get free items with your blueprints.
    Items that can go into your inventory are awarded when you unlock their blueprint through Archipelago."""
    display_name = "Free Samples"


class IgnoreRadiation(Toggle):
    """Whether to allow soaking radiation damage to access checks.
    Don't enable this unless you think you can fix the Aurora without the radiation suit."""
    display_name = "Ignore Radiation"


class CanSlipThrough(Choice):
    """Whether the player is comfortable bypassing some propulsion cannon or laser cutter segments.
    None: Not able to slip through either Laser Cutter or Propulsion Cannon segments
    Laser Cutter: able to slip through Laser Cutter segments (Grassy Plateaus East Wreck)
    Propulsion Cannon: able to slip through Propulsion Cannon segments (Aurora)
    Both: able to slip through both laser and propsulsion cannon segments

    At the moment only applies to the jump into the cargo bay in the Aurora."""

    display_name = "Can Slip Through"
    option_none = 0
    option_laser_cutter = 1
    option_propulsion_cannon = 2
    option_both = 3


class Goal(Choice):
    """Goal to complete.
    Launch: Leave the planet.
    Free: Disable quarantine.
    Infected: Reach maximum infection level.
    Drive: Repair the Aurora's Drive Core"""
    auto_display_name = True
    display_name = "Goal"
    option_launch = 0
    option_free = 1
    option_infected = 2
    option_drive = 3

    def get_event_name(self) -> str:
        return {
            self.option_launch: "Neptune Launch",
            self.option_infected: "Full Infection",
            self.option_free: "Disable Quarantine",
            self.option_drive: "Repair Aurora Drive"
        }[self.value]


class PlantScans(Range):
    """Place items on specific, randomly chosen, flora scans."""
    display_name = "Plant Scans"
    range_end = len(all_flora)

    def get_pool(self) -> typing.List[str]:
        return sorted(plant_locations)


class CreatureScans(Range):
    """Place items on specific, randomly chosen, creature scans.
    Warning: Includes aggressive Leviathans."""
    display_name = "Creature Scans"
    range_end = len(all_creatures)


class AggressiveScanLogic(Choice):
    """By default (Stasis), aggressive Creature Scans are logically expected only with a Stasis Rifle.
    Containment: Removes Stasis Rifle as expected solution and expects Alien Containment instead.
    Either: Creatures may be expected to be scanned via Stasis Rifle or Containment, whichever is found first.
    None: Aggressive Creatures are assumed to not need any tools to scan.
    Removed: No Creatures needing Stasis or Containment will be in the pool at all.

    Note: Containment, Either and None adds Cuddlefish as an option for scans.
    Note: Stasis, Either and None adds unhatchable aggressive species, such as Warper.
    Note: This is purely a logic expectation, and does not affect gameplay, only placement."""
    display_name = "Aggressive Creature Scan Logic"
    option_stasis = 0
    option_containment = 1
    option_either = 2
    option_none = 3
    option_removed = 4

    def get_pool(self) -> typing.List[str]:
        if self == self.option_removed:
            return Definitions.all_creatures_presorted_without_aggressive_and_containment
        elif self == self.option_stasis:
            return Definitions.all_creatures_presorted_without_containment
        elif self == self.option_containment:
            return Definitions.all_creatures_presorted_without_stasis
        else:
            return Definitions.all_creatures_presorted


class SubnauticaDeathLink(DeathLink):
    """When you die, everyone dies. Of course the reverse is true too.
    Note: can be toggled via in-game console command "deathlink"."""


class FillerItemsDistribution(ItemDict):
    """Random chance weights of various filler resources that can be obtained.
    Available items: """
    __doc__ += ", ".join(f"\"{item_name}\"" for item_name in item_names_by_type[ItemType.resource])
    valid_keys = sorted(item_names_by_type[ItemType.resource])
    default = {item_name: 1 for item_name in item_names_by_type[ItemType.resource]}
    display_name = "Filler Items Distribution"

    @cached_property
    def weights_pair(self) -> typing.Tuple[typing.List[str], typing.List[int]]:
        from itertools import accumulate
        return list(self.value.keys()), list(accumulate(self.value.values()))


@dataclass
class SubnauticaOptions(PerGameCommonOptions):
    swim_rule: SwimRule
    consider_items: ConsiderItems
    include_seamoth: IncludeSeamoth
    include_prawn: IncludePrawnSuit
    include_cyclops: IncludeCyclops
    early_seaglide: EarlySeaglide
    seaglide_depth: SeaglideDepth
    pre_seaglide_distance: PreSeaglideDistance
    free_samples: FreeSamples
    ignore_radiation: IgnoreRadiation
    can_slip_through: CanSlipThrough
    goal: Goal
    creature_scans: CreatureScans
    creature_scan_logic: AggressiveScanLogic
    plant_scans: PlantScans
    death_link: SubnauticaDeathLink
    start_inventory_from_pool: StartInventoryPool
    filler_items_distribution: FillerItemsDistribution
