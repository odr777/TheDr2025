#include 'protheus.ch'
#include "Topconn.ch"

/**
Ponto de entrada que permite realizar operações após gravação na rotina de parte diária (MNTA851)

Nahim Terrazas 03/07/2020


**/


User Function MNTA851B()
/*
    Local nOperat := PARAMIXB[1] // nOpcx
    Local cFilTV1 := PARAMIXB[2] // M->TV1_FILIAL
    Local cEmpTv1 := PARAMIXB[3] // M->TV1_EMPRES
    Local cBemTv1 := PARAMIXB[4] // M->TV1_CODBEM
    Local dDtTv1  := PARAMIXB[5] // M->TV1_DTSERV
    Local aHeader := PARAMIXB[6] // oGet:aHeader
    Local aCols   := PARAMIXB[7] // oGet:aCols
    Local cKey    := cFilTV1 + cEmpTv1 + cBemTv1 + dtos( dDtTv1 )
    Local cMesage := ''
    Local nIndex  := 0
    Local nCodati := aScan( aHeader ,{ |x| AllTrim( Upper( X[2] ) ) == "TV2_CODATI" } )
    Local nHrini  := aScan( aHeader ,{ |x| AllTrim( Upper( X[2] ) ) == "TV2_HRINI" } )
    Local nHrFim  := aScan( aHeader ,{ |x| AllTrim( Upper( X[2] ) ) == "TV2_HRFIM" } )

    If nOperat == 3
        cMesage += 'INCLUSÃO DE PARTE DIÁRIA'
    ElseIf nOperat == 4
        cMesage += 'ALTERAÇÃO DE PARTE DIÁRIA'
    ElseIf nOperat == 5
        cMesage += 'EXCLUSÃO DE PARTE DIÁRIA'
    EndIf

    If IsInCallStack("MNTA852")
        cMesage += ' - Rotina MNTA852' + CRLF + CRLF
    Else
        cMesage += ' - Rotina MNTA851' + CRLF + CRLF
    EndIf

    cMesage += 'Bem: ' + Alltrim( cBemTv1 ) + ' - data: ' + DToC( dDtTv1 )  + CRLF

    
    If Isblind() // sem interface -  Cuando lo hace desde TOP Nahim 21/07/2020
        dbSelectArea('TV1')
        dbSetOrder(1) //TV1_FILIAL+TV1_EMPRES+TV1_CODBEM+DTOS( TV1_DTSERV )+TV1_TURNO+TV1_HRINI+TV1_HRFIM
        If dbSeek( cKey ) // posicionadnomé en la TV1
        nContTOP := U_getKMTOP(cBemTv1,DTOC(dDtTv1)) // obtengo el KM FINAL
            if !EMPTY(nContTOP)
                RecLock("TV1",.F.)
                TV1->TV1_CONFIM	:= nContTOP
                    MsUnlock()
            endif
        endif
        Conout( cMesage ) // mensaje de integración correcto
    Else
        If nOperat == 3 .Or. nOperat == 4 // Inclusión o modificación. (03/07/2020)

        dbSelectArea('TV2')
        dbSetOrder(1)
            If dbSeek( cKey )
            aArrayPTd :={}
                While TV2->( !Eof() ) .And. cKey == TV2->TV2_FILIAL + TV2->TV2_EMPRES + TV2->TV2_CODBEM + DToS( TV2->TV2_DTSERV )
                    //Nahim posicione en la TV0 para veriificar si corresponde el apunte
                    // TV0_FILIAL+TV0_CODATI
                    dbSelectArea('TV0')
                    TV0->(dbSetOrder(1))
                    TV0->(dbSeek(xFilial("TV0") + TV2->TV2_CODATI)) // posicionandomé en la actividad
                    
                    if TV0->TV0_TIPHOR $ '1|4' // Tipo de hora trabajada y planificación deberían apuntarse 29/12/2020
                    // if alltrim(TV2->TV2_CODATI) == "1"
                        // Nahim Adicionando array para enviar apuntes de costos SD3
                                        // Nahim probando muestra hora inicial 30/06/2020
                        // Posicione BIEN DE MANTENIMIENTO (ST9)
                        dbSelectArea("ST9")
                        dbSetOrder(1)
                        // T9_FILIAL+T9_CODBEM
                        IF dbSeek(xFilial("ST9")+cBemTv1)
                            dbSelectArea("SN3") //Posicione SN3
                            dbSetOrder(1)
                            // N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
                            IF dbSeek(xFilial("SN3")+ST9->T9_CODIMOB) // Encuentra SN3
                                if !empty(SN3->N3_CLVLCON)  // no tiene que estár vacio
                            cProducto := U_getProByCl(SN3->N3_CLVLCON)// obtengo el código del producto
                                    if !empty(cProducto) // obtengo el producto de costo de mano de obra
                                        // u_cosParDi(_cDoc,cCodigo,nQUant,dEmissao,cCusto,cTM,cAccount) // Ejecuta movimiento SD3 que genera costo
                                        
                                        // Busca código del item cuenta NT 20/07/2020
                                        IF TV2->TV2_XTOTCO <> 0 // Nahim 22/06/2021
                                            cItemCont := u_getItemContable(TV2->TV2_CODBEM,TV2->TV2_DTSERV)
                                            aRegTv2 := {}
                                            AADD( aRegTv2,cProducto)      // 1
                                            // AADD( aRegTv2,TV2->TV2_UTOTHD)  // 2
                                            // AADD( aRegTv2,Val(SubStr(TV2->TV2_TOTHOR,1,2))+Val(SubStr(TV2->TV2_TOTHOR,4,2))/60 )  // 2
                                            AADD( aRegTv2,TV2->TV2_XTOTCO)  // 2
                                            AADD( aRegTv2,TV2->TV2_DTSERV)  // 3
                                            AADD( aRegTv2,TV2->TV2_CODFRE)  // 4
                                            AADD( aRegTv2,SN3->N3_CLVLCON)  // 5
                                            AADD( aRegTv2,SN3->N3_FILIAL)  // 6
                                            AADD( aRegTv2,cItemCont)  // 7 item cuenta
                                            AADD( aArrayPTd,aRegTv2)
                                        endif
                                        // u_cosParDi("NTP-00001",SB1->B1_COD,TV2_UTOTHD,TV2->TV2_DTSERV,TV2->TV2_CODFRE,"512",SB1->B1_UCTAPRO) // Ejecuta movimiento SD3 que genera costo 19/06/2020
                                    else
                                        alert("No encontró Producto de mano de Obra, Clase Valor: " + SN3->N3_CLVLCON)
                                    endif
                                else
                                    alert("campo N3_CLVLCON vacio en el bien: "  + SN3->N3_CBASE)
                                endif
                            else
                                alert("NO RELACION EN LA SN3 (ACTIVOS) :" +ST9->T9_CODIMOB)
                            ENDIF
                        else
                            alert("NO RELACION EN LA ST9 (Bienes) - Mant. " +cBemTv1)
                        endif
                    endif

                cMesage += 'Atividade: ' + TV2->TV2_CODATI + ' / ' + TV2->TV2_HRINI + ' - ' + TV2->TV2_HRFIM + CRLF

                TV2->( dbSkip() )
                End
            // Nahim Terrazas 07/03/2020
            // Verificando si debería hacer el apunte de parte diario
                if !empty(aArrayPTd)
                cDoc := "PT" + Alltrim(cBemTv1) + DTOC(dDtTv1) // Nro de docuemtno
                // Realiza el costo de mano de obra
                u_cosParDi(cDoc,SUPERGETMV("MV_XTMMANOB", .T., "513"),aArrayPTd)

                // Realizando apunte activo fijo
                    For nI := 1 To Len(aArrayPTd)
                    u_getATF(aArrayPTd[nI][5],aArrayPTd[nI][6])
                        if ! VW_CPX->(EoF())

                        ArrTeste := {}
                        AADD(Arrteste, GetSXENum("FNA", "FNA_IDMOV")) //IDMOV
                        AADD(Arrteste, '001') //ITMOV
                        //AADD(Arrteste, ctod('20191113'))//DATA   dEmissa
                        AADD(Arrteste, aArrayPTd[nI][3])
                        AADD(Arrteste, 'P2') ///TIPO APUNTE
                        AADD(Arrteste,  aArrayPTd[nI][3]) //PERIODO INICIAL
                        AADD(Arrteste,  aArrayPTd[nI][3]) //PERIODO FINAL
                        AADD(Arrteste, aArrayPTd[nI][2]) // cantidad de horas D1_UHORAEQ 01/07/2020
                        AADD(Arrteste, VW_CPX->N3_CBASE)// N3_CBASE
                        AADD(Arrteste, VW_CPX->N3_ITEM)// N3_ITEM
                        AADD(Arrteste, VW_CPX->N3_TIPO)// N3_TIPO
                        AADD(Arrteste, VW_CPX->N3_SEQ) 

                        VW_CPX->(DbCloseArea())

                        U_AF110EXC(Arrteste)
                        ConfirmSx8()
                        ENDIF
                    next nI
                endif



            EndIf

            If nOperat == 4

                For nIndex := 1 to Len( aCols )

                    If GDDeleted( nIndex, aHeader, aCols ) .And.;
                        nCodati > 0 .And. !Empty( aCols[nIndex, nCodati ] ) .And.;
                        nHrini > 0 .And. !Empty( aCols[nIndex, nHrini ] ) .And.;
                        nHrFim > 0 .And. !Empty( aCols[nIndex, nHrFim ] )

                    cMesage += 'Item excluído: Atividade ' + aCols[nIndex, nCodati ] + ' - '
                    cMesage += aCols[nIndex, nHrini ] + '/' + aCols[nIndex, nHrFim ] + CRLF

                        EndIf

                Next

            EndIf

        EndIf
        MsgInfo( cMesage, 'Parte diária')
    EndIf
*/
Return
