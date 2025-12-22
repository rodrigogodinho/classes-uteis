#include "totvs.ch"

/*/{Protheus.doc} JSONConfig
Classe "configuradora" que lê as regras de substituição de json
@type class
@author Rodrigo Godinho
@since 22/12/2025
/*/
CLASS JSONConfig FROM ConfiguradorTrataStringHelperBase
	DATA cPathFile

	METHOD New(cPathFile) CONSTRUCTOR
	METHOD GetConfig()
	METHOD ReadJSON()
ENDCLASS

/*/{Protheus.doc} JSONConfig::New
Construtor
@type method
@author Rodrigo Godinho
@since 22/12/2025
@param cPathFile, character, Caminho do arquivo JSON
@return object, Instância da classe
/*/
METHOD New(cPathFile) CLASS JSONConfig

	::cPathFile := cPathFile
	
Return

/*/{Protheus.doc} JSONConfig::GetConfig
Método que retorna o JSON com as configurações
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return json, JSON com as configurações
/*/
METHOD GetConfig() CLASS JSONConfig
	Local jRet		:= JSONObject():New()
	Local jAuxJSON	:= JSONObject():New()
	Local cJSON		:= ::ReadJSON()

	jRet["caracteres"] := {}
	If !Empty(cJSON) .And. jAuxJSON:FromJSON(cJSON) == Nil .And. jAuxJSON:HasProperty("caracteres")
		jRet["caracteres"] := jAuxJSON["caracteres"]
	EndIf

Return jRet

/*/{Protheus.doc} JSONConfig::ReadJSON
Lé o arquivo JSON e retorna a string com o conteúdo do arquivp
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return character, Conteúdo do arquivo que contem o json
/*/
METHOD ReadJSON() CLASS JSONConfig
	Local cRet		:= {}
	Local oFile

	If File(::cPathFile)
		oFile := FWFileReader():New(::cPathFile)
		If oFile:Open()
			cRet := oFile:fullRead()
			oFile:Close()
		EndIf
		If oFile != NIL
			FreeObj(oFile)
		EndIf
	EndIf

Return cRet
