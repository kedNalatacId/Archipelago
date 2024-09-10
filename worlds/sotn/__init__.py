from typing import ClassVar, Dict, Tuple, List

import settings, typing, random
from worlds.AutoWorld import WebWorld, World
from BaseClasses import Tutorial, MultiWorld, ItemClassification, Item
from worlds.LauncherComponents import Component, components, SuffixIdentifier, launch_subprocess, Type
from Options import AssembleOptions


from .Items import item_table, relic_table, SotnItem, ItemData, base_item_id, event_table, IType, vanilla_list
from .Locations import location_table, SotnLocation, exp_locations_token
from .Regions import create_regions
from .Rules import set_rules
from .Options import sotn_option_definitions
from .Rom import SOTNDeltaPatch, patch_rom


def run_client():
    print('Running SOTN Client')
    from SotnClient import main
    # from .SotnClient import main for release
    launch_subprocess(main, name="SotnClient")


components.append(Component('SOTN Client', 'SotnClient', func=run_client,
                            component_type=Type.CLIENT, file_identifier=SuffixIdentifier('.apsotn')))


# -- Problem found on last play --
# Getting Error num_id is nil in lua after receiving a misplaced, just once
# Maybe Succubus be a boss?
# Better distribution of vanilla items based on type
# Faerie scroll place holder missing
# TODO: Improve skill of wolf and bat card check
# Alucart Mail not sorting when received

class SotnSettings(settings.Group):
    class RomFile(settings.UserFilePath):
        """File name of the SOTN US rom Track 1"""
        description = "Symphony of the Night (SLU067) ROM File (Track 1)"
        copy_to = "Castlevania - Symphony of the Night (USA) (Track 1).bin"
        md5s = [SOTNDeltaPatch.hash]

    rom_file: RomFile = RomFile(RomFile.copy_to)

    class AudioFile(settings.UserFilePath):
        """File name of the SOTN US rom Track 2"""
        description = "Symphony of the Night (SLU067) Audio File (Track 2)"
        copy_to = "Castlevania - Symphony of the Night (USA) (Track 2).bin"

    audio_file: AudioFile = AudioFile(AudioFile.copy_to)


class SotnWeb(WebWorld):
    setup = Tutorial(
        "Multiworld Setup Guide",
        "A guide to setting up Symphony of the Night for MultiWorld.",
        "English",
        "setup_en.md",
        "setup/en",
        ["FDelduque"]
    )

    tutorials = [setup]


