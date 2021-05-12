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
            resp = {'kill':true}
        }
        catch (err) {
            resp = {'kill':false}
            req.reject(400, 'Erro ao deletar tabela')
        }
        return resp
    })
}