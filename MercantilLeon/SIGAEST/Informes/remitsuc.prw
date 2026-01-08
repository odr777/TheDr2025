#Include 'Protheus.ch'


User Function remitsuc(_hNumero,_hSerie,_hTipo)

//local cAreaA:=alias()
LOCAL CAreaA := GetArea()
Public _PAR01
Public _PAR02
Public _PAR03
Public _PAR04
Public _PAR05
Public _PAR06
Public _PAR07

RemPerg()
cPerg:="RES010"


aDRIVER := READDRIVER()
cString:="SF2"
titulo :=PADC("Emision de Remitos de salida" ,74)
cDesc1 :=PADC("Sera solicitado el Intervalo para la emision de los",74)
cDesc2 :=PADC("remitos generadoas",74)
cDesc3 :=""
aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci"), 1, 2, 1,"",1 }
nomeprog:="REMITSUC" 
nLin:=0
wnrel:= "REMITSUC"     
   
PERGUNTE(cPerg,.F.)
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"M","",.F.)
If Empty(_hNumero)
	_PAR04 := ""
	_PAR05 := ""
	_PAR06 :=1	
	
	If AllTrim(cEspecie) $ 'RTS' //SALIDA
	   _PAR01 := SF2->F2_DOC 
	   _PAR02 := SF2->F2_DOC
	   _PAR03 := SF2->F2_SERIE
	   	_PAR07 :=1
	else         //ENTRADA
	   _PAR01 := SF1->F1_DOC 
	   _PAR02 := SF1->F1_DOC
	   _PAR03 := SF1->F1_SERIE
	   _PAR07:=2
	End
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+Space(4)+'01'))               
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=_PAR01
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'02'))
		RecLock('SX1',.F.)
	   SX1->X1_CNT01 := _PAR02
	   SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'03'))               
	   RecLock('SX1',.F.)
		SX1->X1_CNT01 :=_PAR03
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'04'))               
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=_PAR04
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'05'))
		RecLock('SX1',.F.)
	   SX1->X1_CNT01 := _PAR05
	   SX1->(MsUnlock())
	End
	/*If SX1->(DbSeek(cPerg+Space(4)+'06'))               
	   RecLock('SX1',.F.)
		SX1->X1_CNT01 :=1
		SX1->(MsUnlock())
	End*/
	If SX1->(DbSeek(cPerg+Space(4)+'07'))               
	   RecLock('SX1',.F.)
		SX1->X1_PRESEL :=  _PAR07
		SX1->(MsUnlock())
	End
		
Else
	_PAR01 := _hNumero 
	_PAR02 := _hNumero
	_PAR03 := _hSerie
	_PAR04 := ""
	_PAR05 := ""
	_PAR06 := 1
	_PAR07 := _hTipo
	aReturn[5]:=1 // 1 = en disco - 2 = en Spool - 3 = en Puerto.
endif   

If nLastKey!=27
   SetDefault(aReturn,cString)
   If nLastKey!=27
      VerImp()       
      RptStatus({|| RptRemito()})
   endif
Endif

//dbselectarea(cAreaA)
RestArea (CAreaA)
Return


Static Function RptRemito()

local nLin,nTotImp,nTotItem,cLin,nIndSF2,nIndSD2
local cCidade	:= space(10)
local nTotItem := 0

dbselectarea("SB1")
dbsetorder(1)		// B1_FILIAL+B1_COD
dbgotop()

dbselectarea("SA3")
dbsetorder(1)		// A3_FILIAL+A3_COD
dbgotop()
SA3->(dbseek(xfilial("SA3")+SF2->F2_VEND1))

dbselectarea("SD2")
dbsetorder(3)		// D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
dbgotop()

dbSelectArea("SF2")         
dbSetOrder(1)		// F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
dbgotop()

dbselectarea("SD1")
dbsetorder(1)		// D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
dbgotop()

dbSelectArea("SF1")         
dbSetOrder(1)		// F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
dbgotop()

IF _PAR07 = 1
	if !empty(_PAR01)
		dbSelectArea("SF2")         
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+_PAR01+_PAR03,.t.)
	endif           
