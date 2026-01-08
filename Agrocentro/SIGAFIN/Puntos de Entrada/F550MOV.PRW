#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
/*    
    Jorge Saavedra
    04/12/2021
    P.E. para Seleccionar el banco donde se quiere hacer la devolucion de saldos
*/

User Function F550MOV()
	If AllTrim(FunName())=="FINA550"
		IF !(Type('aReposi') == 'U')
			IF SEU->EU_TIPO == '11'

				/*
				If Type("cxTrbGlo")=="C"
					RecLock("SE5", .F.)
					SE5->E5_UGLOSA := cxTrbGlo
					SE5->(MsUnLock())

				endif*/

				if Type("cxCaixGlo")=="C"
				////POSICIONAR SE5 21 E5_FILIAL+E5_IDORIG+E5_TIPODOC
					aAreaSE5 := SE5->(GetArea())

					DbSelectArea("SE5")
					SE5->(DbSetOrder(21))
					If SE5->(DbSeek(xFilial("SE5")+ FK5->FK5_IDMOV+FK5->FK5_TPDOC ))
						While SE5->(!EoF()) .and. SE5->E5_IDORIG+E5_TIPODOC == FK5->FK5_IDMOV+FK5->FK5_TPDOC
							RECLOCK( "SE5", .F. )
							SE5->E5_UGLOSA := cxCaixGlo
							MSUNLOCK()
							SE5->(DbSkip())
						EndDo
					Endif

					RestArea(aAreaSE5)
				endif

				IF !EMPTY(ALLTRIM(SET->ET_XBCOTEM))
					_BancoTem := StrTokArr(alltrim(SET->ET_XBCOTEM) ,'|')

					RecLock("SET",.F.)
					SET->ET_BANCO:= 	_BancoTem[1]
					SET->ET_AGEBCO:= 	_BancoTem[2]
					SET->ET_CTABCO:= 	_BancoTem[3]
					SET->ET_XBCOTEM := ""
					MsUnLock()
				END
			END
		ENDIF
	EndIf
Return


