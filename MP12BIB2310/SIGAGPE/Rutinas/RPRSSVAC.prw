#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³ RPRSSVAC	  Author: Erick Etcheverry     º Data ³ 09/05/2024º±±
±±º 		 	 	 	 	   				 	 	 	 	 	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Recalculo de vacaciones			 	 	 	 	 	      º±±
±±º USO      ³ Ajusta lineas de vacaciones SR8 luego ajusta tablas SRD    º±±
±±º	y SRC																  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function RPRSSVAC
	Local aArea    := GetArea()
	Local nNroMeses
	Local i
	Local cCampo := ReadVar()
	Local lInsert := .t.
	Local cVACCodFol:= '0072'	//Identificador Concepto de Vacacion
	Local cPDVAC	:= GetAdvFVal("SRV","RV_COD", xFilial("SRV") + cVACCodFol, 2, "")
	Local cTipoAFa := GetAdvFVal("RCM","RCM_TIPO",xFilial("RCM")+cPDVAC,3,"")
	Local cXLog := ''
	Local cLogText := ""
	Local cQuebra  := CRLF + "+=======================================================================+" + CRLF
	Local nOpcA := 0
	Private cPerActual := ""
	Private cPerg := "RPRSSV"
	Private nDias := 0
	Private cProcesso := "00000"  ///TRAER DE LA SRA

	CriaSX1(cPerg)


	FormBatch("Recalculo de vacacion",{OemToAnsi("Rutina que permite ajustar"),OemToAnsi("el saldo de vacaciones")},;
		{ { 5,.T.,{|o| Pergunte(cPerg,.T.) }},;
		{ 1,.T.,{|o| nOpcA := 1,o:oWnd:End()}},;
		{ 2,.T.,{|o| nOpca := 2,o:oWnd:End()}}})


	If ( nOpcA==1 )  ///ok?

		if empty(MV_PAR02) .and. empty(MV_PAR04) .and. empty(MV_PAR07)

			alert("Registre las preguntas correctamente")
			Pergunte(cPerg,.T.)

		endif

		cProcesso = ALLTRIM(MV_PAR07)

		cPerActual = getOpenPeriod(cProcesso)

		cLogText := "Funcion   - "+ FunName()       + CRLF
		cLogText += "Usuario  - "+ cUserName       + CRLF
		cLogText += "Fecha     - "+ dToC(dDataBase) + CRLF
		cLogText += "Hora     - "+ Time()          + CRLF
		cLogText +=  cQuebra
		cLogText +=  "Preguntas  - " + CRLF
		cLogText +=  "MV_PAR01   - "+  MV_PAR01       + CRLF
		cLogText +=  "MV_PAR02   - "+  MV_PAR02       + CRLF
		cLogText +=  "MV_PAR03   - "+  MV_PAR03       + CRLF
		cLogText +=  "MV_PAR04   - "+  MV_PAR04       + CRLF
		cLogText +=  "MV_PAR05   - "+  MV_PAR05       + CRLF
		cLogText +=  "MV_PAR06   - "+  MV_PAR06       + CRLF
		cLogText +=  "MV_PAR07   - "+  MV_PAR07       + CRLF
		cLogText +=   cQuebra
		cLogText +=  "Ajuste de SR8 - " + CRLF
		cLogText +=  "cQuery2 - " + CRLF

		If Select("CQRYSR8") > 0
			dbSelectArea("CQRYSR8")
			dbCloseArea()
		Endif

		//AJUSTE DE LINEA PARA EMPLEADO
		cQuery2 := "SELECT R8_FILIAL,R8_MAT,R8_DATA,R8_SEQ,R8_DATAINI,R8_DURACAO,R8_DATAFIM,R8_PER,R8_NUMPAGO,R8_NUMID, "
		cQuery2 += "R8_DIASEMP,R8_DPAGAR,R8_SDPAGAR,R8_DPAGOS,R8_STATUS,R8_PROCES,SR8.R_E_C_N_O_,RA_NOME,RA_ADMISSA,RA_DEMISSA "
		cQuery2 += "FROM " + RetSqlName("SR8") + " SR8 "
		cQuery2 += "JOIN " + RetSqlName("SRA") + " SRA ON RA_FILIAL = R8_FILIAL AND RA_MAT = R8_MAT AND SRA.D_E_L_E_T_ = ' ' AND RA_SITFOLH <> 'D' AND RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
		cQuery2 += " WHERE "
		cQuery2 += " R8_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQuery2 += " AND SR8.D_E_L_E_T_ = ' ' AND R8_TIPOAFA = '" + cTipoAFa +"' "
		cQuery2 += " AND SUBSTRING(R8_DATAINI,1,6) <>  SUBSTRING(R8_DATAFIM ,1,6)  "
		cQuery2 += " ORDER BY R8_FILIAL,R8_MAT,R8_DATAINI "

		cQuery2 := ChangeQuery(cQuery2)

		TCQUERY cQuery2 NEW ALIAS "CQRYSR8"

		//cLogText +=  "cQuery2 - " + cQuery2 + CRLF
		cLogText +=  "REGISTROS MODIFICADOS " + CRLF

		////AJUSTA LA TABLA SR8 CUANDO UN REGISTRO DE VACACIÓN CUBRÍA MÁS DE 2 MESES
		while ! CQRYSR8->( eof() )

			dDataIni := STOD(CQRYSR8->R8_DATAINI)  //fecha inicial
			dDataFim := STOD(CQRYSR8->R8_DATAFIM)  //fecha final    20230902

			cPer = CQRYSR8->R8_PER
			cNumPago = CQRYSR8->R8_NUMPAGO

			nNroMeses := DATEDIFFMONTH( dDataIni , dDataFim ) + 1   /// ES MAYOR A 3 MESES?

			nMedioDia = 0
			if CQRYSR8->R8_DURACAO - int(CQRYSR8->R8_DURACAO) > 0		// si la vacación solo fue medio día 
				nMedioDia = 0.5
			endif		

			Begin Transaction
				for i := 1 to nNroMeses
					if i == 1 .and. i <> nNroMeses ///si es el primero pero no el ultimo, osea mayor a uno en total

						dDtFimTemp = LASTDATE(dDataIni) ///sacamos el ultimo dia del mismo mes
						nDias = 0
						GpeCalend(,,,,,dDataIni,dDtFimTemp,@nDias,"D", cCampo,,,,,cPer,cNumPago)

						DbselectArea("SR8")
						dbGoto(CQRYSR8->R_E_C_N_O_)

						////CONSULTAMOS QUE HABIA ANTES
						cXLog  = "ANTES:   " 
						cXLog += "MATRICULA " + SR8->R8_MAT 	
						cXLog += " - R8_DATAINI " + dtoc(SR8->R8_DATAINI) 	
						cXLog += " - R8_DURACAO " + cValtochar(SR8->R8_DURACAO)
						cXLog += " - R8_DATAFIM " + dtoc(SR8->R8_DATAFIM) 
						cXLog += " - R8_DPAGAR " + cValtochar(SR8->R8_DPAGAR) 
						cXLog += " - R8_SDPAGAR " + cValtochar(SR8->R8_SDPAGAR) 
						cXLog += " - R8_DPAGOS " + cValtochar(SR8->R8_DPAGOS)
						cXLog += " - R8_PER " + SR8->R8_PER
						cXLog += " - R8_NUMID " + SR8->R8_NUMID 
						cXLog += " - RECNO " + cValtochar(CQRYSR8->R_E_C_N_O_) + CRLF
						cLogText += cXLog + CRLF

						//actualizamos la SR8
						RecLock("SR8",.F.)
						SR8->R8_DURACAO	:= nDias
						SR8->R8_DATAFIM	:= dDtFimTemp
						SR8->R8_DPAGAR	:= nDias
						SR8->R8_SDPAGAR	:= 0
						SR8->R8_DPAGOS	:= nDias
						SR8->R8_PER := MESANO(dDtFimTemp)
						SR8->R8_NUMID	:= ALLTRIM(SR8->R8_NUMID)+"-AJ"
						MsUnLock()

						cXLog  = "DESPUES: "
						cXLog += "MATRICULA " + SR8->R8_MAT 		
						cXLog += " - R8_DATAINI " + dtoc(SR8->R8_DATAINI) 	
						cXLog += " - R8_DURACAO " + cValtochar(SR8->R8_DURACAO)
						cXLog += " - R8_DATAFIM " + dtoc(SR8->R8_DATAFIM) 
						cXLog += " - R8_DPAGAR " + cValtochar(SR8->R8_DPAGAR) 
						cXLog += " - R8_SDPAGAR " + cValtochar(SR8->R8_SDPAGAR) 
						cXLog += " - R8_DPAGOS " + cValtochar(SR8->R8_DPAGOS)
						cXLog += " - R8_PER " + SR8->R8_PER
						cXLog += " - R8_NUMID " + SR8->R8_NUMID 
						cXLog += " - RECNO " + cValtochar(CQRYSR8->R_E_C_N_O_) + CRLF
						cLogText += cXLog + CRLF
						cLogText += cQuebra

					else
						//si es el segundo o mas, sumamos los meses
						dNewdataini = MonthSum(dDataIni, 1)    //202308 + 1 = 202309
						dDataIni = FIRSTDATE(dNewdataini)   ///OBTENEMOS EL PRIMER DIA DEL NUEVO MES  --->   20230901

						if i == nNroMeses ///ya llegamos al final toma la fecha final mas la inicial
							nDias = 0
							cPer = MESANO(dDataIni)
							GpeCalend(,,,,,dDataIni,dDataFim,@nDias,"D", cCampo,,,,,cPer,cNumPago)   // 20230901   20230902
							
							nDias -= nMedioDia

							//actualizamos la SR8
							if lInsert

								RecLock("SR8",.T.)
								SR8->R8_FILIAL	:= CQRYSR8->R8_FILIAL
								SR8->R8_MAT	:= CQRYSR8->R8_MAT
								SR8->R8_DATA	:= STOD(CQRYSR8->R8_DATA)     ///PONER TIPO DATA
								SR8->R8_SEQ	:= maxseqr8(CQRYSR8->R8_FILIAL,CQRYSR8->R8_MAT)
								SR8->R8_TIPOAFA	:= cTipoAFa
								SR8->R8_PD	:= cPDVAC
								SR8->R8_CONTINU	:= '2'
								SR8->R8_NUMPAGO	:= CQRYSR8->R8_NUMPAGO
								SR8->R8_VALOR := 0
								SR8->R8_DIASEMP := 999
								SR8->R8_NUMID	:= SUBSTR(CQRYSR8->R8_NUMID,1,12)+DTOS(dDataIni)+"-AJ"								
								SR8->R8_PROCES	:= CQRYSR8->R8_PROCES
								SR8->R8_DNAPLIC	:= 0

								////IMPORTANTE
								SR8->R8_DATAINI	:= dDataIni
								SR8->R8_DURACAO	:= nDias
								SR8->R8_DATAFIM	:= dDataFim
								SR8->R8_DPAGAR	:= nDias   //aca deberian ser los dias a descontar
								SR8->R8_SDPAGAR	:= 0       ////igual a dias con periodo abierto
								SR8->R8_DPAGOS	:= nDias   ///al cerrar periodo cero comienzo y luego se cambia con sdpagar
								SR8->R8_PER := MESANO(dDataFim)
								SR8->R8_STATUS	:= ' '
								MsUnLock()

								cLogText += cQuebra
								cXLog  =  "INCLUSION NUEVO: " 
								cXLog +=  "R8_DATAINI " + dtoc(dDataIni) 
								cXLog +=  " - R8_DURACAO " + cValtochar(nDias) 
								cXLog +=  " - R8_DATAFIM " + dtoc(dDataFim) 
								cXLog +=  " - R8_DPAGAR " + cValtochar(nDias)
								cXLog +=  " - R8_DPAGOS " + cValtochar(nDias)
								cXLog +=  " - R8_PER " + MESANO(dDataFim) 
								cLogText += cXLog + CRLF
								cLogText += cQuebra

							endif

						else /// por aca no entra a no ser que sea mas de 2 meses
							dNewdataini = MonthSum(dDataIni, 1)    //202402 + 1 = 202403
							dDataIni = FIRSTDATE(dNewdataini)
							dDtFimTemp = LASTDATE(dNewdataini)

							nDias = 0
							cPer = MESANO(dDataIni)
							GpeCalend(,,,,,dDataIni,dDtFimTemp,@nDias,"D", cCampo,,,,,cPer,cNumPago)

							//actualizamos la SR8
							if lInsert
								RecLock("SR8",.T.)
								SR8->R8_FILIAL	:= CQRYSR8->R8_FILIAL
								SR8->R8_MAT	:= CQRYSR8->R8_MAT
								SR8->R8_DATA	:= STOD(CQRYSR8->R8_DATA)
								SR8->R8_SEQ	:= maxseqr8(CQRYSR8->R8_FILIAL,CQRYSR8->R8_MAT)
								SR8->R8_TIPOAFA	:= cTipoAFa
								SR8->R8_PD	:= cPDVAC
								SR8->R8_CONTINU	:= '2'
								SR8->R8_NUMPAGO	:= CQRYSR8->R8_NUMPAGO
								SR8->R8_VALOR := 0
								SR8->R8_DIASEMP := 999
								SR8->R8_NUMID	:= SUBSTR(CQRYSR8->R8_NUMID,1,12)+DTOS(dDataIni)+"-AJ"								
								SR8->R8_PROCES	:= CQRYSR8->R8_PROCES
								SR8->R8_DNAPLIC	:= 0

								////IMPORTANTE
								SR8->R8_DATAINI	:= dDataIni
								SR8->R8_DURACAO	:= nDias
								SR8->R8_DATAFIM	:= dDtFimTemp
								SR8->R8_DPAGAR	:= nDias   //aca deberian ser los dias a descontar
								SR8->R8_SDPAGAR	:= 0       ////igual a dias con periodo abierto
								SR8->R8_DPAGOS	:= nDias   ///al cerrar periodo cero comienzo y luego se cambia con sdpagar
								SR8->R8_PER := MESANO(dDtFimTemp)
								SR8->R8_STATUS	:= ' '
								MsUnLock()

								cLogText +=   cQuebra
								cXLog  =  "INCLUSION NUEVO(+): "
								cXLog +=  " - R8_DATAINI " + dtoc(dDataIni)
								cXLog +=  " - R8_DURACAO " + cValtochar(nDias)
								cXLog +=  " - R8_DATAFIM " + dtoc(dDtFimTemp)
								cXLog +=  " - R8_DPAGAR " + cValtochar(nDias)
								cXLog +=  " - R8_DPAGOS " + cValtochar(nDias)
								cXLog +=  " - R8_PER " + MESANO(dDtFimTemp)
								cLogText += cXLog + CRLF
								cLogText += cQuebra

							endif

						endif
					endif
				next

			End Transaction

			CQRYSR8->( DBSKIP() )

		enddo

		cLogText +=   cQuebra
		cLogText +=  "Ajuste de SR8 DIAS INCOMPLETOS NO CERRADOS MAL CALCULADOS- " + CRLF
		//cLogText +=  "cQuery22 - " + CRLF


		nDias = 0
		////AJUSTE SR8 ERROR EN CANTIDAD DE DIAS Y NO CALCULADOS

		If Select("CQRYSR8D") > 0
			dbSelectArea("CQRYSR8D")
			dbCloseArea()
		Endif

		//AJUSTE DE LINEA PARA EMPLEADO
		cQuery22 := "SELECT R8_FILIAL,R8_MAT,R8_DATA,R8_SEQ,R8_DATAINI,R8_DURACAO,R8_DATAFIM,R8_PER,R8_NUMPAGO,R8_NUMID, "
		cQuery22 += "R8_DIASEMP,R8_DPAGAR,R8_SDPAGAR,R8_DPAGOS,R8_STATUS,R8_PROCES,SR8.R_E_C_N_O_,RA_NOME,RA_ADMISSA,RA_DEMISSA "
		cQuery22 += "FROM " + RetSqlName("SR8") + " SR8 "
		cQuery22 += "JOIN " + RetSqlName("SRA") + " SRA ON RA_FILIAL = R8_FILIAL AND RA_MAT = R8_MAT AND SRA.D_E_L_E_T_ = ' ' AND RA_SITFOLH <> 'D' AND RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
		cQuery22 += " WHERE "
		cQuery22 += " R8_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQuery22 += " AND SR8.D_E_L_E_T_ = ' ' "
		cQuery22 += " AND R8_SEQ > '000' AND SUBSTRING(R8_DATAINI,1,6) <> '" + cPerActual + "' AND R8_TIPOAFA = '" + cTipoAFa +"' "
		cQuery22 += " AND (R8_DURACAO <> R8_DPAGAR OR R8_SDPAGAR <> 0 OR R8_DPAGAR <> R8_DPAGOS OR R8_STATUS <> 'C')  "
		cQuery22 += " ORDER BY R8_FILIAL,R8_MAT,R8_DATAINI "

		cQuery22 := ChangeQuery(cQuery22)

		TCQUERY cQuery22 NEW ALIAS "CQRYSR8D"

		//cLogText +=  "cQuery22 - " + cQuery22 + CRLF
		cLogText +=  "REGISTROS MODIFICADOS " + CRLF


		////AJUSTA LA TABLA SR8
		while ! CQRYSR8D->( eof() )

			Begin Transaction

				dDataIni := STOD(CQRYSR8D->R8_DATAINI)  //fecha inicial
				dDataFim := STOD(CQRYSR8D->R8_DATAFIM)  //fecha final    20230902

				cPer = CQRYSR8D->R8_PER
				cNumPago = CQRYSR8D->R8_NUMPAGO

				nDias = 0
				GpeCalend(,,,,,dDataIni,dDataFim,@nDias,"D", cCampo,,,,,cPer,cNumPago)
				
				DbselectArea("SR8")
				dbGoto(CQRYSR8D->R_E_C_N_O_)

				if nDias - int(SR8->R8_DURACAO) > 0		// si la vacación solo fue medio día 
					nDias -= 0.5
				endif				

				cXLog  =  "ANTES:   "
				cXLog +=  "MATRICULA " + SR8->R8_MAT
				cXLog +=  " - R8_DURACAO " + cValtochar(SR8->R8_DURACAO)
				cXLog +=  " - R8_DPAGAR " + cValtochar(SR8->R8_DPAGAR)
				cXLog +=  " - R8_SDPAGAR " + cValtochar(SR8->R8_SDPAGAR)
				cXLog +=  " - R8_DPAGOS " + cValtochar(SR8->R8_DPAGOS)
				cXLog +=  " - R8_STATUS " + cValtochar(SR8->R8_STATUS)
				cXLog +=  " - R8_PER " + cValtochar(SR8->R8_PER)
				cXLog +=  " - RECNO " + cValtochar(CQRYSR8D->R_E_C_N_O_)
				cLogText += cXLog + CRLF

				//actualizamos la SR8
				RecLock("SR8",.F.)
				SR8->R8_DURACAO	:= nDias
				SR8->R8_DPAGAR	:= nDias
				SR8->R8_SDPAGAR	:= 0
				SR8->R8_DPAGOS	:= nDias
				SR8->R8_NUMID	:= ALLTRIM(SR8->R8_NUMID)+"-AJ"
				SR8->R8_STATUS	:= "C"
				SR8->R8_PER	:= MESANO(SR8->R8_DATAINI)
				MsUnLock()

				cXLog  =  "DESPUES: "
				cXLog +=  "MATRICULA " + SR8->R8_MAT
				cXLog +=  " - R8_DURACAO " + cValtochar(SR8->R8_DURACAO)
				cXLog +=  " - R8_DPAGAR " + cValtochar(SR8->R8_DPAGAR)
				cXLog +=  " - R8_SDPAGAR " + cValtochar(SR8->R8_SDPAGAR)
				cXLog +=  " - R8_DPAGOS " + cValtochar(SR8->R8_DPAGOS)
				cXLog +=  " - R8_STATUS " + cValtochar(SR8->R8_STATUS)
				cXLog +=  " - R8_PER " + cValtochar(SR8->R8_PER)
				cXLog +=  " - RECNO " + cValtochar(CQRYSR8D->R_E_C_N_O_)
				cLogText += cXLog + CRLF
				cLogText +=   cQuebra

			end Transaction

			CQRYSR8D->( DBSKIP() )

		enddo

		cLogText +=   cQuebra
		cLogText +=  "Ajuste de LINEA SRD PERIODO CERRADO- " + CRLF
		//cLogText +=  "cQuery3 - " + CRLF

		///AJUSTAMOS SRD

		If Select("CQRYSRD") > 0
			dbSelectArea("CQRYSRD")
			dbCloseArea()
		Endif

		//AJUSTE DE LINEA PARA EMPLEADO   **ignorar periodo abierto
		cQuery3 := "SELECT   (SELECT SUM(SR8.R8_DPAGOS) "
		cQuery3 += "FROM " + RetSqlName("SR8") + " SR8 "
		cQuery3 += "WHERE SRD.RD_FILIAL = SR8.R8_FILIAL AND SRD.RD_MAT = SR8.R8_MAT "
		cQuery3 += "AND SRD.RD_PERIODO = SR8.R8_PER AND SR8.D_E_L_E_T_ = '' AND R8_TIPOAFA = 'VAC' AND R8_SEQ > '000' "
		cQuery3 += ")  NUEVODIAS,SRD.R_E_C_N_O_,RD_FILIAL,RD_MAT,RD_PERIODO,RA_CC,RA_SALARIO,RA_DEPTO "
		cQuery3 += "FROM " + RetSqlName("SRD") + " SRD "
		cQuery3 += "JOIN " + RetSqlName("SRA") + " SRA ON RD_FILIAL = RA_FILIAL AND RA_MAT = RD_MAT AND SRA.D_E_L_E_T_ = ' ' AND RA_RESCRAI NOT IN('30','31') "
		cQuery3 += "WHERE SRD.D_E_L_E_T_ = '' AND SRD.RD_PD = '"+cPDVAC+"' AND RD_MAT BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04+"' AND RD_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery3 += " UNION "
		cQuery3 += "SELECT R8_DPAGOS,SRD.R_E_C_N_O_,R8_FILIAL,R8_MAT,R8_PER,RA_CC,RA_SALARIO,RA_DEPTO   "
		cQuery3 += "FROM(   "
		cQuery3 += "SELECT SUM(R8_DPAGOS) R8_DPAGOS,R8_FILIAL,R8_MAT,R8_PER,RA_CC,RA_SALARIO,RA_DEPTO "
		cQuery3 += "FROM " + RetSqlName("SR8") + " SR8 "
		cQuery3 += "JOIN " + RetSqlName("SRA") + " SRA ON R8_FILIAL = RA_FILIAL AND RA_MAT = R8_MAT AND SRA.D_E_L_E_T_ = ' ' AND RA_RESCRAI NOT IN('30','31') "
		cQuery3 += "WHERE R8_TIPOAFA = 'VAC' AND SR8.D_E_L_E_T_ = ' ' AND R8_SEQ > '000' "
		cQuery3 += "AND R8_MAT BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04+"' AND R8_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
		cQuery3 += "GROUP BY R8_FILIAL,R8_MAT,R8_PER,RA_CC,RA_SALARIO,RA_DEPTO )TAB "
		cQuery3 += "LEFT JOIN SRD010 SRD ON TAB.R8_FILIAL = RD_FILIAL AND TAB.R8_MAT = RD_MAT AND RD_PERIODO = TAB.R8_PER AND SRD.D_E_L_E_T_ = ' ' "
		cQuery3 += "AND RD_PD = '"+cPDVAC+"' "
		cQuery3 += "WHERE SRD.R_E_C_N_O_ IS NULL ORDER BY RD_PERIODO "

		cQuery3 := ChangeQuery(cQuery3)

		TCQUERY cQuery3 NEW ALIAS "CQRYSRD"

		//cLogText +=  "cQuery3 - " + cQuery3 + CRLF
		cLogText +=  "REGISTROS MODIFICADOS " + CRLF

		Begin Transaction
			////AJUSTA LA TABLA SRD
			while ! CQRYSRD->( eof() )

				nPagSum = NUEVODIAS
				cxdFilial = CQRYSRD->RD_FILIAL
				cxdMat = CQRYSRD->RD_MAT

				IF CQRYSRD->R_E_C_N_O_ == 0
					///INCLUIR SRD SI ES NULO
					cLogText +=  "INCLUSION SRD MAT: " + cxdMat + " - DIAS " + cValtochar(nPagSum) + " - PERIODO " + CQRYSRD->RD_PERIODO + CRLF

					Reclock("SRD",.T.)
					SRD->RD_FILIAL:= cxdFilial
					SRD->RD_MAT:= cxdMat
					SRD->RD_PD:= cPDVAC
					SRD->RD_TIPO1:= "V"
					SRD->RD_QTDSEM:= 0
					SRD->RD_HORINFO:= nPagSum
					SRD->RD_HORAS:= nPagSum

					///CALCULAR VALOR
					SRD->RD_VALINFO:= ROUND((CQRYSRD->RA_SALARIO / 30) * nPagSum,2)
					SRD->RD_VALOR:= ROUND((CQRYSRD->RA_SALARIO / 30) * nPagSum,2)

					SRD->RD_VNAOAPL:= 0
					SRD->RD_DATARQ:= CQRYSRD->RD_PERIODO
					SRD->RD_DATPGT:= LASTDATE(STOD(CQRYSRD->RD_PERIODO+"01"))
					SRD->RD_CC:=   CQRYSRD->RA_CC ////TRAER CC SRA
					SRD->RD_SEQ:= '1'
					SRD->RD_TIPO2:= 'C'
					SRD->RD_STATUS:= 'A'
					SRD->RD_INSS:= 'N'
					SRD->RD_IR:= 'N'
					SRD->RD_PROCES:= cProcesso
					SRD->RD_PERIODO:= CQRYSRD->RD_PERIODO
					SRD->RD_SEMANA:= '01'
					SRD->RD_ROTEIR:= 'FOL'
					SRD->RD_DTREF:= LASTDATE(STOD(CQRYSRD->RD_PERIODO+"01"))
					SRD->RD_MES:= STRZERO(MONTH(STOD(CQRYSRD->RD_PERIODO+"01")),2)
					SRD->RD_DEPTO:= CQRYSRD->RA_DEPTO
					SRD->RD_VALORBA := 0
					MsUnLock()

				ELSE   //CUANDO HAY SRD

					//vamos a la SRD para modificar
					dbSelectArea("SRD")
					dbGoto(CQRYSRD->R_E_C_N_O_)

					IF nPagSum <> NIL  //QUIERE DECIR SI TIENE SR8 SINO TIENE SE TIENE QUE BORRAR LA SRD
						///preguntamos si esta diferente sino no actualizamos nada
						if SRD->RD_HORAS <> nPagSum
							///valor a actualizar
							nValAtu = SRD->RD_VALOR
							nHorAnt = SRD->RD_HORAS
							nValTot = nValAtu / nHorAnt

							cLogText +=  "MODIFICA SRD MAT: " + cxdMat + " DIAS " + cValtochar(nPagSum) + CRLF
							cXLog  =  "ANTES: "
							cXLog +=  " - RD_HORAS " + cValtochar(SRD->RD_HORAS) 
							cXLog +=  " - RD_HORINFO " + cValtochar(SRD->RD_HORINFO)
							cXLog +=  " - RD_VALOR " + cValtochar(SRD->RD_VALOR) 
							cXLog +=  " - RD_VALINFO " + cValtochar(SRD->RD_VALINFO)
							cLogText += cXLog + CRLF

							Reclock("SRD",.f.)
							SRD->RD_HORAS := nPagSum
							SRD->RD_HORINFO := nPagSum
							SRD->RD_VALOR := ROUND(nValTot * nPagSum,2)   ///VALOR ANTERIOR POR NUEVAS HORAS(DIAS)
							SRD->RD_VALINFO := ROUND(nValTot * nPagSum,2)
							MsUnLock()

							cXLog  =  "DESPUES: "
							cXLog +=  " - RD_HORAS " + cValtochar(SRD->RD_HORAS) 
							cXLog +=  " - RD_HORINFO " + cValtochar(SRD->RD_HORINFO)
							cXLog +=  " - RD_VALOR " + cValtochar(SRD->RD_VALOR) 
							cXLog +=  " - RD_VALINFO " + cValtochar(SRD->RD_VALINFO)
							cLogText += cXLog + CRLF
						ENDIF
					ELSE
						cLogText +=  "BORRO SRD MAT: " + cxdMat + " DIAS " + cValtochar(nPagSum) + " - RECNO: " + cValtochar(CQRYSRD->R_E_C_N_O_) + CRLF
						/////BORRAR SRD
						Reclock("SRD")
						dbDelete()
						MsUnlock()
					ENDIF
				ENDIF


				CQRYSRD->( DBSKIP() )

			enddo
		END Transaction

		cLogText +=   cQuebra
		cLogText +=  "Ajuste de LINEA SRF DIAS Y DISPONIBLES - " + CRLF
		//cLogText +=  "cQuery5 - " + CRLF

		///AJUSTAR SRF

		If Select("cQrySRF") > 0
			dbSelectArea("cQrySRF")
			dbCloseArea()
		Endif

		//AJUSTE DE LINEA PARA EMPLEADO   **ignorar periodo abierto
		cQuery5 := "SELECT RA_FILIAL,RA_MAT,SUM(R8_DPAGOS) R8_DPAGOS "
		cQuery5 += "FROM " + RetSqlName("SR8") + " SR8 "
		cQuery5 += "JOIN " + RetSqlName("SRA") + " SRA ON RA_FILIAL = R8_FILIAL AND RA_MAT = R8_MAT AND SRA.D_E_L_E_T_ = ' ' AND RA_SITFOLH <> 'D' AND RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND RA_RESCRAI NOT IN('30','31') "
		cQuery5 += " WHERE "
		cQuery5 += " R8_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "
		cQuery5 += " SR8.D_E_L_E_T_ = ' ' AND R8_TIPOAFA = '" + cTipoAFa +"' "
		cQuery5 += " GROUP BY RA_FILIAL,RA_MAT "

		cQuery5 := ChangeQuery(cQuery5)

		TCQUERY cQuery5 NEW ALIAS "cQrySRF"

		//cLogText +=  "cQuery5 - " + cQuery5 + CRLF
		cLogText +=   cQuebra

		cxdFilial = ""
		cxdMat = ""
		nPagSum = 0

		BEGIN Transaction
			////AJUSTA LA TABLA SR8
			while cQrySRF->( !eof() )

				cxdFilial = cQrySRF->RA_FILIAL
				cxdMat = cQrySRF->RA_MAT
				nPagSum = cQrySRF->R8_DPAGOS

				If Select("cQrySRFIN") > 0
					dbSelectArea("cQrySRFIN")
					dbCloseArea()
				Endif

				//AJUSTE DE LINEA PARA EMPLEADO   **ignorar periodo abierto
				cQuery6 := "SELECT SRF.R_E_C_N_O_ R_E_C_N_O_ "
				cQuery6 += "FROM " + RetSqlName("SRF") + " SRF "
				cQuery6 += "JOIN " + RetSqlName("SRA") + " SRA ON RA_FILIAL = RF_FILIAL AND RA_MAT = RF_MAT AND SRA.D_E_L_E_T_ = ' ' AND RA_SITFOLH <> 'D' AND RA_MAT = '" + cxdMat + "' AND RA_RESCRAI NOT IN('30','31') "
				cQuery6 += " WHERE "
				cQuery6 += " RF_FILIAL = '" + cxdFilial + "' AND "
				cQuery6 += " SRF.D_E_L_E_T_ = ' ' ORDER BY RF_DATABAS "

				cQuery6 := ChangeQuery(cQuery6)

				TCQUERY cQuery6 NEW ALIAS "cQrySRFIN"

				//RecCount()

				//Count To nTotReg

				///RECORREMOS Y VAMOS RESTANDO, HAY QUE SABER CUANTOS REGISTROS HAY PARA PONERLO SI SOBRA EN EL ULTIMO				

				WHILE cQrySRFIN->( !eof() )

					dbSelectArea("SRF")
					dbGoto(cQrySRFIN->R_E_C_N_O_)

					if nPagSum > 0
						///VEAMOS EL DISPONIBLE
						nDispon = SRF->RF_DFERVAT + SRF->RF_DFERAAT  // 15    30

						if nDispon <= nPagSum  ///tenes mas vacacion o SR8

							nPagSum = nPagSum - nDispon ///281 - 15    266

							if SRF->RF_DFERANT <> nDispon  ///necesita ser cambiado?
								///log
								cXLog  = "RECNO SRF " + cValtochar(cQrySRFIN->R_E_C_N_O_)
								cXLog += " | MATRICULA " + cxdMat
								cXLog += " | RF_DFERANT ANTES: " + cValtochar(SRF->RF_DFERANT)
								Reclock("SRF",.f.)
								SRF->RF_DFERANT := nDispon
								MsUnLock()
								cXLog +=  " | DESPUES: " + cValtochar(SRF->RF_DFERANT)
							endif
						else

							if SRF->RF_DFERANT <> nPagSum

								cXLog  = "RECNO SRF " + cValtochar(cQrySRFIN->R_E_C_N_O_)
								cXLog += " | MATRICULA " + cxdMat
								cXLog += " | RF_DFERANT ANTES: " + cValtochar(SRF->RF_DFERANT)

								Reclock("SRF",.f.)
								SRF->RF_DFERANT := nPagSum
								MsUnLock()
								cXLog +=  " | DESPUES: " + cValtochar(SRF->RF_DFERANT)
							endif
							nPagSum = 0

						endif
					else   /////si termino el saldo para ajustar DFERANT
						if SRF->RF_DFERANT > 0

							cXLog  = "RECNO SRF " + cValtochar(cQrySRFIN->R_E_C_N_O_)
							cXLog += " | MATRICULA " + cxdMat
							cXLog += "RF_DFERANT CON SALDO ANTES: " + cValtochar(SRF->RF_DFERANT)

							Reclock("SRF",.f.)
							SRF->RF_DFERANT := 0
							MsUnLock()

							cXLog +=  " | DESPUES - " + cValtochar(SRF->RF_DFERANT)
						endif
					endif

					Reclock("SRF",.f.)
					if SRF->RF_DIASDIR == SRF->RF_DFERANT .AND. SRF->RF_STATUS <> '3'			
						SRF->RF_STATUS = '3'
						cXLog  = "RECNO SRF " + cValtochar(cQrySRFIN->R_E_C_N_O_)
						cXLog += " | MATRICULA " + cxdMat
						cXLog += " ESTATUS: " + SRF->RF_STATUS
					ELSEIF SRF->RF_DIASDIR > SRF->RF_DFERANT .AND. SRF->RF_STATUS <> '1'
						SRF->RF_STATUS = '1'	
						cXLog  = "RECNO SRF " + cValtochar(cQrySRFIN->R_E_C_N_O_)
						cXLog += " | MATRICULA " + cxdMat	
						cXLog += " ESTATUS: " + SRF->RF_STATUS							
					ENDIF
					MsUnLock()
					cLogText += cXLog + CRLF
					cQrySRFIN->( DBSKIP() )

				ENDDO

				cQrySRF->( DBSKIP() )

			enddo

		END Transaction

		////hay una inconsistencia en SRF Y SR8
		if nPagSum > 0
			cLogText +=  "inconsistencia en SRF Y SR8 - " + cValtochar(nPagSum) + CRLF
		endif

		cLogText +=   cQuebra
		cLogText +=  "FIN DE PROCESAMIENTO" + CRLF
		cLogText +=   cQuebra
		Aviso("FIN DE PROCESO LOG",cLogText,{'ok'},,,,,.t.)

	EndIf

	RestArea( aArea )

