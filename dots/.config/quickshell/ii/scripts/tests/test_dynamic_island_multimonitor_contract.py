"""Contracts for Dynamic Island multi-monitor visibility and screen scoping.

Validates that:
1. IslandPolicy declares multi-monitor properties: onlyShowOnSingleMonitor, singleMonitorName, and isScreenAllowed().
2. IslandGeometry supports per-monitor center width caching and lookups: centerWidths, centerWidthFor(), setCenterWidth().
3. BarLayout scopes island center reservation to allowed screens (so non-island screens retain center widgets).
4. DynamicIslandStyle scopes islandInBarCenter and uses per-screen islandReservedWidth via centerWidthFor().
5. DynamicIsland.qml uses Variants to instantiate NotchIsland per allowed screen or pinned monitor.
6. NotchIsland.qml declares screenOverride and binds targetScreen to screenOverride with fallback.
"""

from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
POLICY = (ROOT / "modules/ii/dynamicIsland/core/IslandPolicy.qml").read_text(encoding="utf-8")
GEOMETRY = (ROOT / "modules/ii/dynamicIsland/core/IslandGeometry.qml").read_text(encoding="utf-8")
BAR_LAYOUT = (ROOT / "modules/ii/bar/core/BarLayout.qml").read_text(encoding="utf-8")
DYNAMIC_STYLE = (ROOT / "modules/ii/bar/styles/DynamicIslandStyle.qml").read_text(encoding="utf-8")
DYNAMIC_ISLAND = (ROOT / "modules/ii/dynamicIsland/DynamicIsland.qml").read_text(encoding="utf-8")
NOTCH_ISLAND = (ROOT / "modules/ii/dynamicIsland/styles/notch/NotchIsland.qml").read_text(encoding="utf-8")


class DynamicIslandMultiMonitorContractTests(unittest.TestCase):
    def test_island_policy_declares_screen_allowed_and_monitors(self):
        self.assertIn("readonly property bool onlyShowOnSingleMonitor:", POLICY)
        self.assertIn("readonly property string singleMonitorName:", POLICY)
        self.assertIn("function isScreenAllowed(screenName)", POLICY)

    def test_island_geometry_supports_per_screen_metrics(self):
        self.assertIn("property var centerWidths: ({})", GEOMETRY)
        self.assertIn("function centerWidthFor(screenName)", GEOMETRY)
        self.assertIn("function setCenterWidth(screenName, width)", GEOMETRY)

    def test_bar_layout_scopes_island_presence_per_screen(self):
        self.assertIn("property var screen: null", BAR_LAYOUT)
        self.assertIn("readonly property string screenName: screen ? screen.name : \"\"", BAR_LAYOUT)
        self.assertIn("readonly property bool islandAllowedHere:", BAR_LAYOUT)
        self.assertIn("IslandPolicy.isScreenAllowed(root.screenName)", BAR_LAYOUT)
        self.assertIn("readonly property var centerList: islandAllowedHere ? root._emptyLayout", BAR_LAYOUT)

    def test_dynamic_island_style_scopes_center_and_queries_screen_width(self):
        self.assertIn("IslandPolicy.isScreenAllowed(root.screen ? root.screen.name : \"\")", DYNAMIC_STYLE)
        self.assertIn("IslandGeometry.centerWidthFor(root.screen ? root.screen.name : \"\")", DYNAMIC_STYLE)

    def test_dynamic_island_uses_variants_for_multimonitor(self):
        self.assertIn("Variants {", DYNAMIC_ISLAND)
        self.assertIn("id: islandVariants", DYNAMIC_ISLAND)
        self.assertIn("GlobalStates.allowedScreens", DYNAMIC_ISLAND)
        self.assertIn("screenOverride: monitorIslandScope.modelData", DYNAMIC_ISLAND)

    def test_notch_island_declares_screen_override(self):
        self.assertIn("property ShellScreen screenOverride: null", NOTCH_ISLAND)
        self.assertIn("if (root.screenOverride)\n            return root.screenOverride;", NOTCH_ISLAND)
        self.assertIn("IslandGeometry.setCenterWidth(win.screen ? win.screen.name : \"\",", NOTCH_ISLAND)


if __name__ == "__main__":
    unittest.main()
