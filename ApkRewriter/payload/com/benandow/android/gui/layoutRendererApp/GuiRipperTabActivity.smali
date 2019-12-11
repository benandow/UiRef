.class public Lcom/benandow/android/gui/layoutRendererApp/GuiRipperTabActivity;
.super Landroid/app/TabActivity;
.source "GuiRipperTabActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Landroid/app/TabActivity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 11
    invoke-super {p0, p1}, Landroid/app/TabActivity;->onCreate(Landroid/os/Bundle;)V

    .line 13
    new-instance v0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    invoke-direct {v0, p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;-><init>(Landroid/app/Activity;)V

    .line 14
    .local v0, "base":Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;
    invoke-virtual {v0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V

    .line 15
    return-void
.end method
