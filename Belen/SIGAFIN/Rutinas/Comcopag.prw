#Include "PROTHEUS.Ch"
#Include "RwMake.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} User Function comcobob
    LLama comprobante contable de COBROS DIVERSOS 
    @type  Function
    @author user
    @since 29/03/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function comcopag()
    ValidPerg()
    if pergunte("COMPAG",.t.)// llama para que digite el nro del cobro.
        dbSelectArea("SEK")
        DbSetOrder(1)
        if DbSeek(xFilial("SEK") + MV_PAR01) //verifico el recibo X
            dbSelectArea("CT2") 
            dbSetOrder(15) // CT2_FILIAL+CT2_DIACTB+CT2_NODIA
            if dbSeek(SEK->EK_FILIAL+SEK->EK_DIACTB + SEK->EK_NODIA)
                M->DDATALANC := CT2->CT2_DATA
                M->CLOTE := CT2->CT2_LOTE
                M->cSubLote := CT2->CT2_SBLOTE
                M->CDOC := CT2->CT2_DOC
                U_CtbcR070()
            else
                alert("No se encontró el asiento contable.")
            ENDIF
        else
            alert("No se encontró el Pago.")
        endif
    endif
Return 



/*-------------------------------------------------------------------------------------------------------*/
Static Function ValidPerg()

	LOCAL aVldSX1  := GetArea()
	LOCAL aCposSX1 := {}
	LOCAL aPergs   := {}
	LOCAL cPerg    := PADR("COMPAG",10)
	Local nj,nX

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
	"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
	"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
	"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
	"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
	"X1_F3","X1_GRPSXG"}

	aAdd(aPergs,{'Ord.Pag.','Orden.Pago.','Desde Orden.Pago.','mv_ch1','C', 6, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
	// aAdd(aPergs,{'Ord.Pag.','Hasta Ord.Pag.','Hasta Ord.Pag.','mv_ch2','C', 6, 0, 1, 'G', '', 'mv_par02','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
	
	// aAdd(aPergs,{'De Proveedor','De Proveedor','De Proveedor','mv_ch1','C', 06, 0, 1, 'G', '', 'mv_par03','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SA2',''})
	// aAdd(aPergs,{'A Proveedor','A Proveedor','A Proveedor','mv_ch2','C', 06, 0, 1, 'G', '', 'mv_par04','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SA2',''})

	// aAdd(aPergs,{'De Fecha','De Fecha','De Fecha','mv_ch1','D', 08, 0, 0, 'G', '', 'mv_par05','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
	// aAdd(aPergs,{'A Fecha','A Fecha','A Fecha','mv_ch2','D', 08, 0, 0, 'G', '', 'mv_par06','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
	

	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		If !(dbSeek(cPerg+StrZero(nx,2)))
			RecLock("SX1",.T.)
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with StrZero(nx,2)
			for nj:=1 to Len(aCposSX1)
				FieldPut(FieldPos(ALLTRIM(aCposSX1[nJ])),aPergs[nx][nj])
			next nj
			MsUnlock()
		Endif
	Next

	RestArea( aVldSX1 )

Return
