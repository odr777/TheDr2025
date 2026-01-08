#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"        

/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ  TRAINV  บAutor  ณJorge Saavedra      Fecha 28/05/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑDescripcionณ Nota de ingreso a inventario                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BASE BOLIVIA                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TRAINV()
 
 Local oReport    
 Local nOrdem  := 0
 Local wnrel   := "TRAINV" // Nome default do relat๓rio em disco
 //Local tamanho := "M"
 //Local titulo  := OemToAnsi("ORDEN DE NACIONALIZACION Rev.1") //"Pick-List  (Expedicao)"
 Local cDesc1  := OemToAnsi("REVALORIZACION DE INVENTARIO") //"Emisso de produtos a serem separados pela expedicao, para"
 Local cDesc2  := OemToAnsi("") //"determinada faixa de pedidos."
 Local cDesc3  := ""
 Local cString := "SF1" // Alias do arquivo principal do relat๓rio para o uso de filtro

 PRIVATE cPerg    := "TRINV" // Nome da pergunte a ser exibida para o usuแrio Nota de ingreso a inventario.
 Private _cAlm	  := ""
 PRIVATE aReturn  := {"Zebrado", 1,"Administracion", 2, 2, 1, "",1} //"Zebrado"###"Administracao" // Array com as informa็๕es para a tela de configura็ใo da impressใo
 PRIVATE nomeprog := "TRAINV" //Nome do programa do relat๓rio
 PRIVATE nLastKey := 0 //Utilizado para controlar o cancelamento da impressใo do relat๓rio.
 PRIVATE nBegin   := 0
 PRIVATE aLinha   := {} //Array que contem informa็๕es para a impressใo de relat๓rios cadastrais
 PRIVATE li       := 15 //Controle das linhas de impressใo. Seu valor inicial ้ a quantidade mแxima de linhas por pแgina utilizada no relat๓rio.
 PRIVATE limite   := 132 //Quantidade de colunas no relat๓rio (80, 132, 220).
 PRIVATE lRodape  := .F.
 PRIVATE m_pag    := 1    //Controle do n๚mero de pแginas do relat๓rio.  
 PRIVATE titulo   := "TRANSFERENCIA DE STOCK"
 PRIVATE cabec1   := ""
 PRIVATE cabec2   := ""
 PRIVATE tamanho  := "M"
 PRIVATE _cTipoOp

 aOrd :={}
cTipodoc	:= IIf(aCfgNf[1]==64,'E','S') 
 //Pergunte('REMT10',.F.)
 //_cTipoOp:=If(mv_par01==1,'E','S')  //Indica se ้ transferencia de Entrada ou Saํda		 
 
 If !Empty(cTipodoc)
 	_cTipoOp :=	cTipodoc        //E: Entrada; S: Salida; P: Pantalla
 Else	
 	_cTipoOp := 'P'
 Endif
 If cTipodoc $ 'E'
 	titulo += " (ENTRADA)"
 else
 	titulo += " (SALIDA)"
 end
