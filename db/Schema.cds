namespace regrasNamespace;

entity BOM {
    key tipoInstalacao : String(1);
    key idTipoOS       : String(200);
    key codMaterialSAP : String(40);
        qtdMin         : Decimal;
        qtdMax         : Decimal;
        pctBom         : Decimal;
        qtdTol         : Decimal;
        unidadeConsumo : String(3);
        aprovacaoClaro : Boolean default false;
        tipoOs         : Association to one TipoOs
                             on tipoOs.tipo_Os = $self.idTipoOS;
        materiais      : Association to one Materiais
                             on materiais.matnr = $self.codMaterialSAP;
}

entity BOM_TRANSITORIA {
    key tipoInstalacao : String(1);
    key idTipoOS       : String(200);
    key codMaterialSAP : String(40);
        qtdMin         : Decimal;
        qtdMax         : Decimal;
        pctBom         : Decimal;
        qtdTol         : Decimal;
        unidadeConsumo : String(3);
        aprovacaoClaro : Boolean default false;
}

entity RegraDeCalculo {
    key tipoDeRegra  : String(50);
        BOM          : Integer;
        estoque      : Integer;
        atribTecnico : Integer;
        atribAcessor : Integer;
}

entity TipoWoBaixaAutomatica {
    key tipoWo : String(20);
}

entity Parametros {
    key parametros     : Integer;
        labelParametro : String;
        valor          : String;
}

@cds.persistence.exists
entity REMOTECONSOLID {
    key mandt            : String(3);
    key id_consolid_orig : String(50);
    key consolidado      : String(50);
    key contador         : Integer;
        matnr            : String(18);
        status           : String(1);
        mensagem         : String(220);
        lbkum            : Decimal(13, 3);
        lbkum_doc        : Decimal(13, 3);
        mblnr            : String(10);
        mjahr            : String(4);
        zeile            : String(4);
        data             : String(8);
        wo               : String(50);
        lifnr            : String(10);
        item_text        : String(50);
        uuid             : String(40);
        erdat            : String(8);
        erzet            : String(6);
}
/*
entity REMOTECONSOLID       as
    select from REMOTECONSOLID2 {
        mandt,
        id_consolid_orig,
        consolidado,
        contador,
        matnr,
        status,
        mensagem,
        lbkum,
        lbkum_doc,
        mblnr,
        mjahr,
        zeile,
        data,
        wo,
        lifnr,
        item_text,
        uuid,
        erdat,
        erzet
    };*/

@cds.persistence.exists
entity Fornecedor {
    lifnr     : String(10);
    berid     : String(10);
    werks_mrp : String(10);
    name1     : String(35);
    stcd1     : String(16);
    stcd2     : String(11);
}

@cds.persistence.exists
entity Empresas {
    bukrs  : String(4);
    branch : String(4);
}

@cds.persistence.exists
entity Centros {
    werks      : String(4);
    name1      : String(30);
    bwkey      : String(4);
    kunnr      : String(10);
    lifnr      : String(10);
    j_1bbranch : String(4);
}

entity TecnicoPorEPO {
    key loginTecnico     : String(120);
        CodFornecedorSAP : String(50);
        fornecedor       : Association to one FornecedorHelpOdata
                               on $self.CodFornecedorSAP = fornecedor.fornecedor
}

entity ExpandTecnico        as
    select from TecnicoPorEPO {
        loginTecnico          as loginTecnico,
        CodFornecedorSAP      as CodFornecedorSAP,
        fornecedor.fornecedor as descrFornecedor,
        fornecedor.cnpj       as CNPJ
    }
    group by
        loginTecnico,
        CodFornecedorSAP,
        fornecedor.fornecedor,
        fornecedor.cnpj;

entity LoginTecnico {
    key loginTecnico     : String(120);
        CodFornecedorSAP : String(50);
        CNPJ             : String(10);
}

entity BOM2ODATA            as
    select from BOM
    left join Materiais as mat
        on BOM.codMaterialSAP = mat.matnr
    left join TipoOs as os
        on BOM.idTipoOS = os.tipo_Os
    {
        BOM.tipoInstalacao,
        case BOM.tipoInstalacao
            when
                'C'
            then
                'Casa'
            else
                'Edifício/Unidade'
        end        as descTipoInstalacao : String(12),
        BOM.idTipoOS,
        os.desc_os as descTipoOs         : String(50),
        BOM.codMaterialSAP,
        mat.maktx  as descMaterial       : String(50),
        BOM.qtdMin,
        BOM.qtdMax,
        BOM.unidadeConsumo
    };

@cds.persistence.exists
entity TipoOs {
    key tipo_Os   : String(4);
        desc_os   : String(50);
        aplicacao : String(1);
}

entity RespBaixa {
    key mandt            : String(3);
    key id_consolid_orig : String(50);
    key consolidado      : String(50);
    key contador         : Integer;
        matnr            : String(18);
        status           : String(1);
        mensagem         : String(220);
        lbkum            : Decimal(13, 3);
        lbkum_doc        : Decimal(13, 3);
        mblnr            : String(10);
        mjahr            : String(4);
        zeile            : String(4);
        data             : String(8);
        wo               : String(50);
        lifnr            : String(10);
        item_text        : String(50);
        uuid             : String(40);
        erdat            : String(8);
        erzet            : String(6);
        repTime: String(50);
}

entity TipoOsHelpOdata      as
    select from TipoOs {
        tipo_Os as tipoOs,
        desc_os as descricaoOs
    };

entity RetornoDaBaixa       as
    select from RespBaixa {
        consolidado      as consolidado,
        id_consolid_orig as consolidID,
        matnr            as material,
        contador         as contador,
        status           as status,
        mensagem         as mensagem,
        lbkum            as quantidade,
        lbkum_doc        as quantidadeDoc,
        mblnr            as mblnr,
        mjahr            as mjahr,
        zeile            as zeile,
        CONCAT(
            CONCAT(
                CONCAT(
                    CONCAT(
                        LEFT(
                            data, 4
                        ), '-'
                    ), LEFT(
                        RIGHT(
                            data, 4
                        ), 2
                    )
                ), '-'
            ), RIGHT(
                data, 2
            )
        )                as data : Date,
        wo               as workOrderID,
        lifnr            as fornecedorID,
        item_text        as aplicacao,
        erdat            as erdat,
        erzet            as erzet
    };

@cds.persistence.exists
entity Materiais {
    key matnr : String(18);
    key spras : String(1);
        maktx : String(40);
        meins : String(3);
        mtart : String(4);
}

entity MateriaisHelpOdata   as
    select from Materiais {
        key matnr as material,
            maktx as descMaterial,
            meins as unidade
    }
    where
        spras = 'P';

entity FornecedorHelpOdata  as
    select from Fornecedor {
        key lifnr as fornecedor,
            name1 as nomeFornecedor,
            stcd1 as cnpj
    }
    group by
        lifnr,
        name1,
        stcd1;

entity FornecedorHelpCentro as
    select from Fornecedor {
        key lifnr     as fornecedor,
            name1     as nomeFornecedor,
            stcd1     as cnpj,
            werks_mrp as centro
    }
    group by
        lifnr,
        name1,
        stcd1,
        werks_mrp;

entity MatCount             as
    select count(
        *
    ) as c : String(10) from Materiais;

entity MateriaisExcecao {
    key material : String;
}

entity TesteSidecar {
    key sideDeploy : String;
}

entity AcessoTerminal {
    key terminal  : String(40);
    key acessorio : String(40);
}

entity AcessoTerminal_Transitoria {
    key terminal  : String(40);
    key acessorio : String(40);
}
