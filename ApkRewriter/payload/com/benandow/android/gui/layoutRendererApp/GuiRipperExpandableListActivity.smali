.class public Lcom/benandow/android/gui/layoutRendererApp/GuiRipperExpandableListActivity;
.super Landroid/app/ExpandableListActivity;
.source "GuiRipperExpandableListActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 6
    invoke-direct {p0}, Landroid/app/ExpandableListActivity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 10
    invoke-super {p0, p1}, Landroid/app/ExpandableListActivity;->onCreate(Landroid/os/Bundle;)V

    .line 12
    new-instance v0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    invoke-direct {v0, p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;-><init>(Landroid/app/Activity;)V

    .line 13
    .local v0, "base":Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;
    invoke-virtual {v0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V

    .line 14
    return-void
.end method
