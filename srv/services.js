module.exports = (motor) => {
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
                    b.unidadeConsumo = r.unidadeConsumo
                    r.codMaterialSAP = 'Linha alterada'
                }
            })
        })
        reqArr.forEach((r) => {
            if (r.codMaterialSAP != 'Linha alterada') {
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