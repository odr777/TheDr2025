#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±±±
±±³Fun‡…o    ³ ParDiEqo ³ Autor Carlos Egüez³	Query     : Carlos Egüez	³ ±±
±±						        24/10/17                                     ±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±±
±±³Descri‡…o ³  "Parte Diario de Equipo Pesado y otros"					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±±
±±³Sintaxe   ³ SEUvsCT2()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±±
±±³ Uso      ³ Casa Grande													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/
*/

user function ParDiEqo()
LOCAL oReport
PRIVATE cPerg   := "ParDiEq" 

CriaSX1(cPerg)
Pergunte(cPerg,.F.) 

oReport := ReportDef()
oReport:PrintDialog()	

Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local NombreProg := "Parte Diario de Equipo Pesado y Otros"

oReport	 := TReport():New("ParDiEqo",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Parte Diario de Equipo Pesado y Otros")
oSection := TRSection():New(oReport,"ParDiEqo",{"SD1"})
oReport:SetTotalInLine(.F.)

TRCell():New(oSection,"D1_DOC"      ,"SD1","REMITO",,TamSx3("D1_DOC")[1],.T.)
TRCell():New(oSection,"D1_SERIE"    ,"SD1","SERIE",,TamSx3("D1_SERIE")[1],.T.)
TRCell():New(oSection,"D1_COD"      ,"SD1","PRODUCTO",,TamSx3("D1_COD")[1],.T.)
TRCell():New(oSection,"D1_UDESC"    ,"SD1","DESCRIP.",,TamSx3("D1_UDESC")[1],.T.) 
TRCell():New(oSection,"D1_UHRINIE"  ,"SD1","HORA INI",,TamSx3("D1_UHRINIE")[1],.T.)
TRCell():New(oSection,"D1_UHRFINE"  ,"SD1","HORA FIN",,TamSx3("D1_UHRFINE")[1],.T.)
TRCell():New(oSection,"D1_UHORAEQ"  ,"SD1","DIF.HORA",,TamSx3("D1_UHORAEQ")[1],.T.)
TRCell():New(oSection,"D1_QUANT"    ,"SD1","CANTIDAD",,TamSx3("D1_QUANT")[1],.T.)
TRCell():New(oSection,"D1_VUNIT"    ,"SD1","PRC.UNIT",PesqPict("SD1","D1_VUNIT")/*Picture*/,TamSX3("D1_VUNIT")[1])
TRCell():New(oSection,"D1_TOTAL"    ,"SD1","TOTAL",PesqPict("SD1","D1_TOTAL")/*Picture*/,TamSX3("D1_TOTAL")[1])
TRCell():New(oSection,"D1_UM"       ,"SD1","UN.MED",,TamSx3("D1_UM")[1],.T.)
TRCell():New(oSection,"D1_UNROPTD"	,"SD1","NRO.PTD",,TamSx3("D1_UNROPTD")[1],.T.)   
TRCell():New(oSection,"D1_UDTPTD"	,"SD1","FECHA",,TamSx3("D1_UDTPTD")[1],.T.)     
TRCell():New(oSection,"D1_UOPERPT"  ,"SD1","OPERADOR",,TamSx3("D1_UOPERPT")[1],.T.)       
TRCell():New(oSection,"D1_CLVL"     ,"SD1","CLASE VALOR",,TamSx3("D1_CLVL")[1],.T.) 
TRCell():New(oSection,"D1_UACTPTD"  ,"SD1","ACTIVIDAD REALIZADA",,TamSx3("D1_UACTPTD")[1],.T.)    
TRCell():New(oSection,"D1_ITEMCTA"  ,"SD1","ITEM CONTABLE",,TamSx3("D1_ITEMCTA")[1],.T.)   
TRCell():New(oSection,"D1_CC"       ,"SD1","CENTRO COSTO",,TamSx3("D1_CC")[1],.T.)    
TRCell():New(oSection,"D1_TES"      ,"SD1","TIPO ENTRADA",,TamSx3("D1_TES")[1],.T.)
  

TRCell():New(oSection,"D1_UTPCOMB"  ,"SD1","COMBUSTIBLE",,TamSx3("D1_UTPCOMB")[1],.T.)
TRCell():New(oSection,"D1_UCOMBUS"  ,"SD1","CANT.COMBUSTIBLE",,TamSx3("D1_UCOMBUS")[1],.T.)
TRCell():New(oSection,"D1_UHREFEC"  ,"SD1","HORAS EFECTIVAS",,TamSx3("D1_UHREFEC")[1],.T.)
TRCell():New(oSection,"D1_UHRNUL"   ,"SD1","HORAS NULAS",,TamSx3("D1_UHRNUL")[1],.T.)
TRCell():New(oSection,"D1_UOTRINS"  ,"SD1","OTROS INSUMOS",,TamSx3("D1_UOTRINS")[1],.T.)


oSection:SetColSpace(1)
Return oReport

Static Function PrintReport(oReport)
Local oSection 	:= oReport:Section(1)


#IFDEF TOP

oSection:BeginQuery()
BeginSql alias "QRYSD1"


SELECT D1_DOC, D1_SERIE, D1_COD, D1_UDESC, D1_UHRINIE, D1_UHRFINE, D1_UHORAEQ, D1_QUANT, D1_UM, D1_UNROPTD, 
D1_UDTPTD, D1_UOPERPT, D1_URENDPT, D1_CLVL, D1_UACTPTD, D1_ITEMCTA, D1_CC, D1_TES,D1_VUNIT,D1_TOTAL, 
CASE D1_UTPCOMB WHEN 'D' THEN 'DIESEL' WHEN 'G' THEN 'GASOLINA' END AS D1_UTPCOMB,D1_UCOMBUS,D1_UOTRINS,D1_UHREFEC,D1_UHRNUL
FROM %Table:SD1% SD1
WHERE SD1.D_E_L_E_T_ = ' ' 
AND SD1.D1_UNROPTD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND SD1.D1_UDTPTD  BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND SD1.D1_UOPERPT BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND SD1.D1_CLVL BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
AND SD1.D1_ITEMCTA BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
AND SD1.D1_CC BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
ORDER BY D1_DOC

endSql

oSection:EndQuery()

#ENDIF

oSection:Print()

Return


Static Function CriaSX1(cPerg) 
xPutSx1(cPerg,"01","¿De Nro PTD?"      , "¿De Nro PTD?"	   ,"¿De Nro PTD?"		,"MV_CH1","C",6,0,0,"G","","","",""	,"MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")     
xPutSx1(cPerg,"02","¿A Nro PTD?" 	   ,"¿A Nro PTD?"	   ,"¿A Nro PTD?"		,"MV_CH2","C",6,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
xPutSx1(cPerg,"03","¿De Fecha PTD?"    ,"¿De Fecha PTD?"   ,"¿De Fecha PTD?"    ,"MV_CH3","D",8,0,0,"G",""," ","","","MV_PAR03",""       ,""            ,""        ,""     ,,"")     
xPutSx1(cPerg,"04","¿A Fecha PTD?" 	   ,"¿A Fecha PTD?"    ,"¿A Fecha PTD?"	    ,"MV_CH4","D",8,0,0,"G",""," ","","","MV_PAR04",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"05","¿De Operador PTD?" ,"¿De Operador PTD?","De Operador PTD?"	,"MV_CH5","C",6,0,0,"G","","" ,"" ,"" ,"MV_PAR05",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"06","¿A Operador PTD?"  ,"¿A Operador PTD?" ,"¿A Operador PTD?"	,"MV_CH6","C",6,0,0,"G","","" ,"" ,"" ,"MV_PAR06",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"07","¿De Clase Valor(Equipo)?"         ,"¿De Clase Valor(Equipo)?"        ,"¿De Clase Valor(Equipo)?","MV_CH7","C",9,0,0,"G","","" ,"" ,"" ,"MV_PAR07",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"08","¿A Clase Valor(Equipo)?"          ,"¿A Clase Valor(Equipo)?"	     ,"¿A Clase Valor(Equipo)?","MV_CH8","C",9,0,0,"G","","" ,"" ,"" ,"MV_PAR08",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"09","¿De Item Contable(actividad)?"    ,"¿De Item Contable(actividad)?"	 ,"¿De Item Contable(actividad)?","MV_CH9","C",9,0,0,"G","","" ,"" ,"" ,"MV_PAR09",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"10","¿A Item Contable(actividad)?"     ,"¿A Item Contable(actividad)?"	 ,"¿A Item Contable(actividad)?","MV_CH10","C",9,0,0,"G","","" ,"" ,"" ,"MV_PAR10",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"11","¿De Centro de Costos(Proyecto)?"  ,"¿De Centro de Costos(Proyecto)?" ,"¿De Centro de Costos(Proyecto)?","MV_CH11","C",9,0,0,"G","","" ,"" ,"" ,"MV_PAR11",""       ,""            ,""        ,""     ,,"")
xPutSx1(cPerg,"12","¿A Centro de Costos(Proyecto)?"   ,"¿A Centro de Costos(Proyecto)?"	 ,"¿A Centro de Costos(Proyecto)?" ,"MV_CH12","C",9,0,0,"G","","" ,"" ,"" ,"MV_PAR12",""       ,""            ,""        ,""     ,,"")
Return

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,; 
     cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,; 
     cF3, cGrpSxg,cPyme,; 
     cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,; 
     cDef02,cDefSpa2,cDefEng2,; 
     cDef03,cDefSpa3,cDefEng3,; 
     cDef04,cDefSpa4,cDefEng4,; 
     cDef05,cDefSpa5,cDefEng5,; 
     aHelpPor,aHelpEng,aHelpSpa,cHelp) 

LOCAL aArea := GetArea() 
Local cKey 
Local lPort := .f. 
Local lSpa := .f. 
Local lIngl := .f. 

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "." 

cPyme    := Iif( cPyme           == Nil, " ", cPyme          ) 
cF3      := Iif( cF3           == NIl, " ", cF3          ) 
cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     ) 
cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      ) 
cHelp      := Iif( cHelp          == Nil, "" , cHelp          ) 

