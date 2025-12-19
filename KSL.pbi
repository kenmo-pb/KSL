; +-----+------------------------------+
; | KSL | The "Kenmo Standard Library" |
; +-----+------------------------------+

;-
CompilerIf (Not Defined(_KSL_Included, #PB_Constant))
#_KSL_Included = #True

; ---------------------
#KSL_Version = 20251216
; ---------------------

CompilerIf (#PB_Compiler_Version < 510)
  CompilerError #PB_Compiler_Filename + " requires PureBasic 5.10 or newer!" ; mainly for Bool()
CompilerEndIf

CompilerIf (#PB_Compiler_IsMainFile)
  EnableExplicit
CompilerEndIf

;- ----- Compile Switches -----

CompilerIf (Not Defined(KSL_ExcludeNetworkFunctions, #PB_Constant))
  #KSL_ExcludeNetworkFunctions = #False
CompilerEndIf

;-

;- ----- OS Info -----

CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
  Macro WindowsElse(_WindowsExpr, _ElseExpr)
    _WindowsExpr
  EndMacro
  Macro OnWindows(_Expression)
    _Expression
  EndMacro
  Macro WLMO(_WindowsExpr, _LinuxExpr, _MacExpr, _OtherExpr)
    _WindowsExpr
  EndMacro
CompilerElse
  Macro WindowsElse(_WindowsExpr, _ElseExpr)
    _ElseExpr
  EndMacro
  Macro OnWindows(_Expression)
    ;
  EndMacro
CompilerEndIf

CompilerIf (#PB_Compiler_OS = #PB_OS_Linux)
  Macro LinuxElse(_LinuxExpr, _ElseExpr)
    _LinuxExpr
  EndMacro
  Macro OnLinux(_Expression)
    _Expression
  EndMacro
  Macro WLMO(_WindowsExpr, _LinuxExpr, _MacExpr, _OtherExpr)
    _LinuxExpr
  EndMacro
CompilerElse
  Macro LinuxElse(_LinuxExpr, _ElseExpr)
    _ElseExpr
  EndMacro
  Macro OnLinux(_Expression)
    ;
  EndMacro
CompilerEndIf

CompilerIf (#PB_Compiler_OS = #PB_OS_MacOS)
  Macro MacElse(_MacExpr, _ElseExpr)
    _MacExpr
  EndMacro
  Macro OnMac(_Expression)
    _Expression
  EndMacro
  Macro WLMO(_WindowsExpr, _LinuxExpr, _MacExpr, _OtherExpr)
    _MacExpr
  EndMacro
CompilerElse
  Macro MacElse(_MacExpr, _ElseExpr)
    _ElseExpr
  EndMacro
  Macro OnMac(_Expression)
    ;
  EndMacro
CompilerEndIf

#OSName$ = WLMO("Windows", "Linux", "Mac", "Other")

#Windows = WindowsElse(#True, #False)
#Linux   = LinuxElse(#True, #False)
#Mac     = MacElse(#True, #False)

#PS   = WindowsElse('\', '/')
#PS$  = WindowsElse("\", "/")
#NPS  = WindowsElse('/', '\')
#NPS$ = WindowsElse("/", "\")
#EOL$ = WindowsElse(#CRLF$, #LF$)

;-

;- ----- PB Compatibility -----

Macro PBLT(_Version)
  (#PB_Compiler_Version < (_Version))
EndMacro
Macro PBLTE(_Version)
  (#PB_Compiler_Version <= (_Version))
EndMacro
Macro PBGT(_Version)
  (#PB_Compiler_Version > (_Version))
EndMacro
Macro PBGTE(_Version)
  (#PB_Compiler_Version >= (_Version))
EndMacro

CompilerIf (PBLT(600))
  #PB_Backend_Asm = 0
  #PB_Backend_C   = 1
  #PB_Compiler_Backend = #PB_Backend_Asm
CompilerEndIf

CompilerIf (Not Defined(PB_Compiler_64Bit, #PB_Constant))
  CompilerIf (SizeOf(INTEGER) = 8)
    #PB_Compiler_32Bit = #False
    #PB_Compiler_64Bit = #True
  CompilerElse
    #PB_Compiler_32Bit = #True
    #PB_Compiler_64Bit = #False
  CompilerEndIf
CompilerEndIf

#PB_Compiler_Examples3DData      = #PB_Compiler_Home + WindowsElse("Examples\3D\Data\", "examples/3d/Data/")
#PB_Compiler_ExamplesSourcesData = #PB_Compiler_Home + WindowsElse("Examples\Sources\Data\", "examples/sources/Data/")

CompilerIf (Not Defined(PB_MessageRequester_Info, #PB_Constant))
  #PB_MessageRequester_Info = WindowsElse(#MB_ICONINFORMATION, 0)
CompilerEndIf
CompilerIf (Not Defined(PB_MessageRequester_Warning, #PB_Constant))
  #PB_MessageRequester_Warning = WindowsElse(#MB_ICONWARNING, 0)
CompilerEndIf
CompilerIf (Not Defined(PB_MessageRequester_Error, #PB_Constant))
  #PB_MessageRequester_Error = WindowsElse(#MB_ICONERROR, 0)
CompilerEndIf

CompilerIf (PBGTE(600))
  Procedure.i _KSL_ReturnTrue()
    ProcedureReturn (#True)
  EndProcedure
CompilerEndIf

CompilerIf (PBGTE(600))
  Macro InitNetwork()
    _KSL_ReturnTrue()
  EndMacro
CompilerEndIf

CompilerIf (PBGTE(610))
  Macro InitScintilla()
    _KSL_ReturnTrue()
  EndMacro
CompilerEndIf

;-

;- ----- Build Info -----

#Debugger   = #PB_Compiler_Debugger
#ThreadSafe = #PB_Compiler_Thread

CompilerIf (#PB_Compiler_ExecutableFormat = #PB_Compiler_Console)
  #ConsoleMode = #True
CompilerElse
  #ConsoleMode = #False
CompilerEndIf

CompilerIf (#PB_Compiler_Unicode)
  #Unicode  = #True
  #Ascii    = #False
  #CharSize = 2
CompilerElse
  #Unicode  = #False
  #Ascii    = #True
  #CharSize = 1
CompilerEndIf

CompilerIf (#Unicode)
  #InternalStringFormat  = #PB_Unicode
  #DefaultIOStringFormat = #PB_UTF8
CompilerElse
  #InternalStringFormat  = #PB_Ascii
  #DefaultIOStringFormat = #PB_Ascii
CompilerEndIf

CompilerIf (#PB_Compiler_Backend = #PB_Backend_C)
  #BackendName$ = "C"
  #IsCBackend   = #True
  #IsAsmBackend = #False
CompilerElse
  #BackendName$ = "ASM"
  #IsCBackend   = #False
  #IsAsmBackend = #True
CompilerEndIf

CompilerIf (#PB_Compiler_64Bit)
  #BitString$       = "64-bit"
  #ProcessorString$ = "x64"
  #IntSize          = 8
  #Is32Bit          = #False
  #Is64Bit          = #True
CompilerElse
  #BitString$       = "32-bit"
  #ProcessorString$ = "x86"
  #IntSize          = 4
  #Is32Bit          = #True
  #Is64Bit          = #False
CompilerEndIf

CompilerIf (PBGTE(600))
  #BuildMode$ = #OSName$ + " " + #ProcessorString$ + " (" + #BackendName$ + " Backend)"
CompilerElse
  #BuildMode$ = #OSName$ + " " + #ProcessorString$
CompilerEndIf

Macro PureBasicVersionString()
  StrF(#PB_Compiler_Version * 0.01, 2)
EndMacro

Macro PureBasicBuildModeFull()
  "PureBasic " + PureBasicVersionString() + " " + #BuildMode$
EndMacro

Macro DebugProcedure()
  Debug #PB_Compiler_Procedure + "()"
EndMacro

;-

;- ----- Common Constants -----

#NO  = 0
#YES = 1

#SP  = $20
#SP$ = Chr(#SP)
#DQ  = $22
#DQ$ = Chr(#DQ)
#SQ  = $27
#SQ$ = Chr(#SQ)

CompilerIf (#Unicode)
  #EL$ = Chr($2026)
CompilerElse
  #EL$ = "..."
CompilerEndIf

#LFLF$ = #LF$ + #LF$

#NBSP  = $A0
#NBSP$ = Chr(#NBSP)

#Euro  = $20AC
#Euro$ = Chr($20AC)

#BOM   = $FEFF
#BOM$  = Chr(#BOM)
#NBOM  = $FFFE
#NBOM$ = Chr(#NBOM)

#VS15  = $FE0E
#VS15$ = Chr(#VS15) ; Text Variant
#VS16  = $FE0F
#VS16$ = Chr(#VS16) ; Emoji Variant

#ReplacementChar  = $FFFD
#ReplacementChar$ = Chr(#ReplacementChar)

#Black   = $000000
#White   = $FFFFFF
#Red     = $0000FF
#Green   = $00FF00
#Blue    = $FF0000
#Cyan    = $FFFF00
#Magenta = $FF00FF
#Yellow  = $00FFFF

;#PB_FileSize_Zero      =  0
#PB_FileSize_Missing   = -1
#PB_FileSize_Directory = -2

#CurrentDirectorySymbol = "."
#ParentDirectorySymbol  = ".."
#HomeDirectorySymbol    = "~"

#PB_Shortcut_Equal  = WindowsElse(#VK_OEM_PLUS,  '=')
#PB_Shortcut_Hyphen = WindowsElse(#VK_OEM_MINUS, '-')

;-

;- ----- Dialog Functions -----

CompilerIf (PBGTE(610))
  Macro Info(_Text, _ParentID = #Null)
    MessageRequester("Information", _Text, #PB_MessageRequester_Info, (_ParentID))
  EndMacro
  Macro InfoI(_Integer, _ParentID = #Null)
    MessageRequester("Information", Str(_Integer), #PB_MessageRequester_Info, (_ParentID))
  EndMacro
  Macro Warn(_Text, _ParentID = #Null)
    MessageRequester("Warning", _Text, #PB_MessageRequester_Warning, (_ParentID))
  EndMacro
  Macro Error(_Text, _ParentID = #Null)
    MessageRequester("Error", _Text, #PB_MessageRequester_Error, (_ParentID))
  EndMacro
  Macro PasswordRequester(_Title, _Message, _DefaultString = "", _ParentID = #Null)
    InputRequester(_Title, _Message, _DefaultString, #PB_InputRequester_Password, (_ParentID))
  EndMacro
CompilerElse
  Macro Info(_Text, _ParentID = #Null)
    MessageRequester("Information", _Text, #PB_MessageRequester_Info)
  EndMacro
  Macro InfoI(_Integer, _ParentID = #Null)
    MessageRequester("Information", Str(_Integer), #PB_MessageRequester_Info)
  EndMacro
  Macro Warn(_Text, _ParentID = #Null)
    MessageRequester("Warning", _Text, #PB_MessageRequester_Warning)
  EndMacro
  Macro Error(_Text, _ParentID = #Null)
    MessageRequester("Error", _Text, #PB_MessageRequester_Error)
  EndMacro
  Macro PasswordRequester(_Title, _Message, _DefaultString = "", _ParentID = #Null)
    InputRequester(_Title, _Message, _DefaultString, #PB_InputRequester_Password)
  EndMacro
CompilerEndIf

Procedure.i Confirm(Text.s, AllowCancel.i = #False, ParentID.i = #Null)
  Protected Result.i
  
  Protected Flags.i
  If (AllowCancel)
    Flags = #PB_MessageRequester_YesNoCancel
  Else
    Flags = #PB_MessageRequester_YesNo
  EndIf
  CompilerIf (#Windows)
    Flags | #MB_ICONQUESTION
  CompilerElse
    Flags | #PB_MessageRequester_Warning;#PB_MessageRequester_Info
  CompilerEndIf
  CompilerIf (PBGTE(610))
    Result = MessageRequester("Confirm", Text, Flags, ParentID)
  CompilerElse
    Result = MessageRequester("Confirm", Text, Flags)
  CompilerEndIf
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- Math Functions -----

#TwoPi = (2.0 * #PI)

Procedure.i _IIfI(Boolean.i, ValueIfTrue.i, ValueIfFalse.i)
  If (Boolean)
    ProcedureReturn  (ValueIfTrue)
  Else
    ProcedureReturn  (ValueIfFalse)
  EndIf
EndProcedure

Procedure.s _IIfS(Boolean.i, ValueIfTrue.s, ValueIfFalse.s)
  If (Boolean)
    ProcedureReturn  (ValueIfTrue)
  Else
    ProcedureReturn  (ValueIfFalse)
  EndIf
EndProcedure

Macro IIfI(_Expression, _IntIfTrue, _IntIfFalse)
  _IIfI(Bool(_Expression), (_IntIfTrue), (_IntIfFalse))
EndMacro

Macro IIfS(_Expression, _StringIfTrue, _StringIfFalse)
  _IIfS(Bool(_Expression), (_StringIfTrue), (_StringIfFalse))
EndMacro

Procedure.i MaxI(a.i, b.i)
  If (a > b)
    ProcedureReturn (a)
  EndIf
  ProcedureReturn (b)
EndProcedure
Procedure.i MinI(a.i, b.i)
  If (a < b)
    ProcedureReturn (a)
  EndIf
  ProcedureReturn (b)
EndProcedure

Procedure.f MaxF(a.f, b.f)
  If (a > b)
    ProcedureReturn (a)
  EndIf
  ProcedureReturn (b)
EndProcedure
Procedure.f MinF(a.f, b.f)
  If (a < b)
    ProcedureReturn (a)
  EndIf
  ProcedureReturn (b)
EndProcedure

Procedure.d MaxD(a.d, b.d)
  If (a > b)
    ProcedureReturn (a)
  EndIf
  ProcedureReturn (b)
EndProcedure
Procedure.d MinD(a.d, b.d)
  If (a < b)
    ProcedureReturn (a)
  EndIf
  ProcedureReturn (b)
EndProcedure

Procedure.i RandomBool(PercentTrue.i)
  If (Random(99, 0) < PercentTrue)
    ProcedureReturn (#True)
  EndIf
  ProcedureReturn (#False)
EndProcedure

;-

;- ----- Time Functions -----

Macro SecondsToMinutes(_Seconds)
  ((_Seconds) / 60.0)
EndMacro
Macro MinutesToSeconds(_Minutes)
  ((_Minutes) * 60)
EndMacro
Macro SecondsToMilliseconds(_Seconds)
  ((_Seconds) * 1000)
EndMacro
Macro MinutesToMilliseconds(_Minutes)
  ((_Minutes) * 60 * 1000)
EndMacro

Macro Now()
  Date()
EndMacro

Macro DateString(_Timestamp = Now())
  FormatDate("%yyyy-%mm-%dd", _Timestamp)
EndMacro
Macro TimeString(_Timestamp = Now())
  FormatDate("%hh:%ii:%ss", _Timestamp)
EndMacro
Macro TimestampString(_Timestamp = Now())
  FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", _Timestamp)
EndMacro

;-

;- ----- Image Functions -----

#JPEGQualityMinimum = 0
#JPEGQualityDefault = 7
#JPEGQualityMaximum = 10

Macro IsImageAnimated(_Image)
  (Bool(ImageFrameCount(_Image) > 1))
EndMacro

Macro UseJPEGCodecs()
  UseJPEGImageDecoder()
  UseJPEGImageEncoder()
EndMacro

Macro UsePNGCodecs()
  UsePNGImageDecoder()
  UsePNGImageEncoder()
EndMacro

Macro SaveBMP(_Image, _FileName)
  SaveImage((_Image), _FileName, #PB_ImagePlugin_BMP)
EndMacro

Macro SavePNG(_Image, _FileName)
  SaveImage((_Image), _FileName, #PB_ImagePlugin_PNG)
EndMacro

Macro SaveJPEG(_Image, _FileName, _Quality = #JPEGQualityDefault)
  SaveImage((_Image), _FileName, #PB_ImagePlugin_JPEG, _Quality)
EndMacro

Procedure.i SaveImageByExtension(Image.i, FileName.s, Quality.i = #JPEGQualityDefault)
  Protected Result.i = #False
  If (FileName)
    Select (LCase(GetExtensionPart(FileName)))
      Case "bmp"
        Result = SaveBMP(Image, FileName)
      Case "png"
        Result = SavePNG(Image, FileName)
      Case "jpg", "jpeg"
        Result = SaveJPEG(Image, FileName, Quality)
      Default
        Result = SavePNG(Image, FileName)
        If (Not Result)
          Result = SaveBMP(Image, FileName)
        EndIf
    EndSelect
  EndIf
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- List / Map Functions -----

Macro SelectRandomElement(_List)
  SelectElement(_List, Random(ListSize(_List) - 1))
EndMacro

Macro ClearAndFreeList(_List)
  ClearList(_List)
  FreeList(_List)
EndMacro

Macro ClearAndFreeMap(_Map)
  ClearMap(_Map)
  FreeMap(_Map)
EndMacro

;-

;- ----- String Functions -----

Enumeration ; Flags for the Interate procedures
  #KSL_ExcludeBlank      = $0001
  #KSL_ExcludeWhitespace = $0002
EndEnumeration

Global Dim _StrBool.s((2)-1)
_StrBool(0) = "false"
_StrBool(1) = "true"

Macro StrBool(_Expr)
  _StrBool(Bool(_Expr))
EndMacro

Macro HexLong(_Number)
  (Hex((_Number), #PB_Long))
EndMacro

Macro BytesToChars(_Bytes)
  ((_Bytes) / #CharSize)
EndMacro
Macro CharsToBytes(_Chars)
  ((_Chars) * #CharSize)
EndMacro

Macro AddString(_List, _String)
  AddElement(_List)
  _List = _String
EndMacro

Macro StartsWith(_String, _Prefix)
  (Bool(Left((_String), Len(_Prefix)) = (_Prefix)))
EndMacro
Macro EndsWith(_String, _Suffix)
  (Bool(Right((_String), Len(_Suffix)) = (_Suffix)))
EndMacro
Macro Contains(_String, _Substring)
  (Bool(FindString((_String), (_Substring)) > 0))
EndMacro

Macro Quote(_String)
  #DQ$ + _String + #DQ$
EndMacro

Macro SQuote(_String)
  #SQ$ + _String + #SQ$
EndMacro

Macro SDQuote(_String)
  ReplaceString(_String, #SQ$, #DQ$)
EndMacro
Macro SDQuoteInPlace(_String)
  ReplaceString(_String, #SQ$, #DQ$, #PB_String_InPlace)
EndMacro

Macro RemoveSpaces(_String)
  RemoveString(_String, " ")
EndMacro

Macro TextVariant(_CharStr)
  RTrim(RTrim((_CharStr), #VS15$), #VS16$) + #VS15$
EndMacro
Macro EmojiVariant(_CharStr)
  RTrim(RTrim((_CharStr), #VS15$), #VS16$) + #VS16$
EndMacro

Macro StringByteLengthN(_String, _Format = #InternalStringFormat, _NumNulls = 1)
  (StringByteLength(_String, _Format) + ((_NumNulls) * NullTerminatorSize(_Format)))
EndMacro

Procedure.i NullTerminatorSize(Format.i = #InternalStringFormat)
  Select (Format)
    Case #PB_Ascii, #PB_UTF8
      ProcedureReturn (1)
    Case #PB_Unicode, #PB_UTF16, #PB_UTF16BE
      ProcedureReturn (2)
    Case #PB_UTF32, #PB_UTF32BE
      ProcedureReturn (4)
  EndSelect
  ProcedureReturn (0)
EndProcedure

Procedure.i StringBuffer(String.s, Format.i = #InternalStringFormat, NumNulls.i = 1)
  Protected *Buffer = #Null
  
  If (Format = #PB_Default)
    Format = #InternalStringFormat
  EndIf
  Select (Format)
    Case #PB_Ascii, #PB_UTF8, #PB_Unicode
      Protected Bytes.i = StringByteLengthN(String, Format, NumNulls)
      If (Bytes > 0)
        *Buffer = AllocateMemory(Bytes)
        If (*Buffer)
          PokeS(*Buffer, String, -1, Format | #PB_String_NoZero)
        EndIf
      EndIf
  EndSelect
  
  ProcedureReturn (*Buffer)
EndProcedure

CompilerIf (Not Defined(Unicode, #PB_Function))
Procedure.i Unicode(String.s)
  ProcedureReturn (StringBuffer(String, #PB_Unicode, 1))
EndProcedure
CompilerEndIf

Procedure.s Unquote(Text.s, Character.s = "")
  If (Len(Character) = 1)
    If ((Left(Text, 1) = Character) And (Right(Text, 1) = Character))
      Text = Mid(Text, 2, Len(Text) - 2)
    EndIf
  Else
    If ((Left(Text, 1) = #DQ$) And (Right(Text, 1) = #DQ$))
      Text = Mid(Text, 2, Len(Text) - 2)
    ElseIf ((Left(Text, 1) = #SQ$) And (Right(Text, 1) = #SQ$))
      Text = Mid(Text, 2, Len(Text) - 2)
    EndIf
  EndIf
  ProcedureReturn (Text)
EndProcedure

Procedure.s QuoteIfSpaces(Text.s, QuoteEmptyString.i = #False)
  If (FindString(Text, " ") Or (QuoteEmptyString And (Text = "")))
    Text = Quote(Text)
  EndIf
  ProcedureReturn (Text)
EndProcedure

Procedure.s ChrU(Value.i)
  CompilerIf (#Unicode)
    If (Value > $FFFF)
      Protected Result.s = "  "
      Value = (Value - $10000)
      PokeU(@Result + 0, $D800 + (Value >> 10) & $03FF)
      PokeU(@Result + 2, $DC00 + (Value >>  0) & $03FF)
      ProcedureReturn (Result)
    Else
      ProcedureReturn (Chr(Value))
    EndIf
  CompilerElse
    ProcedureReturn (Chr(Value))
  CompilerEndIf
EndProcedure

Procedure.s Plural(N.i, Singular.s, Multiple.s = "")
  If (N = 1)
    ProcedureReturn (Str(N) + " " + Singular)
  Else
    If (Multiple = "")
      Multiple = Singular + "s"
    EndIf
    ProcedureReturn (Str(N) + " " + Multiple)
  EndIf
EndProcedure

Procedure.s RandomString(List StrList.s())
  Protected Result.s = ""
  PushListPosition(StrList())
  SelectRandomElement(StrList())
  Result = StrList()
  PopListPosition(StrList())
  ProcedureReturn (Result)
EndProcedure

Procedure.i FindStringOccurrence(String.s, StringToFind.s, Occurrence.i, Mode.i = #PB_String_CaseSensitive)
  Protected Result.i = 0
  Protected Found.i  = 0
  Protected i.i = 1
  While (Found < Occurrence)
    i = FindString(String, StringToFind, i, Mode)
    If (i)
      Found + 1
      If (Found = Occurrence)
        Result = i
        Break
      Else
        i + Len(StringToFind)
      EndIf
    Else
      Break
    EndIf
  Wend
  ProcedureReturn (Result)
EndProcedure

Procedure.i FindLastOccurrence(String.s, StringToFind.s, Mode.i = #PB_String_CaseSensitive)
  Protected Result.i = 0
  Protected LString.s = String
  Protected LStringToFind.s = StringToFind
  If (Mode = #PB_String_NoCase)
    LString = LCase(LString)
    LStringToFind = LCase(LStringToFind)
  EndIf
  Protected i.i = CountString(String, StringToFind)
  If (i > 0)
    Result = FindStringOccurrence(String, StringToFind, i, Mode)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s Before(String.s, Suffix.s, Occurrence.i = 1)
  Protected Result.s
  If (String And Suffix)
    Protected i.i = FindStringOccurrence(String, Suffix, Occurrence)
    If (i)
      Result = Left(String, i-1)
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s After(String.s, Prefix.s, Occurrence.i = 1)
  Protected Result.s
  If (String And Prefix)
    Protected i.i = FindStringOccurrence(String, Prefix, Occurrence)
    If (i)
      Result = Mid(String, i + Len(Prefix))
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s Between(String.s, Prefix.s, Suffix.s)
  Protected Result.s
  String = After(String, Prefix)
  Result = Before(String, Suffix)
  ProcedureReturn (Result)
EndProcedure

Procedure.s LTrimWhitespace(String.s)
  Protected *C.CHARACTER = @String
  While (#True)
    Select (*C\c)
      Case #SP, #TAB, #CR, #LF
        ; ...
      Default ; including #NUL
        ProcedureReturn (PeekS(*C))
    EndSelect
    *C + SizeOf(CHARACTER)
  Wend
  ProcedureReturn (String)
EndProcedure

Procedure.s TrimWhitespace(String.s)
  Protected *Start.CHARACTER = @String
  While (#True)
    Select (*Start\c)
      Case #SP, #TAB, #CR, #LF
        ; ...
      Default ; including #NUL
        Break
    EndSelect
    *Start + SizeOf(CHARACTER)
  Wend
  If (*Start\c <> #NUL)
    Protected *Stop.CHARACTER = *Start
    Protected *C.CHARACTER = *Start
    While (*C\c)
      Select (*C\c)
        Case #SP, #TAB, #CR, #LF
          ; ...
        Default ; including #NUL
          *Stop = *C
      EndSelect
      *C + SizeOf(CHARACTER)
    Wend
    ProcedureReturn (PeekS(*Start, BytesToChars(*Stop - *Start) + 1))
  EndIf
  ProcedureReturn ("")
EndProcedure

Procedure.s ListToString(List StrList.s(), BetweenEach.s = #LF$, BeforeEach.s = "", AfterEach.s = "")
  Protected Result.s = ""
  
  PushListPosition(StrList())
  ForEach (StrList())
    If (ListIndex(StrList()) > 0)
      Result + BetweenEach
    EndIf
    Result + BeforeEach
    Result + StrList()
    Result + AfterEach
  Next
  PopListPosition(StrList())
  
  ProcedureReturn (Result)
EndProcedure

Prototype _KSL_IterateStringCallback(String.s, UserData.i)

Procedure.i IterateStringList(List StrList.s(), *CallbackWithUserData, UserData.i = #Null, Flags.i = #PB_Default, ExcludePrefix.s = "")
  Protected Result.i = 0
  
  If (Flags = #PB_Default)
    Flags = #Null
  EndIf
  If (Flags & #KSL_ExcludeWhitespace)
    Flags | #KSL_ExcludeBlank
  EndIf
  Protected Callback._KSL_IterateStringCallback = *CallbackWithUserData
  
  PushListPosition(StrList())
  ForEach (StrList())
    If ((Not (Flags & #KSL_ExcludeBlank)) Or (StrList() <> ""))
      If ((Not (Flags & #KSL_ExcludeWhitespace)) Or (TrimWhitespace(StrList()) <> ""))
        If ((ExcludePrefix = "") Or (Left(LTrimWhitespace(StrList()), Len(ExcludePrefix)) <> ExcludePrefix))
          If (*CallbackWithUserData)
            Callback(StrList(), UserData)
          EndIf
          Result + 1
        EndIf
      EndIf
    EndIf
  Next
  PopListPosition(StrList())
  
  ProcedureReturn (Result)
EndProcedure

Procedure.i IterateStringFields(String.s, Separator.s, *CallbackWithUserData, UserData.i = #Null, Flags.i = #PB_Default, ExcludePrefix.s = "")
  Protected Result.i = 0
  
  If (Flags = #PB_Default)
    Flags = #Null
  EndIf
  If (Flags & #KSL_ExcludeWhitespace)
    Flags | #KSL_ExcludeBlank
  EndIf
  Protected Callback._KSL_IterateStringCallback = *CallbackWithUserData
  
  If (String And Separator)
    Protected N.i = 1 + CountString(String, Separator)
    Protected i.i
    For i = 1 To N
      Protected Field.s = StringField(String, i, Separator)
      If ((Not (Flags & #KSL_ExcludeBlank)) Or (Field <> ""))
        If ((Not (Flags & #KSL_ExcludeWhitespace)) Or (TrimWhitespace(Field) <> ""))
          If ((ExcludePrefix = "") Or (Left(LTrimWhitespace(Field), Len(ExcludePrefix)) <> ExcludePrefix))
            If (*CallbackWithUserData)
              Callback(Field, UserData)
            EndIf
            Result + 1
          EndIf
        EndIf
      EndIf
    Next
  EndIf
  
  ProcedureReturn (Result)
EndProcedure

Procedure.i IterateStringsFromFile(File.i, *CallbackWithUserData, UserData.i = #Null, Flags.i = #PB_Default, ExcludePrefix.s = "")
  Protected Result.i = 0
  
  If (Flags = #PB_Default)
    Flags = #Null
  EndIf
  If (Flags & #KSL_ExcludeWhitespace)
    Flags = Flags | #KSL_ExcludeBlank
  EndIf
  Protected Callback._KSL_IterateStringCallback = *CallbackWithUserData
  
  Protected SpecificFormat.i
  If (Loc(File) = 0)
    Select (ReadStringFormat(File))
      Case #PB_UTF8
        SpecificFormat = #PB_UTF8
      Case #PB_Unicode
        SpecificFormat = #PB_Unicode
      Default
        SpecificFormat = -1
    EndSelect
  EndIf
  
  Protected Line.s
  While (Not Eof(File))
    If (SpecificFormat >= 0)
      Line = ReadString(File, SpecificFormat)
    Else
      Line = ReadString(File)
    EndIf
    If ((Not (Flags & #KSL_ExcludeBlank)) Or (Line <> ""))
      If ((Not (Flags & #KSL_ExcludeWhitespace)) Or (TrimWhitespace(Line) <> ""))
        If ((ExcludePrefix = "") Or (Left(LTrimWhitespace(Line), Len(ExcludePrefix)) <> ExcludePrefix))
          If (*CallbackWithUserData)
            Callback(Line, UserData)
          EndIf
          Result + 1
        EndIf
      EndIf
    EndIf
  Wend
  
  ProcedureReturn (Result)
EndProcedure

Procedure.i IterateStringsFromFilePath(FilePath.s, *CallbackWithUserData, UserData.i = #Null, Flags.i = #PB_Default, ExcludePrefix.s = "")
  Protected Result.i = 0
  
  If (FilePath)
    Protected FN.i = ReadFile(#PB_Any, FilePath)
    If (FN)
      Result = IterateStringsFromFile(FN, *CallbackWithUserData, UserData, Flags, ExcludePrefix)
      CloseFile(FN)
    EndIf
  EndIf
  
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- Color Functions -----

#OpaqueBlack   = $FF000000
#OpaqueRed     = $FF0000FF
#OpaqueGreen   = $FF00FF00
#OpaqueBlue    = $FFFF0000
#OpaqueYellow  = $FF00FFFF
#OpaqueMagenta = $FFFF00FF
#OpaqueCyan    = $FFFFFF00
#OpaqueWhite   = $FFFFFFFF

Enumeration ; ColorFormats for the Compose procedures
  #KSL_ColorFormat_Integer = 0
  #KSL_ColorFormat_HexPB
  #KSL_ColorFormat_HexCSS
  #KSL_ColorFormat_RGBComponents
EndEnumeration

Macro Transparent(_RGB)
  ((_RGB) & $00FFFFFF)
EndMacro

Macro SetAlpha(_Color, _Alpha)
  (Transparent(_Color) | ((_Alpha) << 24))
EndMacro

Macro Opaque(_RGB)
  (SetAlpha((_RGB), $FF))
EndMacro

Procedure.i SwapRGB(Color.i)
  ProcedureReturn (RGBA(Blue(Color), Green(Color), Red(Color), Alpha(Color)))
EndProcedure

Procedure.s ComposeRGB(RGBColor.i, ColorFormat.i = #KSL_ColorFormat_HexCSS)
  Protected Result.s = ""
  
  RGBColor = RGBColor & $00FFFFFF
  Select (ColorFormat)
    Case #KSL_ColorFormat_HexPB
      Result = "$" + RSet(Hex(RGBColor, #PB_Long), 6, "0")
    Case #KSL_ColorFormat_HexCSS
      Result = "#" + RSet(Hex(SwapRGB(RGBColor), #PB_Long), 6, "0")
    Case #KSL_ColorFormat_RGBComponents
      Result = "RGB(" + Str(Red(RGBColor)) + ", " + Str(Green(RGBColor)) + ", " + Str(Blue(RGBColor)) + ")"
    Default ;Case #KSL_ColorFormat_Integer
      Result = StrU(RGBColor)
  EndSelect
  
  ProcedureReturn (Result)
EndProcedure

Procedure.s ComposeRGBA(RGBAColor.i, ColorFormat.i = #KSL_ColorFormat_HexCSS)
  Protected Result.s = ""
  
  RGBAColor = RGBAColor & $FFFFFFFF
  Select (ColorFormat)
    Case #KSL_ColorFormat_HexPB
      Result = "$" + RSet(Hex(RGBAColor, #PB_Long), 8, "0")
    Case #KSL_ColorFormat_HexCSS
      If (#True) ; move AA to the end, after #RRGGBB
        Result = "#" + RSet(Hex(SwapRGB(RGBAColor) & $00FFFFFF), 6, "0") + RSet(Hex(Alpha(RGBAColor)), 2, "0")
      Else
        Result = "#" + RSet(Hex(SwapRGB(RGBAColor), #PB_Long), 8, "0")
      EndIf
    Case #KSL_ColorFormat_RGBComponents
      Result = "RGBA(" + Str(Red(RGBAColor)) + ", " + Str(Green(RGBAColor)) + ", " + Str(Blue(RGBAColor)) + ", " + Str(Alpha(RGBAColor)) + ")"
    Default ;Case #KSL_ColorFormat_Integer
      Result = StrU(RGBAColor & $FFFFFFFF)
  EndSelect
  
  ProcedureReturn (Result)
EndProcedure

Procedure.i ParseColor(Text.s)
  Protected Result.i = 0
  
  Text = LCase(RemoveSpaces(Text))
  Select (Text)
    
    Case "black"
      Result = #Black
    Case "red"
      Result = #Red
    Case "green"
      Result = #Green
    Case "blue"
      Result = #Blue
    Case "cyan"
      Result = #Cyan
    Case "yellow"
      Result = #Yellow
    Case "magenta"
      Result = #Magenta
    Case "gray"
      Result = #Gray
    Case "white"
      Result = #White
      
    Default
      
      Protected IsHex.i      = #False
      Protected SwapOrder.i  = #False
      Protected Expand3to6.i = #False
      Protected Handled.i    = #False
      
      If (Left(Text, 1) = "$")
        Text = Mid(Text, 2)
        IsHex = #True
      ElseIf (Left(Text, 2) = "0x")
        Text = Mid(Text, 3)
        IsHex = #True
      ElseIf (Left(Text, 1) = "#")
        Text = Mid(Text, 2)
        IsHex = #True
        SwapOrder = #True
        If (Len(Text) = 3)
          Expand3to6 = #True
        ElseIf (Len(Text) = 8)
          If (#True) ; assume AA is at the end, swap #RRGGBBAA --> AARRGGBB
            Text = Mid(Text, 7, 2) + Left(Text, 6)
          EndIf
        ElseIf (Len(Text) = 4)
          Expand3to6 = #True
          If (#True) ; assume A is at the end, swap #RGBA --> ARGB
            Text = Mid(Text, 4, 1) + Left(Text, 3)
          EndIf
        EndIf
      ElseIf (FindString(Text, "rgb(") Or FindString(Text, "rgba("))
        Handled = #True
        Text = After(Text, "(")
        Text = Before(Text, ")")
        Result = RGBA(Val(StringField(Text, 1, ",")), Val(StringField(Text, 2, ",")), Val(StringField(Text, 3, ",")), Val(StringField(Text, 4, ",")))
      EndIf
      
      If (Not Handled)
        If (IsHex)
          Result = Val("$" + Text)
        Else
          Result = Val(Text)
        EndIf
        If (Expand3to6)
          Result = ((Result & $F000) << 12) | ((Result & $F00) << 8) | ((Result & $0F0) << 4) | (Result & $00F)
          Result = (Result << 4) | (Result)
        EndIf
        If (SwapOrder)
          Result = SwapRGB(Result)
        EndIf
      EndIf
      
  EndSelect
  
  Result = Result & $FFFFFFFF
  
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- Drawing Functions -----

Macro StartImageDrawing(_Image)
  StartDrawing(ImageOutput(_Image))
EndMacro
Macro StartCanvasDrawing(_Gadget)
  StartDrawing(CanvasOutput(_Gadget))
EndMacro

;-

;- ----- Path Functions -----

Macro PathExists(_Path)
  (Bool(FileSize(_Path) = #PB_FileSize_Directory))
EndMacro

Macro FileExists(_File)
  (Bool(FileSize(_File) >= 0))
EndMacro

Macro FileOrFolderExists(_Path)
  (Bool(FileSize(_Path) <> #PB_FileSize_Missing))
EndMacro

CompilerIf ((#Windows And (#True)) Or (#False))
  Macro SameFile(_File1, _File2)
    Bool(LCase(_File1) = LCase(_File2))
  EndMacro
CompilerElse
  Macro SameFile(_File1, _File2)
    Bool(_File1 = _File2)
  EndMacro
CompilerEndIf

Macro GetNamePart(_File)
  GetFilePart(_File, #PB_FileSystem_NoExtension)
EndMacro

Macro RemoveExtensionPart(_File)
  SetExtensionPart((_File), "")
EndMacro

Procedure.i DeleteFolder(Folder.s, Force.i = #True)
  Protected Result.i = #False
  If (Folder)
    DeleteDirectory(Folder, "", #PB_FileSystem_Recursive | (Bool(Force) * #PB_FileSystem_Force))
    Result = Bool(FileSize(Folder) = #PB_FileSize_Missing)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i DeleteFileOrFolder(Path.s, Force.i = #True)
  Protected Result.i = #False
  If (Path)
    Select (FileSize(Path))
      Case #PB_FileSize_Missing
        Result = #True
      Case #PB_FileSize_Directory
        DeleteDirectory(Path, "", #PB_FileSystem_Recursive | (Bool(Force) * #PB_FileSystem_Force))
        Result = Bool(FileSize(Path) = #PB_FileSize_Missing)
      Default
        DeleteFile(Path, Bool(Force) * #PB_FileSystem_Force)
        Result = Bool(FileSize(Path) = #PB_FileSize_Missing)
    EndSelect
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s AppendFileName(File.s, Suffix.s)
  Protected Result.s = ""
  If (File And Suffix)
    Protected Ext.s = GetExtensionPart(File)
    If (Ext)
      Result = Left(File, Len(File) - (1 + Len(Ext))) + Suffix + "." + Ext
    Else
      Result = File + Suffix
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s SetExtensionPart(File.s, NewExtension.s)
  Protected Result.s = ""
  If (File)
    Result = GetPathPart(File)
    File = GetFilePart(File)
    If (GetExtensionPart(File) = "")
      If (NewExtension)
        File + "." + NewExtension
      EndIf
    Else
      File = GetFilePart(File, #PB_FileSystem_NoExtension)
      If (NewExtension)
        File + "." + NewExtension
      EndIf
    EndIf
    Result + File
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s NormalizePathSeparators(Path.s, SeparatorToUse.s = #PS$)
  Select (SeparatorToUse)
    Case "/"
      ReplaceString(Path, "\", "/", #PB_String_InPlace)
    Case "\"
      ReplaceString(Path, "/", "\", #PB_String_InPlace)
    Case ""
      ReplaceString(Path, #NPS$, #PS$, #PB_String_InPlace)
    Default
      CompilerIf (#Windows Or (#True))
        ReplaceString(Path, "\", SeparatorToUse, #PB_String_InPlace)
      CompilerEndIf
      ReplaceString(Path, "/", SeparatorToUse, #PB_String_InPlace)
  EndSelect
  ProcedureReturn (Path)
EndProcedure

Procedure.s EnsurePathSeparator(Path.s)
  If (Path)
    CompilerIf (#Windows Or (#False))
      If (Not (EndsWith(Path, #PS$) Or EndsWith(Path, #NPS$)))
        Path + #PS$
      EndIf
    CompilerElse
      If (Not EndsWith(Path, #PS$))
        Path + #PS$
      EndIf
    CompilerEndIf
  EndIf
  ProcedureReturn (Path)
EndProcedure

Procedure.s RemovePathSeparator(Path.s)
  If (Path)
    CompilerIf (#Windows Or (#False))
      While (EndsWith(Path, #PS$) Or EndsWith(Path, #NPS$))
        Path = RTrim(Path, #PS$)
        Path = RTrim(Path, #NPS$)
      Wend
    CompilerElse
      Path = RTrim(Path, #PS$)
    CompilerEndIf
  EndIf
  ProcedureReturn (Path)
EndProcedure

Procedure.i IsAbsolutePath(Path.s)
  Protected Result.i = #False
  If (Path)
    CompilerIf (#Windows)
      If (FindString(Path, ":"))
        Result = #True
      EndIf
    CompilerElse
      If (Left(Path, 1) = "/")
        Result = #True
      ElseIf (Left(Path, 1) = #HomeDirectorySymbol)
        Result = #True
      EndIf
    CompilerEndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s EnsureAbsolutePath(Path.s, RootDir.s = "")
  If (Not IsAbsolutePath(Path))
    If (RootDir = "")
      RootDir = GetCurrentDirectory()
    Else
      RootDir = EnsurePathSeparator(RootDir)
    EndIf
    CompilerIf (#Windows)
      Path = LTrim(Path, #PS$)
      Path = LTrim(Path, #NPS$)
    CompilerEndIf
    Path = RootDir + Path
  EndIf
  ProcedureReturn (Path)
EndProcedure

Procedure.s GetTopDirectoryName(Directory.s)
  ProcedureReturn (GetFilePart(RemovePathSeparator(Directory)))
EndProcedure

Procedure.s GetParentDirectory(Directory.s)
  ProcedureReturn (GetPathPart(RemovePathSeparator(Directory)))
EndProcedure

Procedure.s NormalizePath(Path.s, ExpandCurrentDirectory.i = #False)
  Protected Result.s = ""
  
  If ((Path = "") And (ExpandCurrentDirectory) And (#False))
    Path = #CurrentDirectorySymbol
  EndIf
  
  If (Path)
    Path = NormalizePathSeparators(Path, #PS$)
    Protected IsAbsolute.i = IsAbsolutePath(Path)
    Protected File.s = GetFilePart(Path)
    Path = GetPathPart(Path)
    If (File = #CurrentDirectorySymbol)
      If (ExpandCurrentDirectory)
        File = GetCurrentDirectory()
      Else
        File = ""
      EndIf
    ElseIf (File = #ParentDirectorySymbol)
      File = ""
      Path + #ParentDirectorySymbol + #PS$
    EndIf
    If (Path)
      Protected ExtraParents.i = 0
      Protected N.i = 1 + CountString(Path, #PS$)
      Protected i.i
      For i = 1 To N
        Protected Term.s = StringField(Path, i, #PS$)
        If (Term <> "")
          If (Term = #CurrentDirectorySymbol)
            If ((Result = "") And (ExpandCurrentDirectory))
              Result = GetCurrentDirectory()
            Else
              ; ignore
            EndIf
          ElseIf (Term = #ParentDirectorySymbol)
            If (IsAbsolute)
              Result = GetParentDirectory(Result)
              If (Result = "")
                Result = ""
                File = ""
                ExtraParents = 0
                Break
              Else
                ; OK
              EndIf
            Else
              If (Result)
                Result = GetParentDirectory(Result)
              Else
                ExtraParents + 1
              EndIf
            EndIf
          ElseIf ((Term = #HomeDirectorySymbol) And (Result = "") And (Not #Windows))
            Result = GetHomeDirectory()
          Else
            Result + Term + #PS$
          EndIf
        Else
          If (i = 1)
            Result + #PS$
          Else
            ; ignore
          EndIf
        EndIf
      Next i
      While (ExtraParents > 0)
        Result = #ParentDirectorySymbol + #PS$ + Result
        ExtraParents - 1
      Wend
    EndIf
    Result + File
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s MakeRelativePath(Path.s, RootDir.s)
  Protected Result.s = ""
  If (Path And RootDir)
    Protected IsAbsolute.i = #False
    If (IsAbsolutePath(Path) And IsAbsolutePath(RootDir))
      IsAbsolute = #True
    EndIf
    Path    = NormalizePath(Path)
    RootDir = EnsurePathSeparator(NormalizePath(RootDir))
    If (Path And RootDir)
      If (Path = RootDir)
        ; exact match - result is empty string
      Else
        Protected Prefix.s = ""
        While (#True)
          If (SameFile(Left(Path, Len(RootDir)), RootDir))
            Result = Mid(Path, 1 + Len(RootDir))
            Break
          Else
            RootDir = GetParentDirectory(RootDir)
            If (IsAbsolute And (RootDir = ""))
              Result = ""
              Prefix = ""
              Break
            Else
              Prefix + #ParentDirectorySymbol + #PS$
            EndIf
          EndIf
        Wend
        Result = Prefix + Result
      EndIf
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s GetProgramDirectory()
  ProcedureReturn (GetPathPart(ProgramFilename()))
EndProcedure

Procedure.s GetDesktopDirectory()
  ProcedureReturn (GetUserDirectory(#PB_Directory_Desktop))
EndProcedure

Procedure.s GetDocumentsDirectory()
  ProcedureReturn (GetUserDirectory(#PB_Directory_Documents))
EndProcedure

Procedure.s GetDownloadsDirectory()
  ProcedureReturn (GetUserDirectory(#PB_Directory_Downloads))
EndProcedure

Procedure.s GetMusicDirectory()
  ProcedureReturn (GetUserDirectory(#PB_Directory_Musics))
EndProcedure

Procedure.s GetVideosDirectory()
  ProcedureReturn (GetUserDirectory(#PB_Directory_Videos))
EndProcedure

Procedure.s GetPicturesDirectory()
  ProcedureReturn (GetUserDirectory(#PB_Directory_Pictures))
EndProcedure

Procedure.i CreateDirectoryRecursive(Path.s)
  Protected Result.i = #False
  If (Path)
    If (FileSize(Path) = -1)
      Path = EnsurePathSeparator(NormalizePath(Path))
      If (CreateDirectoryRecursive(GetParentDirectory(Path)))
        CreateDirectory(Path)
      EndIf
    EndIf
    Result = Bool(FileSize(Path) = -2)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s FindFirstFile(Pattern.s, Directory.s = "")
  Protected Result.s = ""
  If (Directory = "")
    Directory = GetCurrentDirectory()
  EndIf
  Protected DN.i = ExamineDirectory(#PB_Any, Directory, Pattern)
  If (DN)
    While (NextDirectoryEntry(DN))
      If (DirectoryEntryType(DN) = #PB_DirectoryEntry_File)
        Result = DirectoryEntryName(DN)
        Break
      EndIf
    Wend
    FinishDirectory(DN)
  EndIf
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- File/Folder Functions -----

Macro GetCreatedDate(_File)
  GetFileDate((_File), #PB_Date_Created)
EndMacro
Macro GetModifiedDate(_File)
  GetFileDate((_File), #PB_Date_Modified)
EndMacro

Macro WriteProgramEOF(_Program)
  WriteProgramData(_Program, #PB_Program_Eof, 0)
EndMacro

CompilerIf (#Windows)
  Macro LaunchFile(_File)
    RunProgram(_File)
  EndMacro
  Macro LaunchFolder(_Folder)
    RunProgram(_Folder)
  EndMacro
CompilerElse
  Macro LaunchFile(_File)
    RunProgram("open", Quote(_File), GetPathPart(_File))
  EndMacro
  Macro LaunchFolder(_Folder)
    RunProgram("open", Quote(_Folder), _Folder)
  EndMacro
CompilerEndIf

Procedure ShowInExplorer(FileOrFolder.s)
  If (FileExists(FileOrFolder))
    CompilerIf (#Windows)
      RunProgram("explorer.exe", "/SELECT," + Quote(FileOrFolder), "")
    CompilerElse
      LaunchFolder(GetPathPart(FileOrFolder))
    CompilerEndIf
    
  ElseIf (PathExists(FileOrFolder))
    CompilerIf (#Windows)
      If (#False)
        RunProgram("explorer.exe", "/SELECT," + Quote(FileOrFolder), "")
      Else
        LaunchFolder(FileOrFolder)
      EndIf
    CompilerElse
      LaunchFolder(FileOrFolder)
    CompilerEndIf
  EndIf
EndProcedure

Procedure.s ReadFileToString(File.s, FileFormat.i = #PB_Default)
  Protected Result.s = ""
  Protected FN.i = ReadFile(#PB_Any, File)
  If (FN)
    Protected ReadFormat.i = 0
    If (FileFormat <> #PB_Ascii)
      ReadFormat = ReadStringFormat(FN)
    EndIf
    If (FileFormat = #PB_Default)
      If (ReadFormat = #PB_Ascii) ; no BOM was detected
        ReadFormat = #DefaultIOStringFormat
      EndIf
    Else
      ReadFormat = FileFormat ; use specified
    EndIf
    Select (ReadFormat)
      Case #PB_Ascii, #PB_UTF8, #PB_Unicode
        Result = ReadString(FN, ReadFormat | #PB_File_IgnoreEOL)
    EndSelect
    CloseFile(FN)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i CreateFileFromString(File.s, String.s, Format.i = #PB_Default, WriteBOM.i = #PB_Default)
  Protected Result.i = #False
  If (Format = #PB_Default)
    Format = #DefaultIOStringFormat
  EndIf
  If (WriteBOM = #PB_Default)
    WriteBOM = Bool(Format = #PB_Unicode)
  EndIf
  Select (Format)
    Case #PB_Ascii, #PB_UTF8, #PB_Unicode
      Protected FN.i = CreateFile(#PB_Any, File)
      If (FN)
        If (WriteBOM)
          WriteStringFormat(FN, Format)
        EndIf
        WriteString(FN, String, Format)
        CloseFile(FN)
        Result = #True
      EndIf
  EndSelect
  ProcedureReturn (Result)
EndProcedure

Procedure.i ReadFileInteger(File.s)
  Protected Result.i = 0
  Protected FN.i = ReadFile(#PB_Any, File)
  If (FN)
    ReadStringFormat(FN)
    Result = Val(ReadString(FN))
    CloseFile(FN)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i WriteFileInteger(File.s, Value.i)
  Protected Result.i = #False
  Protected FN.i = CreateFile(#PB_Any, File)
  If (FN)
    WriteStringN(FN, Str(Value))
    CloseFile(FN)
    Result = #True
  EndIf
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- Gadget Functions -----

Macro MoveGadget(_Gadget, _x, _y)
  ResizeGadget((_Gadget), (_x), (_y), #PB_Ignore, #PB_Ignore)
EndMacro
Macro SetGadgetSize(_Gadget, _Width, _Height)
  ResizeGadget((_Gadget), #PB_Ignore, #PB_Ignore, (_Width), (_Height))
EndMacro
Macro GadgetExtentX(_Gadget)
  (GadgetX(_Gadget) + GadgetWidth(_Gadget))
EndMacro
Macro GadgetExtentY(_Gadget)
  (GadgetY(_Gadget) + GadgetHeight(_Gadget))
EndMacro

Macro GadgetRequiredWidth(_Gadget)
  (GadgetWidth((_Gadget), #PB_Gadget_RequiredSize))
EndMacro
Macro GadgetRequiredHeight(_Gadget)
  (GadgetHeight((_Gadget), #PB_Gadget_RequiredSize))
EndMacro
Macro FitGadgetWidth(_Gadget)
  ResizeGadget((_Gadget), #PB_Ignore, #PB_Ignore, GadgetRequiredWidth(_Gadget), #PB_Ignore)
EndMacro
Macro FitGadgetHeight(_Gadget)
  ResizeGadget((_Gadget), #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetRequiredHeight(_Gadget))
EndMacro
Macro FitGadgetSize(_Gadget)
  SetGadgetSize((_Gadget), GadgetRequiredWidth(_Gadget), GadgetRequiredHeight(_Gadget))
EndMacro

Macro GetCanvasKey(_CanvasGadget)
  (GetGadgetAttribute((_CanvasGadget), #PB_Canvas_Key))
EndMacro
Macro GetCanvasModifiers(_CanvasGadget)
  (GetGadgetAttribute((_CanvasGadget), #PB_Canvas_Modifiers))
EndMacro
Macro GetCanvasMouseX(_CanvasGadget)
  (GetGadgetAttribute((_CanvasGadget), #PB_Canvas_MouseX))
EndMacro
Macro GetCanvasMouseY(_CanvasGadget)
  (GetGadgetAttribute((_CanvasGadget), #PB_Canvas_MouseY))
EndMacro
Macro GetCanvasWheelDelta(_CanvasGadget)
  (GetGadgetAttribute((_CanvasGadget), #PB_Canvas_WheelDelta))
EndMacro

Macro SetCanvasCursor(_CanvasGadget, _Cursor)
  SetGadgetAttribute((_CanvasGadget), #PB_Canvas_Cursor, (_Cursor))
EndMacro

Macro GetPanelWidth(_PanelGadget)
  (GetGadgetAttribute(((_PanelGadget), #PB_Panel_ItemWidth)))
EndMacro
Macro GetPanelHeight(_PanelGadget)
  (GetGadgetAttribute(((_PanelGadget), #PB_Panel_ItemHeight)))
EndMacro

Procedure SelectGadget(Gadget.i)
  CompilerIf (#Windows)
    SendMessage_(GadgetID(Gadget), #EM_SETSEL, 0, -1)
  CompilerEndIf
  SetActiveGadget(Gadget)
EndProcedure

;-

;- ----- Window/Desktop Functions -----

CompilerIf (#True)
  #PB_Window_AllSizeGadgets = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget
CompilerEndIf
CompilerIf (#False)
  #PB_Window_Hidden = #PB_Window_Invisible
CompilerEndIf

Macro StandardWindowFlags(_Resizeable = #False, _Invisible = #False)
  (#PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | (Bool(_Resizeable) * #PB_Window_AllSizeGadgets) | (Bool(_Invisible) * #PB_Window_Invisible))
EndMacro

Macro MoveWindow(_Window, _x, _y)
  ResizeWindow((_Window), (_x), (_y), #PB_Ignore, #PB_Ignore)
EndMacro
Macro SetWindowSize(_Window, _Width, _Height)
  ResizeWindow((_Window), #PB_Ignore, #PB_Ignore, (_Width), (_Height))
EndMacro

Macro ShowWindow(_Window)
  HideWindow((_Window), #False)
EndMacro

Macro WaitCloseWindow(_Window = #PB_Any)
  Repeat
  Until ((WaitWindowEvent() = #PB_Event_CloseWindow) And (((_Window) = #PB_Any) Or (EventWindow() = (_Window))))
EndMacro

Procedure.i CountDesktops()
  ProcedureReturn (ExamineDesktops())
EndProcedure
Procedure.i IsDesktop(i.i)
  ProcedureReturn (Bool((i >= 0) And (i < CountDesktops())))
EndProcedure

Procedure.i DesktopExtentX(i.i)
  ProcedureReturn (DesktopX(i) + DesktopWidth(i))
EndProcedure
Procedure.i DesktopExtentY(i.i)
  ProcedureReturn (DesktopY(i) + DesktopHeight(i))
EndProcedure

Procedure.i DesktopToGlobalX(dx.i, Desktop.i)
  ProcedureReturn (dx + DesktopX(Desktop))
EndProcedure
Procedure.i DesktopToGlobalY(dy.i, Desktop.i)
  ProcedureReturn (dy + DesktopY(Desktop))
EndProcedure
Procedure.i GlobalToDesktopX(gx.i, Desktop.i)
  ProcedureReturn (gx - DesktopX(Desktop))
EndProcedure
Procedure.i GlobalToDesktopY(gy.i, Desktop.i)
  ProcedureReturn (gy - DesktopY(Desktop))
EndProcedure

Procedure.i FindExactDesktop(ID.i = -1, Width.i = 0, Height.i = 0, Depth.i = 0, Frequency.i = 0)
  Protected Result.i = -1
  Protected N.i = CountDesktops()
  Protected i.i
  For i = 0 To N - 1
    Protected Match.i = #True
    If (Match And (ID >= 0))
      If (i <> ID)
        Match = #False
      EndIf
    EndIf
    If (Match And (Width > 0))
      If (DesktopWidth(i) <> Width)
        Match = #False
      EndIf
    EndIf
    If (Match And (Height > 0))
      If (DesktopHeight(i) <> Height)
        Match = #False
      EndIf
    EndIf
    If (Match And (Depth > 0))
      If (DesktopDepth(i) <> Depth)
        Match = #False
      EndIf
    EndIf
    If (Match And (Frequency > 0))
      If (DesktopFrequency(i) <> Frequency)
        Match = #False
      EndIf
    EndIf
    If (Match)
      Result = i
      Break
    EndIf
  Next i
  ProcedureReturn (Result)
EndProcedure

Procedure.i FindClosestDesktop(ID.i = -1, Width.i = 0, Height.i = 0, Depth.i = 0, Frequency.i = 0)
  Protected Result.i = -1
  If (CountDesktops() > 1)
    Result = FindExactDesktop(ID, Width, Height, Depth, Frequency)
    If (Result < 0)
      Result = FindExactDesktop(-1, Width, Height, Depth, Frequency)
    EndIf
    If (Result < 0)
      Result = FindExactDesktop(-1, Width, Height, Depth, 0)
    EndIf
    If (Result < 0)
      Result = FindExactDesktop(-1, Width, Height, 0, 0)
    EndIf
    ;If (Result < 0)
    ;  Result = FindClosestDesktopFromResolution(Width, Height)
    ;EndIf
    If (Result < 0)
      Result = 0
    EndIf
  Else
    Result = 0
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i FindClosestDesktopFromIDString(IDString.s)
  Protected Term.s
  IDString = LCase(IDString)
  
  Protected ID.i = -1
  If (FindString(IDString, ":"))
    Term = Before(IDString, ":")
    If (Term)
      ID = Val(Term)
    EndIf
    IDString = After(IDString, ":")
  EndIf
  
  Protected Frequency.i = 0
  If (FindString(IDString, "@"))
    Term = After(IDString, "@")
    If (Term)
      Frequency = Val(Term)
    EndIf
    IDString = Before(IDString, "@")
  EndIf
  
  Protected Width.i = 0
  Protected Height.i = 0
  Protected Depth.i = 0
  If (CountString(IDString, "x") = 2)
    Width  = Val(StringField(IDString, 1, "x"))
    Height = Val(StringField(IDString, 2, "x"))
    Depth  = Val(StringField(IDString, 3, "x"))
  ElseIf (CountString(IDString, "x") = 1)
    Width  = Val(StringField(IDString, 1, "x"))
    Height = Val(StringField(IDString, 2, "x"))
  EndIf
  
  ProcedureReturn (FindClosestDesktop(ID, Width, Height, Depth, Frequency))
EndProcedure

Procedure.s DesktopIDString(i.i)
  Protected Result.s = ""
  If (IsDesktop(i))
    If (#True)
      Result + Str(i) + ":"
    EndIf
    Result + Str(DesktopWidth(i)) + "x" + Str(DesktopHeight(i))
    If (#True)
      Result + "x" + Str(DesktopDepth(i))
    EndIf
    If (#True)
      Result + "@" + Str(DesktopFrequency(i))
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i IsMinimized(Window.i)
  ProcedureReturn (Bool(GetWindowState(Window) = #PB_Window_Minimize))
EndProcedure
Procedure.i IsMaximized(Window.i)
  ProcedureReturn (Bool(GetWindowState(Window) = #PB_Window_Maximize))
EndProcedure

Procedure.i WindowCenterX(Window.i)
  ProcedureReturn (WindowX(Window) + WindowWidth(Window)/2)
EndProcedure
Procedure.i WindowCenterY(Window.i, PercentDown.f = 0.50)
  ProcedureReturn (WindowY(Window) + WindowHeight(Window) * PercentDown)
EndProcedure
Procedure GetWindowCenterXY(Window.i, *CX.INTEGER, *CY.INTEGER, YPercentDown.f = 0.50)
  If (*CX)
    *CX\i = WindowCenterX(Window)
  EndIf
  If (*CY)
    *CY\i = WindowCenterY(Window, YPercentDown)
  EndIf
EndProcedure

Procedure.i DesktopFromPoint(x.i, y.i)
  Protected Result.i = -1
  Protected N.i = CountDesktops()
  If (N > 0)
    Protected i.i
    For i = 0 To (N - 1)
      If (x >= DesktopX(i))
        If (x < DesktopExtentX(i))
          If (y >= DesktopY(i))
            If (y < DesktopExtentY(i))
              Result = i
              Break
            EndIf
          EndIf
        EndIf
      EndIf
    Next i
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i DesktopFromWindowTopLeft(Window.i)
  ProcedureReturn (DesktopFromPoint(WindowX(Window), WindowY(Window)))
EndProcedure

Procedure.i DesktopFromWindowCenter(Window.i, YPercentDown.f = 0.50)
  ProcedureReturn (DesktopFromPoint(WindowCenterX(Window), WindowCenterY(Window, YPercentDown)))
EndProcedure

Procedure.i DesktopFromWindow(Window.i)
  Protected Result.i = DesktopFromWindowCenter(Window)
  If (Result < 0)
    Result = DesktopFromWindowTopLeft(Window)
  EndIf
  If (Result < 0)
    Result = 0
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure CenterWindowInDesktop(Window.i, Desktop.i, YPercentDown.f = 0.50)
  ExamineDesktops()
  MoveWindow(Window, DesktopX(Desktop) + (DesktopWidth(Desktop) - WindowWidth(Window))/2, DesktopY(Desktop) + (DesktopHeight(Desktop) - WindowHeight(Window)) * YPercentDown)
EndProcedure

Procedure CenterWindowInWindow(ChildWindow.i, ParentWindow.i, YPercentDown.f = 0.50)
  MoveWindow(ChildWindow, WindowX(ParentWindow) + (WindowWidth(ParentWindow) - WindowWidth(ChildWindow))/2, WindowY(ParentWindow) + (WindowHeight(ParentWindow) - WindowHeight(ChildWindow)) * YPercentDown)
EndProcedure

Procedure.i SameDesktop(Window1.i, Window2.i)
  ProcedureReturn (Bool(DesktopFromWindow(Window1) = DesktopFromWindow(Window2)))
EndProcedure

Procedure EnsureSameDesktop(ChildWindow.i, ParentWindow.i)
  If (Not SameDesktop(ChildWindow, ParentWindow))
    CenterWindowInWindow(ChildWindow, ParentWindow)
  EndIf
EndProcedure

;-

;- ----- Preference Functions -----

Procedure WritePreferenceBool(Key.s, Value.i)
  WritePreferenceInteger(Key, Bool(Value))
EndProcedure

Procedure.i ReadPreferenceBool(Key.s, DefaultValue.i)
  Protected Result.i
  Select (LCase(Trim(ReadPreferenceString(Key, ""))))
    Case "1", "t", "true", "y", "yes", "on", "en", "enable", "enabled"
      Result = #True
    Case "0", "f", "false", "n", "no", "off", "dis", "disable", "disabled"
      Result = #False
    Default
      Result = DefaultValue
  EndSelect
  ProcedureReturn (Result)
EndProcedure

Procedure WritePreferenceRGB(Key.s, Color.i, ColorFormat.i = #KSL_ColorFormat_Integer)
  WritePreferenceString(Key, ComposeRGB(Color, ColorFormat))
EndProcedure

Procedure WritePreferenceRGBA(Key.s, Color.i, ColorFormat.i = #KSL_ColorFormat_Integer)
  WritePreferenceString(Key, ComposeRGBA(Color, ColorFormat))
EndProcedure

Procedure.i ReadPreferenceRGBA(Key.s, DefaultValue.i)
  Protected Result.i
  Protected Text.s = LCase(Trim(ReadPreferenceString(Key, "")))
  Select (Text)
    Case ""
      Result = DefaultValue
    Default
      Result = ParseColor(Text) & $FFFFFFFF
  EndSelect
  ProcedureReturn (Result)
EndProcedure

Procedure.i ReadPreferenceRGB(Key.s, DefaultValue.i)
  Protected Result.i
  Protected Text.s = LCase(Trim(ReadPreferenceString(Key, "")))
  Select (Text)
    Case ""
      Result = DefaultValue
    Default
      Result = ParseColor(Text) & $00FFFFFF
  EndSelect
  ProcedureReturn (Result)
EndProcedure

;-

;- ----- Network Functions -----

Procedure LaunchURL(URL.s)
  If (URL)
    If (Not FindString(URL, "://"))
      URL = "http://" + URL
    EndIf
    CompilerIf (#Windows)
      RunProgram(URL)
    CompilerElse
      RunProgram("open", Quote(URL), "")
    CompilerEndIf
  EndIf
EndProcedure

CompilerIf (Not #KSL_ExcludeNetworkFunctions)

Procedure.s ReceiveHTTPString(URL.s, Flags.i = #Null)
  Protected Result.s = ""
  
  Flags = Flags & (~#PB_HTTP_Asynchronous) ; (don't allow here)
  Protected *Buffer = ReceiveHTTPMemory(URL, Flags)
  If (*Buffer)
    Result = PeekS(*Buffer, MemorySize(*Buffer), #PB_UTF8 | #PB_ByteLength)
    FreeMemory(*Buffer)
  EndIf
  
  ProcedureReturn (Result)
EndProcedure

Procedure.i InitNetworkTimeout(TimeoutMS.i = MinutesToMilliseconds(3))
  CompilerIf (PBGTE(600))
    ProcedureReturn (#True)
  CompilerElse
    Protected Result.i = InitNetwork()
    
    If (Not Result)
      Protected StartTime.i = ElapsedMilliseconds()
      While (ElapsedMilliseconds() - StartTime <= TimeoutMS)
        Delay(SecondsToMilliseconds(1))
        If (InitNetwork())
          Result = #True
          Break
        EndIf
      Wend
    EndIf
    
    ProcedureReturn (Result)
  CompilerEndIf
EndProcedure

CompilerIf (Not Defined(_KSL_NetworkVerifyURL, #PB_Constant))
  #_KSL_NetworkVerifyURL = "http://captive.apple.com"
CompilerEndIf
CompilerIf (Not Defined(_KSL_NetworkVerifyContains, #PB_Constant))
  #_KSL_NetworkVerifyContains = "Success"
CompilerEndIf

Procedure.i InitNetworkVerify(TimeoutMS.i = MinutesToMilliseconds(3))
  Protected Result.i = #False
  
  Protected StartTime.i = ElapsedMilliseconds()
  If (InitNetworkTimeout(TimeoutMS))
    Repeat ; try at least once...
      If (Contains(ReceiveHTTPString(#_KSL_NetworkVerifyURL, #PB_HTTP_NoRedirect), #_KSL_NetworkVerifyContains))
        Result = #True
      Else
        Delay(SecondsToMilliseconds(5))
      EndIf
    Until (ElapsedMilliseconds() - StartTime > TimeoutMS)
  EndIf
  
  ProcedureReturn (Result)
EndProcedure

CompilerEndIf

;-

;- ----- OS-Specific -----


;-
;- - Windows
CompilerIf (#Windows)

; "Best practice is that all applications call the process-wide SetErrorMode function with a parameter of
; SEM_FAILCRITICALERRORS at startup. This is to prevent error mode dialogs from hanging the application."
;   https://learn.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-seterrormode
SetErrorMode_(#SEM_FAILCRITICALERRORS)

CompilerIf (Not Defined(COMBOBOXINFO, #PB_Structure))
Structure COMBOBOXINFO
  cbSize.l
  rcItem.RECT
  rcButton.RECT
  stateButton.l
  hwndCombo.i
  hwndEdit.i
  hwndList.i
EndStructure
CompilerEndIf

Procedure.i _StringGadgetWithCtrlBackspaceEntire(hWnd.i, uMsg.i, wParam.i, lParam.i)
  If ((uMsg = #WM_CHAR) And (wParam = #DEL))
    ProcedureReturn (SendMessage_(hWnd, #WM_SETTEXT, #Null, #Null$))
  Else
    ProcedureReturn (CallFunctionFast(GetWindowLongPtr_(hWnd, #GWLP_USERDATA), hWnd, uMsg, wParam, lParam))
  EndIf
EndProcedure

Procedure.i _StringGadgetWithCtrlBackspace(hWnd.i, uMsg.i, wParam.i, lParam.i)
  If ((uMsg = #WM_CHAR) And (wParam = #DEL))
    Protected N.i = SendMessage_(hWnd, #WM_GETTEXTLENGTH, 0, 0)
    If (N > 0)
      Protected Text.s = Space(N)
      SendMessage_(hWnd, #WM_GETTEXT, N + 1, @Text)
      Protected StartPos.i, EndPos.i
      SendMessage_(hWnd, #EM_GETSEL, @StartPos, @EndPos)
      If ((StartPos >= 1) And (StartPos = EndPos))
        StartPos - 1
        Protected HaveSeenChars.i = #False
        While (#True)
          Select (PeekC(@Text + (StartPos * SizeOf(CHARACTER))))
            Case ' ', #TAB, #CR, #LF
              If (HaveSeenChars)
                StartPos + 1
                Break
              EndIf
            Case #NUL
              Break
            Default
              HaveSeenChars = #True
          EndSelect
          If (StartPos = 0)
            Break
          Else
            StartPos - 1
          EndIf
        Wend
        SendMessage_(hWnd, #EM_SETSEL, StartPos, EndPos)
      EndIf
      If (EndPos > StartPos)
        ProcedureReturn (SendMessage_(hWnd, #EM_REPLACESEL, #True, #Null$))
      Else
        ProcedureReturn (#Null)
      EndIf
    EndIf
  Else
    ProcedureReturn (CallFunctionFast(GetWindowLongPtr_(hWnd, #GWLP_USERDATA), hWnd, uMsg, wParam, lParam))
  EndIf
EndProcedure

Procedure.i StringGadgetWithCtrlBackspace(Gadget.i, x.i, y.i, Width.i, Height.i, Content.s, Flags.i = #Null)
  Protected Result.i = StringGadget(Gadget, x, y, Width, Height, Content, Flags)
  If (Result)
    If (Gadget = #PB_Any)
      Gadget = Result
    EndIf
    If (Flags & #PB_String_ReadOnly)
      ; leave wndproc as-is
    Else
      SetWindowLongPtr_(GadgetID(Gadget), #GWLP_USERDATA, GetWindowLongPtr_(GadgetID(Gadget), #GWLP_WNDPROC))
      If (Flags & #PB_String_Password)
        SetWindowLongPtr_(GadgetID(Gadget), #GWLP_WNDPROC, @_StringGadgetWithCtrlBackspaceEntire())
      Else
        SetWindowLongPtr_(GadgetID(Gadget), #GWLP_WNDPROC, @_StringGadgetWithCtrlBackspace())
      EndIf
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i ComboBoxGadgetWithCtrlBackspace(Gadget.i, x.i, y.i, Width.i, Height.i, Flags.i = #Null)
  Protected Result.i = ComboBoxGadget(Gadget, x, y, Width, Height, Flags)
  If (Result)
    If (Gadget = #PB_Any)
      Gadget = Result
    EndIf
    If (Flags & #PB_ComboBox_Editable)
      Protected CBI.COMBOBOXINFO
      CBI\cbSize = SizeOf(COMBOBOXINFO)
      If (GetComboBoxInfo_(GadgetID(Gadget), @CBI))
        If (CBI\hwndEdit)
          SetWindowLongPtr_(CBI\hwndEdit, #GWLP_USERDATA, GetWindowLongPtr_(CBI\hwndEdit, #GWLP_WNDPROC))
          SetWindowLongPtr_(CBI\hwndEdit, #GWLP_WNDPROC, @_StringGadgetWithCtrlBackspace())
        EndIf
      EndIf
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

CompilerIf (#True)
Macro StringGadget(_Gadget, _x, _y, _Width, _Height, _Content, _Flags = #Null)
  StringGadgetWithCtrlBackspace((_Gadget), (_x), (_y), (_Width), (_Height), (_Content), (_Flags))
EndMacro
Macro ComboBoxGadget(_Gadget, _x, _y, _Width, _Height, _Flags = #Null)
  ComboBoxGadgetWithCtrlBackspace((_Gadget), (_x), (_y), (_Width), (_Height), (_Flags))
EndMacro
CompilerEndIf

CompilerEndIf ; Windows


;-
;- - Linux
CompilerIf (#Linux)

#GDK_LEFTTAB = $FE20

CompilerIf (#True)
  ;
  ; On Linux, launching executable from file explorer seems to default its CWD to user's home.
  ; This will adjust it to the executable's directory, if it makes sense (eg. not in TEMP folder via PB IDE!)
  ;
  If (GetCurrentDirectory() <> GetProgramDirectory())
    If (GetProgramDirectory() <> GetTemporaryDirectory())
      If (GetCurrentDirectory() = GetHomeDirectory())
        SetCurrentDirectory(GetProgramDirectory())
      EndIf
    EndIf
  EndIf
CompilerEndIf

CompilerEndIf ; Linux


CompilerEndIf
;-