//-------------------------------------------------------------------- 
 ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO		 
 GraContPert()
 
 If AllTrim(Funname()) == 'MATA462TN'
 	Pergunte(cPerg,.F.)
 Else
 	Pergunte(cPerg,.T.)
 Endif
   
  
 wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
 
 If nLastKey == 27
  dbClearFilter()
  Return
 Endif
 
 SetDefault(aReturn,cString)
 
 If nLastKey == 27
  dbClearFilter()
  Return
 Endif
 
 RptStatus({|lEnd| OCDAT1(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  

 
Return
    
//------------------------------------------------------
Static  Function OCDAT1(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)
 
  fImpInforme()         
 
	If aReturn[5] = 1
	  Set Printer TO
	  dbCommitAll()
	  OurSpool(wnrel)
	 EndIf
	 MS_FLUSH()  
	
Return NIL



Static Function fImpInforme()


Local nTotalcant    := 00.0
Local nTotalval    := 00.0

nOrdem:=aReturn[8]
       
//"+RetSqlName("SYA")+" SYA On B1_UPROCE=YA_CODGI "

If _cTipoOp=='E'                                                                                        
	cQuery := "select F1_DOC,F1_EMISSAO,F1_FILORIG,B1_DESC,D1_LOTECTL,D1_CUSTO, "
//(D1_QUANT*D1_CUSTO) as total, "//c6_num,
	cQuery += "D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_UM,D1_PEDIDO,D1_ITEMORI,D1_NFORI ,F1_MOEDA,NNR.NNR_DESCRI as almdes,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG  "//B2_QATU,B2_CM1  "
	cQuery += "from " + RetSqlName("SF1") + " SF1 "     
	cQuery += "inner Join " + RetSqlName("SD1") + " SD1 on F1_DOC=D1_DOC and F1_FILIAL=D1_FILIAL and F1_SERIE=D1_SERIE and D1_TIPODOC='64' AND D1_FORNECE=F1_FORNECE" 
	cQuery += " and F1_FILORIG = '"+trim(mv_par01)+"' AND F1_FILIAL = '"+trim(mv_par02)+"'"
	cQuery += " and F1_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
	cQuery += " and F1_DOC Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
	cQuery += " and F1_SERIE Between '"+trim(mv_par07)+"' and '"+trim(mv_par08)+"'"
	cQuery += " AND SD1.D_E_L_E_T_!='*'"
	//cQuery += "left outer Join " + RetSqlName("SD2") + " SD2 on D2_doc=D1_doc and D2_filial=F1_FILORIG and D2_serie=D1_SERIORI and D2_TIPODOC='54' and SD2.D_E_L_E_T_!='*' "  
	cQuery += "inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=D1_COD AND SB1.D_E_L_E_T_!='*' "
	/*cQuery += "left outer Join " + RetSqlName("SC7") + " SC7 on C7_NUM=D1_PEDIDO AND C7_ITEM=D1_ITEMPC and F1_FILORIG=C7_FILIAL and C7_local=d1_local and C7_NUMSC<>' ' and SC7.D_E_L_E_T_!='*' "
	cQuery += "left outer Join " + RetSqlName("SC6") + " SC6 on C6_NUMSC=C7_NUMSC AND C6_ITEMSC=C7_ITEMSC and F1_FILORIG=C6_FILIAL AND C6_local=d1_local and C6_NUMSC<>' ' AND SC6.D_E_L_E_T_!='*' "
	cQuery += "left outer Join " + RetSqlName("SA1") + " SA1 on A1_COD=C6_CLI and c6_loja=a1_loja AND SA1.D_E_L_E_T_!='*'" 
	//cQuery += "left outer Join " + RetSqlName("SB2") + " SB1 on B2_COD=d1_COD and b2_local=d1_local and b2_filial=d1_filial "*/  
	cQuery += "inner Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D1_LOCAL and F1_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' AND SF1.D_E_L_E_T_!='*'"
	//cQuery += "inner Join " + RetSqlName("SZB") + " SZX on SZX.zb_local=d2_local and F1_FILORIG=SZX.zb_filial AND SZX.D_E_L_E_T_!='*'"  
	//cQuery += " and sf1.d_e_l_e_t_=' ' and sd1.d_e_l_e_t_=' ' and f1_serie='TRF' and sa1.d_e_l_e_t_=' ' "//and sb1.d_e_l_e_t_=' ' "
	//cQuery += " group by F1_DOC,F1_EMISSAO,F1_FILORIG,B1_DESC,D1_CUSTO,D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_PEDIDO,D1_ITEMORI,D1_NFORI,F1_MOEDA,NNR.NNR_DESCRI,D1_VUNIT,D1_TOTAL,F1_SERIE,D1_LOCAL,D1_LOTECTL,D1_LOCALIZ,D1_NUMSERI,D1_NFORI,D1_SERIORI,F1_USRREG  "//,c6_num,
	cQuery += " order by D1_ITEM " 
Else
	cQuery := "select F2_FILIAL,F2_DOC,F2_EMISSAO,F2_FILDEST,B1_DESC,D2_LOTECTL,D2_CUSTO1,D2_UM,(D2_QUANT*D2_CUSTO1) as total,A1_NOME, max(A1_NOME) as cli1,min(A1_NOME) as cli2, "//c6_num,
	cQuery += "D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_PEDIDO,D2_ITEMORI,D2_NFORI ,F2_MOEDA,NNR.NNR_DESCRI as almdes,D2_LOCDEST,F2_SERIE,D2_LOCAL,D2_LOTECTL,D2_LOCALIZ,D2_NUMSERI,F2_USRREG   "//B2_QATU,B2_CM1  "
	cQuery += "from " + RetSqlName("SF2") + " SF2 "     
	cQuery += "inner Join " + RetSqlName("SD2") + " SD2 on F2_DOC=D2_DOC and F2_FILIAL=D2_FILIAL and F2_SERIE=D2_SERIE and D2_TIPODOC='54' " 
	cQuery += " and F2_FILDEST = '"+trim(mv_par01)+"' AND F2_FILIAL = '"+trim(mv_par02)+"'"
	cQuery += " and F2_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
	cQuery += " and F2_DOC Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
	cQuery += " and F2_SERIE Between '"+trim(mv_par07)+"' and '"+trim(mv_par08)+"'"
	cQuery += "inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=D2_COD and sb1.d_e_l_e_t_=' ' "  
	cQuery += "inner Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D2_LOCAL and F2_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' "  
	cQuery += "left outer Join " + RetSqlName("SA1") + " SA1 on A1_COD=F2_CLIENTE and F2_LOJA=A1_LOJA and sa1.d_e_l_e_t_=' ' " 
	cQuery += " WHERE sf2.d_e_l_e_t_=' ' and sd2.d_e_l_e_t_=' '  "//and sb1.d_e_l_e_t_=' ' "
	cQuery += " group by F2_FILIAL,F2_DOC,F2_EMISSAO,F2_FILDEST,B1_DESC,D2_CUSTO1,D2_UM,D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_PEDIDO,D2_ITEMORI,D2_NFORI,F2_MOEDA,NNR.NNR_DESCRI,D2_PRCVEN,D2_TOTAL,A1_NOME,D2_LOCDEST,F2_SERIE,D2_LOCAL,D2_LOTECTL,D2_LOCALIZ,D2_NUMSERI,F2_USRREG    "//,c6_num,
	cQuery += " order by D2_ITEM " 
Endif

//Aviso("",cQuery,{'ok'},,,,,.t.)

//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//MemoWrite("\TRAINV.sql",cQuery)  
TCQUERY cQuery NEW ALIAS "OrdenesCom"
   
 moneda:=""  
 
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15,,.F.)
 fImpCab() // IMPRIME LA CABECERA  
 
 li := 14
 j	:= 1
 sw	:= 1    

 While OrdenesCom->(!EOF())
	If li > 58
	 	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15,,.F.)
	Endif
	If _cTipoOp=='E'
 
	     If (sw==1)  
	           _cAlm:=Posicione("SD2",1,OrdenesCom->F1_FILORIG+OrdenesCom->D1_COD,"D2_LOCAL")
	          //_cAlmDes:=OrdenesCom->D1_ITEMORI
	          sw:=2
	     EndIf
		 @ li,5 PSAY OrdenesCom->D1_COD	 
		 
		 cNumPart := OrdenesCom->D1_NUMSERI //POSICIONE("SB1",1,XFILIAL("SB1")+OrdenesCom->D1_COD,"B1_UFRU")
		 
		 @ li,38/*50*/ PSAY SUBSTR(OrdenesCom->B1_DESC,1,40) 
		 	   
		 @ li,113/*118*/ PSAY OrdenesCom->D1_QUANT	Picture	 "@E 999,999.99"   
	     //@ li,98 PSAY XMOEDA(OrdenesCom->D1_VUNIT,OrdenesCom->F1_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"   
		 //@ li,113 PSAY XMOEDA(OrdenesCom->D1_total,OrdenesCom->F1_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"																									
		 //@ li,98 PSAY OrdenesCom->D1_VUNIT Picture "@E 99,999,999.99"   
		@ li,98 PSAY OrdenesCom->D1_UM  
//		 @ li,20 PSay SubStr(cNumPart,1,15)		
		 
			//If len(cNumPart)> 15		

		//	@ li,60/*60*/ PSAY  OrdenesCom->D1_LOTECTL	
		 if len(alltrim(OrdenesCom->B1_DESC))>45
		 li++
		 @ li,38 PSay alltrim(SubStr(OrdenesCom->B1_DESC,46,80))
		 endif
		 if !Empty(OrdenesCom->D1_LOTECTL)
		 li++      // nahim
		 @ li,38/*85*/ PSAY  OrdenesCom->D1_LOTECTL	
		 endif
		 
		//	@ li,73/*85*/ PSAY  OrdenesCom->D1_LOCALIZ
			//Endif
		                           	
	    nTotalval:=nTotalval+D1_TOTAL  
	    nTotalcant:=nTotalcant+ OrdenesCom->D1_QUANT
	    moneda :=OrdenesCom->F1_MOEDA   
   
   Else                                                  
   /*

	     If (sw==1)  
	           _cAlm:=Posicione("SD2",1,OrdenesCom->F1_FILORIG+OrdenesCom->D1_COD,"D2_LOCAL")
	          //_cAlmDes:=OrdenesCom->D1_ITEMORI
	          sw:=2
	     EndIf   
	     */
		 @ li,01 PSAY OrdenesCom->D2_COD	 
	
		 cNumPart := OrdenesCom->D2_NUMSERI//POSICIONE("SB1",1,XFILIAL("SB1")+OrdenesCom->D2_COD,"B1_UFRU")
		 //@ li,18 PSAY SUBSTR(cNumPart,1,15)
		 //@ li,39/*50*/ PSAY SUBSTR(OrdenesCom->B1_DESC,1,23)

		 @ li,38 PSay alltrim(SubStr(OrdenesCom->B1_DESC,1,45))			
		 @ li,113 PSAY OrdenesCom->D2_QUANT Picture	 "@E 999,999.99"  
	     //@ li,98 PSAY XMOEDA(OrdenesCom->D1_VUNIT,OrdenesCom->F1_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"   
		 @ li,98 PSAY OrdenesCom->D2_UM 																								
		 //@ li,98 PSAY OrdenesCom->D2_PRCVEN Picture "@E 99,999,999.99" 
		 
		 //@ li,113 PSAY OrdenesCom->D2_TOTAL Picture "@E 99,999,999.99"	
		 if len(alltrim(OrdenesCom->B1_DESC))>45
		 li++
		 @ li,38 PSay alltrim(SubStr(OrdenesCom->B1_DESC,46,80))
		 endif
		 if !Empty(OrdenesCom->D2_LOTECTL)
		 li++      // nahim
		 @ li,38/*85*/ PSAY  OrdenesCom->D2_LOTECTL	
		 endif

		 
		//If Len(cNumPart)> 15 .Or. Len(OrdenesCom->B1_DESC)> 20 .OR. Len(OrdenesCom->almdes)> 25
			li++
			//If len(cNumPart)> 15		
			
			//Endif
			//If len(OrdenesCom->B1_DESC)> 20
			
			//Endif
			/*If len(OrdenesCom->almdes)> 26
				@ li,56 PSay SubStr(OrdenesCom->almdes,27,26)
			Endif
		Endif*/
		                           	
	    nTotalval:=nTotalval+D2_total   
	    nTotalcant:=nTotalcant+ OrdenesCom->D2_QUANT
	    moneda :=OrdenesCom->f2_moeda   
    End

    li++
    j++ 
    OrdenesCom->(dbSkip())   
 End     
 @ li,02 PSAY REPLICATE('_',130)          
 //total( nTotalval)	
  total( nTotalval,moneda,MV_PAR07,li,nTotalcant )	
 OrdenesCom->(DbCloseArea()) 
//lert("chau")
Return
 

Static Function fImpCab()
 //SetPrc(0,0)                
 //cUsuario:=RetCodUsr() 
 nomusuario:=Subs(cUsuario,7,15)

// @ 007,50 PSAY "ORDEN DE NACIONALIZACION "    
// @ 007,80 PSAY "Rev.1"   
// _cEmp:=cfuncao()       
//alert(cnumemp)
 //uvc_direc := Posicione("SM0",1,substr(cnumemp,1,2)+dba->dba_filial,"M0_ENDENT") 
 @ 006,02 PSAY "Documento: " + If( _cTipoOp=='E' ,OrdenesCom->F1_SERIE+" - "+OrdenesCom->F1_DOC,OrdenesCom->F2_SERIE+" - "+OrdenesCom->F2_DOC)
 @ 006,90 PSAY "Fecha: " + ffechalatin(If(_cTipoOp=='E',OrdenesCom->f1_EMISSAO,OrdenesCom->f2_EMISSAO)) 
 @ 007,90 PSAY "T.C.:: " + TRANSFORM(POSICIONE("SM2",1,If(_cTipoOp=='E',OrdenesCom->F1_EMISSAO,OrdenesCom->f2_EMISSAO),"M2_MOEDA2"),"@E 99.99") 
 /*alert(OrdenesCom->C6_NUM)
 alert(cli2)      
 alert(OrdenesCom->A1_NOME) */    
//@ 008,02 PSAY "Cliente: " + OrdenesCom->A1_NOME              
  
/* 
if OrdenesCom->cli1==OrdenesCom->cli2 
   @ 008,02 PSAY "Cliente: " + OrdenesCom->A1_NOME              
 else 
    if OrdenesCom->cli1<>OrdenesCom->cli2  
     @ 008,02 PSAY "Varios Clientes "              
   else 
     @ 008,02 PSAY "Cliente: " + OrdenesCom->A1_NOME       
   endif  
 endif*/
  
  iF _cTipoOp=='S'
  	@ 007,03 PSAY "SUCURSAL ORIGEN:  " + OrdenesCom->F2_FILIAL + "     DEPOSITO ORIGEN:  " + POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D2_LOCAL,'NNR_DESCRI')	
  	@ 008,02 psay "SUCURSAL DESTINO: "+ OrdenesCom->F2_FILDEST + "     DEPOSITO DESTINO: " + POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D2_LOCDEST,'NNR_DESCRI')
  ELSE
  @ 007,03 PSAY  "SUCURSAL ORIGEN:  " + OrdenesCom->F1_FILORIG + "     DEPOSITO ORIGEN:  " + POSICIONE('NNR',1,XFILIAL('NNR')+ Posicione("SD2",3,OrdenesCom->F1_FILORIG+OrdenesCom->(D1_NFORI+D1_SERIORI),"D2_LOCAL"),'NNR_DESCRI')	
  @ 008,02 psay "SUCURSAL DESTINO: "+ Right(CNUMEMP,2) + "     DEPOSITO DESTINO: " + POSICIONE('NNR',1,XFILIAL('NNR')+ OrdenesCom->D1_LOCAL,'NNR_DESCRI')

  END
  
  @ 009,02 PSAY "Registrado Por: " + upper( If( _cTipoOp=='E' ,OrdenesCom->F1_USRREG ,OrdenesCom->F2_USRREG ))    		 	       
  @ 009,90 PSAY "Impreso Por: " + SUBSTR(CUSERNAME,1,15)                                                                                                          
 //alorigen:=POSICIONE("SZB",1,If( _cTipoOp=='E',OrdenesCom->F1_FILORIG,OrdenesCom->F2_FILIAL)+_cAlm,"ZB_NOMALM") 
  alorigen:=""//OrdenesCom->ALMORG
  
 /*@ 008,80 PSAY "Origen: "  + trim(alorigen) //OrdenesCom->almorg //ciudad(OrdenesCom->F1_FILORIG)
 @ 009,02 PSAY "Glosa: " //+ OrdenesCom->F2_DOC
 @ 010,02 PSAY "Transferencia de " + trim(alorigen) + " a " +  trim(OrdenesCom->almdes) + " PC No."  + If(_cTipoOp=='E',OrdenesCom->D1_PEDIDO ,OrdenesCom->D2_PEDIDO)
*/   
 @ 011,02 PSAY REPLICATE('_',130)  

 @ 012,05 PSAY "Codigo" 
