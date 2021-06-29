module.exports = (motor) => {

    //teste pull
    motor.before('CREATE', 'BOM', async (req) => {
        if (req.data.qtdTol > 0) {
            req.data.pctBom = 100 * req.data.qtdTol / req.data.qtdMax
        } else if (req.data.pctBom > 0) {
            req.data.qtdTol = req.data.pctBom * req.data.qtdMax / 100
        }
    })

    motor.before('UPDATE', 'BOM', async (req) => {
        if (req.data.qtdTol > 0) {
            req.data.pctBom = 100 * req.data.qtdTol / req.data.qtdMax
        } else if (req.data.pctBom > 0) {
            req.data.qtdTol = req.data.pctBom * req.data.qtdMax / 100
        }
    })

    motor.on('CREATE', 'importBOM', async (req) => {
        const srv = await cds.connect.to('db');
        const { BOM } = srv.entities
        reqArr = req.data.BOM
        bomTable = await srv.run(SELECT.from(BOM))
        backupBom = []
        bomTable.forEach((b) => {
            if (b.qtdTol === '' || b.qtdTol === null) {
                b.qtdTol = 0
            }
            if (b.pctBom === '' || b.pctBom === null) {
                b.pctBom = 0
            }
            backupBom.push(b)
            reqArr.forEach((r) => {
                if (b.tipoInstalacao === r.tipoInstalacao && b.idTipoOS === r.idTipoOS && b.codMaterialSAP === r.codMaterialSAP) {
                    b.qtdMax = r.qtdMax
                    b.qtdMin = r.qtdMin
                    if (r.qtdTol > 0) {
                        b.qtdTol = r.qtdTol
                        r.pctBom = String(100 * r.qtdTol / r.qtdMax)
                        b.pctBom = r.pctBom
                    } else if (r.pctBom > 0) {
                        b.pctBom = r.pctBom
                        r.qtdTol = String(r.pctBom * r.qtdMax / 100)
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
                    r.pctBom = String(100 * r.qtdTol / r.qtdMax)
                } else if (r.pctBom > 0) {
                    r.qtdTol = String(r.pctBom * r.qtdMax / 100)
                }
                let zeroEsquerda = '0000' + r.idTipoOS
                r.idTipoOS = zeroEsquerda.slice(-4)
                bomTable.push(r)
            }
        })
        console.log(JSON.stringify(reqArr))
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
