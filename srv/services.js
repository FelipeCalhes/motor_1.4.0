module.exports = (motor) => {

    motor.before('CREATE', 'BOM', async (req) => {
        if (req.data.qtdTol > 0) {
            req.data.pctBom = String(Math.trunc(100 * 100 * req.data.qtdTol / req.data.qtdMax) / 100)
        } else if (req.data.pctBom > 0) {
            req.data.qtdTol = String(Math.trunc(100 * req.data.pctBom * req.data.qtdMax / 100) / 100)
        }
    })

    motor.after('CREATE', 'BOM', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })

    motor.after('CREATE', 'Parametros', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL RESET_TOTALITEMS()')
    })
    
    motor.after('UPDATE', 'Parametros', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL RESET_TOTALITEMS()')
    })
    
    motor.after('CREATE', 'RegraDeCalculo', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('UPDATE', 'RegraDeCalculo', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('CREATE', 'Regioes', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('UPDATE', 'Regioes', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('CREATE', 'Agrupadores', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('UPDATE', 'Agrupadores', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('CREATE', 'MateriaisExcecao', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })
    
    motor.after('UPDATE', 'MateriaisExcecao', async (req) => {                
        let srv = await cds.connect.to('db');
        await srv.run('CALL UPDATE_TOTALITEMS()')
    })



    motor.on('upsert_bom', async () => {
        try {
            const srv = await cds.connect.to('db');
            await srv.run('CALL UPSERT_BOM()')
            await srv.run('CALL UPDATE_TOTALITEMS()')
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

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
    })

    motor.before('CREATE', 'Agrupadores', async (req) => {
        const srv = await cds.connect.to('db');
        const { LogAgrupadores } = srv.entities
        let log = []
        let hoje = new Date()
        let timestamp =
            ('0000' + JSON.stringify(hoje.getFullYear())).slice(-4)
            + '-' + ('00' + JSON.stringify(hoje.getMonth() + 1)).slice(-2)
            + '-' + ('00' + JSON.stringify(hoje.getDate())).slice(-2)
            + 'T' + ('00' + JSON.stringify(hoje.getHours())).slice(-2)
            + ':' + ('00' + JSON.stringify(hoje.getMinutes())).slice(-2)
            + ':' + ('00' + JSON.stringify(hoje.getSeconds())).slice(-2)
        req.data.usuario = req.user.id
        req.data.dataHora = timestamp
    })

    motor.on('CREATE', 'importAgrupadores', async (req) => {
        const srv = await cds.connect.to('db');
        const { Agrupadores_Transitoria } = srv.entities
        let hoje = new Date()
        let timestamp =
            ('0000' + JSON.stringify(hoje.getFullYear())).slice(-4)
            + '-' + ('00' + JSON.stringify(hoje.getMonth() + 1)).slice(-2)
            + '-' + ('00' + JSON.stringify(hoje.getDate())).slice(-2)
            + 'T' + ('00' + JSON.stringify(hoje.getHours())).slice(-2)
            + ':' + ('00' + JSON.stringify(hoje.getMinutes())).slice(-2)
            + ':' + ('00' + JSON.stringify(hoje.getSeconds())).slice(-2)

        req.data.agrupadores.forEach((a) => {
            a.usuario = req.user.id
            a.dataHora = timestamp
        })
        await srv.run(INSERT.into(Agrupadores_Transitoria).entries(req.data.agrupadores))
        return req.data
    })

    motor.on('CREATE', 'importRegioes', async (req) => {
        const srv = await cds.connect.to('db');
        const { Regioes_Transitoria, Municipios_Transitoria } = srv.entities
        await srv.run(INSERT.into(Regioes_Transitoria).entries(req.data.regioes))
        return req.data
    })

    motor.on('upsert_acessoTerminal', async () => {
        try {
            const srv = await cds.connect.to('db');
            await srv.run('CALL UPSERT_ACESSOTERMINAL()')
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

    motor.on('upsert_agrupadores', async () => {
        try {
            const srv = await cds.connect.to('db');
            await srv.run('CALL UPSERT_AGRUPADORES()')
            await srv.run('CALL UPDATE_TOTALITEMS()')
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

    motor.on('READ', 'killAgrupadores', async (req) => {
        const srv = await cds.connect.to('db');
        const { Agrupadores } = srv.entities
        let resp
        try {
            await srv.run(DELETE.from(Agrupadores))
            resp = { 'kill': true }
        }
        catch (err) {
            resp = { 'kill': false }
            req.reject(400, 'Erro ao deletar tabela')
        }
        return resp
    })

    motor.on('upsert_regioes', async () => {
        try {            
            const srv = await cds.connect.to('db');
            await srv.run('CALL UPSERT_REGIOES()')
            await srv.run('CALL UPDATE_TOTALITEMS()')
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

    motor.on('replicate_baixa', async () => {
        try {
            const srv = await cds.connect.to('db');
            await srv.run('CALL REPLICATE_BAIXA()')
            return true
        } catch (error) {
            console.error(error)
            return false
        }
    })

    motor.before('CREATE', 'Regioes', async (req) => {
        const srv = await cds.connect.to('db');
        const { Regioes } = srv.entities
        let reg = []
        reg = await srv.run(SELECT.from(Regioes).where({ municipio_municipio: req.data.municipio_municipio }))
        if (reg.length > 0) {
            req.reject(400, 'regiao already exists')
        }
    })
}