#include "themehelper.h"
#include "utils.h"

#include <QApplication>
#include <QFile>

#import <Foundation/Foundation.h>

using namespace std;

ThemeHelper::ThemeHelper(QObject *parent) : QObject(parent)
{

}

bool ThemeHelper::isSystemDarkTheme()
{
    NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
    std::string mode;
    if (osxMode.length == 0)
        mode = "";
    else
        mode = [osxMode UTF8String];
    return QString::fromStdString(mode).toLower() == "dark";
}

void ThemeHelper::setupThemeOnStartup()
{
    ConfigHelper *helper = Utils::getConfigHelper();

    if ((isSystemDarkTheme() && helper->getGeneralSettings()["systemTheme"] == 2) || helper->getGeneralSettings()["systemTheme"] == 1)
        applyDarkQss();
    else
        applyLightQss();
}

void ThemeHelper::applyLightQss()
{
    QFile qssFile(":/qss/light.qss");
    qssFile.open(QIODevice::ReadOnly | QIODevice::Text);
    qApp->setStyleSheet(qssFile.readAll());
}

void ThemeHelper::applyDarkQss()
{
    QFile qssFile(":/qss/dark.qss");
    qssFile.open(QIODevice::ReadOnly | QIODevice::Text);
    qApp->setStyleSheet(qssFile.readAll());
}
