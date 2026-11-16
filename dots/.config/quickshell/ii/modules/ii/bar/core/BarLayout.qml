import QtQuick
import qs
import qs.modules.common
import qs.modules.ii.dynamicIsland.core

// Computes leftList / centerList / rightList from Config.options.bar.layouts.center.
// A widget with { centered: true } becomes the single centerList item;
// everything before it goes to leftList, everything after to rightList.
// If no centered widget exists, all items go to centerList (legacy behavior).
Item {
    id: root
    visible: false

    property var screen: null
    readonly property string screenName: screen ? screen.name : ""

    readonly property var _emptyLayout: []
    readonly property var fullModel: {
        const model = Config.options.bar.layouts.center;
        return (model && model.length > 0) ? model : root._emptyLayout;
    }
    // Islands background style overrides centered — widgets must follow the

    // island layout, not their own centering.
    /// The config's value unless Settings' preview tries another on.
    property int backgroundStyle: Config.options.bar.barBackgroundStyle
    readonly property int centerIdx: root.backgroundStyle === 3 ? -1 : fullModel.findIndex(item => item.centered)

    readonly property var leftList: centerIdx === -1 ? root._emptyLayout : fullModel.slice(0, centerIdx)
    // The centre is only surrendered when the island will actually be there on this monitor.
    // In multi-monitor setups with single-monitor pinning, secondary bars keep their center widgets.
    readonly property bool islandAllowedHere: IslandPolicy.centerInBar && IslandPolicy.isScreenAllowed(root.screenName)
    readonly property var centerList: islandAllowedHere ? root._emptyLayout : (centerIdx === -1 ? fullModel.slice() : [fullModel[centerIdx]])
    readonly property var rightList: centerIdx === -1 ? root._emptyLayout : fullModel.slice(centerIdx + 1)
}
