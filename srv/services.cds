using regrasNamespace as p from '../db/Schema';

define type ObjBOM {
    tipoInstalacao : String(1);
    idTipoOS       : String(200);
    regiao         : String(50);
    codMaterialSAP : String(40);
    agrupador      : String(50);
    tecnologia     : String(50);
    qtdMin         : Decimal;
    qtdMax         : Decimal;
    pctBom         : Decimal;
    qtdTol         : Decimal;
    unidadeConsumo : String(3);
    aprovacaoClaro : Boolean;
}

define type ObjTipoWo {
    tipoWo : String(20);
}

define type ObjFornecedor {
    fornecedor : String(10);
}

define type ObjAcessoTerminal {
    terminal  : String(40);
    acessorio : String(40);
}

define type ObjAgrupadores {
    agrupador  : String(50);
    tecnologia : String(50);
    material   : String(40);
    usuario    : String(120);
    dataHora   : String(50);
}

define type ObjRegioes {
    regiao              : String(50);
    municipio_municipio : String(50);
}

define type ObjMateriaisExcecao {
    material              : String(50);
}

service MotorDeRegras {

    function upsert_bom() returns Boolean;
    function upsert_agrupadores() returns Boolean;
    function upsert_regioes() returns Boolean;
    function upsert_acessoTerminal() returns Boolean;
    function replicate_baixa() returns Boolean;
    
    entity FornecedorBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.FornecedorBaixaAutomatica 

    entity Agrupadores @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.Agrupadores

    entity Regioes @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.Regioes

    entity Municipios @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.Municipios

    entity REMOTECONSOLID @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.REMOTECONSOLID

    entity BOM @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.BOM;

    entity BOM_TRANSITORIA @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.BOM_TRANSITORIA;

    entity RegraDeCalculo @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.RegraDeCalculo_P;

    entity Parametros @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.Parametros_P;

    entity TecnicoPorEPO @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.TecnicoPorEPO;

    entity TipoOsHelp @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.TipoOsHelpOdata;

    entity MateriaisHelp @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.MateriaisHelpOdata;

    entity FornecedorHelp @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.FornecedorHelpOdata;

    entity RetornoDaBaixa @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.RetornoDaBaixa_P;

    entity importBOM @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        BOM : array of ObjBOM;
    }    
    
    entity importMateriaisExcecao @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        MateriaisExcecao : array of ObjMateriaisExcecao;
    }

    entity importAgrupadores @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        agrupadores : array of ObjAgrupadores;
    }

    entity importRegioes @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        regioes : array of ObjRegioes;
    }
    
    entity importFornecedorBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        fornecedor : array of ObjFornecedor;
    } 

    entity killBOM @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        kill : Boolean;
    }
    
    entity killAgrupadores @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        kill : Boolean;
    }
    
    entity killFornecedorBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        kill : Boolean;
    }

    entity TipoWoBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.TipoWoBaixaAutomatica_P;


    entity importTipoWoBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        TipoWoBaixaAutomatica : array of ObjTipoWo;
    }

    entity killTipoWoBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        kill : Boolean;
    }

    entity ExpandTecnico @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.ExpandTecnico;

    entity Fornecedor @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.Fornecedor_P;

    entity MateriaisExcecao @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.MateriaisExcecao_P;

    entity AcessoTerminal @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.AcessoTerminal;

    entity killAcessoTerminal @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        kill : Boolean;
    }

    entity importAcessoTerminal @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) {
        AcessoTerminal : array of ObjAcessoTerminal;
    }

    entity GrupoView @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.GrupoView;
}