class SotnWorld(World):
    """
    Symphony of the Night is a metroidvania developed by Konami
    and release for Sony Playstation and Sega Saturn in (add year after googling)
    """
    game: ClassVar[str] = "Symphony of the Night"
    web: ClassVar[WebWorld] = SotnWeb()
    settings_key = "sotn_settings"
    settings: ClassVar[SotnSettings]
    option_definitions: ClassVar[Dict[str, AssembleOptions]] = sotn_option_definitions
    data_version: ClassVar[int] = 1
    required_client_version: Tuple[int, int, int] = (0, 3, 9)

    item_name_to_id: ClassVar[Dict[str, int]] = {name: data.index for name, data in item_table.items()}
    location_name_to_id: ClassVar[Dict[str, int]] = {name: data.location_id for name, data in location_table.items()}

    def __init__(self, world: MultiWorld, player: int):
        super().__init__(world, player)

    @classmethod
    def stage_assert_generate(cls, _multiworld: MultiWorld) -> None:
        # don't need rom anymore
        pass

    def generate_early(self) -> None:
        pass

    def create_item(self, name: str) -> Item:
        data = item_table[name]
        return SotnItem(name, data.ic, data.index, self.player)

    def create_items(self) -> None:
        exp = self.options.exploration_needed
        added_items = 0

        self.multiworld.get_location("NZ0 - Slogra and Gaibon kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("NO1 - Doppleganger 10 kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("LIB - Lesser Demon kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("NZ1 - Karasuman kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("DAI - Hippogryph kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("ARE - Minotaurus/Werewolf kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("NO2 - Olrox kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("NO4 - Scylla kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("NO4 - Succubus kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("CHI - Cerberos kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("CAT - Legion kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RARE - Fake Trevor/Grant/Sypha kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RCAT - Galamoth kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RCHI - Death kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RDAI - Medusa kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RNO1 - Creature kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RNO2 - Akmodan II kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RNO4 - Doppleganger40 kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RNZ0 - Beezelbub kill", self.player).place_locked_item(
            self.create_item("Boss token"))
        self.multiworld.get_location("RNZ1 - Darkwing bat kill", self.player).place_locked_item(
            self.create_item("Boss token"))

        for k, v in exp_locations_token.items():
            self.multiworld.get_location(k, self.player).place_locked_item(
                self.create_item("Exploration token"))

        for i in range(exp + 1, 20 + 1):
            exp_location = f"Exploration {i * 10} item"
            self.multiworld.get_location(exp_location, self.player).place_locked_item(self.create_random_junk())
            added_items += 1

        itempool: typing.List[SotnItem] = []
        # TODO: Learn about item weights for difficult
        difficulty = self.multiworld.difficulty[self.player]
        # Last generate 278 Items 386 Locations with all relics
        # Removed bump librarian
        # 28 Relic location filled with pre_fill (Not anymore)
        # total_location = 385 added 20 exploration locations
        total_location = 405

        # Add progression items
        itempool += [self.create_item("Spike breaker")]
        itempool += [self.create_item("Holy glasses")]
        itempool += [self.create_item("Gold ring")]
        itempool += [self.create_item("Silver ring")]
        added_items += 4

        prog_relics = ["Soul of bat", "Echo of bat", "Soul of wolf", "Form of mist", "Cube of zoe",
                       "Gravity boots", "Leap stone", "Holy symbol", "Jewel of open", "Merman statue",
                       "Demon card", "Heart of vlad", "Tooth of vlad", "Rib of vlad", "Ring of vlad", "Eye of vlad"
                       ]

        if difficulty == 0:
            itempool += [self.create_item("Alucard shield")]
            itempool += [self.create_item("Alucard sword")]
            itempool += [self.create_item("Mablung Sword")]
            itempool += [self.create_item("Crissaegrim")]
            itempool += [self.create_item("Crissaegrim")]
            itempool += [self.create_item("Alucard mail")]
            itempool += [self.create_item("God's Garb")]
            itempool += [self.create_item("Dragon helm")]
            itempool += [self.create_item("Twilight cloak")]
            itempool += [self.create_item("Ring of varda")]
            itempool += [self.create_item("Ring of varda")]
            itempool += [self.create_item("Duplicator")]
            added_items += 12

            itempool += [self.create_item("Life Vessel") for _ in range(40)]
            itempool += [self.create_item("Heart Vessel") for _ in range(40)]
            added_items += 80
            for r in relic_table:
                itempool += [self.create_item(r)]
                added_items += 1
            for r in prog_relics:
                itempool += [self.create_item(r)]
                added_items += 1
            while True:
                if added_items >= total_location or len(vanilla_list) == 0:
                    break
                item = random.choice(vanilla_list)
                itempool += [self.create_item(item)]
                added_items += 1
                vanilla_list.remove(item)

        if difficulty == 1:
            itempool += [self.create_item("Alucard sword")]
            itempool += [self.create_item("Crissaegrim")]
            itempool += [self.create_item("Alucard mail")]
            itempool += [self.create_item("God's Garb")]
            itempool += [self.create_item("Ring of varda")]
            added_items += 5

            itempool += [self.create_item("Life Vessel") for _ in range(32)]
            itempool += [self.create_item("Heart Vessel") for _ in range(33)]
            added_items += 65
            for r in relic_table:
                itempool += [self.create_item(r)]
                added_items += 1
            while True:
                if added_items >= total_location or len(vanilla_list) == 0:
                    break
                item = random.choice(vanilla_list)
                itempool += [self.create_item(item)]
                added_items += 1
                vanilla_list.remove(item)

        if difficulty == 2:
            itempool += [self.create_item("Life Vessel") for _ in range(17)]
            itempool += [self.create_item("Heart Vessel") for _ in range(17)]
            added_items += 34
            for r in prog_relics:
                itempool += [self.create_item(r)]
                added_items += 1
            for _ in range(100):
                if added_items >= total_location:
                    break
                item = random.choice(vanilla_list)
                itempool += [self.create_item(item)]
                added_items += 1
                vanilla_list.remove(item)

        if difficulty == 3:
            for r in prog_relics:
                itempool += [self.create_item(r)]
                added_items += 1
            for _ in range(40):
                if added_items >= total_location:
                    break
                item = random.choice(vanilla_list)
                itempool += [self.create_item(item)]
                added_items += 1
                vanilla_list.remove(item)

        # Still have space? Add junk items
        itempool += [self.create_random_junk() for _ in range(total_location - added_items)]

        self.multiworld.itempool += itempool

    def create_random_junk(self) -> SotnItem:
        junk_list = ["Orange", "Apple", "Banana", "Grapes", "Strawberry", "Pineapple", "Peanuts", "Toadstool"]
        rng_junk = random.choice(junk_list)
        data = item_table[rng_junk]
        return SotnItem(rng_junk, data.ic, data.index, self.player)

    def create_regions(self) -> None:
        create_regions(self.multiworld, self.player)

    def generate_basic(self) -> None:
        required = self.options.bosses_needed
        exp = self.options.exploration_needed

        if required > 20:
            required = 20
        if exp > 20:
            exp = 20

        self.multiworld.get_location("RCEN - Kill Dracula", self.player).place_locked_item(
            self.create_event("Victory"))
        self.multiworld.completion_condition[self.player] = lambda state: \
            (state.has("Victory", self.player) and state.has("Boss token", self.player, required) and
             state.has("Exploration token", self.player, exp))

    def create_event(self, name: str) -> Item:
        return SotnItem(name, ItemClassification.progression, None, self.player)

    def set_rules(self):
        set_rules(self.multiworld, self.player)

    def generate_output(self, output_directory: str) -> None:
        print("Inside Output")
        patch_rom(self, output_directory)
