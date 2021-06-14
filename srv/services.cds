using regrasNamespace as p from '../db/Schema';

define type ObjBOM {
    tipoInstalacao : String(1);
    idTipoOS       : String(200);
    codMaterialSAP : String(40);
    qtdMin         : Decimal;
    qtdMax         : Decimal;
    unidadeConsumo : String(3);
}

define type ObjTipoWo {
    tipoWo : String(20);
}

service MotorDeRegras {
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

    //entity BOMUpd as projection on p.BOM;

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
}