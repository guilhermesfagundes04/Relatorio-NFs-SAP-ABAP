* Faço meu formulário de busca (SELECTS) começar sempre do macro pro micro. *
* Faço meu formulário de busca (SELECTS) começar sempre do macro pro micro. *
FORM zf_busca.

  SELECT *                                                     "SELECIONO * (TUDO)
    FROM tvarvc                                                "DA tabela TVARVC
    INTO CORRESPONDING FIELDS OF TABLE @gt_tvarvc              "NA TABELA global gt_tvarvc (jogando na tabela)
    WHERE name = 'ZGSF_IMP'.                                   "ONDE name = ZRGSF_IMP (Parametrização de impostos que eu criei).

  SELECT docnum, pstdat, nftype, direct, series, nfnum, nfenum "SELECIONO esses atributos
    FROM j_1bnfdoc                                             "DA TABELA j_1bnfdoc
    INTO CORRESPONDING FIELDS OF TABLE @gt_j_1bnfdoc           "EM CAMPOS CORRESPONDETES DA TABELA @gt_j_1bnfdoc
    WHERE docnum IN @s_docnum                                  "ONDE docnum está EM seleção s_docnum
      AND pstdat IN @s_pstdat.                                 "E pstdat está EM seleção s_pstdat.

  IF sy-subrc IS INITIAL.                                      "SE sy-subrc É INICIAL (valor padrão = 0).

    SELECT docnum, itmnum, matnr, maktx, menge, cfop, nfnet    "SELECIONO esses atributos
      FROM j_1bnflin                                           "DA TABELA j_1bnflin
      INTO CORRESPONDING FIELDS OF TABLE @gt_j_1bnflin         "EM CAMPOS CORRESPONDETES DA TABELA @gt_j_1bnflin
      FOR ALL ENTRIES IN @gt_j_1bnfdoc                         "PARA TODAS AS ENTRADAS EM @gt_j_1bnfdoc
      WHERE docnum EQ @gt_j_1bnfdoc-docnum.                    "ONDE docnum IGUAL A @gt_j_1bnfdoc-docnum.

    SELECT docnum, itmnum, taxtyp, taxval                      "SELECIONO esses atributos
      FROM j_1bnfstx                                           "DA TABELA j_1bnfstx
      INTO CORRESPONDING FIELDS OF TABLE @gt_j_1bnfstx         "EM CAMPOS CORRESPONDENTES DA TABELA @gt_j_1bnfstx
      FOR ALL ENTRIES IN @gt_j_1bnflin                         "PARA TODAS AS ENTRADAS EM @gt_j_1bnflin
      WHERE docnum EQ @gt_j_1bnflin-docnum                     "ONDE docnum IGUAL A @gt_j_1bnflin-docnum
        AND itmnum EQ @gt_j_1bnflin-itmnum.                    "E itmnum IGUAL A @gt_j_1bnflin-itmnum.

  ENDIF.                                                       "Fim do IF (sy-subrc).

  PERFORM zf_ordenacao.                                        "EXECUTAR FORM zf_ordenacao.

ENDFORM.                                                       "Fim do FORM zf_busca.

* Faço meu formulário de ordenação (SORT). *
FORM zf_ordenacao.

  SORT: gt_j_1bnfdoc BY docnum pstdat nftype, "ORDENAR tabela gt_j_1bnfdoc POR esses campos em ordem CRESCENTE.
        gt_j_1bnflin BY docnum itmnum matnr,  "ORDENAR tabela gt_j_1bnflin POR esses campos em ordem CRESCENTE.
        gt_j_1bnfstx BY docnum itmnum.        "ORDENAR tabela gt_j_1bnfstx POR esses campos em ordem CRESCENTE.

ENDFORM.                                      "Fim do FORM zf_ordenacao.

* Faço meu formulário de tratamento (LÓGICA). *
FORM zf_tratamento.

* Declaração das minhas variáveis locais que vou utilizar no FORM. *
  DATA: lv_total         TYPE j_1bnfstx-taxval,
        lv_soma_outros   TYPE j_1bnfstx-taxval,
        lv_valor_imposto TYPE j_1bnfstx-taxval,
        lv_tax_desc      TYPE string,
        lv_tax_line      TYPE string.

* Declaração da minha tabela local que vou utilizar no FORM. *
  DATA: lt_tax_text TYPE TABLE OF string.

