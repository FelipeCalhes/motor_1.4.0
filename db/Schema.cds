namespace regrasNamespace;

entity BOM {
    key tipoInstalacao : String(1);
    key idTipoOS       : String(200);
    key regiao         : String(50) default '';
    key codMaterialSAP : String(40) default '';
    key agrupador      : String(50) default '';
    key tecnologia     : String(50) default '';
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

@cds.persistence.exists
entity BOM_P {
    key tipoInstalacao : String(1);
    key idTipoOS       : String(200);
    key regiao         : String(50);
    key codMaterialSAP : String(40);
    key agrupador      : String(50);
    key tecnologia     : String(50);
        qtdMin         : Decimal;
        qtdMax         : Decimal;
        pctBom         : Decimal;
        qtdTol         : Decimal;
        unidadeConsumo : String(3);
        aprovacaoClaro : Boolean;
        tipoOs         : Association to one TipoOs_P
                             on tipoOs.tipo_Os = $self.idTipoOS;
        materiais      : Association to one Materiais_P
                             on materiais.matnr = $self.codMaterialSAP;
}

@cds.persistence.exists
entity FornecedorBaixaAutomatica {
    key fornecedor : String(10);
}

entity Estoque {
    key matnr     : String(18);
    key werks     : String(4);
    key charg     : String(10);
    key sobkz     : String(1);
    key lifnr     : String(10);
        lblab     : Decimal(13, 3);
        lbins     : Decimal(13, 3);
        meins     : String(3);
        timestamp : Timestamp;
}

@cds.persistence.exists
entity Estoque_P {
    key matnr     : String(18);
    key werks     : String(4);
    key charg     : String(10);
    key sobkz     : String(1);
    key lifnr     : String(10);
        lblab     : Decimal(13, 3);
        lbins     : Decimal(13, 3);
        meins     : String(3);
}

entity LoginTecnicoMotor {
    key loginTecnico     : String(120);
        CodFornecedorSAP : String(50);
        CNPJ             : String(16);
}

@cds.persistence.exists
entity LoginTecnicoMotor_P {
    key loginTecnico     : String(120);
        CodFornecedorSAP : String(50);
        CNPJ             : String(16);
}

entity Regioes {
    key regiao    : String(50);
    key municipio : Association to Municipios;
}

@cds.persistence.exists
entity Regioes_P {
    key regiao    : String(50);
    key municipio : Association to Municipios;
}

entity Municipios {
    key municipio      : String(50);
        descrMunicipio : String(200);
}

@cds.persistence.exists
entity Municipios_P {
    key municipio      : String(50);
        descrMunicipio : String(200);
}

entity Regioes_Transitoria {
    key regiao              : String(50);
    key municipio_municipio : String(50);
}

entity Municipios_Transitoria {
    key municipio      : String(50);
        descrMunicipio : String(200);
}

@cds.persistence.exists
entity Agrupadores_P {
    key agrupador  : String(50);
    key tecnologia : String(50);
    key material   : String(40);
}

entity Agrupadores {
    key agrupador  : String(50);
    key tecnologia : String(50);
    key material   : String(40);
        usuario    : String(120);
        dataHora   : String(50);
        materiais  : Association to one Materiais
                         on materiais.matnr = $self.material;
}

entity Agrupadores_Transitoria {
    key agrupador  : String(50);
    key tecnologia : String(50);
    key material   : String(40);
        usuario    : String(120);
        dataHora   : String(50);
}

entity GrupoView            as
    select from Agrupadores {
        agrupador,
        tecnologia
    }
    group by
        agrupador,
        tecnologia;

entity BOM_TRANSITORIA {
    key tipoInstalacao : String(1);
    key idTipoOS       : String(200);
    key regiao         : String(50) default '';
    key codMaterialSAP : String(40) default '';
    key agrupador      : String(50) default '';
    key tecnologia     : String(50) default '';
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

@cds.persistence.exists
entity RegraDeCalculo_P {
    key tipoDeRegra  : String(50);
        BOM          : Integer;
        estoque      : Integer;
        atribTecnico : Integer;
}

entity TipoWoBaixaAutomatica {
    key tipoWo : String(20);
}

@cds.persistence.exists
entity TipoWoBaixaAutomatica_P {
    key tipoWo : String(20);
}

entity Parametros {
    key parametros     : Integer;
        labelParametro : String;
        valor          : String;
}

@cds.persistence.exists
entity Parametros_P {
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

entity Fornecedor {
    lifnr     : String(10);
    berid     : String(10);
    werks_mrp : String(10);
    name1     : String(35);
    stcd1     : String(16);
    stcd2     : String(11);
}

@cds.persistence.exists
entity Fornecedor_P {
    lifnr     : String(10);
    berid     : String(10);
    werks_mrp : String(10);
    name1     : String(35);
    stcd1     : String(16);
    stcd2     : String(11);
}

entity Empresas {
    bukrs  : String(4);
    branch : String(4);
}

@cds.persistence.exists
entity Empresas_P {
    bukrs  : String(4);
    branch : String(4);
}

entity Centros {
    werks      : String(4);
    name1      : String(30);
    bwkey      : String(4);
    kunnr      : String(10);
    lifnr      : String(10);
    j_1bbranch : String(4);
}

@cds.persistence.exists
entity Centros_P {
    werks      : String(4);
    lifnr      : String(10);
    j_1bbranch : String(4);
}

entity TecnicoPorEPO {
    key loginTecnico     : String(120);
        CodFornecedorSAP : String(50);
        fornecedor       : Association to one FornecedorHelpOdata
                               on $self.CodFornecedorSAP = fornecedor.fornecedor
}

@cds.persistence.exists
entity TecnicoPorEPO_P {
    key loginTecnico     : String(120);
        CodFornecedorSAP : String(50);
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

entity TipoOs {
    key tipo_Os   : String(4);
        desc_os   : String(50);
        aplicacao : String(1);
}

@cds.persistence.exists
entity TipoOs_P {
    key tipo_Os   : String(4);
        desc_os   : String(50);
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
        repTime          : String(50);
}

entity TipoOsHelpOdata      as
    select from TipoOs {
        tipo_Os as tipoOs,
        desc_os as descricaoOs
    };

@cds.persistence.exists
entity RetornoDaBaixa_P {
    key consolidado   : String(50);
    key consolidID    : String(50);
    key material      : String(18);
    key contador      : Integer;
        status        : String(1);
        mensagem      : String(220);
        quantidade    : Decimal(13, 0);
        quantidadeDoc : Decimal(13, 0);
        mblnr         : String(10);
        mjahr         : String(4);
        zeile         : String(4);
        data          : String(10);
    key workOrderID   : String(50);
        fornecedorID  : String(10);
        aplicacao     : String(50);
        uuid          : String(40);
        erdat         : String(8);
        erzet         : String(6);
}

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
        uuid             as uuid,
        erdat            as erdat,
        erzet            as erzet
    };

entity Materiais {
    key matnr : String(18);
    key spras : String(1);
        maktx : String(40);
        meins : String(3);
        mtart : String(4);
}

@cds.persistence.exists
entity Materiais_P {
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

@cds.persistence.exists
entity MateriaisExcecao_P {
    key material : String;
}

entity MateriaisExcecao_Transitoria {
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

@cds.persistence.exists
entity TotalItemTab {
    key workOrderID       : String(50);
        contrato          : String(50);
        tipoWo            : String(20);
        idTecnico         : String(100);
        fornecedorSAP     : String(10);
        dataAtendimento   : Date;
        municipio         : String(100);
        enviado           : Boolean default false;
        statusFinalizacao : String(50);
        totalItems        : Integer;
        sla               : String(10);
        status            : Integer;
}

@cds.persistence.exists
entity TotalItemView {
    key workOrderID       : String(50);
        contrato          : String(50);
        tipoWo            : String(20);
        idTecnico         : String(100);
        fornecedorSAP     : String(10);
        dataAtendimento   : Date;
        municipio         : String(100);
        enviado           : Boolean default false;
        statusFinalizacao : String(50);
        totalItems        : Integer;
        sla               : String(10);
        status            : Integer;
}

@cds.persistence.exists
entity UnionErros {
    key workOrderID       : String(50);
        material          : String(50);
        mensagem          : String;
        tipoErro         : String(12);
        status     : Integer;
        aprovacaoAdmStatus   : String(20);
}

@cds.persistence.exists
entity UnionErrosView {
    key workOrderID       : String(50);
        material          : String(50);
        mensagem          : String;
        tipoErro         : String(12);
        status     : Integer;
        aprovacaoAdmStatus   : String(20);
}

@cds.persistence.exists
entity Material {
    key workOrderID_workOrderID : String(50);
    key material                : String;
        linha                   : Integer;
        quantidade              : Decimal;
        unidade                 : String(3);
}

@cds.persistence.exists
entity WorkOrder {
    key workOrderID       : String(50);
        apptNumber        : String(50);
        idTecnico         : String(100);
        dataAtendimento   : Date;
        tecnologia        : String(50) default '';
        municipio         : String(100);
        codIBGE           : String(50) default '';
        tipoWo            : String(20);
        justificativa     : String;
        byPassVal         : Boolean;
        contrato          : String(50);
        tipoEdificacao    : String(1);
        fornecedorSAP     : String(10);
        aprovador         : String(120);
        timeAprovacao     : String(50);
        enviado           : Boolean default false;
        foraTOA           : Boolean default false;
        statusFinalizacao : String(50);
        seriaisNovos      : Decimal(13, 2);
}

entity EstoqueLastChange    as
    select from Estoque {
        matnr,
        lifnr
    }
    where
        timestamp = (
            select MAX(
                timestamp
            ) as max from Estoque
        )
    group by
        matnr,
        lifnr;

entity UpdateList           as
    select from Material as mat
    inner join WorkOrder as wo
        on wo.workOrderID = mat.workOrderID_workOrderID
    inner join EstoqueLastChange as ch
        on  LTRIM(
            ch.matnr, '0'
        ) = mat.material
        and LTRIM(
            ch.lifnr, '0'
        ) = wo.fornecedorSAP
    {
        wo.workOrderID
    }
    group by
        wo.workOrderID;
