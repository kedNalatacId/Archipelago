import pytest
from . import SubnauticaTest

class GroupAssociationTest(SubnauticaTest):
    def testGroupAssociation(self):
        from worlds.subnautica import items
        for item_id, item_data in items.item_table.items():
            if item_data.type == items.ItemType.group:
                with self.subTest(item=item_data.name):
                    self.assertIn(item_id, items.group_items)
        for item_id in items.group_items:
            with self.subTest(item_id=item_id):
                self.assertEqual(items.item_table[item_id].type, items.ItemType.group)


