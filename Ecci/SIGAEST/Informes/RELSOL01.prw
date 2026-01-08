#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"  
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELSOL01  ºAutor  ³Andre Sarraipa      º Data ³  09/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorios das solicitações de Transferencias               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Milano                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



user function RELSOL01()

local oReport
local cPerg  := 'RELSOL01'
local cAlias := getNextAlias()

criaSx1(cPerg)

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()

return

//+-----------------------------------------------------------------------------------------------+
//! Fun?o para cria?o da estrutura do relat?io.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Reporte de solicitudes de transferencia"
local cHelp   := "Permite generar reporte de solicitud transferencias."
Local aOrdem  := {"Solicitud", ""}
//Local aOrdem  := "Solicitacao"

local oReport
local oSection1
local oSection2
local oBreak1

oReport	:= TReport():New('RELSOL01',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetPortrait()

//Primeira se?o
oSection1 := TRSection():New(oReport,"Solicitudes",{"NNS"},aOrdem)    

TRCell():New(oSection1,"NNS_COD"   , "NNS", "Solicitud: ")
TRCell():New(oSection1,"NNS_DATA"  , "NNS", "Emisión") 
TRCell():New(oSection1,"NNS_XNOMSO", "NNS", "Solicitante",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| UsrRetName((cAlias)->(NNS_SOLICT)) })  
TRCell():New(oSection1,"NNS_STATUS", "NNS", "Status") 
  
//TRCell():New(oSection1,"A1_EST", "SA1", "Estado")   

//Segunda se?o
oSection2:= TRSection():New(oSection1,"ITENS",{"NNT","SB1","NNR"})
        
oSection2:SetLeftMargin(2)

//TRCell():New(oSection2,"NNT_PROD", "NNT", "Produto")   
TRCell():New(oSection2,"NNT_PROD" , "NNT","Código de Producto",,18)
TRCell():New(oSection2,"B1_DESC", "SB1", "Descripción")
TRCell():New(oSection2,"NNT_UM", "NNT", "Unid")
TRCell():New(oSection2,"NNT_QUANT", "NNT", "Cantidad")//
TRCell():New(oSection2,"ALM_ORIG", "NNR", "Alm. Origen",,40)
TRCell():New(oSection2,"NNR_DESCRI", "NNR", "Alm. Destino")
// TRCell():New(oSection2,"NNT_XQTORI", "NNT", "Qtd Original")
// TRCell():New(oSection2,"B2_QTSEGUM", "SB2", "Saldo 2 Unid")
TRCell():New(oSection2,"NNT_OBS", "NNT", "Observación")
//TRCell():New(oSection2,"C6_VALOR", "SC6", "Total")              
//TRCell():New( oSection2, "EMISSAO" , "QRY","Emissão",,11)
                                                                              

//Totalizador por cliente
oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(NNS_COD) },"Total:",.F.)                   
//TRFunction():New(oSection2:Cell("NNT_PROD" ), "TOT1", "COUNT", oBreak1,,,"Qtd de Itens:", .F., .F.)
//TRFunction():New(oSection2:Cell("NNT_QUANT" ),"TOT2", "SUM", oBreak1,,,"Qtd de Volumes:", .F., .F.)
//TRFunction():New(oSection2:Cell("NNT_QUANT" ), "TOT2", "SUM", oBreak1,,,, .F., .F.)          
TRFunction():New(oSection2:Cell("NNT_PROD"),NIL,"COUNT",oBreak1,,,,.F.,.F.)         
TRFunction():New(oSection2:Cell("NNT_QUANT"),NIL,"SUM",oBreak1,,,,.F.,.F.)       


//Aqui, farei uma quebra  por seção
oSection1:SetPageBreak(.T.)
                               */
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relat?io.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)  
local cOrdem    
local cStatus 
IF funname() <> 'RELSOL01' 
    MV_PAR01 := NNS->NNS_FILIAL
    MV_PAR02 := NNS->NNS_FILIAL
    MV_PAR03 := NNS->NNS_COD
    MV_PAR04 := NNS->NNS_COD
    MV_PAR05 := NNS->NNS_DATA
    MV_PAR06 := NNS->NNS_DATA
    MV_PAR07 := 1
endif

/*if oReport:Section(1):GetOrder() == 1
	cOrdem := "NNS_COD" 
else
	cOrdem := "NNT_FILDES"
endif*/

