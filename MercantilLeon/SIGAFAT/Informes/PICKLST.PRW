#INCLUDE "RWMAKE.CH"

User Function PICKLST()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PICKLST  ³ Autor ³Jose Carlos Taborga   ³ Data ³16.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Emitir Pick List - Mercantil Leon S.R.L.                    ³±±
±±º          ³  				                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Emitir Pick List                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Local cQuery := ""
Private aPerg :={}
Private cPerg := "NOPED"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private cVendedor := "" 
Private nPesoBrt  := 0

fAjustaSx1()

Pergunte(cPerg,.T.)

If Select("PICKLDET") <> 0
	PICKLDET->( DbCLoseArea() )
End

Processa({|lEnd|MontaRel(),"Imprimiendo Reporte","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function MontaRel()

Local nD, nP , nC, _cObs
Private _cObsItem := ""
Private nCont  := 0
Private nCont1 := 1
Private Cont   := 1
Private Cont1  := 15
Private oPrint,oFont8,oFont10,oFont16,oFont16n,oFont24
Private cNom1,cMoneda,cDirec,cTel,cFax,cLugarEnt,cDps, cDirDps  := ""

// Datos Empresa de SIGAMATEMP
Private aDadosEmp	:=	{SM0->M0_NOMECOM,; //Nome da Empresa - 1
SM0->M0_ENDCOB ,; //Endereço - 2
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,;//Complemento - 3
Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; //CEP - 4
SM0->M0_TEL,; //Telefones - 5
alltrim(SM0->M0_CGC),; // CNPJ - 6
alltrim(SM0->M0_FILIAL),; // SUCURSAL -7
Subs(SM0->M0_CIDENT,1,20)} //CIUDAD - 8


//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//oBrush := TBrush():New("",4)
oPrint:= TMSPrinter():New("PickList")
oPrint:SetPortrait() // ou SetPortrait() or SetLandscape

oPrint:Setup() // para configurar impressora

DbSelectArea("SA1"); DbSetOrder(1) //Clientes

////// Query peso neto

cQuery1 := "Select ROUND(SUM(B1_PESO*C6_QTDVEN),2) PESO "
cQuery1 += "From " + RetSqlName("SC5") + " SC5 "
cQuery1 += "Inner Join " + RetSqlName("SC6") + " SC6 on C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL  "
cQuery1 += "Left outer Join " + RetSqlName("SB1") + " SB1 on B1_COD=C6_PRODUTO "
cQuery1 += " WHERE C5_FILIAL Between '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
cQuery1 += " and C5_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"' "
cQuery1 += " and C5_NUM Between '"+alltrim(mv_par05)+"' and '"+alltrim(mv_par06)+"'"
cQuery1 += " and SC5.D_E_L_E_T_=' ' and SC6.D_E_L_E_T_=' ' " 

dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery1),"PESOBRT", .F., .T.)

DbSelectArea("PESOBRT")
DbGoTop()            

nPesoBrt := PESOBRT->PESO 

PESOBRT->( DbCloseArea() )


////// Query Pick List Mercantil Leon


cQuery := "Select distinct C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_EMISSAO,C5_FECENT,C5_CONDPAG,C5_DESC1,C5_MENNOTA, C5_UNOMCLI, C5_UNITCLI,C5_ULUGENT,C5_TPFRETE, C5_FRETE, "
cQuery += "C5_UTPOENT, C5_UNUCOCL,C5_PBRUTO,C5_TRANSP,C5_COTACAO, C5_UOBSERV, C5_USRREG,A3_NOME, "
cQuery += "C6_ENTREG,C6_ITEM, B1_UCODFAB,C6_PRODUTO,C6_LOCAL,C6_NUMLOTE,C6_LOTECTL, NNR_DESCRI, NNR_UDIREC,C6_UM, C6_QTDVEN,C6_PRCVEN,C6_VALOR,"
cQuery += "A1_NOME,A1_CGC,A1_END,C6_DESCRI, C6_UESPECI ,C5_TXMOEDA,C5_MOEDA,E4_DESCRI "
cQuery += "From " + RetSqlName("SC5") + " SC5 "
cQuery += "Inner Join " + RetSqlName("SC6") + " SC6 on C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL  "
cQuery += "Left outer Join " + RetSqlName("SA1") + " SA1 on A1_COD=C5_CLIENTE "
cQuery += "Left outer Join " + RetSqlName("SA3") + " SA3 on A3_COD=C5_VEND1 "
cQuery += "Left outer Join " + RetSqlName("SB1") + " SB1 on B1_COD=C6_PRODUTO "
cQuery += "Left outer Join " + RetSqlName("SE4") + " SE4 on E4_CODIGO=C5_CONDPAG "
cQuery += "left outer Join " + RetSqlName("NNR") + " NNR on NNR_CODIGO=C6_LOCAL "
cQuery += " WHERE C5_FILIAL Between '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
cQuery += " and C5_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"' "
cQuery += " and C5_NUM Between '"+alltrim(mv_par05)+"' and '"+alltrim(mv_par06)+"'"
cQuery += " and SC5.D_E_L_E_T_=' ' and SC6.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"'"          


dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"PICKLDET", .F., .T.)

TcSetField( "PICKLDET", "C5_EMISSAO" , "D", 8, 0 )
TcSetField( "PICKLDET", "C5_FECENT"  , "D", 8, 0 )
TcSetField( "PICKLDET", "C6_ENTREG"  , "D", 8, 0 )

DbSelectArea("PICKLDET")
DbGoTop()

//Codigo        CodigoFabrica  Descripcion Producto           UM  Ctd Vendida      AlmacenUbicacion       Lote

Do While !PICKLDET->(Eof())
	SA1->(DbSeek( xFilial("SA1") + PICKLDET->C5_CLIENTE + PICKLDET->C5_LOJACLI) )
	cCodCredor 		:= SA1->A1_COD
	cLojaCredor		:= SA1->A1_LOJA
	cNomeCredor 	:= Alltrim(SA1->A1_NOME)
	cCGC        	:= SA1->A1_CGC
	cEnd        	:= Alltrim(SA1->A1_END)
	cBairro			:= Alltrim(SA1->A1_BAIRRO)
	cTel        	:= Alltrim(SA1->A1_TEL)
	cMun        	:= Alltrim(SA1->A1_MUN)
	cEst        	:= SA1->A1_EST
	cTemCredor  	:= .T.
	cNaoBloqueado	:= .T.
	cTemCredor    	:= .F.
	cNumPed       	:= PADR(PICKLDET->C5_NUM,TAMSX3("C5_NUM")[01])
	cCodCli       	:= PICKLDET->C5_CLIENTE
	cNumSC			:= PADR(PICKLDET->C5_COTACAO,TAMSX3("C5_COTACAO")[01])
	aDados        	:= {}
	_cObs       	:= PICKLDET->C5_UOBSERV 
	dDataEmi		:= PICKLDET->C5_EMISSAO
	dDataEnt		:= PICKLDET->C5_FECENT

	cTipoFrete		:= IF(PICKLDET->C5_TPFRETE = "F","FOB","CIF") + " / Bs. " + Transform(PICKLDET->C5_FRETE,"@E 999,999.99")
	

	cAten      := PICKLDET->C5_UNOMCLI            // ATENCION
	cVendedor  := PICKLDET->A3_NOME              		// VENDEDOR
	nMon       := PICKLDET->C5_MOEDA                           //MONEDA
	
	dFecha1 := PICKLDET->C5_EMISSAO                 // FECHA
	
	dFecha2 := PICKLDET->C5_FECENT 						// FECHA DE ENTREGA
	cLugarEnt := PICKLDET->C5_ULUGENT                  //LUGAR DE ENTREGA
	cDps   := PICKLDET->C6_LOCAL + " - " + POSICIONE('NNR',1,XFILIAL('NNR')+PICKLDET->C6_LOCAL,'NNR_DESCRI') //PICKLDET->NNR_UDIREC                  //DIRECCION DEL DEPÓSITO
	cDirDps := PICKLDET->NNR_UDIREC
		
	Do Case
		Case nMon == 1 //bolivianos
			cMoneda := "BOLIVIANOS"
		Case nMon == 2 //dolar
			cMoneda := "DOLAR"
		Case nMon == 3 //ufv
			cMoneda := "UFV"
		Case nMon == 4 //euros
			cMoneda := "EUROS"
	EndCase
	
	Do While !Eof() .And. PICKLDET->C5_NUM == cNumPed
		//Detalle de anterior reporte consultar dónd se acomoda
		cdetalle	 := "Nro. Pedido: " + SC5->C5_NUM + "  Cliente: " + SC5->C5_CLIENTE+'-'+SC5->C5_LOJACLI + " - " +POSICIONE('SA1',1,XFILIAL('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_NOME') + "Despacho: " + Iif(SC5->C5_DOCGER == '1'," Interno",Iif(SC5->C5_DOCGER == '2',"Externo",""))+" Emisión PV:" + DTOC(SC5->C5_EMISSAO)

		//  ARMA REGISTRO DE PICKLIST
		aAdd(aDados,{PICKLDET->C6_ITEM,;	// 1  ITEM PEDIDO
		PICKLDET->C5_EMISSAO,;          	// 2  FECHA EMISION PEDIDO
		Alltrim(PICKLDET->C6_DESCRI),;     	// 3  DESCRIPCION PRODUCTO
		PICKLDET->C6_QTDVEN,;             	// 4  CANTIDAD
		PICKLDET->C6_PRCVEN,;              	// 5  PRECIO DE VENTA
		PICKLDET->C6_VALOR,;             	// 6  VALOR
		PICKLDET->C6_PRODUTO,;          	// 7  COD PRODUCTO
		PICKLDET->C6_UM,;            		// 8  UNIDAD DE MEDIDA
		PICKLDET->A3_NOME,;          	 	// 9  VENDEDOR
		Alltrim(PICKLDET->C5_MENNOTA),;		// 10 NOTA DEL PEDIDO DE VENTA
		cdetalle,;                          // 11 CADENA: "Nro. Pedido: " + SC5->C5_NUM + "  Cliente: " + SC5->C5_CLIENTE+'-'+SC5->C5_LOJACLI + " - " +POSICIONE('SA1',1,XFILIAL('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_NOME') + "Despacho: " + Iif(SC5->C5_DOCGER == '1'," Interno",Iif(SC5->C5_DOCGER == '2',"Externo",""))+" Emisión PV:" + DTOC(SC5->C5_EMISSAO)
		PICKLDET->B1_UCODFAB,; //posicione("SB1",1,xFilial("SB1")+PICKLDET->C6_PRODUTO,"B1_UCODFAB"),;// 12 CODIGO DE FABRICA CAMPO USUARIO
		PICKLDET->C6_LOCAL,;                //13 ALMACEN
		PICKLDET->C6_NUMLOTE,;		        // 14 LOTE *** ASIGNAR EL CAMPO QUE CORRESPONDE AL LOTE
		PICKLDET->C6_UESPECI,;              // 15 CAMPO USUARIO
		PICKLDET->C6_ENTREG})  	            // 16 FECHA ENTREGA
		DbSkip()
	EndDo
	
	lEmpCab := lEmpRoda := .t.
	
	// Controla Qtd de Numero de Linhas Por Pick List Maximo de 20 linhas nos itens de um pedido
	nLinMax	:= 20
	nLinAtu	:= 1
	lCrtPag	:= .T.
	
	For nP := 1 to len(aDados)
		
		If  nLinAtu > nLinMax
			nCont := nCont + 1
			oPrint:Say  (0260,2100,Transform(StrZero(ncont,3),""),oFont10)
			oPrint:Say  (0260,2170,"de",oFont10)
			oPrint:Say  (0260,2220,Transform(StrZero(ncont1,3),""),oFont10)
			oPrint:EndPage() // Finaliza a página
			lEmpCab := .T.
			lCrtPag	:= .F.
			nLinAtu := 1
		Endif
		
		If lEmpCab
			EmpCab(_cObs)
			lEmpCab := .f.
			nPos := 0
			
			If lCrtPag
				nCont := nCont + 1
			Endif
			
			oPrint:Say  (0260,2100,Transform(StrZero(ncont,3),""),oFont10)
			oPrint:Say  (0260,2170,"de",oFont10)
			oPrint:Say  (0260,2220,Transform(StrZero(ncont1,3),""),oFont10)
			
		Endif
		
		_nTamStr	:= 38
		_lChkTam	:= .T.
		_nTamDesc	:= 60
		_nTamPNum   := 20
		
		
		If nLinAtu <= nLinMax
			oPrint:Say  (0940+nPos,0110,aDados[nP,1],oFont8) //Item produto
			
			oPrint:Say  (0940+nPos,0200,aDados[nP,7],oFont8) //Codigo produto
			oPrint:Say  (0940+nPos,0410,Substr(aDados[nP,12],1,_nTampNum),oFont8) // Codigo de Fabrica
			
			oPrint:Say  (0940+nPos,0620,aDados[nP,3]+ " " + aDados[nP,15]+ " " + aDados[nP,14],oFont8) // Desc.Produto
			
			oPrint:Say  (0940+nPos,1720,aDados[nP,8],oFont8)//Unidade de medida
			oPrint:Say  (0940+nPos,1900,Transform(aDados[nP,4],"@R 9999.99"),oFont8)//quantidade produto
			
			oPrint:Say  (0940+nPos,2050,aDados[nP,13],oFont8)//Almacen
			oPrint:Say  (0940+nPos,2200,aDados[nP,14],oFont8)//Lote
			
			nPos  += 40
			nLinAtu := nLinAtu + 1
		endif
	Next
	
	DbSelectArea("PICKLDET")
	
	oPrint:EndPage() // Finaliza la página
	
Enddo

oPrint:EndPage() // Finaliza la página   

PICKLDET->( DbCloseArea() )

oPrint:Preview()  // Visualiza antes de imprimir

Return nil


//*****************************************************************************************
//|------------------------------------------------------------------------|
//| Impressao do corpo do pedido de compras                                |
//|------------------------------------------------------------------------|
Static Function EMPCAB(_cObs)


Private cPath := GetSrvProfString("Startpath","\img\") ///system/img/

//... Impressao do cabecalho
oPrint:StartPage()   // Inicia una nueva página

// ENCABEZADO TITULO CENTRO 
oPrint:Box	(0100,0100,0800,2400) //Box Cabecera
oPrint:Say  (0120,1050,"PICK LIST",oFont16n)

oPrint:SayBitmap (130,200,cPath+"img\LOGO.PNG",220,88 ) // Logo Empresa

//NOMBRE Y LOGO EMPRESA
oPrint:Say  ( 0230,0150,/*aDadosEmp[1]*/"MERCANTIL LEON S.R.L" ,oFont10) // Nombre de la empresa "M E R C A N T I L ''L E O N''"

// SUCURSAL MERCANTIL LEON 
oPrint:Say  ( 0280,0150, "Sucursal: " + aDadosEmp[7] ,oFont8) // Sucursal

//CLIENTE
oPrint:Say  (0330,0150,"Cliente: " + cCodCredor + " - " + cNomeCredor ,oFont8)

//VENDEDOR
oPrint:Say  ( 0380,0150,"Vendedor: " + alltrim(cVendedor) ,oFont8) // Vendedor

//LUGAR DE ENTREGA
oPrint:Say  (0430,0150,"Lugar de Entrega: " + alltrim(cLugarEnt),oFont8) // Lugar de entrega

//OBSERVACION           

oPrint:Say  (0500,0150,"Observación: ",oFont8)

_nColPc	:= 550
_nSubDe	:= 1
_nSubAt	:= 50

           
nTamObserv := round(len(PADR(_cObs,100/*TAMSX3("C5_UOBSERV")[01]*/))/50,0)

For nP := 1 to nTamObserv
    
	oPrint:Say  (_nColPc,0150,substr(_cObs,_nSubDe,_nSubAt),oFont10)
	_nSubDe := _nSubAt
	_nColPc	+= 50   	
Next              

// DATOS DERECHA

oPrint:Say  (0110,1600,"Pedido de Venta Nro: ",oFont10)
oPrint:Say  (0110,2000,cNumPed,oFont14)                                               
oPrint:Say  (0210,2100,"Total de Paginas",oFont10)



oPrint:Say  (0220,1600,"Fecha de Emisión",oFont8)
oPrint:Say  (0220,1850,DTOC(dDataEmi),oFont8)


oPrint:Say  (0270,1600,"Fecha de Entrega",oFont8) //Maxima fecha de entrega
oPrint:Say 	(0270,1850,DTOC(dDataEnt), oFont8)


oPrint:Say  (0360,1600,"Depósito de Entrega: " + alltrim(cDps),oFont8)
oPrint:Say  (0410,1600,"Dirección: " + alltrim(cDirDps),oFont8) 

oPrint:Say  (0460,1600,"Fecha de Impresión: " + DTOC(dDataBase)+ "   Hora: " + Time(),oFont8)  

oPrint:Say  (0520,1600,"Peso Bruto:" + iif(nPesoBrt > 0,transform(nPesoBrt,"@E 999,999.99")," "),oFont8)

oPrint:Box	(0820,0100,2800,2400) //Box cuerpo de datos de los itens
oPrint:Line	(0900,0100,0900,2400) //Linea vertical dividiendo box cabecera de los itens


//Item Codigo          Descripcion Producto                     UM  Ctd Vendida      Precio       Monto      Alm   Ubicacion       Lote

oPrint:Say  (0845,0110,"Item",oFont10)
oPrint:Line	(0820,0190,2800,0190) //Linea vertical separando items

oPrint:Say  (0845,0250,"Codigo",oFont10)
oPrint:Line	(0820,0400,2800,0400) //Linea vertical separando Codigo

oPrint:Say  (0845,0420,"Cod.Fab.",oFont10)
oPrint:Line	(0820,0600,2800,0600) //Linea vertical separando Código de Fabrica

oPrint:Say  (0845,0920,"Descripción",oFont10)
oPrint:Line	(0820,1600,2800,1600) //Linea vertical separando Descripción

oPrint:Say  (0845,1670,"Unidad",oFont10)
oPrint:Line	(0820,1850,2800,1850) //Linea vertical separando Unidad

oPrint:Say  (0845,1870,"Cant.",oFont10)
oPrint:Line	(0820,2000,2800,2000) //Linea vertical separando Cantidad

oPrint:Say  (0845,2020,"Almac.",oFont10)
oPrint:Line	(0820,2150,2800,2150) //Linea vertical separando Almacen

oPrint:Say  (0845,2200,"Lote",oFont10)
oPrint:Line	(0820,2400,2800,2400) //Linha vertical separando Lote


oPrint:Line	(3250,550,3250,1000) // linea firma responsable almacen
oPrint:Say  (3270,580,"RESPONSABLE ALMACEN",oFont10)

oPrint:Line	(3250,1300,3250,1750) // linea firma recibi conforma   
oPrint:Say  (3270,1400,"RECIBI CONFORME",oFont10)




oPrint:Say  (3400,0300,"AV VIEDMA No 51 Z/CEMENTERIO GENERAL -SANTA CRUZ - BOLIVIA - TELEFS: (+591) 3 3326174 / 3 3331447 / 3 3364244 - FAX: 3 3368672",oFont8)

DbSelectArea("PICKLDET")


Return


//*************************************************************************************

Static Function fAjustaSx1()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)


aAdd(aRegs,{"01","De Fecha de Emisión     :","mv_ch1","D",08,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"02","A Fecha de Emisión      :","mv_ch2","D",08,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"03","De Cliente              :","mv_ch3","C",6,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,"SA1",""})
aAdd(aRegs,{"04","A Cliente               :","mv_ch4","C",6,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,"SA1",""})
aAdd(aRegs,{"05","De Presupuesto          :","mv_ch5","C",6,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"SCJ",""})
aAdd(aRegs,{"06","A Presupuesto           :","mv_ch6","C",6,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"SCJ",""})

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
         SX1->X1_DEF01    := aRegs[i][10]
         SX1->X1_DEF02    := aRegs[i][11]
         SX1->X1_DEF03    := aRegs[i][12]
         SX1->X1_DEF04    := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]   
         
      MsUnlock()
   Endif
Next

Return

Return
