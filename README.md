# Relatorio-NFs-SAP-ABAP

**Objetivo** 
Relatório de Notas Fiscais. 

**Detalhamento** 

**Processos** 
 
* Criar um relatório ALV (report) – Nome: ZR<iniciais>_SBRELAT_NFS
    * Opções de seleção:
        * Número Nota (J_1BNFDOC-DOCNUM)
        * Data Lançamento (J_1BNFDOC-PSTDAT)
    * Regra:
        * Tabelas J_1BNFDOC (cabeçalho NF), J_1BNFLIN (item NF), J_1BNFSTX (impostos item NF), J_1BAJ (tipo de imposto)
        * Parâmetro Grupo Impostos
            * Criar um parâmetro para armazenar os grupos de impostos que serão exibidos na tela de detalhamentos impostos (STVARV)
        * Funcionalidade
            * Duplo Clique no DOCNUM abre a J1B3N zdo documento
            * Duplo Clique na coluna Total Impostos, exibindo uma mensagem descritiva Exemplo:
                * “ICMS: 150,00. Outros: 50,00”
                * “ICMS: 150,00. IPI: 20,00. Outros: 30,00”.
        * Exibição Principal
            * J_1BNFDOC-DOCNUM – Número documento
            * J_1BNFDOC-PSTDAT – Data Lançamento
            * J_1BNFDOC-NFTYPE – Tipo Nota
            * J_1BNFDOC-DIRECT – Direção
            * J_1BNFDOC-SERIES – Serie NF
            * J_1BNFDOC-NFNUM – Número Nota (antigo)
            * J_1BNFDOC-NFENUM – Número NF Eletrônica
            * J_1BNFLIN-ITMNUM – Item da NF
            * J_1BNFLIN-MATNR - Material
            * J_1BNFLIN-MAKTX – Descrição Material
            * J_1BNFLIN-MENGE - Quantidade
            * J_1BNFLIN-CFOP – CFOP
            * J_1BNFLIN-NFNET – Valor Item
            * J_1BNFSTX-TAXVAL – Total Impostos (soma) 
