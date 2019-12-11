.class public Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;
.super Ljava/lang/Object;
.source "InputTypeDecoder.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static decodeDateTimeClass(I)Ljava/lang/String;
    .locals 2
    .param p0, "itype"    # I

    .prologue
    .line 43
    and-int/lit16 v0, p0, 0xff0

    .line 44
    .local v0, "ivar":I
    sparse-switch v0, :sswitch_data_0

    .line 52
    const-string v1, "UNKNOWN"

    :goto_0
    return-object v1

    .line 46
    :sswitch_0
    const-string v1, "DATE"

    goto :goto_0

    .line 48
    :sswitch_1
    const-string v1, "NORMAL"

    goto :goto_0

    .line 50
    :sswitch_2
    const-string v1, "TIME"

    goto :goto_0

    .line 44
    nop

    :sswitch_data_0
    .sparse-switch
        0x0 -> :sswitch_1
        0x10 -> :sswitch_0
        0x20 -> :sswitch_2
    .end sparse-switch
.end method

.method public static decodeInputType(I)Ljava/lang/String;
    .locals 3
    .param p0, "itype"    # I

    .prologue
    .line 8
    and-int/lit8 v0, p0, 0xf

    .line 9
    .local v0, "iclass":I
    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    .line 10
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "NUMBER|"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeNumberClass(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 17
    :goto_0
    return-object v1

    .line 11
    :cond_0
    const/4 v1, 0x3

    if-ne v0, v1, :cond_1

    .line 12
    const-string v1, "PHONE"

    goto :goto_0

    .line 13
    :cond_1
    const/4 v1, 0x4

    if-ne v0, v1, :cond_2

    .line 14
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "DATETIME|"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeDateTimeClass(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    .line 17
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "TEXT|"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeTextClass(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0
.end method

.method private static decodeNumberClass(I)Ljava/lang/String;
    .locals 4
    .param p0, "itype"    # I

    .prologue
    .line 32
    and-int/lit16 v1, p0, 0xff0

    .line 33
    .local v1, "ivar":I
    invoke-static {p0}, Lcom/benandow/android/gui/layoutRendererApp/InputTypeDecoder;->decodeNumberFlag(I)Ljava/lang/String;

    move-result-object v0

    .line 34
    .local v0, "flag":Ljava/lang/String;
    const/16 v2, 0x10

    if-ne v1, v2, :cond_0

    .line 35
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "PASSWORD|"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 39
    :goto_0
    return-object v2

    .line 36
    :cond_0
    if-nez v1, :cond_1

    .line 37
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "NORMAL|"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    .line 39
    :cond_1
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "UNKNOWN|"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0
.end method

.method private static decodeNumberFlag(I)Ljava/lang/String;
    .locals 2
    .param p0, "itype"    # I

    .prologue
    .line 21
    const v1, 0xfff000

    and-int v0, p0, v1

    .line 22
    .local v0, "fval":I
    sparse-switch v0, :sswitch_data_0

    .line 28
    const-string v1, "UNKNOWN"

    :goto_0
    return-object v1

    .line 24
    :sswitch_0
    const-string v1, "DECIMAL"

    goto :goto_0

    .line 26
    :sswitch_1
    const-string v1, "SIGNED"

    goto :goto_0

    .line 22
    nop

    :sswitch_data_0
    .sparse-switch
        0x1000 -> :sswitch_1
        0x2000 -> :sswitch_0
    .end sparse-switch
.end method

.method private static decodeTextClass(I)Ljava/lang/String;
    .locals 2
    .param p0, "itype"    # I

    .prologue
    .line 56
    and-int/lit16 v0, p0, 0xff0

    .line 57
    .local v0, "ivar":I
    sparse-switch v0, :sswitch_data_0

    .line 89
    const-string v1, "UNKNOWN"

    :goto_0
    return-object v1

    .line 59
    :sswitch_0
    const-string v1, "EMAIL_ADDRESS"

    goto :goto_0

    .line 61
    :sswitch_1
    const-string v1, "EMAIL_SUBJECT"

    goto :goto_0

    .line 63
    :sswitch_2
    const-string v1, "FILTER"

    goto :goto_0

    .line 65
    :sswitch_3
    const-string v1, "LONG_MESSAGE"

    goto :goto_0

    .line 67
    :sswitch_4
    const-string v1, "NORMAL"

    goto :goto_0

    .line 69
    :sswitch_5
    const-string v1, "PASSWORD"

    goto :goto_0

    .line 71
    :sswitch_6
    const-string v1, "PERSON_NAME"

    goto :goto_0

    .line 73
    :sswitch_7
    const-string v1, "PHONETIC"

    goto :goto_0

    .line 75
    :sswitch_8
    const-string v1, "POSTAL_ADDRESS"

    goto :goto_0

    .line 77
    :sswitch_9
    const-string v1, "SHORT_MESSAGE"

    goto :goto_0

    .line 79
    :sswitch_a
    const-string v1, "URI"

    goto :goto_0

    .line 81
    :sswitch_b
    const-string v1, "VISIBLE_PASSWORD"

    goto :goto_0

    .line 83
    :sswitch_c
    const-string v1, "WEB_EDIT_TEXT"

    goto :goto_0

    .line 85
    :sswitch_d
    const-string v1, "WEB_EMAIL_ADDRESS"

    goto :goto_0

    .line 87
    :sswitch_e
    const-string v1, "WEB_PASSWORD"

    goto :goto_0

    .line 57
    nop

    :sswitch_data_0
    .sparse-switch
        0x0 -> :sswitch_4
        0x10 -> :sswitch_a
        0x20 -> :sswitch_0
        0x30 -> :sswitch_1
        0x40 -> :sswitch_9
        0x50 -> :sswitch_3
        0x60 -> :sswitch_6
        0x70 -> :sswitch_8
        0x80 -> :sswitch_5
        0x90 -> :sswitch_b
        0xa0 -> :sswitch_c
        0xb0 -> :sswitch_2
        0xc0 -> :sswitch_7
        0xd0 -> :sswitch_d
        0xe0 -> :sswitch_e
    .end sparse-switch
.end method
