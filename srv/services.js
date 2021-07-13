module.exports = (motor) => {

    motor.before('CREATE', 'BOM', async (req) => {
        if (req.data.qtdTol > 0) {
            req.data.pctBom = String(Math.trunc(100 * 100 * req.data.qtdTol / req.data.qtdMax) / 100)
        } else if (req.data.pctBom > 0) {
            req.data.qtdTol = String(Math.trunc(100 * req.data.pctBom * req.data.qtdMax / 100) / 100)
        }
    })

    motor.on('UPDATE', 'BOM', async (req) => {
        const srv = await cds.connect.to('db');
        const { BOM } = srv.entities
        bomTable = await srv.run(SELECT.one.from(BOM).where({
            codMaterialSAP: req.data.codMaterialSAP,
            idTipoOS: req.data.idTipoOS,
            tipoInstalacao: req.data.tipoInstalacao
        }))
        if (!req.data.qtdMax) {
            req.data.qtdMax = bomTable.qtdMax
        }
        if (!req.data.qtdTol) {
            if (!req.data.pctBom) {
                req.data.pctBom = bomTable.pctBom
                req.data.qtdTol = String(Math.trunc(100 * req.data.pctBom * req.data.qtdMax / 100) / 100)
            } else {
                req.data.qtdTol = String(Math.trunc(100 * req.data.pctBom * req.data.qtdMax / 100) / 100)
            }
        } else {
            if (req.data.qtdMax == 0 || req.data.qtdMax === '' || req.data.qtdMax === null) { req.reject(400, 'qtdMax incorreta') }
            req.data.pctBom = String(Math.trunc(100 * 100 * req.data.qtdTol / req.data.qtdMax) / 100)
        }
        
        if(!req.data.qtdMin){
            req.data.qtdMin = bomTable.qtdMin
        }
        if (typeof req.data.aprovacaoClaro === 'undefined') {
            req.data.aprovacaoClaro = bomTable.aprovacaoClaro
        }
        await srv.run(UPDATE(BOM)
            .set({
                qtdMin: req.data.qtdMin,
                qtdMax: req.data.qtdMax,
                pctBom: req.data.pctBom,
                qtdTol: req.data.qtdTol,
                aprovacaoClaro: req.data.aprovacaoClaro
            })
            .where({
                codMaterialSAP: req.data.codMaterialSAP,
                idTipoOS: req.data.idTipoOS,
                tipoInstalacao: req.data.tipoInstalacao
            }))

        return req.data
    })

    motor.on('CREATE', 'importBOM', async (req) => {
        const srv = await cds.connect.to('db');
        const { BOM } = srv.entities
        reqArr = req.data.BOM
        bomTable = await srv.run(SELECT.from(BOM))
        backupBom = []
        bomTable.forEach((b) => {
            backupBom.push(b)
            reqArr.forEach((r) => {
                if (b.tipoInstalacao === r.tipoInstalacao && b.idTipoOS === r.idTipoOS && b.codMaterialSAP === r.codMaterialSAP) {
                    b.qtdMax = r.qtdMax
                    b.qtdMin = r.qtdMin
                    b.aprovacaoClaro = r.aprovacaoClaro
                    if (r.qtdTol > 0) {
                        b.qtdTol = r.qtdTol
                        r.pctBom = String(Math.trunc(100 * 100 * r.qtdTol / r.qtdMax) / 100)
                        b.pctBom = r.pctBom
                    } else if (r.pctBom > 0) {
                        b.pctBom = r.pctBom
                        r.qtdTol = String(Math.trunc(100 * r.pctBom * r.qtdMax / 100) / 100)
                        b.qtdTol = r.qtdTol
                    }
                    b.qtdTol = r.qtdTol
                    b.pctBom = r.pctBom
                    b.unidadeConsumo = r.unidadeConsumo
                    r.codMaterialSAP = 'Linha alterada'
                }
            })
        })
        reqArr.forEach((r) => {
            if (r.codMaterialSAP != 'Linha alterada') {
                if (r.qtdTol > 0) {
                    r.pctBom = String(Math.trunc(100 * 100 * r.qtdTol / r.qtdMax) / 100)
                } else if (r.pctBom > 0) {
                    r.qtdTol = String(Math.trunc(100 * r.pctBom * r.qtdMax / 100) / 100)
                }
                let zeroEsquerda = '0000' + r.idTipoOS
                r.idTipoOS = zeroEsquerda.slice(-4)
                bomTable.push(r)
            }
        })
        await srv.run(DELETE.from(BOM))
        try {
            await srv.run(INSERT.into(BOM).entries(bomTable))
        }
        catch (err) {
            await srv.run(INSERT.into(BOM).entries(backupBom))
            req.reject(400, 'Erro ao gravar Tabela')
        }
        return (req.data)
    })

    motor.on('READ', 'killBOM', async (req) => {
        const srv = await cds.connect.to('db');
        const { BOM } = srv.entities
        let resp
        try {
            await srv.run(DELETE.from(BOM))
            resp = { 'kill': true }
        }
        catch (err) {
            resp = { 'kill': false }
            req.reject(400, 'Erro ao deletar tabela')
        }
        return resp
    })

    motor.on('CREATE', 'importTipoWoBaixaAutomatica', async (req) => {
        const srv = await cds.connect.to('db');
        const { TipoWoBaixaAutomatica } = srv.entities
        reqArr = req.data.TipoWoBaixaAutomatica
        backup = await srv.run(SELECT.from(TipoWoBaixaAutomatica))
        repetidos = []
        insert = []
        reqArr.forEach((r) => {
            backup.forEach((b) => {
                if (b.tipoWo === r.tipoWo) {
                    repetidos.push(r.tipoWo)
                }
            })
        })
        reqArr.forEach((r) => {
            if (!repetidos.includes(r.tipoWo)) {
                insert.push(r)
            }
        })
        try {
            await srv.run(INSERT.into(TipoWoBaixaAutomatica).entries(insert))
        }
        catch (err) {
            req.reject(400, err.message)
        }
        return (req.data)
    })

    motor.on('READ', 'killTipoWoBaixaAutomatica', async (req) => {
        const srv = await cds.connect.to('db');
        const { TipoWoBaixaAutomatica } = srv.entities
        let resp
        try {
            await srv.run(DELETE.from(TipoWoBaixaAutomatica))
            resp = { 'kill': true }
        }
        catch (err) {
            resp = { 'kill': false }
            req.reject(400, 'Erro ao deletar tabela')
        }
        return resp
    })
}