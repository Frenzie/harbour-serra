import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: header.height + content.height

        PageHeader {
            id: header
            title: qsTr("About") + " Serra"
        }

        Column {
            id: content
            anchors.top: header.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * Theme.horizontalPageMargin
            spacing: Theme.paddingLarge

//            Image {
//                anchors.horizontalCenter: parent.horizontalCenter
//                width: Theme.iconSizeExtraLarge
//                height: Theme.iconSizeExtraLarge
//                source: "../harbour-kat.png"
//            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "v0.1.0"
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "© 2016 Petr Vytovtov"
            }

//            Label {
//                width: parent.width
//                wrapMode: Text.WordWrap
//                text: qsTr("The unofficial client for vk.com, distributed under the terms of the GNU GPLv3.")
//            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: qsTr("Homepage")
                onClicked: Qt.openUrlExternally("https://vk.com/kat_sailfishos")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: qsTr("Donate")
                onClicked: Qt.openUrlExternally("https://money.yandex.ru/to/410013326290845")
            }

//            Button {
//                anchors.horizontalCenter: parent.horizontalCenter
//                width: Theme.buttonWidthMedium
//                text: qsTr("Source code")
//                onClicked: Qt.openUrlExternally("https://github.com/osanwe/Kat")
//            }
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("AudioPlayerPage.qml"))
}
