#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A085CPOS  ºAutor  ³Kevin Rocha ºFecha ³  09/01/2020 		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para la generacion de PA en la orden de 	  º±±
±±º          ³pago.														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BEL                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A085CPOS()

	aHeader := {}

	DbSelectArea("SX3")
	DbSetOrder(2)
	
	/* STANDARD COLUMNS */
	DbSeek("EK_TIPODOC")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_TIPODOC"   ,"9",X3_TAMANHO ,X3_DECIMAL,'PERTENCE("123").And.A085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
	DbSeek("EK_TIPO")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_TIPO"   ,X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'A085aVlds(aDebMed,aDebInm,.T.)',X3_usado,"C","SEK"})
	DbSeek("EK_NUM")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_NUM" 	 ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL, ".T.",X3_usado,"C","SEK"})
	DbSeek("EK_VALOR")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_VALOR"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,".T.",X3_usado,"N","SEK"})
	DbSeek("EK_MOEDA")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_MOEDA"  ,X3_PICTURE, X3_TAMANHO ,X3_DECIMAL,'.F.',X3_usado,"C","SEK"})
	DbSeek("EK_EMISSAO")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_EMISSAO",X3_PICTURE, X3_TAMANHO,X3_DECIMAL,".T.",X3_usado,"D","SEK"})
	DbSeek("EK_VENCTO")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_VENCTO" ,X3_PICTURE, X3_TAMANHO,X3_DECIMAL,"M->EK_VENCTO  >= aCols[N][6].And.A085aVlds()" ,X3_usado,"D","SEK"})
	DbSeek("EK_BANCO")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_BANCO"  ,X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'a085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
	DbSeek("EK_AGENCIA")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_AGENCIA",X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'a085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
	DbSeek("EK_CONTA")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_CONTA"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
	DbSeek("EK_PARCELA")
	Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_PARCELA"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
	If DbSeek("EK_DEBITO")
		Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_DEBITO"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
	Endif
	
	/* ADD HERE ESPECIFIC COLUMNS */
//	If DbSeek("EK_OBSBCO")
//		Aadd(aHeader,{OemToAnsi(x3titulo()),"EK_OBSBCO",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
//	Endif

return aHeader
