#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "Protheus.ch"   
#include "Fileio.ch"                             
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"
//#include "adprint.ch"

#DEFINE nTexto		1
#DEFINE nAlinX		2
#DEFINE nAlinY		3
#DEFINE nFuente		4
#DEFINE nSaltos		5
#DEFINE nMargenX	6
#DEFINE nAncho 		7 

//*******************************************************************************
//*			Autor: Fourier												        *
//*			Version: 1.0														*
//*			Fecha inicio: 16/2/2021												*
//*			Fecha modif.: 18/2/2021												* 
//*			Objetivo: Simular intereses a cobrar y generación de notas de débito* 
//*			Fichero: DSFFIN03.PRW												*
//*******************************************************************************

User Function DSFFIN03()

Local aArea 	    := GetArea()
Local cLinhaOk	    := "AllwaysTrue"
Local cTudoOk	    := "AllwaysTrue"
Local cFieldOk	    := "AllwaysTrue"
Local nOpc		    := GD_UPDATE
Local nMaxOrd	    := 99
Local aAltCpos      := {}
Local bDblClick	    := {|| IIF(oMark:oBrowse:nColPos == 1 ,MarkDesM(.F.),oMark:oBrowse:Refresh()),/*oMark:EditCell()*/}
Local bClickH	    := {|| IIF(oMark:oBrowse:nColPos == 1 ,MarkDesM(.T.),oMark:oBrowse:Refresh()),/*oMark:EditCell()*/}

Static oDlg

Private oMark
Private oBCerrar
Private oBGeneraND
Private oGCliente
Private oGDesdeE
Private oGHastaE
Private oGHVencim
Private oGNVencim
Private oGRazonSoc
Private oGInteres
Private oGLoja 
Private oPanel1
Private oSay1
Private oSay2
Private oSCliente
Private oSDesde
Private oSHasta
Private oSNuevovenc
Private oSRazon
Private oSCodProd
Private oSMPago
//Private oSSPago
Private oGProducto
Private oGDescProd
Private oGCodMPago
Private oGDescPago
//Private oGSalPago
Private oSNega
Private cGLoja          := Space(2)
Private cGCliente       := Space(TamSX3("A1_COD")[1])
Private dGDesdeE        := STOD("20000101")
Private dGHastaE        := Date()
Private dGHVencim       := Date()
Private dGNVencim       := Date()
Private cGRazonSoc      := Space(40)
Private nGInteres       := GetMV("UN_INTMOR")  
Private nGTotalOrig     := 0
Private nGTotalSaldo    := 0
Private nGTotalInt      := 0
Private cProducto       := alltrim(GetMV("UN_PRMOR"))
Private cDescProd       := Posicione("SB1",1,xfilial("SB1") + cProducto, "B1_DESC")
Private cPago           := alltrim(GetMV("UN_CPMOR"))
Private CDescPago       := Posicione("SE4",1,xfilial("SE4") + cPago, "E4_DESCRI")
Private nSalPago        := 0
Private aColsP          := {}
Private aHeadP          := {}
Private aColsE          := {}
Private cChkOk	        := "CHECKED"
Private cChkNo	        := "UNCHECKED"
Private cStatChk        := cChkNo
Private nTotCDis        := 0
Private cVendedor       := ""
Private oGVend
Private oSVende
Private cNomVend        := ""
Private oGNomVend
Private lGenerada       := .F.

AADD(aHeadP, { " ",;                        // Titulo de cabecera
                 "CHECKOK",;                // Campo asociado
                "@BMP",;                    // Picture
                04,;                        // Tamaño
                00,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "C",;                       // Tipo
                ,;                          // Reservado
                "V",;                       // Contexto
                "",;                        // CBox
                "" })                       // When

