using regrasNamespace as p from '../db/Schema';

define type ObjBOM {
    tipoInstalacao : String(1);
    idTipoOS       : String(200);
    codMaterialSAP : String(40);
    qtdMin         : Decimal;
    qtdMax         : Decimal;
    unidadeConsumo : String(3);
}

service MotorDeRegras {
    entity BOM @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.BOM;

    //entity BOMUpd as projection on p.BOM;

    entity RegraDeCalculo @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.RegraDeCalculo;

    entity Parametros @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.Parametros;

    entity TecnicoPorEPO @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.TecnicoPorEPO;

    entity TipoOsHelp @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.TipoOsHelpOdata;

    entity MateriaisHelp @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.MateriaisHelpOdata;

    entity FornecedorHelp @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.FornecedorHelpOdata;

    entity LoginTecnico @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.LoginTecnico;

    entity RetornoDaBaixa @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.RetornoDaBaixa;

    entity importBOM @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) {
        BOM : array of ObjBOM;
    }

    entity killBOM @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) {
        kill : Boolean;
    }

    entity TipoWoBaixaAutomatica @(restrict : [{
        grant : [
            'READ',
            'WRITE'
        ],
        to    : 'Edit'
    }]) as projection on p.TipoWoBaixaAutomatica;
}
