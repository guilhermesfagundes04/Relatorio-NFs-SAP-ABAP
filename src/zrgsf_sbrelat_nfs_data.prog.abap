* Declarando minhas tabelas que vão ser utilizadas no REPORT *
TABLES: j_1bnfdoc, j_1bnflin, j_1bnfstx, j_1baj.

* Declarando meus tipos que vão ser utilizados no REPORT *
TYPES: BEGIN OF ty_saida,
         docnum TYPE j_1bnfdoc-docnum,
         pstdat TYPE j_1bnfdoc-pstdat,
         nftype TYPE j_1bnfdoc-nftype,
         direct TYPE j_1bnfdoc-direct,
         series TYPE j_1bnfdoc-series,
         nfnum  TYPE j_1bnfdoc-nfnum,
         nfenum TYPE j_1bnfdoc-nfenum,
         itmnum TYPE j_1bnflin-itmnum,
         matnr  TYPE j_1bnflin-matnr,
         maktx  TYPE j_1bnflin-maktx,
         menge  TYPE j_1bnflin-menge,
         cfop   TYPE j_1bnflin-cfop,
         nfnet  TYPE j_1bnflin-nfnet,
         taxval TYPE j_1bnfstx-taxval,
       END OF ty_saida,

       BEGIN OF ty_j_1bnfdoc,
         docnum TYPE j_1bnfdoc-docnum,
         pstdat TYPE j_1bnfdoc-pstdat,
         nftype TYPE j_1bnfdoc-nftype,
         direct TYPE j_1bnfdoc-direct,
         series TYPE j_1bnfdoc-series,
         nfnum  TYPE j_1bnfdoc-nfnum,
         nfenum TYPE j_1bnfdoc-nfenum,
       END OF ty_j_1bnfdoc,

       BEGIN OF ty_j_1bnflin,
         docnum TYPE j_1bnflin-docnum,
         itmnum TYPE j_1bnflin-itmnum,
         matnr  TYPE j_1bnflin-matnr,
         maktx  TYPE j_1bnflin-maktx,
         menge  TYPE j_1bnflin-menge,
         cfop   TYPE j_1bnflin-cfop,
         nfnet  TYPE j_1bnflin-nfnet,
       END OF ty_j_1bnflin,

       BEGIN OF ty_j_1bnfstx,
         docnum TYPE j_1bnfstx-docnum,
         itmnum TYPE j_1bnfstx-itmnum,
         taxtyp TYPE j_1bnfstx-taxtyp,
         taxval TYPE j_1bnfstx-taxval,
       END OF ty_j_1bnfstx,

       BEGIN OF ty_tax,
         docnum        TYPE j_1bnflin-docnum,
         itmnum        TYPE j_1bnflin-itmnum,
         desc_impostos TYPE string,
       END OF ty_tax.

* Declarando minhas tabelas internas, work áreas e objetos (GLOBAIS) que vão ser utilizadas no REPORT *
DATA: gt_bdcdata    TYPE STANDARD TABLE OF bdcdata,
      gt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll,
      gw_bdcdata    TYPE bdcdata.

DATA: gt_saida     TYPE STANDARD TABLE OF ty_saida,
      gt_j_1bnfdoc TYPE STANDARD TABLE OF ty_j_1bnfdoc,
      gt_j_1bnflin TYPE STANDARD TABLE OF ty_j_1bnflin,
      gt_j_1bnfstx TYPE STANDARD TABLE OF ty_j_1bnfstx,
      gt_aux_tax   TYPE STANDARD TABLE OF ty_tax.

DATA: gt_tvarvc TYPE STANDARD TABLE OF tvarvc,
      gw_tvarvc TYPE tvarvc.

DATA: go_cc  TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.
