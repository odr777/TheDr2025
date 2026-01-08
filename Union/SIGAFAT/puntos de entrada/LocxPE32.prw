#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LocxPE32ºAutor ³Widen E. Gonzales V.		 Data ³26/NOV/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada para Filtro de Series en la	º±±
±±º          ³ pantalla de Nota Debito-Credito (NCC).                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function LocxPE32()


LOCAL cQuery:=''
LOCAL aItem:= {}
LOCAL cSeries:=''

if(FUNNAME()$"MATA465N")
	

//cQuery := "NCC|D19|D39|221|"

	cQuery := "SELECT FP_SERIE"
	cQuery += " FROM " + RetSqlName("SFP") + " SFP "
	//cQuery += " INNER JOIN " + RetSqlName("ACQ") + " ACQ ON (ACQ_FILIAL=ACR_FILIAL AND ACQ_CODREG=ACR_CODREG) "
	cQuery += " WHERE FP_FILIAL = '"+XFILIAL("SFP")+"'" 
	cQuery += " AND FP_ESPECIE = '"+'4'+"'"
	//cQuery += " AND ACQ_QUANT = '"+alltrim(str(cQuant))+"'"
	cQuery += " AND SFP.D_E_L_E_T_=' '"
	

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//aviso("",cQuery,{'ok'},,,,,.t.)

	//	Aviso("PEdido ",cQuery,{'ok'},,,,,.t.) // NTP Prueba
	
	If !Empty(Select("TRB"))
		dbSelectArea("TRB")
		dbCloseArea()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³ Executa query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	TcQuery cQuery New Alias "TRB"
	dbSelectArea("TRB")
	dbGoTop()
	
	while!EOF()
		//aadd(aItem,{TRB->FP_SERIE})
		cSeries:=cSeries+TRB->FP_SERIE+'|'
		dbSkip()
	EndDo
	
	//aItem :={TRB->ACR_CODPRO,TRB->ACR_LOTE}
	//Alert(cSeries)											
	//Aviso("AVISO",u_zArrToTxt(aItem, .T.),{"Ok"},,,,,.T.)		//Aplicado a un Array
 
endIf

Return(cSeries)




