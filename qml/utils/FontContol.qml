import QtQuick 2.0
;import org.nemomobile.configuration 1.0

Item {
    id: fontControl

    /* Setting normal font size.
     */
    function setNormalFontSize() {
        fontSizeCategory.value = "normal"
    }

    /* Setting large font size.
     */
    function setLargeFontSize() {
        fontSizeCategory.value = "large"
    }

    /* Setting huge font size.
     */
    function setHugeFontSize() {
        fontSizeCategory.value = "huge"
    }

    ConfigurationValue {
        id: fontSizeCategory
        key: "/desktop/jolla/theme/font/sizeCategory"
        defaultValue: "normal"
    }
}
