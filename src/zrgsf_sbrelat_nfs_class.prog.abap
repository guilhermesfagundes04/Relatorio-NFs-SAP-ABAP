* Faço minha classse local para o evento de double click (duplo clique) com DEFINIÇÃO e IMPLEMENTAÇÃO *
CLASS lcl_event_handler DEFINITION.                             "CLASSE local (botões, comandos) DEFINIÇÃO.
  PUBLIC SECTION.                                               "SEÇÃO PÚBLICA.
    METHODS:                                                    "MÉTODOS:

      on_double_click FOR EVENT double_click OF cl_gui_alv_grid "on_double_click PARA EVENTO double_click DE cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no.                     "IMPORTANDO e_row e_column es_row_no (PARÂMETROS)

ENDCLASS.                                                       "Fim da classe DEFINIÇÃO.

CLASS lcl_event_handler IMPLEMENTATION.                         "CLASSE local (botões, comandos) IMPLEMENTAÇÃO.

  METHOD on_double_click.                                       "MÉTODO on_double_click.

    PERFORM zf_double_click USING e_row e_column es_row_no.     "EXECUTAR (form zf_double_click) USANDO OS PARÂMETROS e_row e_column es_row_no.

  ENDMETHOD.                                                    "Fim do método on_double_click.

ENDCLASS.                                                       "Fim da classe IMPLEMENTAÇÃO.

DATA: go_event_handler TYPE REF TO lcl_event_handler.           "DECLARAR OBJETO go_event_handler TIPO REFERÊNCIA DE classe local lcl_event_handler.
