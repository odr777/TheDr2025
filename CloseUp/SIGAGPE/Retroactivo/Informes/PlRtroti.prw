#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±±±
±±³Fun‡…o    ³ PlRtroti ³ Autor Carlos Egüez³	Query     : Carlos Egüez	³ ±±
±±						        26/09/17                    Nahim Terrazas   ±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±±
±±³Descri‡…o ³  "Planilla Retroactiva"					                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±±
±±³Sintaxe   ³ SEUvsCT2()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±±
±±³ Uso      ³ Global														 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/
*/


user function PlRtroti()

LOCAL oReport
PRIVATE cPerg   := "PlRtroti" 

CriaSX1(cPerg)
Pergunte(cPerg,.F.) 

oReport := ReportDef()
oReport:PrintDialog()	

Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local NombreProg := "PlRtroti"
oReport	 := TReport():New("PlRtroti",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Planilla Retroactiva")
oSection := TRSection():New(oReport,"PlRtroti",{"CTK,CT2","SEU"})
oReport:SetTotalInLine(.F.)

TRCell():New(oSection,"RA_FILIAL"     ,"SRA","FILIAL",,TamSx3("RA_FILIAL")[1],.T.)
TRCell():New(oSection,"RA_TPCIC"      ,"SRA","TIPO DE DOCUMENTO DE IDENTIDAD",,TamSx3("RA_TPCIC")[1],.T.) 
TRCell():New(oSection,"RA_RG"         ,"SRA","NUMERO DE DOCUMENTO",,TamSx3("RA_RG")[1],.T.) 
TRCell():New(oSection,"RA_CODPAIS"    ,"SRA","EXTENSION DEL DOCUMENTO DE IDENTIDAD",,TamSx3("RA_CODPAIS")[1],.T.)    
TRCell():New(oSection,"RA_TPAFP"      ,"SRA","AFP A LA QUE APORTA",,TamSx3("RA_TPAFP")[1],.T.)  
TRCell():New(oSection,"RA_NRNUA"      ,"SRA","NUA/CUA",,TamSx3("RA_NRNUA")[1],.T.)
TRCell():New(oSection,"RA_PRISOBR"    ,"SRA","APELLIDO PATERNO",,TamSx3("RA_PRISOBR")[1],.T.)
TRCell():New(oSection,"RA_SECSOBR"    ,"SRA","APELLIDO MATERNO",,TamSx3("RA_SECSOBR")[1],.T.)
TRCell():New(oSection,"RA_PRINOME"	  ,"SRA","PRIMER NOMBRE",,TamSx3("RA_PRINOME")[1],.T.)   
TRCell():New(oSection,"RA_SECNOME"	  ,"SRA","OTROS NOMBRES",,TamSx3("RA_SECNOME")[1],.T.)     
TRCell():New(oSection,"NACIONA"       ,"SRA","PAIS DE NACIONALIDAD",,TamSx3("RA_NACIONA")[1],.T.)    
TRCell():New(oSection,"RA_SEXO"       ,"SRA","SEXO",,TamSx3("RA_SEXO")[1],.T.)  
TRCell():New(oSection,"CARGO"         ,"SRA","CARGO",,TamSx3("RA_CARGO")[1],.T.)   
TRCell():New(oSection,"ADMISSA"       ,"SRA","FECHA DE INGRESO",PesqPict('SB1',"B1_DESC"),TamSx3("RA_ADMISSA")[1],.T.) 
TRCell():New(oSection,"TPCONTR"       ,"SRA","MODALIDAD DE CONTRATO",,TamSx3("RA_TPCONTR")[1],.T.)    
TRCell():New(oSection,"HRSMES"        ,"SRA","HORAS PAGADAS(dia)",,TamSx3("RA_HRSMES")[1],.T.)   
TRCell():New(oSection,"HABER_BASICO"  ,"SRA","HABER_BASICO ANTERIOR",,,.T.)    
TRCell():New(oSection,"RA_SALARIO"    ,"SRA","HABER_BASICO CON INCREMENTO",,TamSx3("RA_SALARIO")[1],.T.)
TRCell():New(oSection,"ENERO"         ,"SRD","MONTO RETROACTIVO ENERO",,,.T.)   
TRCell():New(oSection,"FEBRERO"       ,"SRD","MONTO RETROACTIVO FEBRERO",,,.T.)  
TRCell():New(oSection,"MARZO"         ,"SRD","MONTO RETROACTIVO MARZO",,,.T.)   
TRCell():New(oSection,"ABRIL"         ,"SRD","MONTO RETROACTIVO ABRIL",,,.T.)
TRCell():New(oSection,"MAYO"          ,"SRD","MONTO RETROACTIVO MAYO",,,.T.)  
TRCell():New(oSection,"JUNIO"         ,"SRD","MONTO RETROACTIVO JUNIO",,,.T.)
TRCell():New(oSection,"TOTALGANADO"   ,"SRD","TOTALGANADO",,,.T.)
TRCell():New(oSection,"AFP"           ,"SRD","APORTE AFPs",,,.T.)
TRCell():New(oSection,"LIQUIDOPAGABLE","SRD","LIQUIDO PAGABLE",,,.T.)

oSection:SetColSpace(1)
Return oReport

Static Function PrintReport(oReport)
Local oSection 	:= oReport:Section(1)
Local cTp	    := ""


#IFDEF TOP

oSection:BeginQuery()
BeginSql alias "QRYSRC"



SELECT DISTINCT RA_FILIAL, RA_TPCIC,RA_RG, RA_CODPAIS, RA_TPAFP, RA_NRNUA, RA_PRISOBR, RA_SECSOBR, RA_PRINOME, 
   RA_SECNOME, (RA_NACIONA) NACIONA, RA_SEXO, (RA_CARGO) CARGO, RA_ADMISSA, CASE RA_TPCONTR WHEN 1 THEN 1 ELSE 2 END RA_TPCONTR, 
   HRSMES, AA.RD_MAT,COALESCE(BB.RD_VALOR,'0') HABER_BASICO ,COALESCE(VALORTOTAL,'0') RA_SALARIO , COALESCE(ENERO,'0') ENERO, 
   COALESCE(FEBRERO,'0') FEBRERO, COALESCE(MARZO,'0') MARZO, COALESCE(ABRIL,'0') ABRIL, COALESCE(MAYO,'0') MAYO, COALESCE(JUNIO,'0') JUNIO, 
   COALESCE(TOTALGANADO,'0')TOTALGANADO, COALESCE(EE.VALOR,'0') AFP, COALESCE(TOTALGANADO - EE.VALOR,'0') LIQUIDOPAGABLE 
   FROM 
        (SELECT DISTINCT (SRD.RD_MAT) RD_MAT, RA_FILIAL, RA_TPCIC,RA_RG, RA_CODPAIS, RA_TPAFP, RA_NRNUA, RA_PRISOBR, RA_SECSOBR, RA_PRINOME,	
		RA_SECNOME, CASE X5_TABELA WHEN '34' THEN X5_DESCRI ELSE '' END AS RA_NACIONA, RA_SEXO, 
		CASE RA_CARGO   WHEN Q3_CARGO  THEN Q3_DESCSUM ELSE '' END  RA_CARGO, SUBSTRING(RA_ADMISSA,7,2) + '/' + SUBSTRING(RA_ADMISSA,5,2) + '/' + SUBSTRING(RA_ADMISSA,1,4) RA_ADMISSA, 
		RA_TPCONTR, (RA_HRSMES / 30) HRSMES 
		FROM SRV010 SRV, SRA010 SRA, SX5010 SX5, SQ3010 SQ3, SRD010 SRD
		WHERE X5_TABELA = '34'
		AND RD_ROTEIR = 'RET'
		AND SRA.RA_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SRA.RA_MAT BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND RD_PERIODO = (SELECT TOP 1 RD_PERIODO FROM SRD010 WHERE RD_PERIODO like %Exp:MV_PAR05% +'%%' AND RD_ROTEIR='RET')
		AND RA_SITFOLH IN (' ','A','F')
		AND RA_MAT = RD_MAT
		AND RD_PD = RV_COD
		AND RA_NACIONA = X5_CHAVE
		AND Q3_CARGO = RA_CARGO
		AND SRA.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND SX5.D_E_L_E_T_ = ' '
		AND SQ3.D_E_L_E_T_ = ' ' 
		AND SRD.D_E_L_E_T_ = ' '
        ) 
		AA LEFT JOIN  
	    (SELECT DISTINCT SRD.RD_VALOR, SRD.RD_MAT 
		FROM SRD010 SRD ,SRV010 SRV
		WHERE SRD.RD_PD = (SELECT RV_COD FROM SRV010 SRV WHERE RV_CODFOL = '0031')
		  AND SRD.RD_PERIODO = CONVERT(VARCHAR,CONVERT(INT,SUBSTRING((SELECT SRD2.RD_PERIODO FROM SRD010 SRD2 WHERE SRD2.RD_ROTEIR = 'RET' GROUP BY SRD2.RD_PERIODO),1,4))-1) + '12'
          AND RV_COD = SRD.RD_PD
          AND SRD.RD_ROTEIR = 'FOL'
          AND SRD.D_E_L_E_T_= ' '
          AND SRV.D_E_L_E_T_ = ' ' )BB ON BB.RD_MAT = AA.RD_MAT
          LEFT JOIN  
         (SELECT (CC.RD_VALOR * XX.RD_VALINFO / 100) + CC.RD_VALOR AS VALORTOTAL, XX.RD_MAT FROM 
         (SELECT SRD.RD_VALINFO, SRD.RD_MAT
         FROM SRD010 SRD
         WHERE SRD.RD_PD = (SELECT RV_COD FROM SRV010 SRV WHERE RV_CODFOL = '0031')
         AND SRD.RD_ROTEIR ='RET'
         AND SRD.D_E_L_E_T_ = ' '
         GROUP BY SRD.RD_VALINFO, SRD.RD_MAT)
         XX INNER JOIN
         (SELECT DISTINCT SRD.RD_VALOR, SRD.RD_MAT 
         FROM SRD010 SRD ,SRV010 SRV
         WHERE SRD.RD_PD = (SELECT RV_COD FROM SRV010 SRV WHERE RV_CODFOL = '0031')                                             
         AND SRD.RD_PERIODO = CONVERT(VARCHAR,CONVERT(INT,SUBSTRING((SELECT SRD2.RD_PERIODO FROM SRD010 SRD2 WHERE SRD2.RD_ROTEIR = 'RET' GROUP BY SRD2.RD_PERIODO),1,4))-1) + '12'
		 AND RV_COD = SRD.RD_PD
		 AND SRD.RD_ROTEIR = 'FOL'
		 AND SRD.D_E_L_E_T_= ' '
         AND SRV.D_E_L_E_T_ = ' '
		 GROUP BY SRD.RD_VALOR, SRD.RD_MAT) CC ON CC.RD_MAT = XX.RD_MAT) 
		 YY ON YY.RD_MAT = AA.RD_MAT
         LEFT JOIN          	
         (SELECT SRD.RD_MAT, ENERO, FEBRERO, MARZO, ABRIL, MAYO, JUNIO, (ISNULL(ENERO,'0')+ISNULL(FEBRERO,'0')+ISNULL(MARZO,'0')+ISNULL(ABRIL,'0')+ISNULL(MAYO,'0')+ISNULL(JUNIO,'0'))TOTALGANADO 
		 FROM SRD010 SRD LEFT JOIN
		 (SELECT SUM(SRD.RD_VALOR) ENERO, SRD.RD_MAT
         FROM SRD010 SRD, SRA010 SRA
         WHERE RD_ROTEIR = 'RET'
         AND SRD.RD_SEQ = '1'
         AND SRD.RD_PD IN (SELECT RV_COD FROM SRV010 SRV WHERE  RV_INRETRO = 'S' OR RV_INRETBA = 'S' AND SRV.D_E_L_E_T_= ' ')
         AND SRD.RD_MAT = RA_MAT
         AND RA_SITFOLH IN (' ','A','F') 
         AND SRD.D_E_L_E_T_ = ' '  
         AND SRA.D_E_L_E_T_ = ' '
         GROUP BY SRD.RD_MAT) ENERO ON
         ENERO.RD_MAT = SRD.RD_MAT  LEFT JOIN
		(SELECT SUM(SRD.RD_VALOR) FEBRERO, SRD.RD_MAT
        FROM SRD010 SRD, SRA010 SRA
        WHERE SRD.RD_ROTEIR = 'RET'
        AND SRD.RD_SEQ = '2'
        AND SRD.RD_PD IN (SELECT RV_COD FROM SRV010 SRV WHERE  RV_INRETRO = 'S' OR RV_INRETBA = 'S' AND SRV.D_E_L_E_T_= ' ')
        AND SRD.RD_MAT = RA_MAT
        AND RA_SITFOLH IN (' ','A','F') 
        AND SRD.D_E_L_E_T_ = ' '  
        AND SRA.D_E_L_E_T_ = ' '
        GROUP BY SRD.RD_MAT) FEBRERO ON
        FEBRERO.RD_MAT = SRD.RD_MAT LEFT JOIN
		(SELECT SUM(SRD.RD_VALOR) MARZO, SRD.RD_MAT
        FROM SRD010 SRD, SRA010 SRA
        WHERE SRD.RD_ROTEIR = 'RET'
        AND SRD.RD_SEQ = '3'
        AND SRD.RD_PD IN (SELECT RV_COD FROM SRV010 SRV WHERE  RV_INRETRO = 'S' OR RV_INRETBA = 'S' AND SRV.D_E_L_E_T_= ' ')
        AND SRD.RD_MAT = RA_MAT
        AND RA_SITFOLH IN (' ','A','F') 
        AND SRD.D_E_L_E_T_ = ' '  
        AND SRA.D_E_L_E_T_ = ' '
        GROUP BY SRD.RD_MAT) MARZO ON 
		MARZO.RD_MAT = SRD.RD_MAT LEFT JOIN
		(SELECT SUM(SRD.RD_VALOR) ABRIL, SRD.RD_MAT
        FROM SRD010 SRD, SRA010 SRA
        WHERE SRD.RD_ROTEIR = 'RET'
        AND SRD.RD_SEQ = '4'
        AND SRD.RD_PD IN (SELECT RV_COD FROM SRV010 SRV WHERE  RV_INRETRO = 'S' OR RV_INRETBA = 'S' AND SRV.D_E_L_E_T_= ' ')
        AND SRD.RD_MAT = RA_MAT
        AND RA_SITFOLH IN (' ','A','F') 
        AND SRD.D_E_L_E_T_ = ' '  
        AND SRA.D_E_L_E_T_ = ' '
        GROUP BY SRD.RD_MAT) ABRIL ON 
		ABRIL.RD_MAT = SRD.RD_MAT LEFT JOIN
		(SELECT SUM(SRD.RD_VALOR) MAYO, SRD.RD_MAT
        FROM SRD010 SRD, SRA010 SRA
        WHERE SRD.RD_ROTEIR = 'RET'
        AND SRD.RD_SEQ = '5'
        AND SRD.RD_PD IN (SELECT RV_COD FROM SRV010 SRV WHERE  RV_INRETRO = 'S' OR RV_INRETBA = 'S' AND SRV.D_E_L_E_T_= ' ')
        AND SRD.RD_MAT = RA_MAT
        AND RA_SITFOLH IN (' ','A','F') 
        AND SRD.D_E_L_E_T_ = ' '  
        AND SRA.D_E_L_E_T_ = ' '
        GROUP BY SRD.RD_MAT) MAYO ON 
		MAYO.RD_MAT = SRD.RD_MAT LEFT JOIN
		(SELECT SUM(SRD.RD_VALOR) JUNIO, SRD.RD_MAT
        FROM SRD010 SRD, SRA010 SRA
        WHERE SRD.RD_ROTEIR = 'RET'
        AND SRD.RD_SEQ = '6'
        AND SRD.RD_PD IN (SELECT RV_COD FROM SRV010 SRV WHERE  RV_INRETRO = 'S' OR RV_INRETBA = 'S' AND SRV.D_E_L_E_T_= ' ')
        AND SRD.RD_MAT = RA_MAT
        AND RA_SITFOLH IN (' ','A','F') 
		AND SRD.D_E_L_E_T_ = ' '  
        AND SRA.D_E_L_E_T_ = ' '
        GROUP BY SRD.RD_MAT) JUNIO ON
		JUNIO.RD_MAT = SRD.RD_MAT 
		WHERE ENERO.RD_MAT = SRD.RD_MAT
		GROUP BY SRD.RD_MAT, ENERO, FEBRERO, MARZO, ABRIL, MAYO, JUNIO 
	    ) DD ON DD.RD_MAT = AA.RD_MAT
	    LEFT JOIN  
		(SELECT SUM(SRD.RD_VALOR) VALOR,SRD.RD_MAT
        FROM SRD010 SRD
        WHERE SRD.RD_PD IN ((SELECT RV_COD FROM SRV010 WHERE RV_CODFOL IN('0728')),
        (SELECT RV_COD FROM SRV010 SRV WHERE RV_CODFOL IN('0729')),
        (SELECT RV_COD FROM SRV010 SRV WHERE RV_CODFOL IN('0730')),
        (SELECT RV_COD FROM SRV010 SRV WHERE RV_CODFOL IN('1228')),
        (SELECT SUBSTRING(RCC_CONTEU,23,3) CONTEU FROM RCC010 RCC WHERE  RCC_CODIGO = 'S011' AND RCC_SEQUEN ='001'),
        (SELECT SUBSTRING(RCC_CONTEU,23,3) CONTEU FROM RCC010 RCC WHERE  RCC_CODIGO = 'S011' AND RCC_SEQUEN ='002'),
        (SELECT SUBSTRING(RCC_CONTEU,23,3) CONTEU FROM RCC010 RCC WHERE  RCC_CODIGO = 'S011' AND RCC_SEQUEN ='003'))
        AND SRD.RD_ROTEIR = 'RET'	
        AND SRD.D_E_L_E_T_ = ' '
        GROUP BY SRD.RD_MAT)EE ON EE.RD_MAT = AA.RD_MAT  
 endSql

oSection:EndQuery()

#ENDIF

oSection:Print()

Return`


Static Function CriaSX1(cPerg) 
PutSX1(cPerg,"01","¿De Filial?"       , "¿De Filial?"	   ,"¿De Filial?"		,"MV_CH1","C",2,0,0,"G","","","",""	,"MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")     
PutSX1(cPerg,"02","¿A Filial?" 	      , "¿A Filial?"	   ,"¿A Filial?"		,"MV_CH2","C",2,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
PutSX1(cPerg,"03","¿De Empleado?"     , "¿De Empleado?"    ,"¿De Empleado?"	    ,"MV_CH3","C",6,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,,"")     
PutSX1(cPerg,"04","¿A Empleado?" 	  , "¿A Empleado?"     ,"¿A Empleado?"	    ,"MV_CH4","C",6,0,0,"G","","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,,"")
PutSX1(cPerg,"05","¿Año?"    		  , "¿Año?"			   ,"¿Año?"				,"MV_CH5","C",4,0,0,"G","","" ,"" ,"" ,"MV_PAR05",""       ,""            ,""        ,""     ,,"")
Return


Static Function CabecPak(oReport)
Local aArea		:= GetArea()
Local aCabec   	:= {}
Local cChar    	:= chr(160)
Local titulo   	:= oReport:Title()
Local page 		:= oReport:Page()

aCabec := {     "__LOGOEMP__" ,cChar 	+ "        " + cChar + If(comparador==1," ",RptFolha+" "+cvaltochar(page));
                , " " 			+ " " 	+ "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar + RptEmiss + " " + Dtoc(dDataBase);
                , "Hora: "		+ cValToChar(TIME()) ;
                , "Empresa: "	+ SM0->M0_FILIAL + " " }
RestArea( aArea )
Return(aCabec)
return