#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE STR0000		"Informe tipo de Inf. Suel."

#DEFINE STR0001		"Salario Ganado"		//A
#DEFINE STR0002		"Dominical"				//B
#DEFINE STR0003		"Recargo Nocturno"		//C
#DEFINE STR0004		"Horas Extras"			//D
#DEFINE STR0005		"Bono de Antiguedad"	//E
#DEFINE STR0006		"Otros Ingresos"		//F
#DEFINE STR0007		"Natalidad o Sepelio"	//G
#DEFINE STR0008		"Descuentos AFP"		//H
#DEFINE STR0009		"RC-IVA"				//I
#DEFINE STR0010		"Anticipo Quincena"		//J
#DEFINE STR0011		"Multas"				//K
#DEFINE STR0012		"Sindicato"				//L
#DEFINE STR0013		"Otros Descuentos"		//M
#DEFINE STR0014		"Líquido Pagable"		//N

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ fOpInfSal ³ Autor ³ Denar Terrazas  ³ Data ³ 01/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcion que muestra las opciones para el campo        ³±±
±±³          ³ RV_INFSAL, para el reporte de planilla de sueldos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Belen                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

user function fOpInfSal()

	Local cTitulo	:=	""
	Local MvParDef	:=	""
	Local MvPar
	Local lRet	    :=	.T.

	Private aInc	:=	{}

	aInc			:=	{STR0001, STR0002, STR0003, STR0004, STR0005, STR0006, STR0007;
	, STR0008, STR0009, STR0010, STR0011, STR0012, STR0013, STR0014}

	MvParDef	:=	"ABCDEFGHIJKLMN"
	cTitulo		:=	STR0000  //"Informe tipo de Inf. Suel."

	f_Opcoes(@MvPar,cTitulo,aInc,MvParDef,12,49,.T.) // Chama funcao f_Opcoes

	VAR_IXB := MvPar // Devolve Resultado

Return .T.