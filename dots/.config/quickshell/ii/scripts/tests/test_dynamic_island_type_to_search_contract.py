"""Contract tests for Dynamic Island Type-to-Search from Widgets Dashboard.

Validates that:
1. NotchIsland.qml defines handleDashboardTypeToSearch(event) to seamlessly transition
   from the clean widgets dashboard menu into Search when typing begins.
2. It guards against detail pages (dashboardWantsKeyboard, pendingPage) and grid editing,
   and ignores modifier chords (Ctrl, Alt, Meta) and navigation keys (Escape, Enter, etc.).
3. It sets GlobalStates.activeSearchQuery, dismisses the dashboard, and invokes GlobalStates.openSearch().
4. Both fullWindow and container attach Keys.onPressed to handleDashboardTypeToSearch(event).
5. fullWindow receives forceActiveFocus() when dashboard opens / activates.
6. TypeToSearch.qml recognizes GlobalStates.islandDashboardOpen as a focused shell surface.
"""

from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
NOTCH_ISLAND = (ROOT / "modules/ii/dynamicIsland/styles/notch/NotchIsland.qml").read_text(encoding="utf-8")
TYPE_TO_SEARCH = (ROOT / "services/TypeToSearch.qml").read_text(encoding="utf-8")


class DynamicIslandTypeToSearchContractTests(unittest.TestCase):
    def test_notch_island_declares_type_to_search_handler(self):
        self.assertIn("function handleDashboardTypeToSearch(event)", NOTCH_ISLAND)
        self.assertIn("if (!root.dashboardActive || root.searchActive)", NOTCH_ISLAND)
        self.assertIn("notchContent.dashboardGridEditing || notchContent.dashboardWantsKeyboard || notchContent.pendingPage.pageId !== \"\"", NOTCH_ISLAND)
        self.assertIn("event.modifiers & Qt.ControlModifier || event.modifiers & Qt.AltModifier || event.modifiers & Qt.MetaModifier", NOTCH_ISLAND)
        self.assertIn("event.key === Qt.Key_Escape || event.key === Qt.Key_Tab || event.key === Qt.Key_Return", NOTCH_ISLAND)

    def test_handler_dismisses_dashboard_and_seeds_search(self):
        self.assertIn("root.dismissDashboard();", NOTCH_ISLAND)
        self.assertIn("GlobalStates.activeSearchQuery = text;", NOTCH_ISLAND)
        self.assertIn("GlobalStates.openSearch();", NOTCH_ISLAND)

    def test_fullwindow_and_container_capture_keys(self):
        self.assertIn("Keys.onPressed: event => {\n                root.handleDashboardTypeToSearch(event);", NOTCH_ISLAND)
        self.assertIn("if (root.searchActive || GlobalStates.overviewOpen)\n                        root.collapseToClock();\n                    else if (root.dashboardActive)\n                        root.dismissDashboard();\n                    else\n                        GlobalStates.toggleOverview();", NOTCH_ISLAND)

    def test_toggle_signal_closes_search_or_dashboard(self):
        self.assertIn("function onToggleIslandDashboardRequested() {\n            if (root.searchActive || GlobalStates.overviewOpen)\n                root.collapseToClock();\n            else if (root.dashboardActive)\n                root.dismissDashboard();\n            else\n                root.openDashboard();", NOTCH_ISLAND)

    def test_dashboard_focus_arming(self):
        self.assertIn("if (fullWindow)\n                fullWindow.forceActiveFocus();", NOTCH_ISLAND)

    def test_type_to_search_recognizes_island_dashboard(self):
        self.assertIn("GlobalStates.islandDashboardOpen", TYPE_TO_SEARCH)


if __name__ == "__main__":
    unittest.main()