// @ 012,20 PSAY "Num.Parte" 
 @ 012,38 PSAY "Descripci๓n"  
  // @ 012,60 PSAY "Lote"	//nahim   
 //  @ 012,73 PSAY "Ubicaci๓n" //nahim
 @ 012,97 PSAY "UM"													
 //@ 012,106 PSAY "Costo"												
 @ 012,118 PSAY "Cantidad"  
// @ 011,120 PSAY "Diferencia"																			
 @ 013,02 PSAY REPLICATE('_',130)    												
 
return		 
Static function total( _nTotalVal,moneda,cambio,li,cant)
mone:=""	  
/*if cambio=1
 mone:=supergetmv("mv_simb1")//"$Bs"
else
 mone:=supergetmv("mv_simb2")//"$Us" 	
endif   */
 
 li:=li+3                 
// @ li, 88 Psay cant
 //@ li, 88 Psay "Total General: "      
// @ li, 112 Psay XMOEDA(_nTotalVal,moneda,cambio,DDATABASE) Picture "@E 99,999,999.99"      // Total    
// @ li, 112 Psay _nTotalVal Picture "@E 99,999,999.99"      // Total 
 //@ li, 127 PSAY mone
 li:=li+5
 @ li, 34 PSAY "_ _ _ _ _ _ _ _ _ _ _"    
 @ li, 74 PSAY "_ _ _ _ _ _ _ _ _ _ _" 
 li++    
 @ li, 34 PSAY "   "+Subs(cUsuario,7,15)    
 @ li, 76 PSAY "Firma Autorizada" 
