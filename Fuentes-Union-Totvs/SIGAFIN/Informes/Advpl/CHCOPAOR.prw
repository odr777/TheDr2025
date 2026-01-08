#INCLUDE "rwmake.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

#define nBolivianos 1
#define nDolares    2
#define nInterLin   100
//#define nFinHoja    3000
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAUTOR  	   ³ CHCOPAOR ERICK ETCHEVERRY  							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Recibo  para Cuentas por Cobrar  				  		  º±±
±±º            ³ Imprime un  respaldo al Cliente, cuando se cancela en    º±±
±±º            ³ Tesoreria se da un recibo que es solo cuando lo solicita º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºVersion     ³ V.001                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CHCOPAOR() // u_CFinI204()

	Local _cDesc1        	:= "Comprobante para cobro"
	Local _cDesc2        	:= "de cheques"
	Local _cDesc3        	:= "Dinero segun sea Cuenta por Cobrar o Pagar."
	Local _titCob       	:= "Comprobante para Cobro de Cheques"
	Local _cString		  	:= ""
	Local aArea    := GetArea()
	Private _tamanho      	:= "P"     //P=Vertical(80) G=horizontal(220)	--> M=
	Private _nomeprog     	:= "CHCOPAOR" // Coloque aquí el nombre del programa para impresión en el encabezado
	Private aReturn      	:= { "A Rayas", 1, "Financiero", 2, 2, 1, "", 1}
	Private _wnrel        	:= "CHCOPAOR"  // Nombre del archivo usado para impresión en disco segun el nombre del funcion
	PRIVATE cPerg   := "CHCOPAOR"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	pergunte(cPerg,.F.)  		// Invoca y establece los parametros en SX1 en el reporte
	_wnrel := SetPrint("TRI",_nomeProg,cPerg,@_titCob,_cDesc1,_cDesc2,_cDesc3,.F.,,.T.,_Tamanho,,.F.)

	MakeSqlExpr(cPerg)   // Permite la  Lectura de los valores de cada uno de los parametros definidos en SX1
	SET DEVICE TO PRINTER

	MS_FLUSH()
	MsgRun("Aguarde por favor .....", "Generando el Reporte...", ;
	{ || f4_ROfC3(_titCob,.F.) } )

	RestArea(aArea)
Return

//---------------------------------------------------------------------------------------------------//
// Rutina Secundaria de RECIBO: RECIBO COBROS DIVERSOS
//---------------------------------------------------------------------------------------------------//

