.class public Lcom/benandow/android/gui/layoutRendererApp/GuiRipperActionBarActivity;
.super Landroid/support/v7/app/ActionBarActivity;
.source "GuiRipperActionBarActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Landroid/support/v7/app/ActionBarActivity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 10
    invoke-super {p0, p1}, Landroid/support/v7/app/ActionBarActivity;->onCreate(Landroid/os/Bundle;)V

    .line 12
    new-instance v0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    invoke-direct {v0, p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;-><init>(Landroid/app/Activity;)V

    .line 13
    .local v0, "base":Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;
    invoke-virtual {v0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V

    .line 14
    return-void
.end method