* Declaração da minha estrutura local que vou utilizar no FORM. *
  DATA: ls_aux_tax  TYPE ty_tax.

* Criação dos meus FIELD-SYMBOLS (SÍMBOLOS DE CAMPO). *
  FIELD-SYMBOLS: <fs_saida>     TYPE ty_saida,
                 <fs_j_1bnfdoc> TYPE ty_j_1bnfdoc,
                 <fs_j_1bnflin> TYPE ty_j_1bnflin,
                 <fs_j_1bnfstx> TYPE ty_j_1bnfstx.

* Loop nos documentos (cabeçalho da NF). *
  LOOP AT gt_j_1bnfdoc ASSIGNING <fs_j_1bnfdoc>.

* Loop nos itens da NF, filtrando pelo docnum do cabeçalho. *
    LOOP AT gt_j_1bnflin ASSIGNING <fs_j_1bnflin>
                         WHERE docnum = <fs_j_1bnfdoc>-docnum.

* Inicializa acumuladores e tabela de texto de impostos. *
      FREE: lv_total, lv_soma_outros, lt_tax_text.

      "--- Primeiro soma o total de impostos do item
      LOOP AT gt_j_1bnfstx ASSIGNING <fs_j_1bnfstx>
                           WHERE docnum = <fs_j_1bnflin>-docnum
                             AND itmnum = <fs_j_1bnflin>-itmnum.
        " Soma todos os valores de imposto do item
        lv_total = lv_total + <fs_j_1bnfstx>-taxval.
      ENDLOOP.

      "--- Para cada imposto parametrizado, soma o valor e monta a string
      LOOP AT gt_tvarvc INTO gw_tvarvc.
        " Inicializa acumulador por tipo de imposto
        FREE lv_valor_imposto.
* Percorre impostos do item filtrando pelo tipo parametrizado. *
        LOOP AT gt_j_1bnfstx ASSIGNING <fs_j_1bnfstx>
                             WHERE docnum = <fs_j_1bnflin>-docnum
                               AND itmnum = <fs_j_1bnflin>-itmnum
                               AND taxtyp = gw_tvarvc-low.
          " Soma imposto para esse tipo
          lv_valor_imposto = lv_valor_imposto + <fs_j_1bnfstx>-taxval.
        ENDLOOP.
        "Se tiver valor para esse imposto, adiciona à lista de textos
        IF lv_valor_imposto NE 0.
          lv_tax_line = |{ gw_tvarvc-low }: { lv_valor_imposto }|.
          APPEND lv_tax_line TO lt_tax_text.
        ENDIF.
      ENDLOOP.

      "--- Calcular valores de impostos não parametrizados (OUTROS)
      LOOP AT gt_j_1bnfstx ASSIGNING <fs_j_1bnfstx>
                           WHERE docnum = <fs_j_1bnflin>-docnum
                             AND itmnum = <fs_j_1bnflin>-itmnum.
        " Flag para saber se o imposto está na parametrização
        DATA(lv_encontrado) = abap_false.

* Verifica se o taxtyp atual está na tabela de parametrizados. *
        LOOP AT gt_tvarvc INTO gw_tvarvc WHERE low = <fs_j_1bnfstx>-taxtyp.
          lv_encontrado = abap_true.
          EXIT. " Sai assim que encontrar
        ENDLOOP.

        " Se não encontrou, soma em 'Outros'
        IF lv_encontrado = abap_false.
          lv_soma_outros = lv_soma_outros + <fs_j_1bnfstx>-taxval.
        ENDIF.
      ENDLOOP.

      " Se houve impostos não parametrizados, adiciona linha 'Outros'
      IF lv_soma_outros NE 0.
        APPEND |Outros: { lv_soma_outros }| TO lt_tax_text.
      ENDIF.

      "--- Monta descrição final
      IF lt_tax_text IS INITIAL.
        " Caso não tenha nenhum imposto
        lv_tax_desc = 'Nenhum imposto encontrado'.
      ELSE.
        " Concatena todas as linhas (ICMS, PIS, COFINS, etc.) separadas por ". "
        CONCATENATE LINES OF lt_tax_text INTO lv_tax_desc SEPARATED BY '. '.
      ENDIF.

      "--- Grava na tabela auxiliar para exibir no double click
      " Copia campos correspondentes do item para estrutura auxiliar
      MOVE-CORRESPONDING <fs_j_1bnflin> TO ls_aux_tax.
      ls_aux_tax-docnum         = <fs_j_1bnflin>-docnum.
      ls_aux_tax-itmnum         = <fs_j_1bnflin>-itmnum.
      ls_aux_tax-desc_impostos  = lv_tax_desc.
      " Adiciona linha na tabela auxiliar
      APPEND ls_aux_tax TO gt_aux_tax.

      "--- Monta a saída para exibição no ALV
      " Adiciona nova linha vazia na tabela de saída e atribui ao field-symbol
      APPEND INITIAL LINE TO gt_saida ASSIGNING <fs_saida>.
      " Copia dados do cabeçalho
      MOVE-CORRESPONDING <fs_j_1bnfdoc> TO <fs_saida>.
      " Copia dados do item
      MOVE-CORRESPONDING <fs_j_1bnflin> TO <fs_saida>.
      " Preenche o campo de valor total de imposto
      <fs_saida>-taxval = lv_total.

    ENDLOOP. " Fim loop itens

  ENDLOOP. " Fim loop documentos

