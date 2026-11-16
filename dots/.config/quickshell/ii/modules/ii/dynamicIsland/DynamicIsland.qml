pragma ComponentBehavior: Bound

import qs
import qs.modules.common
import qs.modules.ii.dynamicIsland.core
import qs.modules.ii.dynamicIsland.styles.notch
import QtQuick
import Quickshell

Scope {
    id: root

    Variants {
        id: islandVariants

        readonly property var variantModel: {
            if (!IslandPolicy.enabled)
                return [];
            if (IslandPolicy.onlyShowOnSingleMonitor) {
                const target = IslandPolicy.singleMonitorName;
                const found = Quickshell.screens.find(s => s.name === target);
                return found ? [found] : (Quickshell.screens.length > 0 ? [Quickshell.screens[0]] : []);
            }
            return GlobalStates.allowedScreens;
        }

        model: variantModel

        delegate: Scope {
            id: monitorIslandScope
            required property ShellScreen modelData

            LazyLoader {
                id: islandLoader
                active: IslandPolicy.enabled
                component: NotchIsland {
                    screenOverride: monitorIslandScope.modelData
                }
            }
        }
    }
}