Else               
	if !empty(_PAR01)
		dbSelectArea("SF1")         
		dbSetOrder(1)
		dbSeek(xFilial("SF1")+_PAR01+_PAR03,.t.)
	endif           
endif
// ciudad a imprimir en el formulario
do case
	case SM0->M0_CODFIL = "01"
		cCidade := "SANTA CRUZ"                  
	//case SM0->M0_CODFIL = "02"
		//cCidade := "SANTA CRUZ"
	
endcase

setRegua(reccount())
while !eof()
  IF _PAR07 = 1
	IF SF2->F2_FILIAL = xFilial("SF2") .and. SF2->F2_DOC >= _PAR01 .and. SF2->F2_DOC <= _PAR02 .and. SF2->F2_SERIE==_PAR03
		For _copias := 1 to _PAR06
			//BEZ 20080514 se adiciono F2_SERIE a la llave
			SD2->(dbseek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
//			SC5->(dbseek(xFilial("SC5")+SD2->D2_PEDIDO))
		   SA2->(dbseek(xFILIAL("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
//			SE4->(dbseek(xFILIAL("SE4")+SC5->C5_CONDPAG))
			nLin := 0                                      
			@ nLin,050 PSAY "T R A N S F E R E N C I A - S U C U R S A L E S - S A L I D A"
			nLin++
			@ nLin,049 PSAY "============================================================="
			nLin++
			
			
			//nLin++
			//@ nLin,000 psay "CODIGO: "+SA2->A2_COD
			//@ nLin,025 psay "ALMACEN ORIGEN: "+SD2->D2_LOCAL 
			//@ nLin,054 psay "ALMACEN DESTINO: "+SD2->D2_LOCDEST
			//nLin++
			@ nLin,000 psay "SUCURSAL ORIGEN:  " + Left(CNUMEMP,4) + "     DEPOSITO ORIGEN:  " + POSICIONE('NNR',1,XFILIAL('NNR')+ SD2->D2_LOCAL,'NNR_DESCRI')
			@ nLin,105 psay cCidade+", "+dtoc(SF2->F2_EMISSAO)
			nLin++
			@ nLin,000 psay "SUCURSAL DESTINO: "+ SF2->F2_FILDEST + "     DEPOSITO DESTINO: " + POSICIONE('NNR',1,XFILIAL('NNR')+ SD2->D2_LOCDEST,'NNR_DESCRI')
			@ nLin,105 psay "NUMERO: "+Alltrim(SF2->F2_SERIE)+ ' - ' +SF2->F2_DOC picture pesqpict("SF2","F2_DOC")
			nLin++
			//@ nLin,000 psay "RESPONSABLE: "+ POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_NOME') + "         NRO DOCUMENTO: " + POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_CGC') + "     PLACA: " + POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_PLACA')
			//@ nLin,000 psay "RESPONSABLE:   NRO DOCUMENTO: " + POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_CGC') //"    PLACA: " + POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_PLACA')
			//nLin++
			//@ nLin,000 psay "TIPO: "+ POSICIONE('SX5',1,XFILIAL('SX5')+ 'ZT' + POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_UTIPO'),'X5_DESCRI') + " DOCUMENTO TRANSPORTE: " + POSICIONE('SA4',1,XFILIAL('SA4')+ SF2->F2_UTRANSP,'A4_VIA')
			//nLin++
			//SA4->(dbseek(xFILIAL("SA4")+SF2->F2_UTRANSP))
			
			//nLin++
			@ nLin,000 psay replicate("-",182)
			nLin++
			@ nLin,000 psay "CODIGO"
			@ nLin,010 psay "NOMBRE"
			@ nLin,040 psay "DIMENSION "
			@ nLin,056 psay "D E S C R I P C I O N"
			@ nLin,098 psay "CAPACIDAD"
			@ nLin,115 psay "N?SERIE"
			@ nLin,126 psay "MODELO"
			@ nLin,136 psay "TAG"
			@ nLin,146 psay "NRO. DOC"
			@ nLin,161 psay "CANT."
			@ nLin,168 psay "UNIDAD"
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin++                   
     	
	  		dbselectarea("SD2")
			dbseek(xFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			while SD2->D2_DOC==SF2->F2_DOC .and. SD2->D2_SERIE==SF2->F2_SERIE .and. SD2->D2_CLIENTE==SF2->F2_CLIENTE .and. SD2->D2_LOJA==SF2->F2_LOJA .and. !eof()
		
				// ubicar el fabricante del producto que ser?impreso
				//SB1->(dbseek(xFilial("SB1")+SD2->D2_COD))
				@ nLin,000 psay ALLTRIM(SD2->D2_COD) //picture pesqpict("SD2","D2_COD")
				SB1->(dbseek(xFILIAL("SB1")+SD2->D2_COD))
				@ nLin,010 psay ALLTRIM(SB1->B1_DESC)
				/*if (len(ALLTRIM(SB1->B1_UDIMENS))>0)
					@ nLin,040 psay ALLTRIM(SB1->B1_UDIMENS)
				endif*/
				//if (SC6->(dbseek(xFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)))
					//@ nLin,014 psay SC6->C6_DESCRI picture pesqpict("SC6","C6_DESCRI")
				//else
				if (len(ALLTRIM(SB1->B1_ESPECIF))>0)
					if (len(ALLTRIM(SB1->B1_ESPECIF))>40)
						@ nLin,056 psay SUBS(SB1->B1_ESPECIF,1,40)
					else
						@ nLin,056 psay ALLTRIM(SB1->B1_ESPECIF)
					endif
				endif
				/*
				if (len(ALLTRIM(SB1->B1_UCAPACI))>0)
					@ nLin,098 psay ALLTRIM(SB1->B1_UCAPACI)
				endif
				if (len(ALLTRIM(SD2->D2_NUMSERI))>0)
					@ nLin,115 psay ALLTRIM(SD2->D2_NUMSERI)
				endif*/
				if (len(ALLTRIM(SB1->B1_MODELO))>0)
					@ nLin,126 psay ALLTRIM(SB1->B1_MODELO)
				endif
				//if (len(ALLTRIM(SB1->B1_UTAG))>0)
					//@ nLin,136 psay ALLTRIM(SB1->B1_UTAG)
				/*endif
				if (len(ALLTRIM(SD2->D2_UNUMSAL))>0)
					@ nLin,146 psay ALLTRIM(SD2->D2_UNUMSAL)
				endif*/
				//endif				    					
				@ nLin,156 psay SD2->D2_QUANT picture "@E 999,999.99"
				@ nLin,168 psay ALLTRIM(SD2->D2_UM) 
				nTotItem += SD2->D2_CUSTO1
				if (len(ALLTRIM(SB1->B1_ESPECIF))>40)	
					nLin++
					@ nLin,056 psay ALLTRIM(SUBS(SB1->B1_ESPECIF,41,41))
				Endif
				dbskip()
			   nLin++
			enddo     
			dbselectarea("SF2")         
			nLin := 24
			@ nLin,00 psay CHR(15)+"REGISTRADO POR:                                            AUTORIZADO POR:                                            ENTREGADO POR:"+CHR(18)
			nLin++
			@ nLin,00 psay CHR(15)+"NOMBRE Y FIRMA--> "+Subs(cUsuario,7,15)+"                          NOMBRE Y FIRMA-->                                          NOMBRE Y FIRMA-->"+CHR(18)
			nLin++
			@ nLin,00 psay CHR(15)+"FECHA-->                                                   FECHA-->                                                   FECHA-->"+CHR(18)
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin++
			@ nLin,000 psay CHR(15)
			@ nLin,015 psay "Valor merc.: "+transform(nTotItem,"@E 99,999,999.99")+chr(18)
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin++		
			If Empty(_PAR04) .and. Empty(_PAR05)
//				@ nLin,000 psay SF2->F2_UCOBS
			Else
				@ nLin,000 psay CHR(15)+_PAR04+space(05)+_PAR05+CHR(18)
			Endif
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin+=3  
	//		SF2->(dbskip())
			@ nLin,000 psay space(01)	// para "saltar" efetivamente e passar para a proxima pagina.
			setprc(0,0)
			incregua()
		Next _Copias
	ENDIF
	nTotItem := 0
	SF2->(DBSKIP())
  ELSE
	IF SF1->F1_FILIAL = xFilial("SF1") .and. SF1->F1_DOC >= _PAR01 .and. SF1->F1_DOC <= _PAR02 .and. SF1->F1_SERIE==_PAR03
		For _copias := 1 to _PAR06
			SD1->(dbseek(xFilial("SD1")+SF1->F1_DOC))
//			SC5->(dbseek(xFilial("SC5")+SD2->D2_PEDIDO))
		   SA2->(dbseek(xFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
//			SE4->(dbseek(xFILIAL("SE4")+SC5->C5_CONDPAG))
			nLin := 0                                      
			@ nLin,018 PSAY "T R A N S F E R E N C I A - S U C U R S A L E S - E N T R A D A"
			nLin++
			@ nLin,018 PSAY "==============================================================="
			nLin++
			@ nLin,000 psay cCidade+", "+dtoc(SF1->F1_EMISSAO)
			@ nLin,054 psay "NUMERO: "+Alltrim(SF1->F1_SERIE)+SF1->F1_DOC picture pesqpict("SF1","F1_DOC")
			nLin++
			@ nLin,000 psay "CODIGO: "+SA2->A2_COD
			@ nLin,054 psay "ALMACEN DESTINO: "+SD1->D1_LOCAL
			nLin++
			@ nLin,000 psay "SUCURSAL ORIGEN: "+alltrim(SA2->A2_NOME)
			nLin++
			@ nLin,000 psay "SUCURSAL DESTINO: "+ Right(CNUMEMP,2)
			nLin++
			@ nLin,000 psay replicate("-",182)
			nLin++
			@ nLin,000 psay "CODIGO"
		//	@ nLin,008 psay "FAB"
		//	@ nLin,013 psay "D E S C R I P C I O N"
		//	@ nLin,047 psay "CANT."
			@ nLin,010 psay "NOMBRE"
			@ nLin,040 psay "DIMENSI覰"
			@ nLin,056 psay "D E S C R I P C I ?N"
			@ nLin,098 psay "CAPACIDAD"
			@ nLin,115 psay "N?SERIE"
			@ nLin,126 psay "MODELO"
			@ nLin,136 psay "TAG"
			@ nLin,146 psay "NRO. DOC"
			@ nLin,161 psay "CANT."
			@ nLin,168 psay "UNIDAD"
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin++                   
     	
	  		dbselectarea("SD1")
			dbseek(xFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			while SD1->D1_DOC==SF1->F1_DOC .and. SD1->D1_SERIE==SF1->F1_SERIE .and. SD1->D1_FORNECE==SF1->F1_FORNECE .and. SD1->D1_LOJA==SF1->F1_LOJA .and. !eof()
		
				// ubicar el fabricante del producto que ser?impreso
			//	SB1->(dbseek(xFilial("SB1")+SD1->D1_COD))
			//	@ nLin,000 psay SD1->D1_COD picture pesqpict("SD1","D1_COD")
			//	@ nLin,009 psay SB1->B1_UCFABR
			//	if (SC6->(dbseek(xFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)))
			//		@ nLin,014 psay SC6->C6_DESCRI picture pesqpict("SC6","C6_DESCRI")
			//	else   
			//		SB1->(dbseek(xFILIAL("SB1")+SD2->D2_COD))
			//		@ nLin,014 psay SB1->B1_DESC 
			//	endif    
			//	@ nLin,045 psay SD1->D1_QUANT picture "@E 999,999.99" 
			
				@ nLin,000 psay ALLTRIM(SD1->D1_COD)
				SB1->(dbseek(xFILIAL("SB1")+SD1->D1_COD))
				@ nLin,010 psay ALLTRIM(SB1->B1_DESC)
				if (len(ALLTRIM(SB1->B1_UDIMENS))>0)
					@ nLin,040 psay ALLTRIM(SB1->B1_UDIMENS)
				endif
				if (len(ALLTRIM(SB1->B1_UCAPACI))>0)
					if (len(ALLTRIM(SB1->B1_ESPECIF))>40)
						@ nLin,056 psay SUBS(SB1->B1_ESPECIF,1,40)
					else
						@ nLin,056 psay ALLTRIM(SB1->B1_ESPECIF)
					endif
				endif
				if (len(ALLTRIM(SB1->B1_UCAPACI))>0)
					@ nLin,098 psay ALLTRIM(SB1->B1_UCAPACI)
				endif
				if (len(ALLTRIM(SD2->D2_NUMSERI))>0)
					@ nLin,115 psay ALLTRIM(SD2->D2_NUMSERI)
				endif
				if (len(ALLTRIM(SB1->B1_MODELO))>0)
					@ nLin,126 psay ALLTRIM(SB1->B1_MODELO)
				endif
				if (len(ALLTRIM(SB1->B1_UTAG))>0)
					@ nLin,136 psay ALLTRIM(SB1->B1_UTAG)
				endif
				if (len(ALLTRIM(SD2->D2_UNUMSAL))>0)
					@ nLin,146 psay ALLTRIM(SD2->D2_UNUMSAL)
				endif
				@ nLin,156 psay SD1->D1_QUANT picture "@E 999,999.99"
				@ nLin,168 psay ALLTRIM(SD2->D2_UM)
				nTotItem += SD1->D1_CUSTO
				if (len(ALLTRIM(SB1->B1_ESPECIF))>40)	
					nLin++
					@ nLin,056 psay ALLTRIM(SUBS(SB1->B1_ESPECIF,41,41))
				Endif
				dbskip()
			   nLin++			
			enddo     
			dbselectarea("SF1")         
			nLin := 24
			@ nLin,00 psay CHR(15)+"RECIBI CONFORME                                            AUTORIZADO POR"+CHR(18)
			nLin++
			@ nLin,00 psay CHR(15)+"NOMBRE Y FIRMA-->                                          NOMBRE Y FIRMA-->"+CHR(18)
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin++
			@ nLin,000 psay CHR(15)
			@ nLin,015 psay "Valor merc.: "+transform(nTotItem,"@E 99,999,999.99")+chr(18)
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin++		
			If Empty(_PAR04) .and. Empty(_PAR05)
//				@ nLin,000 psay SF1->F1_UCOBS
			Else
				@ nLin,000 psay CHR(15)+_PAR04+space(05)+_PAR05+CHR(18)			
			Endif
			nLin++
			@ nLin,000 psay replicate("-",182)    
			nLin+=3  
	//		SF2->(dbskip())
			@ nLin,000 psay space(01)	// para "saltar" efetivamente e passar para a proxima pagina.
			setprc(0,0)
			incregua()
		Next _Copias
	ENDIF  		 
	nTotItem := 0
  	SF1->(DBSKIP())	
  Endif
enddo
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

Static Function VerImp()
nLin:= 0                
If aReturn[5]==2
   nOpc:= 1
   While .T.
      Eject
      dbCommitAll()
      SETPRC(0,0)
      IF MsgYesNo("Fomulario esta posicionado ? ")
         nOpc := 1
      ElseIF MsgYesNo("Intenta Nuevamente ? ")
			nOpc := 2
      Else
			nOpc := 3
      Endif
      Do Case
         Case nOpc==1
            lContinua:=.T.
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif
Return

Static Function RemPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("RES010",10)
aRegs:={}


aadd(aRegs,{cPerg,"01","Remito inicial: ","Remito inicial:","Initial remito:","mv_ch1","C",12,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Remito final:","Remito final:","Final remito:","mv_ch2","C",12,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Serie:","Serie:","Series:","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Texto livre (ate 60 pos.):","Glosa (hasta 60 pos.):","Free text (60 char. max.):","mv_ch4","C",60,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Mensagem (ate 60 pos.):","Mensaje (ate 60 pos.):","Message (ate 60 pos.):","mv_ch5","C",60,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Copias:","Copias:","Copias:","mv_ch6","N",1,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Tipo:","Tipo:","Tipo:","mv_ch7","N",1,0,1,"C","","mv_par07","Salida","Salida","Salida","","","Entrada","Entrada","Entrada","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	endif
Next
dbSelectArea(_sAlias)
Return


