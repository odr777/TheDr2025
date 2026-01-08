#INCLUDE 'PROTHEUS.CH'


// Al Generar las orden se servicio Rellena automáticamente valores en la Solicitud del almacen
// Nahim Terrazas 25/11/2019



User Function MT105GRV()
	Local nOpcap := PARAMIXB

	IF FUNNAME() $ "MNTA420|MNTA410|MNTA340|MNTA365|MNTA490" // si estoy ejecutandoló desde la rutina de Mant. Activos (Servicios)
		dbselectArea("SN3") // T9_FILIAL+T9_CODBEM
		dbsetorder(1)
		
		
		If dbSeek( xFilial("SN3") + SUBSTR(ST9->T9_CODIMOB,1,10) )
			cClaseValor :=  SN3->N3_CLVL
		EndIf
		//	cDesc := "Orden servicio : " + SUBSTR(SCP->CP_OP,1,6) + " - Generada por Mant. del Bien: "  + STJ->TJ_ORDEM //+ ST9->T9_CODIMOB
		cDesc := "Orden servicio : " + SUBSTR(SCP->CP_OP,1,6) + " - Generada por Mant. del Bien: "  + ST9->T9_CODBEM //+ ST9->T9_CODIMOB

		RecLock('SCP',.F.)
		//	Replace SCP->CP_NUMOS  With SUBSTR(SCP->CP_OP,1,6)
		Replace SCP->CP_NUMOS  With SUBSTR(SCP->CP_OP,1,6)
		Replace SCP->CP_CLVL  With cClaseValor
		Replace SCP->CP_OBS  With cDesc
		//		SX1->X1_CNT01 := aRegOrPag[1][1] //SEK->EK_ORDPAGO// DTOS(CT2->CT2_DATA)
		SCP->(MsUnlock())
	ENDIF

Return