static function f4_ROfC3(cTitulo,bImprimir)
	Local _csql  := ""
	Local _nLin := 0600
	Local _nInterLin := 70
	Local _nCol3 := 0125
	Local _dFecha
	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL
	PRIVATE nLin1	:= 0080
	PRIVATE nLin2	:= 0140
	PRIVATE nLin3	:= 0200
	PRIVATE nLin4	:= 0255
	PRIVATE nLin5	:= 0310
	DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,10 OF oPrn
	DEFINE FONT oFont9 NAME "Times New Roman" SIZE 0,9 OF oPrn BOLD
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,15 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,15 OF oPrn BOLD
	DEFINE FONT oFont6 NAME "Arial" SIZE 0,07
	DEFINE FONT oFont7 NAME "Times New Roman" SIZE 0,12 OF oPrn
	DEFINE FONT oFont8 NAME "Times New Roman" SIZE 0,08 OF oPrn
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:SetPortrait() // Vertical

	_csql := "SELECT "  + Chr(13)
	_csql := _csql + " E1_CCUSTO,E1_ITEMCTA,CASE E1_MOEDA WHEN 1 THEN 'BOLIVIANO' ELSE 'DOLARES' END AS E1_MOEDA, " + Chr(13)
	_csql := _csql + " E1_VALOR,E1_NUM,E1_NATUREZ,A6_NOME,E1_EMISSAO " + Chr(13)
	_csql := _csql + " FROM " + RetSqlName("SE1") + " SE1 "
	_csql := _csql + " JOIN " + RetSqlName("SA6") + " SA6" + Chr(13)
	_csql := _csql + " ON A6_COD = E1_PORTADO AND A6_FILIAL = '"+xfilial("SA6")+"' AND SA6.D_E_L_E_T_ = ' '" + CHR(13)
	_csql := _csql + " WHERE E1_TIPO = 'CH' AND " + CHR(13)
	_csql := _csql + " E1_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CHR(13)
	_csql := _csql + " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CHR(13)
	_csql := _csql + " AND E1_PORTADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + CHR(13)
	_csql := _csql + " AND SE1.D_E_L_E_T_ = ' '" + CHR(13)

	//aviso("",_csql,{'ok'},,,,,.t.)
	_csql := ChangeQuery(_csql)

	TCQuery _csql New Alias "vw_e1"
	
	While ! vw_e1->(Eof())

		_nLin := 0650
		oPrn:StartPage()
		Logo(cTitulo,vw_e1->E1_NUM,vw_e1->E1_EMISSAO)//numero recibo

		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Banco/Caja", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->A6_NOME , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Beneficiario", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->A6_NOME , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Modalidad", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->E1_NATUREZ , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Moneda", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->E1_MOEDA , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Valor", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, alltrim(TRANSFORM(vw_e1->E1_VALOR,"@E 9,999,999,999.99")) , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Centro de Costo", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->E1_CCUSTO , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Item Contable", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->E1_ITEMCTA , oFont1)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3, "Cheque Numero", oFont1)
		oPrn:Say(_nLin, _nCol3+1000, vw_e1->E1_NUM , oFont1)
		_nLin := _nLin + _nInterLin


		_nLin := _nLin + _nInterLin
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3+330,cUsername,oFont1 )
		_nLin := _nLin + 20
		oPrn:Say(_nLin, _nCol3+250," ______________________",oFont1 )
		oPrn:Say(_nLin, _nCol3+250," ______________________",oFont1 )
		oPrn:Say(_nLin, _nCol3 + 1550,"______________________",oFont1 )
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3 + 350,"	EMITIDO POR ",oFont1 )
		oPrn:Say(_nLin, _nCol3 + 1600,"	 AUTORIZADO POR ",oFont1 )
		_nLin := _nLin + _nInterLin
		oPrn:Box( _nLin , 0080 , _nLin+10 , 2370 )//doble linea
		oPrn:Say(_nLin + 20, _nCol3 + 1850,"	 IMPRESION: ",oFont8 )
		cEmissao		:= 		alltrim(DTOS(dDatabase))
		cAnho			:= 		SubStr(cEmissao, 1,4 )
		cDia				:= 		SubStr(cEmissao, 5,2 )
		cMes				:= 		SubStr(cEmissao, 7,2 )
		cEmissao		:= 		cMes + "/" + cDia + "/" + cAnho
		oPrn:Say(_nLin + 20, _nCol3 + 2050,cEmissao,oFont8 )

		oPrn:EndPage()
		vw_e1->(DbSkip())

	enddo

	Ms_Flush() //JLJR: Sube lo cargado a TMSPrinter
	//JLJR: No Existe este metodo para el Objeto: Reload()
	oPrn:Refresh() //JLJR: Tampoco recarga como esperabamos...
	if bImprimir
		oPrn:Print()
	else
		oPrn:Preview()
	end If
	vw_e1->(DbCloseArea())

return

Static Function Logo(cTitulo,cNroTit,cFeita)
	cFLogo := GetSrvProfString("Startpath","") + "logo_union.bmp"

	oPrn:SayBitmap(nlin2 + 70, 130, cFLogo,500,230)

	oPrn:Say( nLin1 ,0080, cTitulo, oFont5)
	oPrn:Box( nLin1+ 70 , 0070 , nLin1+ 70 , 980 ) //linea texto debjo
	//Cuadro
	oPrn:Box( nLin2 + 60 , 0100,  670 , 2370 )
	oPrn:Say( nLin2 + 310, 0120, Capital(AllTrim(SM0->M0_ENDENT))+ " - " + SM0->M0_CIDCOB, oFont9)
	oPrn:Say( nLin2 + 380, 0120, "Tel.:  " + SM0->M0_TEL, oFont9)
	oPrn:Say( nLin2 + 380, 0400, "Email: ", oFont9)
	oPrn:Say( nLin2 + 450, 0120, "N.I.T. " + SM0->M0_CGC	, oFont9)

	oPrn:Say( nLin2 + 240, 900, "INGRESO POR COBRO DE CHEQUES", oFont4)

	oPrn:Say( nLin2 + 100, 840, "COMPROBANTE", oFont2)
	oPrn:Box( nLin2 + 90 , 1160,  290 , 1800 )	//cuadro comp
	oPrn:Say( nLin2 + 105, 1200,cNroTit , oFont2)

	oPrn:Say( nLin2 + 100, 1870, "FECHA", oFont2)
	oPrn:Box( nLin2 + 90 , 2040,  290 , 2250 )	//cuadro comp
	cEmissao		:= 		alltrim(cFeita)
	cAnho			:= 		SubStr(cEmissao, 1,4 )
	cDia			:= 		SubStr(cEmissao, 5,2 )
	cMes			:= 		SubStr(cEmissao, 7,2 )
	cEmissao		:= 		cMes + "/" + cDia + "/" + cAnho
	oPrn:Say( nLin2 + 105, 2080, cEmissao, oFont2)
