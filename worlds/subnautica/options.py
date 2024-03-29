import typing
from dataclasses import dataclass
from functools import cached_property

from Options import (
    Choice,
    Range,
    DeathLink,
    Toggle,
    DefaultOnToggle,
    StartInventoryPool,
    ItemDict,
    PerGameCommonOptions,
)

from .creatures import all_creatures, Definitions
from .items import ItemType, item_names_by_type
from .plants import all_flora


class SwimRule(Choice):
#   """What logic considers ok swimming distances.
#   Easy: +200 depth from any max vehicle depth.
#   Normal: +400 depth from any max vehicle depth.
#   Warning: Normal can expect you to death run to a location (No viable return trip).
#   Hard: +600 depth from any max vehicle depth.
#   Warning: Hard may require bases, deaths, glitches, multi-tank inventory or other depth extending means.
#   Items: Expected depth is extended by items like seaglide, ultra glide fins and capacity tanks.
#   """
#   display_name = "Swim Rule"
#   option_easy = 0
#   option_normal = 1
#   option_hard = 2
#   option_items_easy = 3
#   option_items_normal = 4
#   option_items_hard = 5
#
#   @property
#   def base_depth(self) -> int:
#       return [200, 400, 600][self.value % 3]

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

class ConsiderExteriorGrowbed(Toggle):
    """Whether expected depth is also extended by exterior growbeds; adds 500 depth by itself.
    This only matters if items are considered (both have to be true to take effect)."""
    display_name = "Consider Exterior Growbed"

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

class FreeSamples(Toggle):
    """Get free items with your blueprints.
    Items that can go into your inventory are awarded when you unlock their blueprint through Archipelago."""
    display_name = "Free Samples"


class IgnoreRadiation(Toggle):
    """Whether to allow soaking radiation damage to access checks.
    Don't enable this unless you think you can fix the Aurora without the radiation suit."""
    display_name = "Ignore Radiation"


class IgnorePrawnDepth(Toggle):
    """Whether to include the prawn suit when considering depth. Makes it less likely to do Prawn suit Lost River runs."""
    display_name = "Ignore Prawn Depth"


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


#class ScannablePlants(Toggle):
#    """Whether plants are scannable or not"""
#    display_name = "Scannable Plants"


#class PlantScans(Range):
#    """How many (randomly chosen) plants to be in the pool."""
#    display_name = "Plant Scans"
#    range_end = len(all_flora)


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
    _valid_keys = frozenset(item_names_by_type[ItemType.resource])
    default = {item_name: 1 for item_name in item_names_by_type[ItemType.resource]}
    display_name = "Filler Items Distribution"

    @cached_property
    def weights_pair(self) -> typing.Tuple[typing.List[str], typing.List[int]]:
        from itertools import accumulate
        return list(self.value.keys()), list(accumulate(self.value.values()))


@dataclass
class SubnauticaOptions(PerGameCommonOptions):
    swim_rule: SwimRule
    early_seaglide: EarlySeaglide
    free_samples: FreeSamples
    goal: Goal
    creature_scans: CreatureScans
    creature_scan_logic: AggressiveScanLogic
    death_link: SubnauticaDeathLink
    start_inventory_from_pool: StartInventoryPool
    filler_items_distribution: FillerItemsDistribution
