#include "totvs.ch"

/*/{Protheus.doc} Exempl01
Fonte de exemplo, para que o programador seleciono o caminho dos arquivos, 
de acordo com o local onde salvou, lembrando que se for no lado do "remote", 
então deve utilizar o webagent para acessá-los, se for do lado do server não é necessário
@type function
@author Rodrigo Godinho
@since 22/12/2025
/*/
User Function Exempl01()
	Local oTrataStr		:= TrataStringHelper():New()
	Local cFileCfg		:= ""
	Local cTextoOrig	:= ""
	Local cTextoTransf	:= ""
	Local oCSVChrCfg
	Local oJSONCfg

	// Selecionar nome do CSV com as regras de substituição, lembrando que este é um exemplo,
	// em casos reais, para "tratar" strings de uma integração, por exemplo, o caminho do arquivo
	// deverá ser obtido por um parâmetro, por exemplo, para evitar interação do usuário em todas
	// as execuções. Lembrando que podem até mesmo definir algum configurador que nem dependa da 
	// leitura de arquivos, parâmetros ou tabelas, que para casos específicos, podem até determinar
	// uma regra em tempo de execução, como comentei no README.md, o limite é a imaginação e a necessidade
	// de cada programador. Caso crie um configurador e considere que seja algo que vai ajudar a comunidade,
	// aproveite e já compartilhe ele por meio deste, ou outros projetos.
	cFileCfg := cGetFIle('Selecione um Arquivo (*.CSV)|*.CSV', 'Selecao de Arquivos', 0, 'C:\', .F., , .T.)
	If File(cFileCfg)
		oCSVChrCfg := CSVChrConfig():New(cFileCfg)
		oTrataStr:AddConfigurador(oCSVChrCfg)
	EndIf

	// Selecionar o arquivo com que contem um json com as regras de substituição
	cFileCfg := cGetFIle('Selecione um Arquivo (*.*)|*.*', 'Selecao de Arquivos', 0, 'C:\', .F., , .T.)
	If File(cFileCfg)
		oJSONCfg := JSONConfig():New(cFileCfg)
		oTrataStr:AddConfigurador(oJSONCfg)
	EndIf
	
	cTextoOrig := "Este é um texto com os caracteres " + Chr(208) + ", " + Chr(253) + " e " + Chr(255) + " ."
	cTextoOrig += "Ficou_b-o-m,_mas pode melhorar_muito com a ajuda_da_comunidade."
	cTextoTransf := oTrataStr:TrataStr(cTextoOrig)
	
Return
