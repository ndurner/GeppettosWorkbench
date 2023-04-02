
#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QWebEngineView>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    connect(ui->webView, &QWebEngineView::loadFinished, [](bool ok) {
        qDebug() << "load finished" << ok;
    });
    connect(ui->webView, &QWebEngineView::loadStarted, []() {
        qDebug() << "loading...";
    });

    ui->webView->show();
    ui->webView->load(QUrl("https://platform.openai.com/playground"));
}

MainWindow::~MainWindow()
{
    delete ui;
}