dbSelectArea( "SX1" ) 
dbSetOrder( 1 ) 

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes. 
// RFC - 15/03/2007 
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " ) 

If !( DbSeek( cGrupo + cOrdem )) 

    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt) 
     cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa) 
     cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng) 

     Reclock( "SX1" , .T. ) 

     Replace X1_GRUPO   With cGrupo 
     Replace X1_ORDEM   With cOrdem 
     Replace X1_PERGUNT With cPergunt 
     Replace X1_PERSPA With cPerSpa 
     Replace X1_PERENG With cPerEng 
     Replace X1_VARIAVL With cVar 
     Replace X1_TIPO    With cTipo 
     Replace X1_TAMANHO With nTamanho 
     Replace X1_DECIMAL With nDecimal 
     Replace X1_PRESEL With nPresel 
     Replace X1_GSC     With cGSC 
     Replace X1_VALID   With cValid 

     Replace X1_VAR01   With cVar01 

     Replace X1_F3      With cF3 
     Replace X1_GRPSXG With cGrpSxg 

     If Fieldpos("X1_PYME") > 0 
          If cPyme != Nil 
               Replace X1_PYME With cPyme 
          Endif 
     Endif 

     Replace X1_CNT01   With cCnt01 
     If cGSC == "C"               // Mult Escolha 
          Replace X1_DEF01   With cDef01 
          Replace X1_DEFSPA1 With cDefSpa1 
          Replace X1_DEFENG1 With cDefEng1 

          Replace X1_DEF02   With cDef02 
          Replace X1_DEFSPA2 With cDefSpa2 
          Replace X1_DEFENG2 With cDefEng2 

          Replace X1_DEF03   With cDef03 
          Replace X1_DEFSPA3 With cDefSpa3 
          Replace X1_DEFENG3 With cDefEng3 

          Replace X1_DEF04   With cDef04 
          Replace X1_DEFSPA4 With cDefSpa4 
          Replace X1_DEFENG4 With cDefEng4 

          Replace X1_DEF05   With cDef05 
          Replace X1_DEFSPA5 With cDefSpa5 
          Replace X1_DEFENG5 With cDefEng5 
     Endif 

     Replace X1_HELP With cHelp 

     PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

     MsUnlock() 
Else 

   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT) 
   lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA) 
   lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG) 

   If lPort .Or. lSpa .Or. lIngl 
          RecLock("SX1",.F.) 
          If lPort 
        SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?" 
          EndIf 
          If lSpa 
               SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?" 
          EndIf 
          If lIngl 
               SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?" 
          EndIf 
          SX1->(MsUnLock()) 
     EndIf 
Endif 

RestArea( aArea ) 

Return