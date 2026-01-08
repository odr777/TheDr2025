#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A085APAG   º Autor ³ Jorge Saavedra   º Fecha ³  10/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Punto de Entrada Validar en la Rutina de Cobranza Diversa º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BASE BOLIVIA                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function A087TUDOK()
	Local _lRet:=.T.
	Local nPosBcoDep	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_BANCO"})
	Local nPosAgeDep	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_AGENCIA"})
	Local nPosCtaDep	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_CONTA"})
	Local nPosTipoDoc	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_TIPODOC"})

	If PARAMIXB==1 //1a pantalla

		cBanco:=POSICIONE("SA6",1,xFilial("SA6")+aCols[n][nPosBcoDep]+aCols[n][nPosAgeDep]+aCols[n][nPosCtaDep],"A6_COD")


		If Empty(aCols[n][nPosAgeDep]+aCols[n][nPosCtaDep]) .Or. Empty(cBanco)
			Help("",1,"FA087BCO")  //"Caja no existente"
			_lRet	:=	.F.
		else
			If SA6->A6_SALATU >= SA6->A6_UMONMAX
				Msginfo("Transfiera el Saldo del Banco, ya que alcanzo el Monto Máximo.")
				_lRet	:=	.F.
			else
				If SA6->A6_SALATU >= SA6->A6_UVALTRA
					Aviso("IMPORTANTE","El Saldo del Banco esta por Alcanzar el Monto Máximo, por favor Transfiera a Caja Central.",{"OK"})
				end
				IF ALLTRIM(aCols[n][nPosTipoDoc]) $ "CD|CC"
					if !DatosTarjeta()
						_lRet	:=	.F.
					end
				END
			END
		Endif

		if fnLPeriod(dDataRef) ///si el periodo esta bloqueado
			Msginfo("Periodo del cobro bloqueado")
			_lRet	:=	.F.

		endif

	Endif

return(_lRet)


Static function DatosTarjeta()
	Local lRet   := .T.
	Local lAcepto	:=	.F.
	Local cTarjeta	:=	 space(TamSX3('EL_UNUMTAR')[1])	,	cBanco	:=	Space(TamSX3('EL_UBANTAR')[1])
	Local cObservacion 	:= Space(TamSX3('EL_UOBSTAR')[1])
	Local lTerc		:=	.T. , oTerc
	Local oDlg
	Local nPosNumTar	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_UNUMTAR"})
	Local nPosBanTar	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_UBANTAR"})
	Local nPosObjTar	:=AScan(aHeader,{|x|Alltrim(x[2])=="EL_UOBSTAR"})


	Define MSDIALOG oDlg FROM 80,000 To 270,430  Title OemToAnsi("Cobro con Tarjeta") PIXEL //"Pago con Cheques de Terceros."
	@ 01,003 To 90,216 Label OemToAnsi("Datos de la Tarjeta")	Of oDlg PIXEL //"Datos del cheque"
	@ 12,008 SAY OemToAnsi("Número de la Tarjeta") SIZE 100,10 Of oDlg PIXEL //"Cliente"
	@ 12,060 MSGET cTarjeta  SIZE C(80),C(10) Of oDlg PIXEL
	@ 30,008 SAY OemToAnsi("Banco") SIZE 30,10 Of oDlg PIXEL //"Cliente"
	@ 30,060 MSGET cBanco   SIZE C(90),C(10) Of oDlg PIXEL

	@ 50,008 SAY OemToAnsi("Observación") SIZE 40,10 Of oDlg PIXEL //"Recibo"
	@ 50,060 MSGET cObservacion  SIZE C(120),C(10) Of oDlg PIXEL

	DEFINE SBUTTON FROM 73,145 Type 1 Action (lAcepto:=.T.,oDlg:End()) Of oDlg PIXEL ENABLE
	DEFINE SBUTTON FROM 73,180 Type 2 Action oDlg:End() Of oDlg PIXEL ENABLE
	Activate Dialog oDlg CENTERED

	IF lAcepto
		if EsVacio(cTarjeta,"Número de la Tarjeta") .and. EsVacio(cBanco,"Banco")
			aCols[n][nPosNumTar]:= val(cTarjeta)
			aCols[n][nPosBanTar]:= cBanco
			aCols[n][nPosObjTar]:= cObservacion
		else
			lRet:=.F.
		end
	else
		lRet:=.F.
	END

return lRet

Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

Static Function EsVacio(variable,campo)
	Local lRet:=.T.
	If empty(alltrim(variable))
		lRet:=.F.
		Msginfo("El Campo " + campo + " es Obligatorio")
	end
return lRet

static function fnLPeriod(dDataVld)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local lPeriod := .f.

	/*
	SELECT * FROM ZXA010
WHERE 
'20210101' >= ZXA_DDINIC AND 
   '20210201' <= ZXA_DDFINA*/

	If Select("QRY_ZXA") > 0
		dbCloseArea()
	Endif

	cQuery := " SELECT * "
	cQuery += " FROM "
	cQuery += " "+RetSQLName("ZXA")+" ZXA "
	cQuery += " WHERE '" + dtos(dDataVld) + "' >= ZXA_DDINIC "
	cQuery += " AND '" + dtos(dDataVld) + "' <= ZXA_DDFINA AND  ZXA_FILIAL = '" + xfilial("ZXA") + "' AND ZXA.D_E_L_E_T_<> '*'"

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "QRY_ZXA"

	if !QRY_ZXA->(EoF())

		lPeriod = .t.

	endif

	QRY_ZXA->(DbCloseArea())
	RestArea(aArea)
return lPeriod

/*
SELECT * FROM ZXA010
WHERE 
'20210101' >= ZXA_DDINIC AND 
   '20210201' <= ZXA_DDFINA
*/
