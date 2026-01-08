#include 'protheus.ch'
/*/{Protheus.doc} User Function NEWJUROS
    (Cuando la fecha de vencimiento cae día Sábado y el pago se realiza día Lunes, días de atraso = 2)
    @type  Function
    @author wico2k
    @since 31/03/2022
    @version 1.0
    /*/
User Function NEWJUROS()
Local dBaja := PARAMIXB[1]
Local dVenc := PARAMIXB[2]
Local nDiasAtraso := PARAMIXB[3]

If FunName() == "FINA087A" .And. dVenc < dBaja .And. Dow(dBaja) == 2 .And. nDiasAtraso <= 2
	nDiasAtraso := 2
EndIf

If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo' .And. FunName() == "FINA087A"
	Alert("NEWJUROS: "+TRANSFORM(round(nDiasAtraso,2),"@E 999,999,999.99"))
EndIf

Return nDiasAtraso
