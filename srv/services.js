module.exports = (motor) => {

    motor.before('CREATE', 'BOM', async (req) => {
        if (req.data.qtdTol > 0) {
            req.data.pctBom = String(Math.trunc(100 * 100 * req.data.qtdTol / req.data.qtdMax) / 100)
        } else if (req.data.pctBom > 0) {
            req.data.qtdTol = String(Math.trunc(100 * req.data.pctBom * req.data.qtdMax / 100) / 100)
        }
    })

    motor.on('upsert_bom', async () => {
        try {
            const db = await cds.connect.to('db')
            const dbClass = require("sap-hdbext-promisfied")
            let dbConn = new dbClass(await dbClass.createConnection(db.options.credentials))
            const hdbext = require("@sap/hdbext")
            const sp = await dbConn.loadProcedurePromisified(hdbext, null, 'UPSERT_BOM')
            const output = await dbConn.callProcedurePromisified(sp, [])
            console.log(output.results)
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

    /*motor.on('UPDATE', 'BOM', async (req) => {
        const srv = await cds.connect.to('db');
        const { BOM, BOM_TRANSITORIA } = srv.entities
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

        if (!req.data.qtdMin) {
            req.data.qtdMin = bomTable.qtdMin
        }
        if (typeof req.data.aprovacaoClaro === 'undefined') {
            req.data.aprovacaoClaro = bomTable.aprovacaoClaro
        }
        console.log(JSON.stringify(req.data))
        await srv.run(INSERT.into(BOM_TRANSITORIA).entries({
            tipoInstalacao: req.data.tipoInstalacao,
            idTipoOS: req.data.idTipoOS,
            codMaterialSAP: req.data.codMaterialSAP,
            qtdMin:req.data.qtdMin,
            qtdMax:req.data.qtdMax,
            pctBom:req.data.pctBom,
            qtdTol:req.data.qtdTol,
            unidadeConsumo:'',
            aprovacaoClaro:req.data.aprovacaoClaro
        }))
        await srv.run("COMMIT")            
        const db = await cds.connect.to('db')
        const dbClass = require("sap-hdbext-promisfied")
        let dbConn = new dbClass(await dbClass.createConnection(db.options.credentials))
        const hdbext = require("@sap/hdbext")
        const sp = await dbConn.loadProcedurePromisified(hdbext, null, 'UPSERT_BOM')
        const output = await dbConn.callProcedurePromisified(sp, [])
        return req.data
    })*/

    motor.on('CREATE', 'importBOM', async (req) => {
        const srv = await cds.connect.to('db');
        const { BOM_TRANSITORIA } = srv.entities
        await srv.run(INSERT.into(BOM_TRANSITORIA).entries(req.data.BOM))
        return req.data
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

    motor.on('CREATE', 'AcessoTerminal', async (req) => {
        const srv = await cds.connect.to('db')
        const { AcessoTerminal } = srv.entities

        try {
            await srv.run(INSERT.into(AcessoTerminal).entries({
                acessorio: req.data.acessorio,
                terminal: req.data.terminal
            }))
        } catch (err) {
            req.reject(err.error, err.message);
        }

        return req.data
    })

    motor.on('GET', 'killAcessoTerminal', async (req) => {
        const srv = await cds.connect.to('db');
        const { killAcessoTerminal } = srv.entities

        let resp
        try {
            await srv.run(DELETE.from(killAcessoTerminal))
            resp = { 'kill': true }
        }
        catch (err) {
            resp = { 'kill': false }
            req.reject(400, 'Erro ao deletar tabela')
        }
        return resp
    })

    motor.on('CREATE', 'importAcessoTerminal', async (req) => {
        const srv = await cds.connect.to('db');
        const { AcessoTerminal_Transitoria } = srv.entities
        await srv.run(INSERT.into(AcessoTerminal_Transitoria).entries(req.data.AcessoTerminal))
        return req.data

        /*
        const srv = await cds.connect.to('db');
        const { AcessoTerminal } = srv.entities
        reqArr = req.data.AcessoTerminal

        backup = await srv.run(SELECT.from(AcessoTerminal))
        repetidos = []
        insert = []
        reqArr.forEach((r) => {
            backup.forEach((b) => {
                if (b.acessorio === r.acessorio && b.terminal === r.terminal) {
                    repetidos.push({acessorio: r.acessorio, terminal: r.termina})
                }
            })
        })
        reqArr.forEach((r) => {            
            if (!(repetidos.find(element => element.acessorio === r.acessorio && element.terminal === r.terminal))) {
                insert.push(r)
            }
        })
        try {
            await srv.run(INSERT.into(AcessoTerminal).entries(insert))
        }
        catch (err) {
            req.reject(400, err.message)
        }
        return (req.data)*/
    })

    motor.on('upsert_acessoTerminal', async () => {
        try {
            const db = await cds.connect.to('db')
            const dbClass = require("sap-hdbext-promisfied")
            let dbConn = new dbClass(await dbClass.createConnection(db.options.credentials))
            const hdbext = require("@sap/hdbext")
            const sp = await dbConn.loadProcedurePromisified(hdbext, null, 'UPSERT_ACESSOTERMINAL')
            const output = await dbConn.callProcedurePromisified(sp, [])
            console.log(output.results)
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

    motor.on('replicate_baixa', async () => {
        try {
            const db = await cds.connect.to('db')
            const dbClass = require("sap-hdbext-promisfied")
            let dbConn = new dbClass(await dbClass.createConnection(db.options.credentials))
            const hdbext = require("@sap/hdbext")
            const sp = await dbConn.loadProcedurePromisified(hdbext, null, 'REPLICATE_BAIXA')
            const output = await dbConn.callProcedurePromisified(sp, [])
            console.log(output.results)
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })
}