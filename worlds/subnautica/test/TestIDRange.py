import pytest
from . import SubnauticaTest
from .. import SubnauticaWorld

class IDRangeTest(SubnauticaTest):
    def testIDRange(self):
        for name, id in SubnauticaWorld.location_name_to_id.items():
            with self.subTest(location=name):
                if "Scan" in name:
                    self.assertLess(self.scancutoff, id)
                else:
                    self.assertGreater(self.scancutoff, id)
