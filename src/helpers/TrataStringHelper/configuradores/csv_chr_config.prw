#include "totvs.ch"

/*/{Protheus.doc} CSVChrConfig
Classe "configuradora" que lê as regras de substituição de um CSV
@type class
@author Rodrigo Godinho
@since 22/12/2025
/*/
CLASS CSVChrConfig FROM ConfiguradorTrataStringHelperBase
	DATA cPathFile
	DATA lHasHeader

	METHOD New(cPathFile, lHasHeader) CONSTRUCTOR
	METHOD GetConfig()
	METHOD GetLinhas()
ENDCLASS

/*/{Protheus.doc} CSVChrConfig::New
Construtor
@type method
@author Rodrigo Godinho
@since 22/12/2025
@param cPathFile, character, Caminho do arquivo CSV
@param lHasHeader, logical, Se o CSV tem cabeçalho
@return object, Instância da classe
/*/
METHOD New(cPathFile, lHasHeader) CLASS CSVChrConfig
	Default lHasHeader	:= .F.

	::cPathFile := cPathFile
	::lHasHeader := lHasHeader
	
Return

/*/{Protheus.doc} CSVChrConfig::GetConfig
Método que retorna o JSON com as configurações
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return json, JSON com as configurações
/*/
METHOD GetConfig() CLASS CSVChrConfig
	Local jRet		:= JSONObject():New()
	Local aLinhas	:= ::GetLinhas()
	Local nI		:= 0
	Local jItem

	jRet["caracteres"] := {}

	For nI := 1 To Len(aLinhas)
		If ValType(aLinhas[nI]) == "A" .And. Len(aLinhas[nI]) > 0 .And. !Empty(aLinhas[nI][1])
			jItem := JSONObject():New()
			jItem["de"] := Chr(Val(aLinhas[nI][1]))
			If Len(aLinhas[nI]) > 1 .And. !Empty(aLinhas[nI][2])
				jItem["para"] := Chr(Val(aLinhas[nI][2]))
			EndIf
			aAdd(jRet["caracteres"], jItem)
		EndIf
	Next
	aSize(aLinhas, 0)
	aLinhas := Nil

Return jRet

/*/{Protheus.doc} CSVChrConfig::GetLinhas
Lé o CSV e retorna o array de linhas
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return array, Array de 2 posições contento do código ASCII dos caracteres para "de" e "para" nestas posiçÕes, 
/*/
METHOD GetLinhas() CLASS CSVChrConfig
	Local aRet		:= {}
	Local aLinhas	:= {}
	Local oFile

	If File(::cPathFile)
		oFile := FWFileReader():New(::cPathFile)
		If oFile:Open()
			aLinhas := oFile:GetAllLines()
			
			If ::lHasHeader
				// Remove a primeira linha, que é o header
				ADel(aLinhas, 1)
				ASize(aLinhas, Len(aLinhas) - 1)
			EndIf
			// Separa o vetor em nível conforme token
			AEval(aLinhas, {|x| aAdd(aRet, StrTokArr2(x, ";", .T.))})
			oFile:Close()
		EndIf
		If oFile != NIL
			FreeObj(oFile)
		EndIf
		aSize(aLinhas, 0)
		aLinhas := Nil
	EndIf

Return aRet
