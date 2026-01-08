#include "totvs.ch"

/*/{Protheus.doc} 410SAIDA
Menu para informe
@type function
@version 1.0
@author Luiz Fael
@since 16/11/2022
/*/
User Function 410SAIDA()
	Local   aArea		:= GetArea()
	Local   aPar 		:= {}
	Local   aRetPrb   	:= {}
	Local   aLayOut 	:= {"Factura", "Descpacho"}
	Local 	cNota		:=''
	Local 	cSucursal	:=''
	Local 	cNum		:=''
	Private cUser 		:= ''
	Private cDocName	:= ""
	Private cDir 		:= Space(120)

	If FUNNAME() $ "MATA462N"
		dbSelectArea( "SC5" )
		dbSetOrder( 1 )//C5_FILIAL+C5_NUM
		DBSEEK( SD2->D2_FILIAL + SD2->D2_PEDIDO)
	ENDIF
	
	//If !Empty(SC5->C5_NOTA)

		aAdd(aPar,{9,"Sucursal"+Space(20)+SC5->C5_FILIAL   ,100,100,.T.})
		aAdd(aPar,{9,"Orden de venta"+space(5)+SC5->C5_NUM ,100,100,.T.})
		aAdd(aPar,{2,"Tipo","1", aLayOut, 080,'.T.',.T.})
		aAdd(aPar,{6,"Guardar archivo en ", cDir,"","","",080,.T.,"*.PDF",,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})
	
		If ParamBox(aPar,"",@aRetPrb, , , , , , ,"oCpdf",.F., .F.)
			MV_PAR1	:= SC5->C5_FILIAL 		//Filial
			MV_PAR2	:= SC5->C5_NUM 			//Pedido
			MV_PAR3	:= aRetPrb[3] 			//Lay Oout
			MV_PAR4	:= Alltrim(aRetPrb[4]) 	//DIRETORIO
			
			If lRemitd2()		
				If !Empty(MV_PAR4)
					If MV_PAR3 = 'Factura'
						If  cPaisLoc == "ARG" .OR. cPaisLoc == "BOL"
							U_COL010()
						Elseif cPaisLoc == "ENG"
							U_USA010()
						Else
							U_BRA010()
						EndIf
					ElseIf MV_PAR3 = 'Descpacho'
						If  cPaisLoc == "ARG" .OR. cPaisLoc == "BOL"
							U_COL020()
						Elseif cPaisLoc == "ENG"
							U_USA020()
						Else
							U_BRA020()
						EndIf
					EndIf
				ELSE
					MsgStop("¡La ubicación para grabar el archivo no fue informada! ")
				EndIf
			Else
				MsgStop("¡Pedido de venta sin Datos! ")
			EndIf
			/*If lRemitd2()
				If !Empty(MV_PAR4)
					If MV_PAR3 = 'Factura'
						U_COL010()
					ElseIf MV_PAR3 = 'Despacho'
						U_COL020()
					EndIf
				ELSE
					MsgStop("¡La ubicación para grabar el archivo no fue informada! ")
				EndIf
			else
				MsgStop("¡Pedido de venta sin Datos! ")
			endif*/
		EndIf
	
	RestArea(aArea)
	FwFreeArray(aPar)
	FwFreeArray(aRetPrb)
Return

Static Function lRemitd2()
	Local aArea			:= getArea()
	Local lRet			:= .f.
	Local cAliasQry		:= GetNextAlias()
	Local cQuery		:= ""

	cQuery += "SELECT DISTINCT SF2.F2_DOC "
	cQuery += "FROM " + RetSQLName("SC5") + " SC5 "
	cQuery += "    INNER JOIN " + RetSQLName("SD2") + " SD2 "
	cQuery += "		     ON (SD2.D2_FILIAL = '" +MV_PAR1+ "' "
	cQuery += "			 AND SD2.D2_PEDIDO = '" +MV_PAR2+ "' "
	cQuery += "			 AND SD2.D_E_L_E_T_ = ' ')  "
	cQuery += "    INNER JOIN " + RetSQLName("SF2") + " SF2 "
	cQuery += "		    ON (SF2.F2_FILIAL   = SD2.D2_FILIAL "
	cQuery += "			AND SF2.F2_DOC   	= SD2.D2_DOC    "
	cQuery += "			AND SF2.F2_SERIE 	= SD2.D2_SERIE  "
	cQuery += "			AND SF2.D_E_L_E_T_ = ' ')
	cQuery += "WHERE "
	cQuery += " 		SC5.C5_FILIAL     = '" +MV_PAR1+ "' "
	cQuery += "         AND SC5.C5_NUM    = '" +MV_PAR2+ "' "
	cQuery += "         AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SF2.F2_DOC"

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	IF (cAliasQry)->( !EOF() )
		lRet := .t.
	EnDIF

	restArea(aArea)

Return lRet
