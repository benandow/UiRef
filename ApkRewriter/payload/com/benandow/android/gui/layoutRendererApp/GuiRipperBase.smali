.class public Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;
.super Ljava/lang/Object;
.source "GuiRipperBase.java"


# static fields
.field private static drawableIdCounter:I


# instance fields
.field private activity:Landroid/app/Activity;

.field private current_layout_counter:I

.field private layout_res_ids:[Ljava/lang/Integer;

.field private output_dir:Ljava/io/File;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 47
    const/4 v0, 0x0

    sput v0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->drawableIdCounter:I

    return-void
.end method

.method public constructor <init>(Landroid/app/Activity;)V
    .locals 1
    .param p1, "activity"    # Landroid/app/Activity;

    .prologue
    .line 54
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 55
    iput-object p1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    .line 57
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getLayoutIds()[Ljava/lang/Integer;

    move-result-object v0

    iput-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    .line 59
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v0

    iput-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;

    .line 61
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getLayoutCounter()I

    move-result v0

    iput v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    .line 62
    return-void
.end method

.method static synthetic access$0(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)Ljava/io/File;
    .locals 1

    .prologue
    .line 52
    iget-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;

    return-object v0
.end method

.method static synthetic access$1(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;Landroid/view/View;Ljava/io/File;I)V
    .locals 0

    .prologue
    .line 453
    invoke-direct {p0, p1, p2, p3}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->dumpScreenshot(Landroid/view/View;Ljava/io/File;I)V

    return-void
.end method

.method static synthetic access$2(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)Landroid/app/Activity;
    .locals 1

    .prologue
    .line 49
    iget-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    return-object v0
.end method

.method static synthetic access$3(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;I)Ljava/lang/String;
    .locals 1

    .prologue
    .line 171
    invoke-direct {p0, p1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$4(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;Landroid/view/ViewGroup;Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 264
    invoke-direct {p0, p1, p2, p3}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->traverseViewHierarchy(Landroid/view/ViewGroup;Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$5(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)I
    .locals 1

    .prologue
    .line 51
    iget v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    return v0
.end method

.method static synthetic access$6(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;)[Ljava/lang/Integer;
    .locals 1

    .prologue
    .line 50
    iget-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    return-object v0
.end method

.method private addDrawable(Ljava/util/HashMap;Landroid/graphics/drawable/Drawable;Ljava/lang/String;)V
    .locals 9
    .param p2, "d"    # Landroid/graphics/drawable/Drawable;
    .param p3, "fileBaseName"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Landroid/graphics/drawable/Drawable;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .prologue
    .line 207
    .local p1, "params":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    if-nez p2, :cond_0

    .line 261
    :goto_0
    return-void

    .line 211
    :cond_0
    const-string v4, "%s_%s.png"

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Object;

    const/4 v6, 0x0

    aput-object p3, v5, v6

    const/4 v6, 0x1

    sget v7, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->drawableIdCounter:I

    add-int/lit8 v8, v7, 0x1

    sput v8, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->drawableIdCounter:I

    invoke-static {v7}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v5, v6

    invoke-static {v4, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    .line 213
    .local v1, "drawableFileName":Ljava/lang/String;
    :try_start_0
    invoke-static {p2}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->drawableToBitmap(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 214
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    new-instance v2, Ljava/io/FileOutputStream;

    new-instance v4, Ljava/io/File;

    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;

    invoke-direct {v4, v5, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-direct {v2, v4}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 215
    .local v2, "fos":Ljava/io/FileOutputStream;
    sget-object v4, Landroid/graphics/Bitmap$CompressFormat;->PNG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v5, 0x64

    invoke-virtual {v0, v4, v5, v2}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 216
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->flush()V

    .line 217
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 222
    .end local v0    # "bitmap":Landroid/graphics/Bitmap;
    .end local v2    # "fos":Ljava/io/FileOutputStream;
    :goto_1
    const-string v4, "drawableVisibility"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 223
    const-string v5, "drawableVisibility"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v4, "drawableVisibility"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "|"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->isVisible()Z

    move-result v6

    invoke-static {v6}, Ljava/lang/Boolean;->toString(Z)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 229
    :goto_2
    const-string v4, "drawableId"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 230
    const-string v5, "drawableId"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v4, "drawableId"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "|"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 236
    :goto_3
    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v3

    .line 237
    .local v3, "r":Landroid/graphics/Rect;
    const-string v4, "drawableTop"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 238
    const-string v5, "drawableTop"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v4, "drawableTop"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "|"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v6, v3, Landroid/graphics/Rect;->top:I

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 243
    :goto_4
    const-string v4, "drawableRight"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 244
    const-string v5, "drawableRight"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v4, "drawableRight"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "|"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v6, v3, Landroid/graphics/Rect;->right:I

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 249
    :goto_5
    const-string v4, "drawableBottom"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_5

    .line 250
    const-string v5, "drawableBottom"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v4, "drawableBottom"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "|"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v6, v3, Landroid/graphics/Rect;->bottom:I

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 255
    :goto_6
    const-string v4, "drawableLeft"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_6

    .line 256
    const-string v5, "drawableLeft"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v4, "drawableLeft"

    invoke-virtual {p1, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "|"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v6, v3, Landroid/graphics/Rect;->left:I

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_0

    .line 226
    .end local v3    # "r":Landroid/graphics/Rect;
    :cond_1
    const-string v4, "drawableVisibility"

    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->isVisible()Z

    move-result v5

    invoke-static {v5}, Ljava/lang/Boolean;->toString(Z)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1, v4, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_2

    .line 233
    :cond_2
    const-string v4, "drawableId"

    invoke-virtual {p1, v4, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_3

    .line 240
    .restart local v3    # "r":Landroid/graphics/Rect;
    :cond_3
    const-string v4, "drawableTop"

    iget v5, v3, Landroid/graphics/Rect;->top:I

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1, v4, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_4

    .line 246
    :cond_4
    const-string v4, "drawableRight"

    iget v5, v3, Landroid/graphics/Rect;->right:I

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1, v4, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_5

    .line 252
    :cond_5
    const-string v4, "drawableBottom"

    iget v5, v3, Landroid/graphics/Rect;->bottom:I

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1, v4, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_6

    .line 258
    :cond_6
    const-string v4, "drawableLeft"

    iget v5, v3, Landroid/graphics/Rect;->left:I

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1, v4, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_0

    .line 218
    .end local v3    # "r":Landroid/graphics/Rect;
    :catch_0
    move-exception v4

    goto/16 :goto_1
.end method

.method private static drawableToBitmap(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Bitmap;
    .locals 7
    .param p0, "drawable"    # Landroid/graphics/drawable/Drawable;

    .prologue
    const/4 v4, 0x1

    const/4 v6, 0x0

    .line 184
    const/4 v0, 0x0

    .line 186
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    instance-of v3, p0, Landroid/graphics/drawable/BitmapDrawable;

    if-eqz v3, :cond_0

    move-object v1, p0

    .line 187
    check-cast v1, Landroid/graphics/drawable/BitmapDrawable;

    .line 188
    .local v1, "bitmapDrawable":Landroid/graphics/drawable/BitmapDrawable;
    invoke-virtual {v1}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v3

    if-eqz v3, :cond_0

    .line 189
    invoke-virtual {v1}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v3

    .line 202
    .end local v1    # "bitmapDrawable":Landroid/graphics/drawable/BitmapDrawable;
    :goto_0
    return-object v3

    .line 193
    :cond_0
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v3

    if-lez v3, :cond_1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v3

    if-gtz v3, :cond_2

    .line 194
    :cond_1
    sget-object v3, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v4, v4, v3}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 199
    :goto_1
    new-instance v2, Landroid/graphics/Canvas;

    invoke-direct {v2, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 200
    .local v2, "canvas":Landroid/graphics/Canvas;
    invoke-virtual {v2}, Landroid/graphics/Canvas;->getWidth()I

    move-result v3

    invoke-virtual {v2}, Landroid/graphics/Canvas;->getHeight()I

    move-result v4

    invoke-virtual {p0, v6, v6, v3, v4}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 201
    invoke-virtual {p0, v2}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    move-object v3, v0

    .line 202
    goto :goto_0

    .line 196
    .end local v2    # "canvas":Landroid/graphics/Canvas;
    :cond_2
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v3

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v4

    sget-object v5, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v4, v5}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    goto :goto_1
.end method

.method private dumpScreenshot(Landroid/view/View;Ljava/io/File;I)V
    .locals 6
    .param p1, "v"    # Landroid/view/View;
    .param p2, "file"    # Ljava/io/File;
    .param p3, "layout_id"    # I

    .prologue
    .line 455
    const/4 v3, 0x1

    :try_start_0
    invoke-virtual {p1, v3}, Landroid/view/View;->setDrawingCacheEnabled(Z)V

    .line 456
    invoke-virtual {p1}, Landroid/view/View;->getDrawingCache()Landroid/graphics/Bitmap;

    move-result-object v3

    invoke-static {v3}, Landroid/graphics/Bitmap;->createBitmap(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 457
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    const/4 v3, 0x0

    invoke-virtual {p1, v3}, Landroid/view/View;->setDrawingCacheEnabled(Z)V

    .line 458
    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, p2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 459
    .local v2, "fos":Ljava/io/FileOutputStream;
    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->PNG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v4, 0x64

    invoke-virtual {v0, v3, v4, v2}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 460
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->flush()V

    .line 461
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 465
    .end local v0    # "bitmap":Landroid/graphics/Bitmap;
    .end local v2    # "fos":Ljava/io/FileOutputStream;
    :goto_0
    return-void

    .line 462
    :catch_0
    move-exception v1

    .line 463
    .local v1, "e":Ljava/lang/Exception;
    const-string v3, "GuiRipper"

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "ScreendumpException("

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p3}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "):"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "/"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    array-length v5, v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method private getLayoutCounter()I
    .locals 10

    .prologue
    const/4 v6, 0x0

    .line 149
    new-instance v2, Ljava/io/File;

    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;

    new-instance v8, Ljava/lang/StringBuilder;

    iget-object v9, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    invoke-virtual {v9}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v9

    invoke-static {v9}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v9, "_PROGRESS.txt"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-direct {v2, v7, v8}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 150
    .local v2, "f":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v7

    if-eqz v7, :cond_0

    invoke-virtual {v2}, Ljava/io/File;->canRead()Z

    move-result v7

    if-nez v7, :cond_1

    .line 168
    :cond_0
    :goto_0
    return v6

    .line 154
    :cond_1
    :try_start_0
    new-instance v5, Ljava/io/BufferedReader;

    new-instance v7, Ljava/io/FileReader;

    invoke-direct {v7, v2}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v5, v7}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 155
    .local v5, "reader":Ljava/io/BufferedReader;
    invoke-virtual {v5}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    .line 156
    .local v4, "line":Ljava/lang/String;
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V

    .line 157
    if-eqz v4, :cond_0

    .line 161
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 162
    .local v0, "counter":I
    iget-object v7, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    aget-object v7, v7, v0

    invoke-virtual {v7}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 163
    .local v3, "layout_id":I
    const-string v7, "GuiRipper"

    new-instance v8, Ljava/lang/StringBuilder;

    const-string v9, "RenderingFailure("

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v3}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, "):"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, "/"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget-object v9, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    array-length v9, v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v7, v8}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 164
    add-int/lit8 v6, v0, 0x1

    goto :goto_0

    .line 165
    .end local v0    # "counter":I
    .end local v3    # "layout_id":I
    .end local v4    # "line":Ljava/lang/String;
    .end local v5    # "reader":Ljava/io/BufferedReader;
    :catch_0
    move-exception v1

    .line 166
    .local v1, "e":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method private getLayoutIds()[Ljava/lang/Integer;
    .locals 7

    .prologue
    .line 468
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 470
    .local v4, "res":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/Integer;>;"
    :try_start_0
    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    invoke-virtual {v5}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/res/Resources;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v5

    const-string v6, "com_benandow_ncsu_gui_layouts.txt"

    invoke-virtual {v5, v6}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v1

    .line 471
    .local v1, "istream":Ljava/io/InputStream;
    new-instance v3, Ljava/io/BufferedReader;

    new-instance v5, Ljava/io/InputStreamReader;

    invoke-direct {v5, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v3, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 472
    .local v3, "reader":Ljava/io/BufferedReader;
    const/4 v2, 0x0

    .line 473
    .local v2, "line":Ljava/lang/String;
    :goto_0
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    move-result-object v2

    if-nez v2, :cond_0

    .line 486
    .end local v1    # "istream":Ljava/io/InputStream;
    .end local v2    # "line":Ljava/lang/String;
    .end local v3    # "reader":Ljava/io/BufferedReader;
    :goto_1
    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v5

    new-array v5, v5, [Ljava/lang/Integer;

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v5

    check-cast v5, [Ljava/lang/Integer;

    return-object v5

    .line 475
    .restart local v1    # "istream":Ljava/io/InputStream;
    .restart local v2    # "line":Ljava/lang/String;
    .restart local v3    # "reader":Ljava/io/BufferedReader;
    :cond_0
    :try_start_1
    const-string v5, "0x"

    invoke-virtual {v2, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 476
    const/4 v5, 0x2

    invoke-virtual {v2, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    .line 478
    :cond_1
    const/16 v5, 0x10

    invoke-static {v2, v5}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    .line 479
    :catch_0
    move-exception v5

    goto :goto_0

    .line 483
    .end local v1    # "istream":Ljava/io/InputStream;
    .end local v2    # "line":Ljava/lang/String;
    .end local v3    # "reader":Ljava/io/BufferedReader;
    :catch_1
    move-exception v0

    .line 484
    .local v0, "e":Ljava/io/IOException;
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_1
.end method

.method private getVisibilityString(I)Ljava/lang/String;
    .locals 1
    .param p1, "vis"    # I

    .prologue
    .line 172
    if-nez p1, :cond_0

    .line 173
    const-string v0, "visible"

    .line 179
    :goto_0
    return-object v0

    .line 174
    :cond_0
    const/4 v0, 0x4

    if-ne p1, v0, :cond_1

    .line 175
    const-string v0, "invisible"

    goto :goto_0

    .line 176
    :cond_1
    const/16 v0, 0x8

    if-ne p1, v0, :cond_2

    .line 177
    const-string v0, "gone"

    goto :goto_0

    .line 179
    :cond_2
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private traverseViewHierarchy(Landroid/view/ViewGroup;Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;Ljava/lang/String;)V
    .locals 24
    .param p1, "vgroup"    # Landroid/view/ViewGroup;
    .param p2, "layout_xml_dump"    # Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    .param p3, "fileBaseName"    # Ljava/lang/String;

    .prologue
    .line 266
    const/4 v12, 0x0

    .local v12, "i":I
    :goto_0
    :try_start_0
    invoke-virtual/range {p1 .. p1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v22

    move/from16 v0, v22

    if-lt v12, v0, :cond_0

    .line 451
    :goto_1
    return-void

    .line 267
    :cond_0
    move-object/from16 v0, p1

    invoke-virtual {v0, v12}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v20

    .line 269
    .local v20, "v":Landroid/view/View;
    new-instance v15, Ljava/util/HashMap;

    invoke-direct {v15}, Ljava/util/HashMap;-><init>()V

    .line 270
    .local v15, "params":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v22, "left"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getLeft()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 271
    const-string v22, "top"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getTop()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 272
    const-string v22, "right"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getRight()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 273
    const-string v22, "bottom"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getBottom()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 275
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/TextView;

    move/from16 v22, v0

    if-eqz v22, :cond_1

    .line 276
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/TextView;

    move-object/from16 v19, v0

    .line 277
    .local v19, "tv":Landroid/widget/TextView;
    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getCompoundDrawables()[Landroid/graphics/drawable/Drawable;

    move-result-object v9

    .line 278
    .local v9, "drawables":[Landroid/graphics/drawable/Drawable;
    array-length v0, v9

    move/from16 v23, v0

    const/16 v22, 0x0

    :goto_2
    move/from16 v0, v22

    move/from16 v1, v23

    if-lt v0, v1, :cond_2

    .line 283
    .end local v9    # "drawables":[Landroid/graphics/drawable/Drawable;
    .end local v19    # "tv":Landroid/widget/TextView;
    :cond_1
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/RatingBar;

    move/from16 v22, v0

    if-eqz v22, :cond_3

    .line 284
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/RatingBar;

    move-object/from16 v16, v0

    .line 285
    .local v16, "rb":Landroid/widget/RatingBar;
    const-string v22, "name"

    invoke-virtual/range {v16 .. v16}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 286
    const-string v22, "id"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RatingBar;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 287
    const-string v22, "superclass"

    const-string v23, "android.widget.RatingBar"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 288
    const-string v22, "visibility"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RatingBar;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 266
    .end local v16    # "rb":Landroid/widget/RatingBar;
    .end local v20    # "v":Landroid/view/View;
    :goto_3
    add-int/lit8 v12, v12, 0x1

    goto/16 :goto_0

    .line 278
    .restart local v9    # "drawables":[Landroid/graphics/drawable/Drawable;
    .restart local v19    # "tv":Landroid/widget/TextView;
    .restart local v20    # "v":Landroid/view/View;
    :cond_2
    aget-object v8, v9, v22

    .line 279
    .local v8, "d":Landroid/graphics/drawable/Drawable;
    move-object/from16 v0, p0

    move-object/from16 v1, p3

    invoke-direct {v0, v15, v8, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->addDrawable(Ljava/util/HashMap;Landroid/graphics/drawable/Drawable;Ljava/lang/String;)V

    .line 278
    add-int/lit8 v22, v22, 0x1

    goto :goto_2

    .line 289
    .end local v8    # "d":Landroid/graphics/drawable/Drawable;
    .end local v9    # "drawables":[Landroid/graphics/drawable/Drawable;
    .end local v19    # "tv":Landroid/widget/TextView;
    :cond_3
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/CheckedTextView;

    move/from16 v22, v0

    if-eqz v22, :cond_6

    .line 290
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/CheckedTextView;

    move-object v7, v0

    .line 291
    .local v7, "ctv":Landroid/widget/CheckedTextView;
    const-string v22, "textSize"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 292
    const-string v22, "textSize"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 293
    const-string v22, "name"

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 294
    const-string v22, "id"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 295
    const-string v22, "superclass"

    const-string v23, "android.widget.CheckedTextView"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 296
    const-string v22, "visibility"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 297
    const-string v22, "input"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 298
    const-string v23, "text"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_4

    const/16 v22, 0x0

    :goto_4
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 299
    const-string v23, "hint"

    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_5

    const/16 v22, 0x0

    :goto_5
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 300
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_3

    .line 448
    .end local v7    # "ctv":Landroid/widget/CheckedTextView;
    .end local v15    # "params":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    .end local v20    # "v":Landroid/view/View;
    :catch_0
    move-exception v10

    .line 449
    .local v10, "e":Ljava/lang/Exception;
    invoke-virtual {v10}, Ljava/lang/Exception;->printStackTrace()V

    goto/16 :goto_1

    .line 298
    .end local v10    # "e":Ljava/lang/Exception;
    .restart local v7    # "ctv":Landroid/widget/CheckedTextView;
    .restart local v15    # "params":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    .restart local v20    # "v":Landroid/view/View;
    :cond_4
    :try_start_1
    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_4

    .line 299
    :cond_5
    invoke-virtual {v7}, Landroid/widget/CheckedTextView;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_5

    .line 301
    .end local v7    # "ctv":Landroid/widget/CheckedTextView;
    :cond_6
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/AbsSpinner;

    move/from16 v22, v0

    if-eqz v22, :cond_7

    .line 302
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/AbsSpinner;

    move-object v4, v0

    .line 303
    .local v4, "abs":Landroid/widget/AbsSpinner;
    const-string v22, "name"

    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 304
    const-string v22, "id"

    invoke-virtual {v4}, Landroid/widget/AbsSpinner;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 305
    const-string v22, "superclass"

    const-string v23, "android.widget.AbsSpinner"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 306
    const-string v22, "visibility"

    invoke-virtual {v4}, Landroid/widget/AbsSpinner;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 307
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 308
    .end local v4    # "abs":Landroid/widget/AbsSpinner;
    :cond_7
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/RadioButton;

    move/from16 v22, v0

    if-eqz v22, :cond_a

    .line 309
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/RadioButton;

    move-object/from16 v16, v0

    .line 310
    .local v16, "rb":Landroid/widget/RadioButton;
    const-string v22, "textSize"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 311
    const-string v22, "textSize"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 312
    const-string v22, "name"

    invoke-virtual/range {v16 .. v16}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 313
    const-string v22, "id"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 314
    const-string v22, "superclass"

    const-string v23, "android.widget.RadioButton"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 315
    const-string v22, "visibility"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 316
    const-string v22, "input"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 317
    const-string v23, "text"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_8

    const/16 v22, 0x0

    :goto_6
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 318
    const-string v23, "hint"

    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_9

    const/16 v22, 0x0

    :goto_7
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 319
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 317
    :cond_8
    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_6

    .line 318
    :cond_9
    invoke-virtual/range {v16 .. v16}, Landroid/widget/RadioButton;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_7

    .line 320
    .end local v16    # "rb":Landroid/widget/RadioButton;
    :cond_a
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/CheckBox;

    move/from16 v22, v0

    if-eqz v22, :cond_d

    .line 321
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/CheckBox;

    move-object v6, v0

    .line 322
    .local v6, "cb":Landroid/widget/CheckBox;
    const-string v22, "textSize"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 323
    const-string v22, "textSize"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 324
    const-string v22, "name"

    invoke-virtual {v6}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 325
    const-string v22, "id"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 326
    const-string v22, "superclass"

    const-string v23, "android.widget.CheckBox"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 327
    const-string v22, "visibility"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 328
    const-string v22, "input"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 329
    const-string v23, "text"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_b

    const/16 v22, 0x0

    :goto_8
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 330
    const-string v23, "hint"

    invoke-virtual {v6}, Landroid/widget/CheckBox;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_c

    const/16 v22, 0x0

    :goto_9
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 331
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 329
    :cond_b
    invoke-virtual {v6}, Landroid/widget/CheckBox;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_8

    .line 330
    :cond_c
    invoke-virtual {v6}, Landroid/widget/CheckBox;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_9

    .line 332
    .end local v6    # "cb":Landroid/widget/CheckBox;
    :cond_d
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/ToggleButton;

    move/from16 v22, v0

    if-eqz v22, :cond_12

    .line 333
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/ToggleButton;

    move-object/from16 v18, v0

    .line 334
    .local v18, "tb":Landroid/widget/ToggleButton;
    const-string v22, "textSize"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 335
    const-string v22, "textSize"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 336
    const-string v22, "name"

    invoke-virtual/range {v18 .. v18}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 337
    const-string v22, "id"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 338
    const-string v22, "superclass"

    const-string v23, "android.widget.ToggleButton"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 339
    const-string v22, "visibility"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 340
    const-string v22, "input"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 341
    const-string v23, "text"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_e

    const/16 v22, 0x0

    :goto_a
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 342
    const-string v23, "hint"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_f

    const/16 v22, 0x0

    :goto_b
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 343
    const-string v23, "textOn"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getTextOn()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_10

    const/16 v22, 0x0

    :goto_c
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 344
    const-string v23, "textOff"

    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getTextOff()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_11

    const/16 v22, 0x0

    :goto_d
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 345
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 341
    :cond_e
    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_a

    .line 342
    :cond_f
    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_b

    .line 343
    :cond_10
    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getTextOn()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_c

    .line 344
    :cond_11
    invoke-virtual/range {v18 .. v18}, Landroid/widget/ToggleButton;->getTextOff()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_d

    .line 346
    .end local v18    # "tb":Landroid/widget/ToggleButton;
    :cond_12
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/Switch;

    move/from16 v22, v0

    if-eqz v22, :cond_17

    .line 347
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/Switch;

    move-object/from16 v17, v0

    .line 348
    .local v17, "sw":Landroid/widget/Switch;
    const-string v22, "textSize"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 349
    const-string v22, "textSize"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 350
    const-string v22, "name"

    invoke-virtual/range {v17 .. v17}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 351
    const-string v22, "id"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 352
    const-string v22, "superclass"

    const-string v23, "android.widget.Switch"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 353
    const-string v22, "visibility"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 354
    const-string v22, "input"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 355
    const-string v23, "text"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_13

    const/16 v22, 0x0

    :goto_e
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 356
    const-string v23, "hint"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_14

    const/16 v22, 0x0

    :goto_f
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 357
    const-string v23, "textOn"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getTextOn()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_15

    const/16 v22, 0x0

    :goto_10
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 358
    const-string v23, "textOff"

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getTextOff()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_16

    const/16 v22, 0x0

    :goto_11
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 359
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 355
    :cond_13
    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_e

    .line 356
    :cond_14
    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_f

    .line 357
    :cond_15
    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getTextOn()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_10

    .line 358
    :cond_16
    invoke-virtual/range {v17 .. v17}, Landroid/widget/Switch;->getTextOff()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_11

    .line 375
    .end local v17    # "sw":Landroid/widget/Switch;
    :cond_17
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/ImageButton;

    move/from16 v22, v0

    if-eqz v22, :cond_18

    .line 376
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/ImageButton;

    move-object v13, v0

    .line 377
    .local v13, "ib":Landroid/widget/ImageButton;
    const-string v22, "name"

    invoke-virtual {v13}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 378
    const-string v22, "id"

    invoke-virtual {v13}, Landroid/widget/ImageButton;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 379
    const-string v22, "superclass"

    const-string v23, "android.widget.ImageButton"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 380
    const-string v22, "visibility"

    invoke-virtual {v13}, Landroid/widget/ImageButton;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 381
    invoke-virtual {v13}, Landroid/widget/ImageButton;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v22

    move-object/from16 v0, p0

    move-object/from16 v1, v22

    move-object/from16 v2, p3

    invoke-direct {v0, v15, v1, v2}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->addDrawable(Ljava/util/HashMap;Landroid/graphics/drawable/Drawable;Ljava/lang/String;)V

    .line 382
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 383
    .end local v13    # "ib":Landroid/widget/ImageButton;
    :cond_18
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/ImageView;

    move/from16 v22, v0

    if-eqz v22, :cond_19

    .line 384
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/ImageView;

    move-object v14, v0

    .line 385
    .local v14, "iv":Landroid/widget/ImageView;
    const-string v22, "name"

    invoke-virtual {v14}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 386
    const-string v22, "id"

    invoke-virtual {v14}, Landroid/widget/ImageView;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 387
    const-string v22, "superclass"

    const-string v23, "android.widget.ImageView"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 388
    const-string v22, "visibility"

    invoke-virtual {v14}, Landroid/widget/ImageView;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 389
    invoke-virtual {v14}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v22

    move-object/from16 v0, p0

    move-object/from16 v1, v22

    move-object/from16 v2, p3

    invoke-direct {v0, v15, v1, v2}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->addDrawable(Ljava/util/HashMap;Landroid/graphics/drawable/Drawable;Ljava/lang/String;)V

    .line 390
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 391
    .end local v14    # "iv":Landroid/widget/ImageView;
    :cond_19
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/webkit/WebView;

    move/from16 v22, v0

    if-eqz v22, :cond_1a

    .line 392
    move-object/from16 v0, v20

    check-cast v0, Landroid/webkit/WebView;

    move-object/from16 v21, v0

    .line 393
    .local v21, "wv":Landroid/webkit/WebView;
    const-string v22, "name"

    invoke-virtual/range {v21 .. v21}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 394
    const-string v22, "id"

    invoke-virtual/range {v21 .. v21}, Landroid/webkit/WebView;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 395
    const-string v22, "superclass"

    const-string v23, "android.webkit.WebView"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 396
    const-string v22, "visibility"

    invoke-virtual/range {v21 .. v21}, Landroid/webkit/WebView;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 397
    const-string v22, "url"

    invoke-virtual/range {v21 .. v21}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 398
    const-string v22, "originalUrl"

    invoke-virtual/range {v21 .. v21}, Landroid/webkit/WebView;->getOriginalUrl()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 399
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 400
    .end local v21    # "wv":Landroid/webkit/WebView;
    :cond_1a
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/EditText;

    move/from16 v22, v0

    if-eqz v22, :cond_1d

    .line 401
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/EditText;

    move-object v11, v0

    .line 402
    .local v11, "et":Landroid/widget/EditText;
    const-string v22, "name"

    invoke-virtual {v11}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 403
    const-string v22, "id"

    invoke-virtual {v11}, Landroid/widget/EditText;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 404
    const-string v22, "superclass"

    const-string v23, "com.widget.EditText"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 405
    const-string v22, "visibility"

    invoke-virtual {v11}, Landroid/widget/EditText;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 406
    const-string v22, "input"

    invoke-virtual {v11}, Landroid/widget/EditText;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 407
    const-string v23, "text"

    invoke-virtual {v11}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v22

    if-nez v22, :cond_1b

    const/16 v22, 0x0

    :goto_12
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 408
    const-string v23, "hint"

    invoke-virtual {v11}, Landroid/widget/EditText;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_1c

    const/16 v22, 0x0

    :goto_13
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 409
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 407
    :cond_1b
    invoke-virtual {v11}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Landroid/text/Editable;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_12

    .line 408
    :cond_1c
    invoke-virtual {v11}, Landroid/widget/EditText;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_13

    .line 410
    .end local v11    # "et":Landroid/widget/EditText;
    :cond_1d
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/Button;

    move/from16 v22, v0

    if-eqz v22, :cond_20

    .line 411
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/Button;

    move-object v5, v0

    .line 412
    .local v5, "btn":Landroid/widget/Button;
    const-string v22, "textSize"

    invoke-virtual {v5}, Landroid/widget/Button;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 413
    const-string v22, "textSize"

    invoke-virtual {v5}, Landroid/widget/Button;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 414
    const-string v22, "name"

    invoke-virtual {v5}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 415
    const-string v22, "id"

    invoke-virtual {v5}, Landroid/widget/Button;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 416
    const-string v22, "superclass"

    const-string v23, "com.widget.Button"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 417
    const-string v22, "visibility"

    invoke-virtual {v5}, Landroid/widget/Button;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 418
    const-string v22, "input"

    invoke-virtual {v5}, Landroid/widget/Button;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 419
    const-string v23, "text"

    invoke-virtual {v5}, Landroid/widget/Button;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_1e

    const/16 v22, 0x0

    :goto_14
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 420
    const-string v23, "hint"

    invoke-virtual {v5}, Landroid/widget/Button;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_1f

    const/16 v22, 0x0

    :goto_15
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 421
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 419
    :cond_1e
    invoke-virtual {v5}, Landroid/widget/Button;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_14

    .line 420
    :cond_1f
    invoke-virtual {v5}, Landroid/widget/Button;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_15

    .line 422
    .end local v5    # "btn":Landroid/widget/Button;
    :cond_20
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/widget/TextView;

    move/from16 v22, v0

    if-eqz v22, :cond_23

    .line 423
    move-object/from16 v0, v20

    check-cast v0, Landroid/widget/TextView;

    move-object/from16 v19, v0

    .line 424
    .restart local v19    # "tv":Landroid/widget/TextView;
    const-string v22, "textSize"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getTextSize()F

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Float;->toString(F)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 425
    const-string v22, "textSize"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 426
    const-string v22, "name"

    invoke-virtual/range {v19 .. v19}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 427
    const-string v22, "id"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 428
    const-string v22, "superclass"

    const-string v23, "com.widget.TextView"

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 429
    const-string v22, "visibility"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 430
    const-string v22, "input"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getInputType()I

    move-result v23

    invoke-static/range {v23 .. v23}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeInputType(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 431
    const-string v23, "text"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_21

    const/16 v22, 0x0

    :goto_16
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 432
    const-string v23, "hint"

    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    if-nez v22, :cond_22

    const/16 v22, 0x0

    :goto_17
    move-object/from16 v0, v23

    move-object/from16 v1, v22

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 433
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V

    goto/16 :goto_3

    .line 431
    :cond_21
    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_16

    .line 432
    :cond_22
    invoke-virtual/range {v19 .. v19}, Landroid/widget/TextView;->getHint()Ljava/lang/CharSequence;

    move-result-object v22

    invoke-interface/range {v22 .. v22}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v22

    goto :goto_17

    .line 434
    .end local v19    # "tv":Landroid/widget/TextView;
    :cond_23
    move-object/from16 v0, v20

    instance-of v0, v0, Landroid/view/ViewGroup;

    move/from16 v22, v0

    if-eqz v22, :cond_24

    .line 435
    const-string v22, "name"

    invoke-virtual/range {v20 .. v20}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 436
    const-string v22, "id"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 437
    const-string v22, "visibility"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 438
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewGroup(Ljava/util/HashMap;)V

    .line 439
    check-cast v20, Landroid/view/ViewGroup;

    .end local v20    # "v":Landroid/view/View;
    move-object/from16 v0, p0

    move-object/from16 v1, v20

    move-object/from16 v2, p2

    move-object/from16 v3, p3

    invoke-direct {v0, v1, v2, v3}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->traverseViewHierarchy(Landroid/view/ViewGroup;Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;Ljava/lang/String;)V

    .line 440
    invoke-virtual/range {p2 .. p2}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->endElement()V

    goto/16 :goto_3

    .line 442
    .restart local v20    # "v":Landroid/view/View;
    :cond_24
    const-string v22, "name"

    invoke-virtual/range {v20 .. v20}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v23

    invoke-virtual/range {v23 .. v23}, Ljava/lang/Class;->toString()Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 443
    const-string v22, "id"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getId()I

    move-result v23

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 444
    const-string v22, "visibility"

    invoke-virtual/range {v20 .. v20}, Landroid/view/View;->getVisibility()I

    move-result v23

    move-object/from16 v0, p0

    move/from16 v1, v23

    invoke-direct {v0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->getVisibilityString(I)Ljava/lang/String;

    move-result-object v23

    move-object/from16 v0, v22

    move-object/from16 v1, v23

    invoke-virtual {v15, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 445
    move-object/from16 v0, p2

    invoke-virtual {v0, v15}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->addViewElement(Ljava/util/HashMap;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_3
.end method

.method private updateLayoutCounter(I)V
    .locals 6
    .param p1, "counter"    # I

    .prologue
    .line 138
    new-instance v1, Ljava/io/File;

    iget-object v3, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->output_dir:Ljava/io/File;

    new-instance v4, Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    invoke-virtual {v5}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v5, "_PROGRESS.txt"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v1, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 140
    .local v1, "f":Ljava/io/File;
    :try_start_0
    new-instance v2, Ljava/io/BufferedWriter;

    new-instance v3, Ljava/io/FileWriter;

    invoke-direct {v3, v1}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-direct {v2, v3}, Ljava/io/BufferedWriter;-><init>(Ljava/io/Writer;)V

    .line 141
    .local v2, "writer":Ljava/io/BufferedWriter;
    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 142
    invoke-virtual {v2}, Ljava/io/BufferedWriter;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 146
    .end local v2    # "writer":Ljava/io/BufferedWriter;
    :goto_0
    return-void

    .line 143
    :catch_0
    move-exception v0

    .line 144
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method


# virtual methods
.method public renderLayout()V
    .locals 11

    .prologue
    .line 65
    iget v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    iget-object v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    array-length v2, v2

    if-lt v1, v2, :cond_0

    .line 66
    const-string v1, "GuiRipper"

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v10, "RenderingComplete(0):"

    invoke-direct {v2, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v10, "/"

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    array-length v10, v10

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 67
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->finish()V

    .line 135
    :goto_0
    return-void

    .line 70
    :cond_0
    iget v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    invoke-direct {p0, v1}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->updateLayoutCounter(I)V

    .line 71
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    iget v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    add-int/lit8 v10, v2, 0x1

    iput v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    aget-object v1, v1, v2

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v5

    .line 72
    .local v5, "layout_id":I
    const-string v1, "GuiRipper"

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v10, "Rendering("

    invoke-direct {v2, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v10, "):"

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v10, "/"

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    array-length v10, v10

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 75
    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    .line 77
    .local v6, "startTime":J
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    invoke-virtual {v1, v5}, Landroid/app/Activity;->setContentView(I)V

    .line 79
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    const v2, 0x1020002

    invoke-virtual {v1, v2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 80
    .local v0, "cv":Landroid/view/View;
    if-nez v0, :cond_1

    .line 81
    invoke-virtual {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 130
    .end local v0    # "cv":Landroid/view/View;
    .end local v6    # "startTime":J
    :catch_0
    move-exception v8

    .line 131
    .local v8, "e":Ljava/lang/Exception;
    const-string v1, "GuiRipper"

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v10, "RenderingException("

    invoke-direct {v2, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v10, "):"

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->current_layout_counter:I

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v10, "/"

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v10, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->layout_res_ids:[Ljava/lang/Integer;

    array-length v10, v10

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 132
    invoke-virtual {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->renderLayout()V

    goto/16 :goto_0

    .line 84
    .end local v8    # "e":Ljava/lang/Exception;
    .restart local v0    # "cv":Landroid/view/View;
    .restart local v6    # "startTime":J
    :cond_1
    :try_start_1
    check-cast v0, Landroid/view/ViewGroup;

    .end local v0    # "cv":Landroid/view/View;
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/view/ViewGroup;

    .line 86
    .local v3, "viewGroup":Landroid/view/ViewGroup;
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;->activity:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v4

    .line 88
    .local v4, "package_name":Ljava/lang/String;
    invoke-virtual {v3}, Landroid/view/ViewGroup;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v9

    .line 89
    .local v9, "vto":Landroid/view/ViewTreeObserver;
    :goto_1
    invoke-virtual {v9}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 92
    new-instance v1, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;

    move-object v2, p0

    invoke-direct/range {v1 .. v7}, Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase$1;-><init>(Lcom/benandow/android/gui/layoutRendererApp/GuiRipperBase;Landroid/view/ViewGroup;Ljava/lang/String;IJ)V

    invoke-virtual {v9, v1}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    goto/16 :goto_0

    .line 90
    :cond_2
    invoke-virtual {v3}, Landroid/view/ViewGroup;->getViewTreeObserver()Landroid/view/ViewTreeObserver;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    move-result-object v9

    goto :goto_1
.end method