Return

Static function fecha(_dFecha)
	Local _cFecha
	Local _nMes

	_cFecha :=  SubStr(_dFecha,7,2) + " de "
	_nMes := Val(SubStr(_dFecha,5,2))
	Do Case
		Case _nMes == 1
		_cFecha += "Enero"
		Case _nMes == 2
		_cFecha += "Febrero"
		Case _nMes == 3
		_cFecha += "Marzo"
		Case _nMes == 4
		_cFecha += "Abril"
		Case _nMes == 5
		_cFecha += "Mayo"
		Case _nMes == 6
		_cFecha += "Junio"
		Case _nMes == 7
		_cFecha += "Julio"
		Case _nMes == 8
		_cFecha += "Agosto"
		Case _nMes == 9
		_cFecha += "Septiembre"
		Case _nMes == 10
		_cFecha += "Octubre"
		Case _nMes == 11
		_cFecha += "Noviembre"
		Case _nMes == 12
		_cFecha += "Diciembre"
	EndCase
	_cFecha += " del " + SubStr(_dFecha,1,4)

return _cFecha

Static Function CriaSX1(cPerg)  // Crear Preguntas

	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
	// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
	// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado

	xPutSx1(cPerg,"01","¿De Fecha?" , "¿De Fecha?","¿De Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"02","¿A Fecha?" , "¿A Fecha?","¿A Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"03","¿De Cheque?" 	, "¿De Cheque?"  ,"¿De Cheque?"	 ,"MV_CH3","C",13 ,0,0,"G","",""	,""	,""	,"MV_PAR03",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"04","¿A Cheque?" 	, "¿A Cheque?"   ,"¿A Cheque?"	 ,"MV_CH4","C",13 ,0,0,"G","",""	,""	,""	,"MV_PAR04",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"05","¿De Banco?" 	, "¿De Banco?"   ,"¿De Banco?"	 ,"MV_CH5","C",3 ,0,0,"G","","A62"	,""	,""	,"MV_PAR05",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"06","¿De Banco?" 	, "¿De Banco?"   ,"¿De Banco?"	 ,"MV_CH6","C",3 ,0,0,"G","","A62"	,""	,""	,"MV_PAR06",""       ,""            ,""        ,""     ,,"")

	//PutSX1(cPerg,"05","¿De Tipo?" 		, "¿De Tipo?"	   ,"¿De Tipo?"		 ,"MV_CH5","C",3 ,0,0,"G","","42" 	,""	,""	,"MV_PAR05",""       ,""            ,""        ,""     ,,"")
	//PutSX1(cPerg,"06","¿A Tipo?" 		, "¿A Tipo?"	   ,"¿A Tipo?"		 ,"MV_CH6","C",3 ,0,0,"G","","42" 	,""	,""	,"MV_PAR06",""       ,""            ,""        ,""     ,,"")
	//PutSX1(cPerg,"07","¿Contabilizada?" , "¿Contabilizada?","¿Contabilizada?","MV_CH7","C",5,0,0,"C","",""		,""	,""	,"MV_PAR07","SI" ,"SI","SI","NO","NO","NO","TODAS","TODAS","TODAS",,,)
	//PutSX1(cPerg,"08","¿Tipo9?" , "¿Tipo9?","¿Tipo9?","MV_CH8","C",5,0,0,"C","",""		,""	,""	,"MV_PAR08","SI" ,"SI","SI","NO","NO","NO","TODAS","TODAS","TODAS",,,)

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