cOrdem := "NNS_COD"  


//1=Aprovado;2=Finalizado;3=Em Aprovacao;4=Rejeitado                                                                              

if  MV_PAR07  == 2

	cStatus := "1"

ELSEIF MV_PAR07  == 3

	cStatus := "2"	
		  
ELSE       

	cStatus := "1','2','3','4"     
	
ENDIF
		  
oSection1b:BeginQuery()

BeginSQL Alias cAlias
	

SELECT	
NNS_COD,NNS_DATA,NNT_PROD,B1_DESC,NNT_UM,NNT_QUANT,
NNT_FILDES,NNR2.NNR_DESCRI AS ALM_ORIG,NNR.NNR_DESCRI,NNS_SOLICT, 
B2_QATU,B2_QTSEGUM,NNT_OBS,NNS_STATUS 
FROM %Table:NNS% NNS  
INNER JOIN %Table:NNT% NNT ON NNS_FILIAL = NNT_FILIAL  AND NNS_COD= NNT_COD 
INNER JOIN %Table:SB1% SB1 ON B1_COD = NNT_PROD 
LEFT  JOIN %Table:SB2% SB2 ON NNT_PROD = B2_COD AND NNT_LOCAL = B2_LOCAL AND NNT_FILIAL = B2_FILIAL AND SB2.D_E_L_E_T_='' 
LEFT  JOIN %Table:NNR% NNR ON NNR_CODIGO = NNT_LOCLD AND NNR_FILIAL = NNT_FILDES AND NNR.D_E_L_E_T_='' 
LEFT  JOIN %Table:NNR% NNR2 ON NNR2.NNR_CODIGO = NNT_LOCAL AND NNR2.NNR_FILIAL = NNT_FILDES AND NNR2.D_E_L_E_T_='' 
WHERE  
NNS.D_E_L_E_T_='' 
AND NNT.D_E_L_E_T_='' 
AND SB1.D_E_L_E_T_=''
AND NNT_FILDES BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
AND NNS_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND NNS_DATA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND NNS_STATUS IN (%Exp:cStatus%)
ORDER BY %Exp:cOrdem% 

	
EndSQL 

oSection1b:EndQuery()    
oSection2b:SetParentQuery()
oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->NNS_COD == cParam}, {|| (cAlias)->NNS_COD})

oSection1b:Print()	   

return

//+-----------------------------------------------------------------------------------------------+
//! Fun?o para cria?o das perguntas (se n? existirem)                                          !
//+-----------------------------------------------------------------------------------------------+


static function criaSX1(cPerg)          

xputSx1(cPerg, '01', 'Filial destino de?' , 'Sucursal?' , '', 'mv_ch1', 'C', TAMSX3("NNT_FILDES")[1], 0, 0, 'G', '', 'XM0', '', '', 'mv_par01')
xputSx1(cPerg, '02', 'Filial destino at?' , 'Sucursal?' , '', 'mv_ch2', 'C', TAMSX3("NNT_FILDES")[1], 0, 0, 'G', '', 'XM0', '', '', 'mv_par02')
xputSx1(cPerg, '03', 'Sol. Transf de?'    , 'Desde Sol. Transf?'    , '', 'mv_ch3', 'C', TAMSX3("NNS_COD")[1]   , 0, 0, 'G', '', ''   , '', '', 'mv_par03')
xputSx1(cPerg, '04', 'Sol. Transf at?'    , 'Hasta Sol. Transf?'    , '', 'mv_ch4', 'C', TAMSX3("NNS_COD")[1]   , 0, 0, 'G', '', ''   , '', '', 'mv_par04')
xputSx1(cPerg, '05', 'Data de?'           , 'Desde Fecha?'           , '', 'mv_ch5', 'D', 8                      , 0, 0, 'G', '', ''   , '', '', 'mv_par05')
xputSx1(cPerg, '06', 'Data at?'           , 'Hasta Fecha?'           , '', 'mv_ch6', 'D', 8                      , 0, 0, 'G', '', ''   , '', '', 'mv_par06')
xputSx1(cPerg, '07', 'Status?'            , 'Status?'            , '','mv_ch7', 'C', 1                      , 0, 0, 'C', '', ''   , '', '1', 'mv_par07','Todas','Todas','Todas','','Em Aberto','Em Aberto','Em Aberto','Encerradas','Encerradas','Encerradas')


return   




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