* Ordena tabela auxiliar por docnum e itmnum para facilitar pesquisa/exibição. *
  SORT gt_aux_tax BY docnum itmnum.

ENDFORM. "Fim do FORM zf_tratamento.

* Faço meu formulário de double click (duplo clique). *
FORM zf_double_click USING e_row     TYPE lvc_s_row          "USANDO e_row TIPO lvc_s_row
                           e_column  TYPE lvc_s_col          "USANDO e_column TIPO lvc_s_col
                           es_row_no TYPE lvc_s_roid.        "USANDO es_row_no TIPO lvc_s_roid.

* Declaração das minhas variávies locais que vão ser utilizadas no FORM *
  DATA: ls_row  TYPE ty_saida,
        ls_desc TYPE ty_tax,
        lv_msg  TYPE string.

* Leitura da tabela gt_saida DENTRO da estrutura local ls_row ÍNDICE e_row-index (Índice da linha). *
  READ TABLE gt_saida INTO ls_row INDEX e_row-index.

  IF sy-subrc IS NOT INITIAL.                                "SE sy-subrc É NÃO INCIAL (Não tem seu valor padrão).
    RETURN.                                                  "RETURN (Sai do FORM aqui e não executa o que vem abaixo).
  ENDIF.                                                     "Fim do IF (sy-subrc).

  CASE e_column-fieldname.                                   "CASO e_column-fieldname (Nome da coluna).

    WHEN 'DOCNUM'.                                           "QUANDO for 'DOCNUM'

      PERFORM zf_grava_bdc USING ls_row-docnum.              "EXECUTAR form zf_grava_bdc USANDO ls_row-docnum
      PERFORM zf_chama_transacao.                            "EXECUTAR form zf_chama_transacao.

    WHEN 'TAXVAL'.                                           "QUANDO for 'TAXVAL'
* Leitura da tabela gt_aux_tax DENTRO da estrutura local ls_desc COM CHAVE docnum/itmnum IGUAL a ls_row-docnum/ls_row-itmnum em PESQUISA BINÁRIA. *
      READ TABLE gt_aux_tax INTO ls_desc
                            WITH KEY docnum  = ls_row-docnum
                                     itmnum  = ls_row-itmnum
                            BINARY SEARCH.

      IF sy-subrc IS INITIAL.                                "SE sy-subrc É INICIAL (valor padrão = 0).
        lv_msg = ls_desc-desc_impostos.                      "lv_msg IGUAL A ls_desc-desc_impostos.
      ELSE.                                                  "SENÃO.
        lv_msg = 'Nenhum imposto encontrado'.                "lv_msg IGUAL A 'Nenhum imposto encontrado'.
      ENDIF.                                                 "Fim do IF (sy-subrc).

      MESSAGE lv_msg TYPE 'I'.                               "MENSAGEM lv_msg DO TIPO 'I' - Informação (gera a mensagem após o double click).

  ENDCASE.                                                   "Fim do CASO (e_column-fieldname).

ENDFORM.                                                     "Fim do FORM zf_double_click.

