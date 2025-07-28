﻿; +-----+------------------------------+
; | KSL | The "Kenmo Standard Library" |
; +-----+------------------------------+

;-
CompilerIf (Not Defined(_KSL_Included, #PB_Constant))
#_KSL_Included = #True

; ---------------------
#KSL_Version = 20250725
; ---------------------

CompilerIf (#PB_Compiler_Version < 510)
  CompilerError #PB_Compiler_Filename + " requires PureBasic 5.10 or newer!"
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

#CurrentDirectoryName = "."
#ParentDirectoryName  = ".."

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

;- ----- Color Functions -----

Macro Opaque(_RGB)
  ((_RGB) | $FF000000)
EndMacro

Macro Transparent(_RGB)
  ((_RGB) & $00FFFFFF)
EndMacro

;-

;- ----- List Functions -----

Macro SelectRandomElement(_List)
  SelectElement(_List, Random(ListSize(_List) - 1))
EndMacro

;-

;- ----- String Functions -----

Enumeration
  #KSL_ExcludeBlank      = $0001
  #KSL_ExcludeWhitespace = $0002
EndEnumeration

Global Dim _StrBool.s((2)-1)
_StrBool(0) = "false"
_StrBool(1) = "true"

Macro StrBool(_Expr)
  _StrBool(Bool(_Expr))
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

Macro TextVariant(_CharStr)
  RTrim(RTrim((_CharStr), #VS15$), #VS16$) + #VS15$
EndMacro
Macro EmojiVariant(_CharStr)
  RTrim(RTrim((_CharStr), #VS15$), #VS16$) + #VS16$
EndMacro

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

Procedure.s Before(String.s, Suffix.s)
  Protected Result.s
  If (String And Suffix)
    Protected i.i = FindString(String, Suffix)
    If (i)
      Result = Left(String, i-1)
    EndIf
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s After(String.s, Prefix.s)
  Protected Result.s
  If (String And Prefix)
    Protected i.i = FindString(String, Prefix)
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
      ElseIf (Left(Path, 1) = "~")
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

Procedure.s NormalizePath(Path.s)
  Protected Result.s = ""
  If (Path)
    Path = NormalizePathSeparators(Path, #PS$)
    Protected IsAbsolute.i = IsAbsolutePath(Path)
    Protected File.s = GetFilePart(Path)
    Path = GetPathPart(Path)
    If (File = #CurrentDirectoryName)
      File = ""
    ElseIf (File = #ParentDirectoryName)
      File = ""
      Path + #ParentDirectoryName + #PS$
    EndIf
    If (Path)
      Protected ExtraParents.i = 0
      Protected N.i = 1 + CountString(Path, #PS$)
      Protected i.i
      For i = 1 To N
        Protected Term.s = StringField(Path, i, #PS$)
        If (Term <> "")
          If (Term = #CurrentDirectoryName)
            ; ignore
          ElseIf (Term = #ParentDirectoryName)
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
        Result = #ParentDirectoryName + #PS$ + Result
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
              Prefix + #ParentDirectoryName + #PS$
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

Macro GetModifiedDate(_File)
  GetFileDate((_File), #PB_Date_Modified)
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

Procedure ShowFileInExplorer(File.s)
  If (File)
    Protected Path.s = GetPathPart(File)
    If (Path = "")
      Path = GetCurrentDirectory()
    EndIf
    CompilerIf (#Windows)
      RunProgram("explorer.exe", "/SELECT," + Quote(File), Path)
    CompilerElse
      LaunchFolder(Path)
    CompilerEndIf
  EndIf
EndProcedure

Procedure.s ReadFileToString(File.s)
  Protected Result.s = ""
  Protected FN.i = ReadFile(#PB_Any, File)
  If (FN)
    Protected Format.i = ReadStringFormat(FN)
    Select (Format)
      Case #PB_Ascii, #PB_UTF8, #PB_Unicode
        Result = ReadString(FN, Format | #PB_File_IgnoreEOL)
    EndSelect
    CloseFile(FN)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i CreateFileFromString(File.s, String.s, Format.i = #PB_Default, WriteBOM.i = #PB_Default)
  Protected Result.i = #False
  If (Format = #PB_Default)
    Format = #PB_UTF8
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

Macro SelectGadget(_Gadget)
  WindowsElse(SendMessage_(GadgetID(_Gadget), #EM_SETSEL, 0, -1), SetActiveGadget(_Gadget))
EndMacro

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

Macro GetPanelWidth(_PanelGadget)
  (GetGadgetAttribute(((_PanelGadget), #PB_Panel_ItemWidth)))
EndMacro
Macro GetPanelHeight(_PanelGadget)
  (GetGadgetAttribute(((_PanelGadget), #PB_Panel_ItemHeight)))
EndMacro

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

;-

;- ----- Network Functions -----

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

;- ----- OS-Specific Initialization -----

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

CompilerEndIf

;-

CompilerEndIf
;-