return

Static Function CriaSX1(cPerg)  // Crear Preguntas

	xPutSX1(cPerg, "01", "Filial De ?" , "¿De Sucursal ?", "Branch From ?", "MV_CH1","C",04,0,0,"G","","SM0","033","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "02", "Filial Ate ?" , "¿A Sucursal ?", "Branch to ?", "MV_CH2","C",04,0,0,"G","naovazio()","SM0","033","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "03", "Matricula De ?" , "¿De matricula ?", "Registration From ?", "MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "04", "Matricula Ate ?" , "¿A matricula ?", "Registration To ?", "MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "05","¿De Centro de costo?" 	, "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH5","C",11,0,0,"G","","CTT","004","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "06","¿A Centro de costo?" 	, "¿A Centro de costo?"		,"¿A Centro de costo?"	,"MV_CH6","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "07","¿Proceso?"				, "¿Proceso?"				,"¿Proceso?"			,"MV_CH7","C",50,0,0,"G","","RCJ","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")

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

	// Ajusta o tamanho do grupo. Ajuste emergencial para validaÃ§Ã£o dos fontes.
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

static function maxseqr8(cxFilial,cxMat)
	Local _cRet		:= ""
	Local _aArea	:= GetArea()
	Local _cQuery	:= ""

	/*
SELECT MAX(R8_SEQ) R8_SEQ FROM SR8010
WHERE R8_MAT = '000038'
AND R8_FILIAL = '0000'
AND D_E_L_E_T_ = ' '*/

	_cQuery := " SELECT MAX(R8_SEQ) MAXSEQ "
	_cQuery += " FROM " + RetSqlName("SR8") + " SR8 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' AND R8_MAT = '" + cxMat + "' "
	_cQuery += " AND R8_FILIAL = '" + cxFilial + "' "

		// Aviso("",_cQuery,{'ok'},,,,,.t.)

	If Select("strSQL")>0
		strSQL->(dbCloseArea())
	End

	TcQuery _cQuery New Alias "strSQL"

	if empty(strSQL->MAXSEQ) .or. 	strSQL->MAXSEQ == nil
		_cRet := StrZero(0 + 1, 3)
	else
		nValCorr := quitZero(strSQL->MAXSEQ) //QUITA CEROS
		nValCorr = val(nValCorr)
		_cRet := StrZero(nValCorr + 1, 3)
	endif

	RestArea(_aArea)

Return _cRet

static Function quitZero(cTexto)
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

	While lContinua

		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
		EndIf

		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)

Return cRetorno

Static Function getOpenPeriod(cProceso)
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local cNextAlias:= GetNextAlias()

	// consulta a la base de datos
	BeginSql Alias cNextAlias

    SELECT TOP 1 RCH_PER
    FROM %table:RCH%
    WHERE RCH_FILIAL = %exp:xFilial("RCH")%
    AND RCH_ROTEIR = 'FOL'
    AND RCH_PERSEL = '1'
	AND RCH_PROCES = %exp:cProceso%
    AND %notdel%

	EndSql
	DbSelectArea(cNextAlias)
	If (cNextAlias)->(!Eof())
		cRet:= TRIM((cNextAlias)->RCH_PER)
	endIf

	restArea(aArea)

Return cRet
