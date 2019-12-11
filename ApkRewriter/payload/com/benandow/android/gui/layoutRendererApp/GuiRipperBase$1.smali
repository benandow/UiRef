.class Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;
.super Ljava/lang/Object;
.source "GuiRipperBase.java"

# interfaces
.implements Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

.field private final synthetic val$layout_id:I

.field private final synthetic val$package_name:Ljava/lang/String;

.field private final synthetic val$startTime:J

.field private final synthetic val$viewGroup:Landroid/view/ViewGroup;


# direct methods
.method constructor <init>(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;Landroid/view/ViewGroup;Ljava/lang/String;IJ)V
    .locals 1

    .prologue
    .line 1
    iput-object p1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    iput-object p2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    iput-object p3, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$package_name:Ljava/lang/String;

    iput p4, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$layout_id:I

    iput-wide p5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$startTime:J

    .line 92
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onGlobalLayout()V
    .locals 15

    .prologue
    const/4 v14, 0x2

    const/4 v13, 0x1

    const/4 v12, 0x0

    .line 95
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v5}, Landroid/view/ViewGroup;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v4

    .line 96
    .local v4, "vto":Landroid/view/ViewTreeObserver;
    :goto_0
    invoke-virtual {v4}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v5

    if-eqz v5, :cond_0

    .line 99
    invoke-virtual {v4, p0}, Landroid/view/ViewTreeObserver;->removeOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 101
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 103
    .local v2, "endTime":J
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    iget-object v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    new-instance v7, Ljava/io/File;

    iget-object v8, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;
    invoke-static {v8}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$0(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)Ljava/io/File;

    move-result-object v8

    const-string v9, "%s_%s.png"

    new-array v10, v14, [Ljava/lang/Object;

    iget-object v11, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$package_name:Ljava/lang/String;

    aput-object v11, v10, v12

    iget v11, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$layout_id:I

    invoke-static {v11}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v11

    aput-object v11, v10, v13

    invoke-static {v9, v10}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    invoke-direct {v7, v8, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iget v8, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$layout_id:I

    # invokes: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->dumpScreenshot(Landroid/view/View;Ljava/io/File;I)V
    invoke-static {v5, v6, v7, v8}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$1(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;Landroid/view/View;Ljava/io/File;I)V

    .line 107
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;
    invoke-static {v5}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$2(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)Landroid/app/Activity;

    move-result-object v5

    invoke-virtual {v5}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->createHierarchyXmlDump(Ljava/lang/String;)Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;

    move-result-object v1

    .line 108
    .local v1, "layout_xml_dump":Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    iget v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$layout_id:I

    iget-wide v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$startTime:J

    sub-long v6, v2, v6

    long-to-double v6, v6

    invoke-virtual {v1, v5, v6, v7}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addLayout(ID)V

    .line 109
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v5}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    const/4 v6, 0x4

    new-array v6, v6, [I

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v7}, Landroid/view/ViewGroup;->getLeft()I

    move-result v7

    aput v7, v6, v12

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v7}, Landroid/view/ViewGroup;->getTop()I

    move-result v7

    aput v7, v6, v13

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v7}, Landroid/view/ViewGroup;->getRight()I

    move-result v7

    aput v7, v6, v14

    const/4 v7, 0x3

    iget-object v8, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v8}, Landroid/view/ViewGroup;->getBottom()I

    move-result v8

    aput v8, v6, v7

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v7}, Landroid/view/ViewGroup;->getId()I

    move-result v7

    iget-object v8, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    iget-object v9, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v9}, Landroid/view/ViewGroup;->getVisibility()I

    move-result v9

    # invokes: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;
    invoke-static {v8, v9}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$3(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v1, v5, v6, v7, v8}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewGroup(Ljava/lang/String;[IILjava/lang/String;)V

    .line 110
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    iget-object v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    const-string v7, "%s_%s"

    new-array v8, v14, [Ljava/lang/Object;

    iget-object v9, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$package_name:Ljava/lang/String;

    aput-object v9, v8, v12

    iget v9, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$layout_id:I

    invoke-static {v9}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v9

    aput-object v9, v8, v13

    invoke-static {v7, v8}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    # invokes: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->traverseViewHierarchy(Landroid/view/ViewGroup;Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;Ljava/lang/String;)V
    invoke-static {v5, v6, v1, v7}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$4(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;Landroid/view/ViewGroup;Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;Ljava/lang/String;)V

    .line 111
    invoke-virtual {v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->endElement()V

    .line 112
    invoke-virtual {v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->endElement()V

    .line 115
    :try_start_0
    new-instance v5, Ljava/io/File;

    iget-object v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;
    invoke-static {v6}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$0(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)Ljava/io/File;

    move-result-object v6

    const-string v7, "%s_%s.xml"

    const/4 v8, 0x2

    new-array v8, v8, [Ljava/lang/Object;

    const/4 v9, 0x0

    iget-object v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$package_name:Ljava/lang/String;

    aput-object v10, v8, v9

    const/4 v9, 0x1

    iget v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$layout_id:I

    invoke-static {v10}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v10

    aput-object v10, v8, v9

    invoke-static {v7, v8}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    invoke-direct {v5, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1, v5}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->writeToFile(Ljava/io/File;)V
    :try_end_0
    .catch Ljavax/xml/transform/TransformerException; {:try_start_0 .. :try_end_0} :catch_0

    .line 121
    :goto_1
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I
    invoke-static {v5}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$5(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)I

    move-result v5

    iget-object v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;
    invoke-static {v6}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$6(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)[Ljava/lang/Integer;

    move-result-object v6

    array-length v6, v6

    if-ge v5, v6, :cond_1

    .line 122
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    invoke-virtual {v5}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V

    .line 127
    :goto_2
    return-void

    .line 97
    .end local v1    # "layout_xml_dump":Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    .end local v2    # "endTime":J
    :cond_0
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->val$viewGroup:Landroid/view/ViewGroup;

    invoke-virtual {v5}, Landroid/view/ViewGroup;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v4

    goto/16 :goto_0

    .line 117
    .restart local v1    # "layout_xml_dump":Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    .restart local v2    # "endTime":J
    :catch_0
    move-exception v0

    .line 118
    .local v0, "e":Ljavax/xml/transform/TransformerException;
    invoke-virtual {v0}, Ljavax/xml/transform/TransformerException;->printStackTrace()V

    goto :goto_1

    .line 124
    .end local v0    # "e":Ljavax/xml/transform/TransformerException;
    :cond_1
    const-string v5, "GuiRipper"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "RenderingComplete(0):"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I
    invoke-static {v7}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$5(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)I

    move-result v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;->this$0:Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;

    # getter for: Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;
    invoke-static {v7}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->access$6(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)[Ljava/lang/Integer;

    move-result-object v7

    array-length v7, v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_2
.end method