AADD(aHeadP, { "PV",;                       // Titulo de cabecera
                 "PVA",;                    // Campo asociado
                "@!",;                      // Picture
                01,;                        // Tamaño
                00,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "C",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When

AADD(aHeadP, { "VENCIMIENTO",;              // Titulo de cabecera
                 "VENCIMIENTO",;            // Campo asociado
                "@!",;                      // Picture
                08,;                        // Tamaño
                00,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "D",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When

AADD(aHeadP, { "VALOR ORIG.",;              // Titulo de cabecera
                 "VALOR",;                  // Campo asociado
                "@E 9,999,999,999,999.99",; // Picture
                16,;                        // Tamaño
                02,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "N",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When   

AADD(aHeadP, { "SALDO",;                    // Titulo de cabecera
                 "SALDO",;                  // Campo asociado
                "@E 9,999,999,999,999.99",; // Picture
                16,;                        // Tamaño
                02,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "N",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When

AADD(aHeadP, { "INTERESES",;                // Titulo de cabecera
                 "INTERESES",;              // Campo asociado
                "@E 9,999,999,999,999.99",; // Picture
                14,;                        // Tamaño
                02,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "N",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When
                                
AADD(aHeadP, { "TIPO COMP.",;               // Titulo de cabecera
                 "TIPO",;                   // Campo asociado
                "@!",;                      // Picture
                03,;                        // Tamaño
                00,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "C",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When

AADD(aHeadP, { "SERIE",;                    // Titulo de cabecera
                 "SERIE",;                  // Campo asociado
                "@!",;                      // Picture
                02,;                        // Tamaño
                00,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "C",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When

AADD(aHeadP, { "NUMERO",;                   // Titulo de cabecera
                 "NUMERO",;                 // Campo asociado
                "@!",;                      // Picture
                18,;                        // Tamaño
                00,;                        // Decimal
                .T.,;                       // Validación
                ,;                          // Reservado
                "C",;                       // Tipo
                ,;                          // Reservado
                "",;                        // Contexto
                "",;                        // CBox
                "" })                       // When


DEFINE MSDIALOG oDlg TITLE "Cálculo de Intereses" FROM 000, 000  TO 600, 800 COLORS 0, 16777215 PIXEL

    @ 068, 002 MSPANEL oPanel1 PROMPT "oPanel1" SIZE 400, 195 OF oDlg COLORS 0, 16777215 RAISED
    @ 009, 012 SAY oSCliente PROMPT "Cliente:" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 009, 085 SAY oSay6 PROMPT "Tienda:" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 009, 130 SAY oSRazon PROMPT "Razón Social: " SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 009, 305 SAY oSay3 PROMPT "Interés Mensual:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 024, 012 SAY oSDesde PROMPT "Desde Emisión:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 024, 105 SAY oSHasta PROMPT "Hasta Emisión:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 024, 200 SAY oSay2 PROMPT "Hasta Vencimiento:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 024, 297 SAY oSNuevovenc PROMPT "Emision Pedido:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 012 SAY oSCodProd PROMPT "Cod. Producto:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL

    @ 040, 215 SAY oSVende PROMPT "Vendedor:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL

    @ 055, 012 SAY oSMPago PROMPT "C.Pago:" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
//    @ 055, 215 SAY oSSPago PROMPT "Saldo:" SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 055, 350 SAY oSNega PROMPT "" SIZE 040, 007 OF oDlg COLORS 255, 16777215 PIXEL

    @ 006, 032 MSGET oGCliente VAR cGCliente PICTURE PesqPict("SA1","A1_COD") F3 "SA1" VALID valcli('COD') SIZE 045, 010 OF oDlg COLORS 0, 16777215 HASBUTTON PIXEL
    @ 006, 105 MSGET oGLoja VAR cGLoja VALID valcli('LOJ') SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 006, 170 MSGET oGRazonSoc VAR cGRazonSoc SIZE 100, 010 OF oDlg COLORS 0, 16777215  READONLY PIXEL
    @ 006, 355 MSGET oGInteres VAR nGInteres VALID CalcInt() SIZE 032, 010 OF oDlg PICTURE "@E 999.99%" COLORS 0, 16777215 READONLY PIXEL
    @ 021, 055 MSGET oGDesdeE VAR dGDesdeE VALID SelDatE1() SIZE 045, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 021, 150 MSGET oGHastaE VAR dGHastaE VALID SelDatE1() SIZE 045, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 021, 252 MSGET oGHVencim VAR dGHVencim SIZE 045, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 021, 350 MSGET oGNVencim VAR dGNVencim VALID SelDatE1() SIZE 045, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 037, 060 MSGET oGProducto VAR cProducto PICTURE PesqPict("SB1","B1_COD") F3 "SB1" VALID valprod() SIZE 045, 010 OF oDlg COLORS 0, 16777215 HASBUTTON PIXEL
    @ 037, 110 MSGET oGDescProd VAR cDescProd SIZE 100, 010 OF oDlg COLORS 0, 16777215  READONLY PIXEL

    @ 037, 250 MSGET oGVend VAR cVendedor SIZE 030, 010 OF oDlg COLORS 255, 16777215 READONLY PIXEL
    @ 037, 285 MSGET oGNomVend VAR cNomVend SIZE 080, 010 OF oDlg COLORS 255, 16777215 READONLY PIXEL

    @ 052, 060 MSGET oGCodMPago VAR cPago PICTURE PesqPict("SE4","E4_CODIGO") F3 "SE4" VALID valpago() SIZE 045, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 052, 110 MSGET oGDescPago VAR cDescPago SIZE 100, 010 OF oDlg COLORS 0, 16777215  READONLY PIXEL
//    @ 052, 240 MSGET oGSalPago VAR nSalPago SIZE 100, 010 OF oDlg PICTURE "@E 9,999,999,999,999.99" COLORS 255, 16777215  READONLY PIXEL

    @ 270, 005 SAY oSay4 PROMPT "Total Valor Orig. Selec." SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL  
    @ 270, 088 SAY oSay5 PROMPT "Total Valor Saldo Selec." SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 270, 171 SAY oSay1 PROMPT "Total Valor Intereses Selec." SIZE 067, 007 OF oDlg COLORS 0, 16777215 PIXEL

    @ 281, 005 MSGET oGTotalOrig VAR nGTotalOrig SIZE 060, 010 OF oDlg PICTURE "@E 9,999,999,999,999.99" COLORS 0, 16777215 READONLY PIXEL
    @ 281, 088 MSGET oGTotalSaldo VAR nGTotalSaldo SIZE 060, 010 OF oDlg PICTURE "@E 9,999,999,999,999.99" COLORS 0, 16777215 READONLY PIXEL
    @ 281, 171 MSGET oGTotalInt VAR nGTotalInt SIZE 060, 010 OF oDlg PICTURE "@E 9,999,999,999,999.99" COLORS 0, 16777215 READONLY PIXEL
    
    @ 275, 258 BUTTON oBGeneraND PROMPT "Imprimir" SIZE 037, 012 OF oDlg PIXEL ACTION (imprime())
    @ 275, 306 BUTTON oBGeneraND PROMPT "Gen. Pedido" SIZE 037, 012 OF oDlg PIXEL ACTION (generaND(.T.))
    @ 275, 354 BUTTON oBCerrar PROMPT "Cerrar" SIZE 037, 012 OF oDlg PIXEL ACTION (oDlg:End())



    if SelDatE1()
        aEval(aColsP,{|y| aAdd(y,.F.)})
    endif

oMark := MSNewGetDados():New(1,;            // Coordenada Y1
                            1,;             // Coordenada X1
                            168,;           // Altura
                            395,;           // Anchura
                            nOpc,;          // opciones de browse
                            cLinhaOk,;      // validación de línea
                            cTudoOk,;       // validación general
                            ,;              // campos auto incrementales
                            aAltCpos,;      // campos que pueden ser alterados
                            ,;              // linea que se desea congelar de la izquierda
                            nMaxOrd,;       // número máximo de líneas
                            cFieldOk,;      // validación del campo
                            ,;              // cSuperDel
                            ,;              // validación ante exclusión
                            oPanel1,;       // objeto o ventana padre
                            aHeadP,;        // Cabecera
                            aColsP)         // Datos

oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT // Somente Interface MDI
oMark:oBrowse:bLDblClick := bDblClick	    // Click para seleccionar uno por uno.
oMark:oBrowse:bHeaderClick := bClickH		// Click para seleccion masiva.
oMark:aCols := {}

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)

RETURN

Static Function MarkDesM(lTodos)

    Local nX	:= 0

    If lTodos
        If cStatChk == cChkNo
            cStatChk := cChkOk
        Else
            cStatChk := cChkNo
        EndIf

        For nX := 1 To Len(oMark:aCols)
            oMark:aCols[nX][1] := cStatChk
        Next nX
    Else
        If oMark:aCols[oMark:nAt][1] == cChkNo
            oMark:aCols[oMark:nAt][1] := cChkOk
        Else
            oMark:aCols[oMark:nAt][1] := cChkNo
        EndIf
    EndIf
    CalcTotal()
    oMark:oBrowse:Refresh()

Return(Nil)

Static Function valcli(cTipoVal)
	Local lRet 		 := .T.

	Local aAreaSA1	 := SA1->(Getarea())

    lGenerada := .F.

	If cTipoVal == 'COD'
		If Empty(cGCliente) .OR. !(ExistCpo("SA1",cGCliente))
			lRet := .F.
		Else
			cGRazonSoc := Posicione('SA1',1,xFilial('SA1')+cGCliente,'A1_NOME')
			SelDatE1()
		EndIf
	Else
		If Empty(cGCliente) .or. Empty(cGLoja) .Or. !(ExistCpo("SA1",cGCliente+cGLoja))
			lRet := .F.
		Else
			cGRazonSoc := Posicione('SA1',1,xFilial('SA1')+cGCliente+cGLoja,'A1_NOME')
			SelDatE1()
		EndIf
	EndIf
    if lRet
        cVendedor := SA1->A1_VEND
        cNomVend := Posicione("SA3",1,xfilial("SA3") + cVendedor,"A3_NOME")
    endif
	RestArea(aAreaSA1)
Return lRet

Static Function valprod()
	Local lRet
	Local aAreaSB1	 := SB1->(Getarea())

    lRet    := .T.

	If Empty(cProducto) .OR. !(ExistCpo("SB1",cProducto))
		lRet := .F.
	Else
		cDescProd := Posicione('SB1',1,xFilial('SB1')+cProducto,'B1_DESC')
	EndIf
	RestArea(aAreaSB1)
Return lRet

Static Function valpago()
	Local lRet
	Local aAreaSE4	 := SE4->(Getarea())

    lRet    := .T.

	If Empty(cPago) .OR. !(ExistCpo("SE4",cPago))
		lRet := .F.
    else
        cDescPago := Posicione('SE4',1,xFilial('SE4')+cPago,'E4_DESCRI')
	EndIf


	RestArea(aAreaSE4)
Return lRet

Static Function SelDatE1()

    Local lDatos    := .T.
    Local cQry		:= ""
    Local nPos		:= 1

    cQry := "SELECT E1_PREFIXO, E1_NUM,E1_VALOR, E1_VENCTO,  E1_SALDO, INTERESES = 0, E1_TIPO, E1_XINTER,E1_XNVOVEN, R_E_C_N_O_ FROM SE1010 "
    cQry += "WHERE E1_EMISSAO BETWEEN '" + dtos(dGDesdeE) + "' AND '" + dtos(dGHastaE) + "' "
    cQry += "AND E1_VENCTO <= '" + dtos(dGHVencim) + "' AND E1_CLIENTE = '" + cGCliente + "' AND E1_SALDO > 0 AND D_E_L_E_T_ <> '*' "
    cQry += "AND (E1_TIPO = 'NF ' OR E1_TIPO = 'NDC') AND E1_LOJA = '" + cGLoja + "' "
    cQry += "AND E1_NUM NOT LIKE 'P%' "
    cQry += "ORDER BY E1_VENCTO "

    cQry   := ChangeQuery( cQry ) 

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)

    DbSelectArea("TRB")
    DbGoTop()
    aColsE  := {}    
    aColsP  := {}
    AADD(aColsP,Array(Len(aHeadP)+1))
    AADD(aColsE,0)
    aColsP[1][1] := cChkNo
    aColsP[1][Len(aHeadP)+1] := .F.
    nGTotalOrig := 0
    nGTotalSaldo := 0
    nGTotalInt := 0


    While !(TRB->( EOF()))
        lDatos := .T.
        IF nPos > 1
            AADD(aColsP,Array(Len(aHeadP)+1))
            AADD(aColsE,0)
        EndIF
        aColsP[nPos][1] := cChkNo
        aColsP[nPos][2] := TRB->E1_XINTER
        if ALLTRIM(TRB->E1_XNVOVEN) == ""
            aColsP[nPos][3] := stod(TRB->E1_VENCTO)
        else
            aColsP[nPos][3] := stod(TRB->E1_XNVOVEN)
        endif
        aColsP[nPos][4] := TRB->E1_VALOR
        aColsP[nPos][5] := TRB->E1_SALDO
        aColsP[nPos][6] := TRB->INTERESES
        aColsP[nPos][7] := TRB->E1_TIPO
        aColsP[nPos][8] := TRB->E1_PREFIXO
        aColsP[nPos][9] := TRB->E1_NUM
        aColsP[nPos][Len(aHeadP)+1] := .F.
        aColsE[nPos] := TRB->R_E_C_N_O_
        nPos++
        TRB->( DbSkip() )
    EndDo

    TRB->( DbCloseArea())
    
    CalcInt()

Return lDatos

Static Function CalcTotal()

    Local nX := 0
    Local TotalOrig := 0
    Local TotalSaldo := 0
    Local TotalInt := 0
    Local F2Cliente
    Local F2Loja
    Local F2Num
    Local F2Prefixo

    F2Cliente   := cGCliente
    F2Loja      := cGLoja
    dbselectarea("SF2")
    dbsetorder(2)
                    
    for nX := 1 to len(aColsP)
        if oMark:aCols[nX][1] == "CHECKED"
            TotalOrig   += aColsP[nX][4]
            TotalSaldo  += aColsP[nX][5]
            TotalInt    += aColsP[nX][6]
            F2Num       := aColsP[nX][7]
            F2Prefixo   := aColsP[nX][8]
        ENDIF
    next nX

    // oGSalPago:Refresh()
    nGTotalOrig := TotalOrig
    nGTotalSaldo := TotalSaldo
    nGTotalInt := TotalInt
    oGTotalOrig:Refresh()
    oGTotalSaldo:Refresh()
    oGTotalInt:Refresh()
RETURN

Static Function CalcInt()

    Local nX := 0
    Local nGracia := SUPERGETMV( "UN_PGRACIA", .F., 7)
    Local nDias     := 0

    if aColsP[1][3] <> Nil
        for nX := 1 to len(aColsP)
            nDias := ( dGNVencim - aColsP[nX][3] - nGracia )
            if nDias > 0
                aColsP[nX][6] := ( dGNVencim - aColsP[nX][3]) * aColsP[nX][5] * nGInteres / (30 * 100)
            else
                aColsP[nX][6] := 0
            endif
        next nX
        oMark:aCols := {}
        oMark:aCols := AClone(aColsP)
        oMark:Refresh()
    endif
RETURN

Static Function generaND(lND)

    Local nMoneda   := 2
    Local aEncab    := {}
    Local aDetalle  := {}
    Local nX        := 0
    Local nCant     := 1
    Local nValor    := nGTotalInt
    Local nCuenta   := 0
    Local aRet      := .F.
//    Local nRecno    := 0
//    Local nCoef     := 0
//    Local oCupoAfec
//    Local F2Cliente
//    Local F2Loja
//    Local F2Num
//    Local F2Prefixo
    Local aColsP
    Local nTotal    := 0
    Local aRecnos   := {}

    if lGenerada
        msginfo("El pedido ya ha sido generado, seleccione otro cliente")
        RETURN
    endif


    aColsP := {}
    aColsP := AClone(oMark:aCols)
    nTotal := 0
    for nX := 1 to len(aColsP)
        if aColsP[nX][1] == cChkOk
            nValor := aColsP[nX][6]
            nTotal += nValor
            cTS := Posicione("SB1",1,xfilial("SB1") + alltrim(cProducto),"B1_TS")
            cDetalle := aColsP[nX][7] + " " + aColsP[nX][9] + " " + dtoc(aColsP[nX][3]) + " " + dtoc(dGNVencim) + " " + ;
                        alltrim(str(dGNVencim - aColsP[nX][3])) + " " + alltrim(str( nGInteres, 6,2 ) + "% " + "Saldo Orig.: " + str(aColsP[nX][5]))
            AADD(aDetalle, { cProducto, nCant, nValor, cDetalle, cTS, aColsE[nX]})
            nCuenta++
            AADD(aRecnos,aColsE[nX])
        endif
    next nX

    if Alltrim(cPago) == ''
        msginfo("Debe seleccionar una Forma de Pago", "Atención")
        Return
    endif

    if Alltrim(cProducto) == ''
        msginfo("Debe seleccionar un Producto", "Atención")
        Return
    endif

    aEncab    := {cGCliente, cGLoja, nMoneda, cPago, cVendedor, nTotal, dGNVencim}

    if nCuenta > 0
            if nTotal > 0
                aRet := U_DSFFIN04(aEncab, aDetalle)
                if aRet[1]
                    lGenerada := .T.
                endif
            else
                msginfo("No tiene valor el interés calculado", "Atención")
            endif
        // aca debemos comprobar si se grabó correctamente la ND y cambiar fecha de vencimiento de titulos.
        // acá debemos guardar también en la nueva base los titulos refinanciados
        // todo con un bucle desde 1 hasta len(aColsP)
    else
        msgalert("Debe seleccionar al menos un comprobante")
    endif
    if lGenerada
        for nX := 1 to Len(aColsP)
            if aColsP[nX][1] == cChkOk
                SE1->(DBGoTo(aColsE[nX]))
                reclock("SE1",.F.)
                SE1->E1_XINTER := '*'
                SE1->E1_XNVOVEN := dGNVencim
                SE1->(msunlock())
            endif
        next nX
    endif
RETURN

Static Function limpia()
    cGCliente   := Space(TamSX3("A1_COD")[1])
    oGCliente:Refresh()
    cGLoja      := Space(2)
    oGLoja:Refresh()
    cGRazonSoc  := Space(40)
    oGRazonSoc:Refresh()
    nGInteres   := 0
    oGInteres:Refresh()
    dGDesdeE    := Date()
    oGDesdeE:Refresh()
    dGHastaE    := Date()
    oGHastaE:Refresh()
    dGHVencim   := Date()
    oGHVencim:Refresh()
    dGNVencim   := Date()
    oGNVencim:Refresh()
    cProducto   := Space(15)
    oGProducto:Refresh()
    cDescProd   := Space(30)
    oGDescProd:Refresh()
    cPago       := Space(4)
    oGCodMPago:Refresh()
    cDescPago   := Space(25)
    oGDescPago:Refresh()
    nSalPago    := 0
    //oGSalPago:Refresh()
    lGenerada := .F.
    SelDatE1()
    oMark:aCols := {}
    oMark:oBrowse:Refresh()
Return

Static Function imprime()

	Local oReport

    Private aLineas := {}



	oReport := ReportDef()
	if oReport <> NIL
		oReport:SetPortrait()
		oReport:oPage:setPaperSize(9)
		oReport:PrintDialog()
	endif		
return

Static Function ReportDef()
	Local oReport
	Local oRegistros
	Local oBreak   

    oReport := TReport():New("Int_a_recup","Intereses a Recuperar (" + alltrim(cGCliente) + " - " + alltrim(cGLoja) + ") " + alltrim(cGRazonSoc),{||xParamBox2()},{|oReport| PrintReport(oReport)},"")	   

    oRegistros := TRSection():New(oReport,"Detalle", {"TT_INT"})

    oRegistros:SetTotalText("Total")
    
    TRCell():New(oRegistros,"NROCOMP" ,     , "Titulo",         ,30,,{|| aLineas[1]},"LEFT",,"CENTER",,2) 
    TRCell():New(oRegistros,"TIPO" ,        , "Tipo",           ,10,,{|| aLineas[2]},"LEFT",,"CENTER",,2)
    TRCell():New(oRegistros,"VENCIMIENTO" , , "Vencimiento",    ,15,,{|| DTOC(aLineas[3])},"LEFT",,"CENTER",,2)
    TRCell():New(oRegistros,"NVOVENC" ,     , "Nuevo Venc.",    ,16,,{|| DTOC(dGNVencim)},"LEFT",,"CENTER",,2)
    TRCell():New(oRegistros,"VALORORIG" ,   , "Valor Orig.",    ,15,,{|| Transform(aLineas[4],PesqPict("SE1","E1_VALOR"))},"RIGHT",,"RIGHT",,2)
    TRCell():New(oRegistros,"SALDO" ,       , "Saldo",          ,15,,{|| Transform(aLineas[5],PesqPict("SE1","E1_VALOR"))},"RIGHT",,"RIGHT",,2)
    TRCell():New(oRegistros,"INTERESES" ,   , "Intereses",      ,15,,{|| Transform(aLineas[6],PesqPict("SE1","E1_VALOR"))},"RIGHT",,"RIGHT",,2)
    TRCell():New(oRegistros,"DIAS" ,        , "Días",           ,15,,{|| Transform(aLineas[7],"@E 99999")},"RIGHT",,"RIGHT",,2)
    TRCell():New(oRegistros,"SALDOINT" ,    , "Saldo c/Int.",   ,15,,{|| Transform(aLineas[8],PesqPict("SE1","E1_VALOR"))},"RIGHT",,"RIGHT",,2)

    oRegistros:SetHeaderPage()
    oRegistros:SetHeaderSection(.T.)
    oRegistros:SetTotalInLine(.F.)
    
    Return oReport

Return NIL

Static Function PrintReport(oReport)

	Local oRegistros := oReport:Section(1) 
    Local nLin := 0

    TRFunction():New(oRegistros:Cell('SALDO')   ,NIL,"SUM",/*oBreak */,/*Titulo */,PesqPict("SE1","E1_VALOR"),/*uFormula */,.T.,.F.)
    TRFunction():New(oRegistros:Cell('INTERESES'),NIL,"SUM",/*oBreak */,/*Titulo */,PesqPict("SE1","E1_VALOR"),/*uFormula */,.T.,.F.)
    TRFunction():New(oRegistros:Cell('SALDOINT'),NIL,"SUM",/*oBreak */,/*Titulo */,PesqPict("SE1","E1_VALOR"),/*uFormula */,.T.,.F.)
 	 		
	oReport:Section(1):Init()       
    For nLin := 1 to Len(aColsP)
    aLineas := {	aColsP[nLin,8] + " " + aColsP[nLin,9],;	    // 1 Titulo
                    aColsP[nLin,7],;			                // 2 Tipo
                    aColsP[nLin,3],;			                // 3 Vencimiento
                    aColsP[nLin,4],;				            // 4 Valor Original
                    aColsP[nLin,5],;			                // 5 Saldo Adeudado
                    aColsP[nLin,6],;				            // 6 Intereses
                    dGNVencim - aColsP[nLin,3] ,;			    // 7 Días
                    aColsP[nLin,5] + aColsP[nLin,6];			// 8 Saldo con Interes
                    }
                    oReport:Section(1):PrintLine()	        	   	    	   	    	    	        	    				
    	            dbSkip()
    Next nLin

    oRegistros:Finish()     
return 



/*


aTexto1 := {}

cTexto1 := 'Cliente: ' + cGCliente + ' - ' + cGRazonSoc +  '  * Desde Fecha Emisión:  ' + DTOC(dGDesdeE) + " Hasta Fecha Emisión: " + DTOC(dGHastaE)
cTexto1 += ' - * Hasta Fecha de Vencimiento: ' + DTOC(dGHVencim) + ' - * Fecha Cálculo Interés: ' + DTOC(dGNVencim)

// Sección detalle de Movimientos

oPrn:StartPage()
esquema()
lPrimera 	:= .T.
nSTotal1		:= 0
nSTotal2		:= 0

For nBucle := 1 to LEN(aLineas)
    if lPrimera
        oPrn:SayAlign( _nY,20,'Comprobante',oFontA08,50,15,,2,0)
        oPrn:SayAlign( _nY,70,'Tipo',oFontA08,355,15,,2,0)
        oPrn:SayAlign( _nY,425,'Vencimiento',oFontA08,50,15,,2,0)
        oPrn:SayAlign( _nY,505,'Valor Orig.',oFontA08,45,15,,2,0)
        oPrn:SayAlign( _nY,550,'Saldo',oFontA08,70,15,,2,0)
        oPrn:SayAlign( _nY,620,'Intereses',oFontA08,70,15,,2,0)
        oPrn:SayAlign( _nY,690,'Días',oFontA08,70,15,,2,0)
        oPrn:SayAlign( _nY,760,'Saldo c/Int.',oFontA08,70,15,,2,0)
        incremY(15)
        oPrn:Line(_nY,20,_nY,830)
        incremY(15)
        lPrimera := .F.
    endif

    nSTotal1 += aLineas[nBucle,5]
    nSTotal2 += aLineas[nBucle,6] 

    nCor := CLR_BLACK

    oPrn:SayAlign( _nY,20,aLineas[nBucle,1],												    oFontCB08,050,15,,0,0)
    oPrn:SayAlign( _nY,70,aLineas[nBucle,2],													oFontCB08,355,15,,0,0)
    oPrn:SayAlign( _nY,425,DTOC(aLineas[nBucle,3]),												oFontCB08,050,15,,0,0)
    oPrn:SayAlign( _nY,505,Transform(aLineas[nBucle,4],PesqPict("SE1","E1_VALOR")),			    oFontCB08,045,15,,1,0)
    oPrn:SayAlign( _nY,550,Transform(aLineas[nBucle,5],PesqPict("SE1","E1_VALOR")),		        oFontCB08,070,15,,1,0)
    oPrn:SayAlign( _nY,620,Transform(aLineas[nBucle,6],PesqPict("SE1","E1_VALOR")),	            oFontCB08,070,15,,1,0)
    oPrn:SayAlign( _nY,690,Transform(aLineas[nBucle,7],"@E 99999"),                             oFontCB08,70,15,,1,0)
    oPrn:SayAlign( _nY,760,Transform(aLineas[nBucle,8],PesqPict("SE1","E1_VALOR")),				oFontCB08,70,15,nCor,1,0)

    incremY(10)

next nBucle

incremY(5)		
oPrn:Line(_nY,20,_nY,830,,'-4')
incremY(5)

// Sección Totales
nCor := CLR_BLACK

oPrn:SayAlign( _nY,70,'Totales',													oFontCB08,355,15,,0,0)	
oPrn:SayAlign( _nY,550,Transform(nSTotal1,PesqPict("SE1","E1_VALOR")),				oFontCB08,070,15,,1,0)
oPrn:SayAlign( _nY,620,Transform(nSTotal2,PesqPict("SE1","E1_VALOR")),				oFontCB08,070,15,,1,0)	
oPrn:SayAlign( _nY,760,Transform(nSTotal1 + nSTotal2,PesqPict("SE1","E1_VALOR")),	oFontCB08,70,15,nCor,1,0)

incremY(15)		
oPrn:Line(_nY,20,_nY,830,,'-4')

oPrn:EndPage()

oPrn:Preview()
//FreeObj(oPrn)
//oPrn := Nil


return

// Función que imprime lineas, marcos, etc. (todo lo que tenga que ver con el layout de la hoja)

Static Function esquema()

	Local nBucle	:= 0
	Local cNombre	:= ''

	nHoja++
	//FWMsPrinter(): SayBitmap ( < nRow>, < nCol>, < cBitmap>, [ nWidth], [ nHeight] )
	oPrn:SayBitmap(1,1,'logo\logo.png',150,112)
	//FWMsPrinter(): Line ( < nTop>, < nLeft>, < nBottom>, < nRight>, [ nColor], [ cPixel] )

	_nY := 30
	oPrn:SayAlign(_nY,155,'Informe de Cálculo de Intereses de Documentos Pendientes',oFontA16,675,1,,0,0)
	_nY := 50
	oPrn:SayAlign(_nY,155,DTOC( Date()),oFontCB14,405,1,0,0)
	oPrn:SayAlign(_nY,670,"Página: " + alltrim(STR(nHoja)),oFontCB12,160,1,,1,0)
	_nY := 80
	if len( cTexto1) > nLargo
		aExtenso := FwTxt2Array(cTexto1,nLargo)
		For nBucle := 1 TO LEN( aExtenso)
			oPrn:SayAlign( _nY,20,aExtenso[nBucle],oFontCB10,810,2,,3,0)
			_nY += 15
		Next nBucle
	else
		oPrn:SayAlign( _nY,20,cTexto1,oFontCB10,810,2,,3,0)
		_nY += 15
	endif

return

Static Function incremY(nCant)

	_nY += nCant

	if _nY > nMaxY
		oPrn:EndPage()
		oPrn:StartPage()
		esquema()
	endif
    lPrimera := .T.

Return

*/
