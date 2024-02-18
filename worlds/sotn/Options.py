from typing import Dict, Union
from BaseClasses import MultiWorld
from Options import Option, Toggle, Choice, Range


class OpenedNO4NO3(Toggle):
    """
        If true, the back door of Underground Caverns will be open
    """
    display_name = "Opened Underground Caverns Backdoor"


class OpenedDAIARE(Toggle):
    """
        If true, the back door of Colosseum will be open
    """
    display_name = "Opened Colosseum Backdoor"


class OpenedDAINO2(Toggle):
    """
        If true, the back door of Olrox's Quarters will be open
    """
    display_name = "Opened Olrox's Quarters Backdoor"


class Difficulty(Choice):
    """
    Determines the difficulty
    """
    display_name = "Difficulty"
    option_easy = 0
    option_normal = 1
    option_hard = 2
    option_insane = 3
    default = 1

class SkipPrologue(Toggle):
    """
    Whether to skip the opening prologue or not
    """
    display_name = "Skip Prologue"

class BossesNeeded(Range):
    """Bosses required to beat Dracula."""
    display_name = "Required Bosses Tokens"
    range_start = 0
    range_end = 19
    default = 0


sotn_option_definitions: Dict[str, type(Option)] = {
    "opened_no4": OpenedNO4NO3,
    "opened_are": OpenedDAIARE,
    "opened_no2": OpenedDAINO2,
    "difficulty": Difficulty,
    "bosses_needed": BossesNeeded,
    "skip_prologue": SkipPrologue,
}


def get_option_value(multiworld: MultiWorld, player: int, name: str) -> Union[int, dict]:
    option = getattr(multiworld, name, None)
    if option is None:
        return 0

    return option[player].value
