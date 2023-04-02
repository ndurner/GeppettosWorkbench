
#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QWebEngineView>
#include <QWebEngineProfile>
#include <QWebEngineScriptCollection>
#include <QLoggingCategory>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    webView = ui->webView;
    setupWebView();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setupWebView()
{
    connect(ui->webView, &QWebEngineView::loadFinished, [](bool ok) {
        qDebug() << "load finished" << ok;
    });
    connect(ui->webView, &QWebEngineView::loadStarted, []() {
        qDebug() << "loading...";
    });

    QWebEngineProfile *profile = new QWebEngineProfile(qApp->applicationName());
    QWebEnginePage *page = new QWebEnginePage(profile);

    QWebEngineScript mod;
    mod.setInjectionPoint(QWebEngineScript::InjectionPoint::DocumentReady);
    mod.setSourceUrl(QUrl("qrc:///ui_mod.js"));
    page->scripts().insert(mod);

    webView->setPage(page);
    webView->load(QUrl("https://platform.openai.com/playground?mode=chat&model=gpt-4"));
    webView->show();
}
