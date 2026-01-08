#ifdef SPANISH
	#define STR0001 "Presupuesto de Venta"
	#define STR0002 "Este programa emitira el Presupuesto de Venta, conforme"
	#define STR0003 "los parametros informados"
	#define STR0004 "Especial"
	#define STR0005 "Administracion"
	#define STR0006 "Presupuesto de Venta Nro."
	#define STR0007 " Cliente  : "
	#define STR0008 " Cond.Pago: "
	#define STR0009 " Descuento: "
	#define STR0010 "* Producto        Descripcion                                                           Cantidad   Precio Venta              Total *"
	#define STR0011 "*                 Componente      Descripcion del Componente                                                                       *"
	#define STR0012 "Continuacion..."
	#define STR0013 "* Total del Presupuesto --> "
#else
	#ifdef ENGLISH
		#define STR0001 "Sales quotation"
		#define STR0002 "This program will issue the Sales Quotation according"
		#define STR0003 "to the requested parameters"
		#define STR0004 "special"
		#define STR0005 "Administration"
		#define STR0006 "Sales Quotation Number"
		#define STR0007 " Customer: "
		#define STR0008 " Patm.Term:"
		#define STR0009 " Discount: "
		#define STR0010 "* Product         Description                                                         Quantity      Sales Price              Total *"
		#define STR0011 "*                 Component       Component Description                                                                            *"
		#define STR0012 "Continued ... "
		#define STR0013 "* Quotation total    -----> "
	#else
		Static STR0001 := "Orcamento de Venda"
		Static STR0002 := "Este programa ira emitir o Orcamento de Venda, conforme"
		Static STR0003 := "os parametros solicitados"
		#define STR0004  "Especial"
		Static STR0005 := "Administracao"
		Static STR0006 := "Orcamento de Venda N."
		Static STR0007 := " Cliente : "
		Static STR0008 := " Cond.Pag: "
		Static STR0009 := " Desconto: "
		Static STR0010 := "* Produto         Descricao                                                           Quantidade    Preco Venda              Total *"
		Static STR0011 := "*                 Componente      Descricao do Componente                                                                          *"
		Static STR0012 := "Continuacao..."
		Static STR0013 := "* Total do Orcamento -----> "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Orçamento De Venda"
			STR0002 := "Este programa irá emitir o orçamento de venda, conforme"
			STR0003 := "Os parâmetros solicitados"
			STR0005 := "Administração"
			STR0006 := "Orçamento De Venda Nº"
			STR0007 := " cliente : "
			STR0008 := " cond.pag: "
			STR0009 := " desconto: "
			STR0010 := "* produto         descrição                                                           quantidade    preço venda              total *"
			STR0011 := "*                 componente      descrição do componente                                                                          *"
			STR0012 := "Continuação..."
			STR0013 := "* total do orçamento -----> "
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Orçamento De Venda"
			STR0002 := "Este programa irá emitir o orçamento de venda, conforme"
			STR0003 := "Os parâmetros solicitados"
			STR0005 := "Administração"
			STR0006 := "Orçamento De Venda Nº"
			STR0007 := " cliente : "
			STR0008 := " cond.pag: "
			STR0009 := " desconto: "
			STR0010 := "* produto         descrição                                                           quantidade    preço venda              total *"
			STR0011 := "*                 componente      descrição do componente                                                                          *"
			STR0012 := "Continuação..."
			STR0013 := "* total do orçamento -----> "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
