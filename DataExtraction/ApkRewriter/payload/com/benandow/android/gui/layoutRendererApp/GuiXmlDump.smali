.class public Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
.super Ljava/lang/Object;
.source "GuiXmlDump.java"


# instance fields
.field private doc:Lorg/w3c/dom/Document;

.field private hierarchy:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Lorg/w3c/dom/Element;",
            ">;"
        }
    .end annotation
.end field

.field private id_counter:I

.field private root_element:Lorg/w3c/dom/Element;


# direct methods
.method private constructor <init>()V
    .locals 1

    .prologue
    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 29
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    .line 30
    const/4 v0, 0x0

    iput v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    .line 31
    return-void
.end method

.method public static createHierarchyXmlDump(Ljava/lang/String;)Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    .locals 6
    .param p0, "package_name"    # Ljava/lang/String;

    .prologue
    .line 46
    new-instance v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;

    invoke-direct {v3}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;-><init>()V

    .line 47
    .local v3, "xml":Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    invoke-static {}, Ljavax/xml/parsers/DocumentBuilderFactory;->newInstance()Ljavax/xml/parsers/DocumentBuilderFactory;

    move-result-object v1

    .line 49
    .local v1, "docFactory":Ljavax/xml/parsers/DocumentBuilderFactory;
    :try_start_0
    invoke-virtual {v1}, Ljavax/xml/parsers/DocumentBuilderFactory;->newDocumentBuilder()Ljavax/xml/parsers/DocumentBuilder;

    move-result-object v0

    .line 50
    .local v0, "docBuilder":Ljavax/xml/parsers/DocumentBuilder;
    invoke-virtual {v0}, Ljavax/xml/parsers/DocumentBuilder;->newDocument()Lorg/w3c/dom/Document;

    move-result-object v4

    iput-object v4, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    .line 51
    iget-object v4, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    const-string v5, "LayoutDump"

    invoke-interface {v4, v5}, Lorg/w3c/dom/Document;->createElement(Ljava/lang/String;)Lorg/w3c/dom/Element;

    move-result-object v4

    iput-object v4, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->root_element:Lorg/w3c/dom/Element;

    .line 52
    iget-object v4, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    iget-object v5, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->root_element:Lorg/w3c/dom/Element;

    invoke-interface {v4, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 53
    iget-object v4, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    iget-object v5, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->root_element:Lorg/w3c/dom/Element;

    invoke-interface {v4, v5}, Lorg/w3c/dom/Document;->appendChild(Lorg/w3c/dom/Node;)Lorg/w3c/dom/Node;

    .line 54
    iget-object v4, v3, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->root_element:Lorg/w3c/dom/Element;

    const-string v5, "name"

    invoke-interface {v4, v5, p0}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljavax/xml/parsers/ParserConfigurationException; {:try_start_0 .. :try_end_0} :catch_0

    .line 58
    .end local v0    # "docBuilder":Ljavax/xml/parsers/DocumentBuilder;
    .end local v3    # "xml":Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    :goto_0
    return-object v3

    .line 55
    .restart local v3    # "xml":Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;
    :catch_0
    move-exception v2

    .line 56
    .local v2, "e":Ljavax/xml/parsers/ParserConfigurationException;
    const/4 v3, 0x0

    goto :goto_0
.end method

.method private getCurrentElement()Lorg/w3c/dom/Element;
    .locals 2

    .prologue
    .line 38
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getTos()I

    move-result v0

    .line 39
    .local v0, "tos":I
    if-ltz v0, :cond_0

    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lt v0, v1, :cond_1

    .line 40
    :cond_0
    const/4 v1, 0x0

    .line 42
    :goto_0
    return-object v1

    :cond_1
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lorg/w3c/dom/Element;

    goto :goto_0
.end method

.method private getTos()I
    .locals 1

    .prologue
    .line 34
    iget-object v0, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    return v0
.end method


# virtual methods
.method public addLayout(ID)V
    .locals 4
    .param p1, "layout_id"    # I
    .param p2, "render_time"    # D

    .prologue
    .line 62
    iget-object v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    const-string v3, "LayoutHierarchy"

    invoke-interface {v2, v3}, Lorg/w3c/dom/Document;->createElement(Ljava/lang/String;)Lorg/w3c/dom/Element;

    move-result-object v0

    .line 63
    .local v0, "layout":Lorg/w3c/dom/Element;
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getCurrentElement()Lorg/w3c/dom/Element;

    move-result-object v1

    .line 64
    .local v1, "root":Lorg/w3c/dom/Element;
    if-nez v1, :cond_0

    .line 73
    :goto_0
    return-void

    .line 68
    :cond_0
    invoke-interface {v1, v0}, Lorg/w3c/dom/Element;->appendChild(Lorg/w3c/dom/Node;)Lorg/w3c/dom/Node;

    .line 69
    const-string v2, "id"

    invoke-static {p1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 70
    const-string v2, "rendertime"

    invoke-static {p2, p3}, Ljava/lang/Double;->toString(D)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 72
    iget-object v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0
.end method

.method public addViewElement(Ljava/lang/String;[ILjava/lang/String;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 5
    .param p1, "class_name"    # Ljava/lang/String;
    .param p2, "ltrb"    # [I
    .param p3, "text"    # Ljava/lang/String;
    .param p4, "hint"    # Ljava/lang/String;
    .param p5, "id"    # I
    .param p6, "superClass"    # Ljava/lang/String;
    .param p7, "visibility"    # Ljava/lang/String;
    .param p8, "inputType"    # Ljava/lang/String;
    .param p9, "textOn"    # Ljava/lang/String;
    .param p10, "textOff"    # Ljava/lang/String;

    .prologue
    .line 165
    iget-object v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    const-string v3, "View"

    invoke-interface {v2, v3}, Lorg/w3c/dom/Document;->createElement(Ljava/lang/String;)Lorg/w3c/dom/Element;

    move-result-object v1

    .line 166
    .local v1, "view":Lorg/w3c/dom/Element;
    const-string v2, "counter"

    iget v3, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    add-int/lit8 v4, v3, 0x1

    iput v4, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 167
    const-string v2, "name"

    invoke-interface {v1, v2, p1}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 168
    const-string v2, "left"

    const/4 v3, 0x0

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 169
    const-string v2, "top"

    const/4 v3, 0x1

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 170
    const-string v2, "right"

    const/4 v3, 0x2

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 171
    const-string v2, "bottom"

    const/4 v3, 0x3

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 172
    const-string v2, "id"

    invoke-static {p5}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 174
    if-eqz p8, :cond_0

    .line 175
    const-string v2, "input"

    invoke-interface {v1, v2, p8}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 179
    :cond_0
    const-string v2, "android.webkit.WebView"

    invoke-virtual {p6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_7

    .line 180
    const-string v2, "url"

    invoke-interface {v1, v2, p3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 185
    :cond_1
    :goto_0
    const-string v2, "android.webkit.WebView"

    invoke-virtual {p6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_8

    .line 186
    const-string v2, "originalUrl"

    invoke-interface {v1, v2, p3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 191
    :cond_2
    :goto_1
    if-eqz p6, :cond_3

    .line 192
    const-string v2, "superclass"

    invoke-interface {v1, v2, p6}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 194
    :cond_3
    if-eqz p7, :cond_4

    .line 195
    const-string v2, "visibility"

    invoke-interface {v1, v2, p7}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 197
    :cond_4
    if-eqz p9, :cond_5

    .line 198
    const-string v2, "textOn"

    invoke-interface {v1, v2, p9}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 200
    :cond_5
    if-eqz p10, :cond_6

    .line 201
    const-string v2, "textOff"

    invoke-interface {v1, v2, p10}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 205
    :cond_6
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getCurrentElement()Lorg/w3c/dom/Element;

    move-result-object v0

    .line 206
    .local v0, "root":Lorg/w3c/dom/Element;
    if-nez v0, :cond_9

    .line 211
    :goto_2
    return-void

    .line 181
    .end local v0    # "root":Lorg/w3c/dom/Element;
    :cond_7
    if-eqz p3, :cond_1

    .line 182
    const-string v2, "text"

    invoke-interface {v1, v2, p3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 187
    :cond_8
    if-eqz p4, :cond_2

    .line 188
    const-string v2, "hint"

    invoke-interface {v1, v2, p4}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_1

    .line 210
    .restart local v0    # "root":Lorg/w3c/dom/Element;
    :cond_9
    invoke-interface {v0, v1}, Lorg/w3c/dom/Element;->appendChild(Lorg/w3c/dom/Node;)Lorg/w3c/dom/Node;

    goto :goto_2
.end method

.method public addViewElement(Ljava/util/HashMap;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .prologue
    .line 98
    .local p1, "params":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    iget-object v4, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    const-string v5, "View"

    invoke-interface {v4, v5}, Lorg/w3c/dom/Document;->createElement(Ljava/lang/String;)Lorg/w3c/dom/Element;

    move-result-object v3

    .line 99
    .local v3, "view":Lorg/w3c/dom/Element;
    const-string v4, "counter"

    iget v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    add-int/lit8 v6, v5, 0x1

    iput v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-interface {v3, v4, v5}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 102
    invoke-virtual {p1}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_0
    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-nez v5, :cond_1

    .line 110
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getCurrentElement()Lorg/w3c/dom/Element;

    move-result-object v1

    .line 111
    .local v1, "root":Lorg/w3c/dom/Element;
    if-nez v1, :cond_2

    .line 116
    :goto_1
    return-void

    .line 102
    .end local v1    # "root":Lorg/w3c/dom/Element;
    :cond_1
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 103
    .local v0, "key":Ljava/lang/String;
    invoke-virtual {p1, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 104
    .local v2, "value":Ljava/lang/String;
    if-eqz v2, :cond_0

    .line 105
    invoke-interface {v3, v0, v2}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 115
    .end local v0    # "key":Ljava/lang/String;
    .end local v2    # "value":Ljava/lang/String;
    .restart local v1    # "root":Lorg/w3c/dom/Element;
    :cond_2
    invoke-interface {v1, v3}, Lorg/w3c/dom/Element;->appendChild(Lorg/w3c/dom/Node;)Lorg/w3c/dom/Node;

    goto :goto_1
.end method

.method public addViewGroup(Ljava/lang/String;[IILjava/lang/String;)V
    .locals 5
    .param p1, "class_name"    # Ljava/lang/String;
    .param p2, "ltrb"    # [I
    .param p3, "id"    # I
    .param p4, "visibility"    # Ljava/lang/String;

    .prologue
    .line 139
    iget-object v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    const-string v3, "ViewGroup"

    invoke-interface {v2, v3}, Lorg/w3c/dom/Document;->createElement(Ljava/lang/String;)Lorg/w3c/dom/Element;

    move-result-object v1

    .line 140
    .local v1, "vg":Lorg/w3c/dom/Element;
    const-string v2, "name"

    invoke-interface {v1, v2, p1}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 141
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getCurrentElement()Lorg/w3c/dom/Element;

    move-result-object v0

    .line 142
    .local v0, "root":Lorg/w3c/dom/Element;
    if-nez v0, :cond_0

    .line 160
    :goto_0
    return-void

    .line 146
    :cond_0
    invoke-interface {v0, v1}, Lorg/w3c/dom/Element;->appendChild(Lorg/w3c/dom/Node;)Lorg/w3c/dom/Node;

    .line 147
    const-string v2, "counter"

    iget v3, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    add-int/lit8 v4, v3, 0x1

    iput v4, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 148
    const-string v2, "left"

    const/4 v3, 0x0

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 149
    const-string v2, "top"

    const/4 v3, 0x1

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 150
    const-string v2, "right"

    const/4 v3, 0x2

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 151
    const-string v2, "bottom"

    const/4 v3, 0x3

    aget v3, p2, v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 152
    const-string v2, "id"

    invoke-static {p3}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 154
    if-eqz p4, :cond_1

    .line 155
    const-string v2, "visibility"

    invoke-interface {v1, v2, p4}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 159
    :cond_1
    iget-object v2, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0
.end method

.method public addViewGroup(Ljava/util/HashMap;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .prologue
    .line 76
    .local p1, "params":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    iget-object v4, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    const-string v5, "ViewGroup"

    invoke-interface {v4, v5}, Lorg/w3c/dom/Document;->createElement(Ljava/lang/String;)Lorg/w3c/dom/Element;

    move-result-object v3

    .line 78
    .local v3, "vg":Lorg/w3c/dom/Element;
    const-string v4, "counter"

    iget v5, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    add-int/lit8 v6, v5, 0x1

    iput v6, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->id_counter:I

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-interface {v3, v4, v5}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    .line 80
    invoke-virtual {p1}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_0
    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-nez v5, :cond_1

    .line 87
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getCurrentElement()Lorg/w3c/dom/Element;

    move-result-object v1

    .line 88
    .local v1, "root":Lorg/w3c/dom/Element;
    if-nez v1, :cond_2

    .line 95
    :goto_1
    return-void

    .line 80
    .end local v1    # "root":Lorg/w3c/dom/Element;
    :cond_1
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 81
    .local v0, "key":Ljava/lang/String;
    invoke-virtual {p1, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 82
    .local v2, "value":Ljava/lang/String;
    if-eqz v2, :cond_0

    .line 83
    invoke-interface {v3, v0, v2}, Lorg/w3c/dom/Element;->setAttribute(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 91
    .end local v0    # "key":Ljava/lang/String;
    .end local v2    # "value":Ljava/lang/String;
    .restart local v1    # "root":Lorg/w3c/dom/Element;
    :cond_2
    invoke-interface {v1, v3}, Lorg/w3c/dom/Element;->appendChild(Lorg/w3c/dom/Node;)Lorg/w3c/dom/Node;

    .line 94
    iget-object v4, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v4, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1
.end method

.method public endElement()V
    .locals 2

    .prologue
    .line 121
    invoke-direct {p0}, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->getTos()I

    move-result v0

    .line 122
    .local v0, "tos":I
    if-lez v0, :cond_0

    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_0

    .line 123
    iget-object v1, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->hierarchy:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 125
    :cond_0
    return-void
.end method

.method public writeToFile(Ljava/io/File;)V
    .locals 4
    .param p1, "output_file"    # Ljava/io/File;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljavax/xml/transform/TransformerException;
        }
    .end annotation

    .prologue
    .line 128
    new-instance v1, Ljavax/xml/transform/dom/DOMSource;

    iget-object v3, p0, Lcom/benandow/android/gui/layoutRendererApp/GuiXmlDump;->doc:Lorg/w3c/dom/Document;

    invoke-direct {v1, v3}, Ljavax/xml/transform/dom/DOMSource;-><init>(Lorg/w3c/dom/Node;)V

    .line 129
    .local v1, "source":Ljavax/xml/transform/dom/DOMSource;
    new-instance v0, Ljavax/xml/transform/stream/StreamResult;

    invoke-direct {v0, p1}, Ljavax/xml/transform/stream/StreamResult;-><init>(Ljava/io/File;)V

    .line 130
    .local v0, "result":Ljavax/xml/transform/stream/StreamResult;
    invoke-static {}, Ljavax/xml/transform/TransformerFactory;->newInstance()Ljavax/xml/transform/TransformerFactory;

    move-result-object v3

    invoke-virtual {v3}, Ljavax/xml/transform/TransformerFactory;->newTransformer()Ljavax/xml/transform/Transformer;

    move-result-object v2

    .line 131
    .local v2, "transformer":Ljavax/xml/transform/Transformer;
    invoke-virtual {v2, v1, v0}, Ljavax/xml/transform/Transformer;->transform(Ljavax/xml/transform/Source;Ljavax/xml/transform/Result;)V

    .line 132
    return-void
.end method
