#Include "Protheus.ch"
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA100Get บAutor  ณEDUAR ANDIA         บ Data ณ  03/04/2019  บฑฑ
ฑฑ			 Modificado			JORGE CARDONA       บ Data ณ  09/10/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Permite ao cliente preencher automaticamente os dados da   บฑฑ
ฑฑบ          ณ tela de transferencia bancแria.	  						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia /UNIONAGRO			                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA100GET
Local aArea		:= GetArea()
Local cBcoOrig	:= ParamIxb[1]
Local cAgenOrig	:= ParamIxb[2]
Local cCtaOrig	:= ParamIxb[3]
Local cNaturOri	:= ParamIxb[4]
Local cBcoDest	:= ParamIxb[5]
Local cAgenDest	:= ParamIxb[6]
Local cCtaDest	:= ParamIxb[7]
Local cNaturDes	:= ParamIxb[8]
Local cTipoTran	:= ParamIxb[9]
Local cDocTran	:= ParamIxb[10]
Local nValorTran:= ParamIxb[11]
Local cHist100	:= ParamIxb[12]
Local cBenef100	:= ParamIxb[13]

//Local __cNumTrf	:= ""
Local aFa100Get	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carregando dados Ini. na tela de Transf. Bancแria           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cNaturOri	:= GETNEWPAR("MV_XTRFMOD","TRANS.BANC")
cNaturDes	:= GETNEWPAR("MV_XTRFMOD","TRANS.BANC")
cTipoTran 	:= "$ "

//__cNumTrf := GetSx8Num("SE5","E5_PROCTRA","E5_PROCTRA"+cEmpAnt)
//If !Empty(__cNumTrf)
//	cDocTran	:= Right( __cNumTrf, /*TamSX3("E5_NUMCHEQ")[1]*/  8 )
//Endif

cHist100	:= "TRANSF. "
cHist100	:= Pad ( cHist100, TamSX3("E5_HISTOR")[1] )

Aadd( aFa100Get, {cBcoOrig}		)
Aadd( aFa100Get, {cAgenOrig}	)
Aadd( aFa100Get, {cCtaOrig}		)
Aadd( aFa100Get, {cNaturOri}	)
Aadd( aFa100Get, {cBcoDest}		)
Aadd( aFa100Get, {cAgenDest}	)
Aadd( aFa100Get, {cCtaDest}		)
Aadd( aFa100Get, {cNaturDes}	)
Aadd( aFa100Get, {cTipoTran}	)
Aadd( aFa100Get, {cDocTran}		)
Aadd( aFa100Get, {nValorTran}	)
Aadd( aFa100Get, {cHist100}		)
Aadd( aFa100Get, {cBenef100}	)

RestArea(aArea)
Return(aFa100Get)