* Faço meu formulário que define uma subrotina que recebe dois parâmetros: o nome do programa da tela e o número do dynpro (tela). *
FORM bdc_dynpro USING program dynpro.

  FREE gw_bdcdata.                    "LIMPAR WORK ÁREA(estrutura) gw_bdcdata.
  gw_bdcdata-program  = program.      "gw_bdcdata-program IGUAL a programa (NOME DO PROGRAMA).
  gw_bdcdata-dynpro   = dynpro.       "gw_bdcdata-dynpro IGUAL a dynpro (TELA).
  gw_bdcdata-dynbegin = 'X'.          "gw_bdcdata-dynbegin IGUAL a 'X' (Para linhas de campos, DYNBEGIN fica vazio.).
  APPEND gw_bdcdata TO gt_bdcdata.    "ADICIONAR WORK ÁREA(estrutura) gw_bdcdata NA TABELA GLOBAL gt_bdcdata.

ENDFORM.                              "Fim do FORM bdc_dynpro.

* Faço meu formulário que define uma subrotina que recebe o nome do campo da tela (fnam) e o valor que será digitado (fval). *
FORM bdc_field USING fnam fval.

  FREE gw_bdcdata.                    "LIMPAR WORK ÁREA(estrutura) gw_bdcdata.
  gw_bdcdata-fnam = fnam.             "gw_bdcdata-fnam IGUAL a fnam (Preenche FNAM com o nome técnico do campo de tela).
  gw_bdcdata-fval = fval.             "gw_bdcdata-fval IGUAL a fval (Preenche FVAL com o valor que tu quer inserir naquele campo).
  APPEND gw_bdcdata TO gt_bdcdata.    "ADICIONAR WORK ÁREA(estrutura) gw_bdcdata NA TABELA GLOBAL gt_bdcdata.

ENDFORM.                              "Fim do FORM bdc_field.

* Faço meu formulário de gravação do BATCH INPUT. *
FORM zf_grava_bdc USING p_docnum TYPE j_1bnfdoc-docnum.          "USANDO parâmetro p_docnum do TIPO j_1bnfdoc-docnum.

  FREE gt_bdcdata.                                               "LIMPAR TABELA GLOBAL gt_bdcdata.

* Tela inicial *
  PERFORM bdc_dynpro      USING 'SAPMJ1B1' '1100'.               "EXECUTAR o FORM bdc_dynpro USANDO 'SAPMJ1B1' '1100' (Inicia um novo dynpro/tela (cabeçalho de tela) no roteiro).
  PERFORM bdc_field       USING 'BDC_OKCODE' '=RUN'.             "EXECUTAR o FORM bdc_field USANDO 'BDC_OKCODE' '=RUN' (Adiciona o function code da tela: =RUN).
  PERFORM bdc_field       USING 'BDC_CURSOR' 'J_1BDYDOC-DOCNUM'. "EXECUTAR o FORM bdc_field USANDO 'BDC_CURSOR' 'J_1BDYDOC-DOCNUM' (Adiciona uma linha bdcdata que indica em qual campo o cursor deve ficar quando a tela abrir).
  PERFORM bdc_field       USING 'J_1BDYDOC-DOCNUM' p_docnum.     "EXECUTAR o FORM bdc_field USANDO 'J_1BDYDOC-DOCNUM' p_docnum (Preenche o campo J_1BDYDOC-DOCNUM com o conteúdo do parâmetro p_docnum).

ENDFORM.                                                         "Fim do FORM zf_grava_bdc.

* Faço meu formulário de chamada de transação (utilizando a J1B3N). *
FORM zf_chama_transacao.

  CALL TRANSACTION 'J1B3N'       "CHAMA A TRANSAÇÃO 'J1B3N'
    USING gt_bdcdata             "USANDO a TABELA GLOBAL gt_dbcdata
    MODE 'E'                     "MODO 'E' (Mostra só se der erro)         'N' - Executa sem mostrar nenhuma tela, 'A' - Mostra todas as telas
    UPDATE 'A'                   "ATUALIZAR 'A' (Atualização assíncrona)   'S' - Atualização síncrona, 'L' - Local update(força execução local)
    MESSAGES INTO gt_bdcmsgcoll. "MENSAGENS PARA TABELA GLOBAL gt_bdcmsgcool (Captura as mensagens geradas pela execução da transação e guarda na tabela interna).

ENDFORM.                         "Fim do FORM zf_chama_transacao.
