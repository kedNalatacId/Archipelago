from test.bases import WorldTestBase, WorldTestBaseNoTests

class SubnauticaTest(WorldTestBaseNoTests):
    # This is an assumption in the mod side
    game: str = "Subnautica"
    player: int = 1
    scancutoff: int = 33999

    def world_setup(self):
        super().world_setup()
        if self.constructed:
            self.world = self.multiworld.worlds[self.player]
