* Faço um SELECTION-SCREEN para por na tela a minha seleção que vai ser utilizada para filtrar os dados que vão ser pesquisados. *
SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_docnum FOR j_1bnfdoc-docnum,
                  s_pstdat FOR j_1bnfdoc-pstdat.

SELECTION-SCREEN END OF BLOCK bc01.
