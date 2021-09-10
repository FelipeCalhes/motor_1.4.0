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

define type ObjAcessoTerminal {
    terminal  : String(40);
    acessorio : String(40);
}

define type ObjAgrupadores {
    agrupador  : String(50);
    tecnologia : String(50);
    material   : String(40);
}

define type ObjRegioes {
    regiao         : String(50);
    municipio      : String(50);
    descrMunicipio : String(200);
}

service MotorDeRegras {

    function upsert_bom() returns Boolean;
    function upsert_agrupadores() returns Boolean;
    function upsert_regioes() returns Boolean;
    function upsert_acessoTerminal() returns Boolean;
    function replicate_baixa() returns Boolean;

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
    }]) as projection on p.RegraDeCalculo;

    entity Parametros @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.Parametros;

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

    entity LoginTecnico @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.LoginTecnico;

    entity RetornoDaBaixa @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.RetornoDaBaixa;

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
        Agrupadores : array of ObjAgrupadores;
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

    entity TipoWoBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.TipoWoBaixaAutomatica;


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
    }]) as projection on p.Fornecedor;

    entity MateriaisExcecao @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : [
            'Edit',
            'system-user'
        ]
    }]) as projection on p.MateriaisExcecao;

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
