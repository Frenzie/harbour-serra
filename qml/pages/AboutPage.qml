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

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge
                height: Theme.iconSizeExtraLarge
                source: "../harbour-serra.png"
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "v0.3.1"
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "© 2016 Petr Vytovtov"
            }

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

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Data providers:")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: "Yandex SpeechKit"
                onClicked: Qt.openUrlExternally("https://tech.yandex.ru/speechkit/cloud/")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: "Google Search"
                onClicked: Qt.openUrlExternally("https://www.google.com/")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: "Open Weather Map"
                onClicked: Qt.openUrlExternally("http://openweathermap.org/")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: "Google Maps"
                onClicked: Qt.openUrlExternally("https://developers.google.com/maps/web-services/")
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("Thanks for icon") + ":<br>R. Sabirov."
            }
        }

        VerticalScrollDecorator {}
    }
}
