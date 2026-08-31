import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

// Audio / volume control popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.standard
    anchors.fill: parent

    StyledText {
        text: "Volume"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    Item { Layout.fillHeight: true }

    Slider {
        id: volSlider
        Layout.alignment: Qt.AlignHCenter
        icon: "volume_up"
        from: 0
        to: 100
        value: Audio.volume * 100
        onMoved: Audio.setVolume(v / 100)
    }

    StyledText {
        text: Math.round(Audio.volume * 100) + "%"
        font.pixelSize: 12
        textColor: Colours.palette.m3onSurfaceVariant
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }
}
