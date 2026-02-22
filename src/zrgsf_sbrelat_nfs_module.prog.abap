* Faço meu MÓDULO display_alv NA SAÍDA para exibição do ALV *
MODULE display_alv OUTPUT.

  IF go_cc IS INITIAL.                                        "SE meu OBJETO GLOBAL go_cc FOR INICIAL (tem seu valor padrão).

    CREATE OBJECT go_cc                                       "CRIAR OBJETO go_cc (INSTANCIANDO UMA CLASSE)
      EXPORTING                                               "EXPORTANDO
        container_name = 'MAIN'.                              "container_name IGUAL a 'MAIN' (nome do custom control que criei no LAYOUT da minha tela 100).
    CREATE OBJECT go_alv                                      "CRIAR OBJETO go_alv (INSTANCIANDO UMA CLASSE).
      EXPORTING                                               "EXPORTANDO
        i_parent = go_cc.                                     "i_parent(CONTAINER PAI) IGUAL a go_cc.

    CREATE OBJECT go_event_handler.                           "CRIAR OBJETO go_event_handler (INSTANCIANDO UMA CLASSE).
    SET HANDLER go_event_handler->on_double_click FOR go_alv. "MANIPULANDO O CONJUNTO go_event_handler ACESSANDO o método on_double_click PARA o objeto go_alv.

* Declaração de tabela interna local e estrutura local de fieldcat para "configuração" das colunas *
    DATA: lt_fieldcat TYPE lvc_t_fcat,
          ls_fieldcat TYPE lvc_s_fcat.

* Monta o catálogo de campos, definindo nome e tamanho *
    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'DOCNUM'.
    ls_fieldcat-coltext   = 'Número documento'.
    ls_fieldcat-outputlen = 5.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'PSTDAT'.
    ls_fieldcat-coltext   = 'Data lançamento'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'NFTYPE'.
    ls_fieldcat-coltext   = 'Tipo Nota'.
    ls_fieldcat-outputlen = 10.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'DIRECT'.
    ls_fieldcat-coltext   = 'Direção'.
    ls_fieldcat-outputlen = 8.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'SERIES'.
    ls_fieldcat-coltext   = 'Serie NF'.
    ls_fieldcat-outputlen = 8.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'NFNUM'.
    ls_fieldcat-coltext   = 'Número nota (antigo)'.
    ls_fieldcat-outputlen = 10.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'NFENUM'.
    ls_fieldcat-coltext   = 'Número NF Eletrônica'.
    ls_fieldcat-outputlen = 10.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'ITMNUM'.
    ls_fieldcat-coltext   = 'Item da NF'.
    ls_fieldcat-outputlen = 10.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MATNR'.
    ls_fieldcat-coltext   = 'Material'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MAKTX'.
    ls_fieldcat-coltext   = 'Descrição material'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MENGE'.
    ls_fieldcat-coltext   = 'Quantidade'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'CFOP'.
    ls_fieldcat-coltext   = 'CFOP'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'NFNET'.
    ls_fieldcat-coltext   = 'Valor item'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'TAXVAL'.
    ls_fieldcat-coltext   = 'Total impostos'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

* Chamada para exibição do ALV *
    CALL METHOD go_alv->set_table_for_first_display             "MÉTODO DE CHAMADA go_alv ACESSANDO o método set_table_for_first_display
      EXPORTING                                                 "EXPORTANDO
        is_layout       = VALUE lvc_s_layo( zebra = abap_true ) "is_layout IGUAL a VALOR lvc_s_layo ( zebra = abap_true )
      CHANGING                                                  "MUDANDO
        it_outtab       = gt_saida                              "it_outtab IGUAL a gt_saida.
        it_fieldcatalog = lt_fieldcat.                          "it_fieldcatalog IGUAL a lt_fieldcat.

  ENDIF.                                                        "Fim do IF (go_cc)

ENDMODULE.                                                      "Fim do MODULE (display_alv).
