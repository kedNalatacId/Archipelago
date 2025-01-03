import typing
from Options import Choice, Option, Toggle, DefaultOnToggle, Range, FreeText, OptionDict
from schema import And, Schema, Optional

class SMLogic(Choice):
    """This option selects what kind of logic to use for item placement inside
    Super Metroid.

    Normal - Normal logic includes only what Super Metroid teaches players
    itself. Anything that's not demonstrated in-game or by the intro cutscenes
    will not be required here.

    Hard - Hard logic is based upon the "no major glitches" ruleset and
    includes most tricks that are considered minor glitches, with some 
    restrictions. You'll want to be somewhat of a Super Metroid veteran for
    this logic.
    
    See https://samus.link/information for required moves."""
    display_name = "SMLogic"
    option_Normal = 0
    option_Medium = 2
    option_Hard = 1
    default = 0

class Z3Logic(Choice):
    """This option selects what kind of logic to use for item placement inside
    Link to the Past.

    Common - no glitches at all
    NMG    - No Major Glitches
    OWG    - Overworld Glitches (includes NMG).

    See https://samus.link/information for required moves."""
    display_name = "Z3Logic"
    option_Common = 0
    option_NMG    = 1
    option_OWG    = 2
    default       = 0

class SwordLocation(Choice):
    """This option decides where the first sword will be placed.
    Randomized - The sword can be placed anywhere.
    Early - The sword will be placed in a location accessible from the start of
    the game.
    Uncle - The sword will always be placed on Link's Uncle."""
    display_name = "Sword Location"
    option_Randomized = 0
    option_Early = 1
    option_Uncle = 2
    default = 0

class MorphLocation(Choice):
    """This option decides where the morph ball will be placed.
    Randomized - The morph ball can be placed anywhere.
    Early - The morph ball will be placed in a location accessible from the 
    start of the game.
    Original location - The morph ball will always be placed at its original 
    location."""
    display_name = "Morph Location"
    option_Randomized = 0
    option_Early = 1
    option_Original = 2
    default = 0

    
class Goal(Choice):
    """This option decides what goal is required to finish the randomizer.
    Defeat Ganon and Mother Brain - Find the required crystals and boss tokens to kill both bosses.
    Fast Ganon and Defeat Mother Brain - The hole to ganon is open without having to defeat Agahnim in 
                                         Ganon's Tower and Ganon can be defeat as soon you have the required 
                                         crystals to make Ganon vulnerable. For keysanity, this mode also removes 
                                         the Crateria Boss Key requirement from Tourian to allow faster access.
    All Dungeons and Defeat Mother Brain -  Similar to "Defeat Ganon and Mother Brain", but also requires all dungeons 
                                            to be beaten including Castle Tower and Agahnim."""
    display_name = "Goal"
    option_DefeatBoth = 0
    option_FastGanonDefeatMotherBrain = 1
    option_AllDungeonsDefeatMotherBrain = 2
    default = 0

class KeyShuffle(Choice):
    """This option decides how dungeon items such as keys are shuffled.
    None - A Link to the Past dungeon items can only be placed inside the 
    dungeon they belong to, and there are no changes to Super Metroid.
    Keysanity - See https://samus.link/information"""
    display_name = "Key Shuffle"
    option_None = 0
    option_Keysanity = 1
    default = 0

class OpenTower(Range):
    """The amount of crystals required to be able to enter Ganon's Tower. 
    If this is set to Random, the amount can be found in-game on a sign next to Ganon's Tower."""
    display_name = "Open Tower"
    range_start = 0
    range_end = 7
    default = 7

class GanonVulnerable(Range):
    """The amount of crystals required to be able to harm Ganon. The amount can be found 
    in-game on a sign near the top of the Pyramid."""
    display_name = "Ganon Vulnerable"
    range_start = 0
    range_end = 7
    default = 7

class OpenTourian(Range):
    """The amount of boss tokens required to enter Tourian. The amount can be found in-game 
    on a sign above the door leading to the Tourian entrance."""
    display_name = "Open Tourian"
    range_start = 0
    range_end = 4
    default = 4

class SpinJumpsAnimation(Toggle):
    """Enable separate space/screw jump animations"""
    display_name = "Spin Jumps Animation"

class HeartBeepSpeed(Choice):
    """Sets the speed of the heart beep sound in A Link to the Past."""
    display_name = "Heart Beep Speed"
    option_Off = 0
    option_Quarter = 1
    option_Half = 2
    option_Normal = 3
    option_Double = 4
    default = 3

class HeartColor(Choice):
    """Changes the color of the hearts in the HUD for A Link to the Past."""
    display_name = "Heart Color"
    option_Red = 0
    option_Green = 1
    option_Blue = 2
    option_Yellow = 3
    default = 0

class QuickSwap(Toggle):
    """When enabled, lets you switch items in ALTTP with L/R"""
    display_name = "Quick Swap"

class EnergyBeep(DefaultOnToggle):
    """Toggles the low health energy beep in Super Metroid."""
    display_name = "Energy Beep"

class LinksHouseName(FreeText):
    """What to name Link's House in game. Can only be up to 4 characters."""
    display_name = "Link's House Name"

class SpriteSettings(OptionDict):
    """Common options about sprite handling"""
    display_name = "Common Sprite Settings"
    valid_keys = ["sprite_cache_path","python_bin", "sprite_something_bin", "sprite_URL"]
    default = {
        "sprite_cache_path": "sprite_cache.json",
        "python_bin": "/usr/bin/python",
        "sprite_something_bin": "SpriteSomething/SpriteSomething.py",
        "sprite_URL": "http://smalttpr.mymm1.com/sprites/"
        }
    value: typing.Dict[str, str]

class LinkSprite(OptionDict):
    """Options to select Link Sprite"""
    display_name = "Link Sprite"
    valid_keys = ["sprite", "avoid_sprites"]
    default = {
        "sprite": "",
        "avoid_sprites": [ ],
        }
#   value: Dict[str, Union[str, List[str]]]
#   schema = Schema({ str: str })

class SamusSprite(OptionDict):
    """Options to select Link Sprite"""
    valid_keys = ["sprite","avoid_sprites"]
    default = {
        "sprite": "",
        "avoid_sprites": [ ],
        }
    display_name = "Samus Sprite"

class SMControls(OptionDict):
    """Controller button scheme for controlling Samus"""
    display_name: "Super Metroid Controls"
    valid_keys = [ "shot", "dash", "jump", "item_select", "item_cancel", "angle_up", "angle_down" ]
    default = {
        "shot": "X",
        "dash": "B",
        "jump": "A",
        "item_select": "Select",
        "item_cancel": "Y",
        "angle_up": "R",
        "angle_down": "L",
        }

smz3_options: typing.Dict[str, type(Option)] = {
    "sm_logic": SMLogic,
    "z3_logic": Z3Logic,
    "sword_location": SwordLocation,
    "morph_location": MorphLocation,
    "goal": Goal,
    "key_shuffle": KeyShuffle,
    "open_tower": OpenTower, 
    "ganon_vulnerable": GanonVulnerable,
    "open_tourian": OpenTourian,
    "spin_jumps_animation": SpinJumpsAnimation,
    "heart_beep_speed": HeartBeepSpeed,
    "heart_color": HeartColor, 
    "quick_swap": QuickSwap,
    "energy_beep": EnergyBeep,
    "links_house_name": LinksHouseName,
    "sprite_settings": SpriteSettings,
    "link_sprite": LinkSprite,
    "samus_sprite": SamusSprite,
    "sm_controls": SMControls
    }