return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณ Walter Alvarez ณ  04/11/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{"01","De Sucursal Origen      :","mv_ch1","C",4,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"SM0",""})
aAdd(aRegs,{"02","A Sucursal Destino      :","mv_ch2","C",4,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0",""})
aAdd(aRegs,{"03","De Fecha de Emisi๓n     :","mv_ch3","D",08,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"04","A Fecha de Emisi๓n      :","mv_ch4","D",08,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"05","De Nro. Documento       :","mv_ch5","C",20,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"06","A Nro. Documento        :","mv_ch6","C",20,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"07","De Serie                :","mv_ch7","C",20,0,0,"G","mv_par07",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"08","A Serie                 :","mv_ch8","C",20,0,0,"G","mv_par08",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"09","De Proveedor            :","mv_ch9","C",20,0,0,"G","mv_par09",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"10","A Proveedor             :","mv_ch10","C",20,0,0,"G","mv_par10",""       ,""            ,""        ,""     ,"",""})

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
   dbSeek(cPerg+aRegs[i][1])
   If !Found()
      RecLock("SX1",!Found())
         SX1->X1_GRUPO    := cPerg
         SX1->X1_ORDEM    := aRegs[i][01]
         SX1->X1_PERSPA   := aRegs[i][02]
         SX1->X1_VARIAVL  := aRegs[i][03]
         SX1->X1_TIPO     := aRegs[i][04]
         SX1->X1_TAMANHO  := aRegs[i][05]
         SX1->X1_DECIMAL  := aRegs[i][06]
         SX1->X1_PRESEL   := aRegs[i][07]
         SX1->X1_GSC      := aRegs[i][08]
         SX1->X1_VAR01    := aRegs[i][09]
         SX1->X1_DEFSPA1    := aRegs[i][10]
         SX1->X1_DEFSPA2    := aRegs[i][11]
         SX1->X1_DEFSPA3    := aRegs[i][12]
         SX1->X1_DEFSPA4    := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]            
      MsUnlock()
   Endif
Next

Return    
  
Return

Static Function ffechalatin(sfechacorta)
     
Local ffechalatin:=""             
Local sdia:=substr(sfechacorta,7,2)
Local smes:=substr(sfechacorta,5,2)
Local sano:=substr(sfechacorta,3,2)
ffechalatin := sdia + "/" + smes + "/" + sano
Return(ffechalatin)    



Static Function GraContPert()

SX1->(DbSetOrder(1))
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FILORIG,SF2->F2_FILDEST)       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FILIAL,SF2->F2_FILIAL)          //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End               

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',dtoc(SF1->F1_EMISSAO),dtoc(SF2->F2_EMISSAO))        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',dtoc(SF1->F1_EMISSAO),dtoc(SF2->F2_EMISSAO))        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_DOC,SF2->F2_DOC)      //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_DOC,SF2->F2_DOC)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End     

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_SERIE,SF2->F2_SERIE)      //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"08"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_SERIE,SF2->F2_SERIE)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"09"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FORNECE,SF2->F2_CLIENTE)      //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"10"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FORNECE,SF2->F2_CLIENTE)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End     
Return



static function  ciudad(filial)  

  Local aSaveArea := GetArea()
  DbSelectArea('SM0')
  SM0->(DbGoTop())        
  _cNomeEmp:=""
  While SM0->(!EOF())

          If SM0->(M0_CODFIL) == filial

               _cNomeEmp:=SM0->M0_FILIAL
               RestArea(aSaveArea)
		   return (_cNomeEmp) 
         EndIf 
        SM0->(DbSkip())
  End
 RestArea(aSaveArea)
return (_cNomeEmp) 
Return