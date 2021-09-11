if Config.UseOldEsx then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end


apx_noclip = false

RegisterKeyMapping('MenuPersonal', 'Abre el menu personal.', 'keyboard', 'F10')

RegisterCommand('MenuPersonal', function()
    PersonalMenu(source)
end)

PersonalMenu = function()
    local elements = {}
    local id = GetPlayerServerId(PlayerId()) 

    ESX.TriggerServerCallback('apx-pmenu:havePermissions', function(cb)
        if cb then
            table.insert(elements, {label = 'Información', value = 'info'})
            table.insert(elements, {label = 'Documentación', value = 'documentacion'})
            table.insert(elements, {label = 'Otros', value = 'otros'})
            if IsPedInAnyVehicle(PlayerPedId()) then 
            table.insert(elements, {label = 'Acciones de vehículo', value = 'veh'})
            end
            table.insert(elements, {label = 'Administracion', value = 'admin'})
        else
            table.insert(elements, {label = 'Información', value = 'info'})
            table.insert(elements, {label = 'Documentación', value = 'documentacion'})
            table.insert(elements, {label = 'Otros', value = 'otros'})
            if IsPedInAnyVehicle(PlayerPedId()) then 
                table.insert(elements, {label = 'Acciones de vehículo', value = 'veh'})
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'apx_pmenu', {
            title = 'Menu Personal - [ <span style = color:lime; span>'..id..'</span> ]', 
            align = Config.Align,
            elements = elements

        }, function(data, menu)
            local val = data.current.value
            if val == 'info' then
                InfoMenu()
            elseif val == 'admin' then
                AdministracionMenu()
            elseif val == 'documentacion' then
                DocumentacionMenu()
            elseif val == 'otros' then
                OtrosMenu()
            elseif val == 'veh' then
                VehMenu()
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

InfoMenu = function()
    ESX.TriggerServerCallback('apx-pmenu:getInformation', function(info)
        local name = GetPlayerName(PlayerId())
        local Data = ESX.GetPlayerData()
        local job = Data.job.label
        local jobgrade = Data.job.grade_label
        local money = info.money
        local bank = info.bankmoney
        local blackmoney = info.blackmoney
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'info', {
            title = 'Informacion de <span style = color:lime; span>'..name..'</span>',
            align = Config.Align,
            elements = {
                {label = 'Trabajo: <span style = color:yellow; span>'..job.. ' - ' ..jobgrade..'</span>', value = nil},
                {label = 'Dinero: <span style = color:lime; span>'..money..'$</span>', value = nil},
                {label = 'Banco: <span style = color:lime; span>'..bank..'$</span>', value = nil},
                {label = 'Dinero negro: <span style = color:lime; span>'..blackmoney..'$</span>', value = nil},
                {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
            }}, function(data, menu)
                local data = data.current.value 
                if data == 'cerrar' then
                    menu.close()
                end
            end, function(data, menu)
                menu.close()
        end)
    end)
end

DocumentacionMenu = function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_personal_documents', {
        title = 'Documentación', 
        align = Config.Align,
        elements = {
            {label = 'Ver DNI', value = 'checkID'},
            {label = 'Enseñar DNI', value = 'showID'},
            {label = 'Ver Licencia de Conducir', value = 'checkDriver'},
            {label = 'Enseñar Licencia de Conducir', value = 'showDriver'},
            {label = 'Ver Licencia de Armas', value = 'checkFirearms'},
            {label = 'Enseñar Licencia de Armas', value = 'showFirearms'},
            {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
        }
    
    }, function(data, menu)
        local docum = data.current.value
        if docum == 'checkID' then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId())) 
        elseif docum == 'showID' then
            local player, distance = ESX.Game.GetClosestPlayer()
  
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
            else
                ESX.ShowNotification('No hay nadie cerca')
            end
  
        elseif docum == 'checkDriver' then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        elseif docum == 'showDriver' then
            local player, distance = ESX.Game.GetClosestPlayer()
  
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
            else
                ESX.ShowNotification('No hay nadie cerca')
            end
        elseif docum == 'checkFirearms' then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
        elseif docum == 'showFirearms' then
            local player, distance = ESX.Game.GetClosestPlayer()
        elseif docum == 'cerrar' then
            ESX.UI.Menu.CloseAll()
  
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
            else
                ESX.ShowNotification('No hay nadie cerca')
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

OtrosMenu = function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'otros', {
        title = 'Opciones variadas',
        align = Config.Align,
        elements = {
            {label = 'Activar/Desactivar graficos', value = 'graf'},
            {label = 'Resetear voz', value = 'voz'},
            {label = 'Resetear pj', value = 'pj'}, 
            {label = 'Gps Rápido', value = 'gps'},
            {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'graf' then
                if not graf then
                    graf = true
                    SetTimecycleModifier('MP_Powerplay_blend')
                    SetExtraTimecycleModifier('reflection_correct_ambient')
                    ESX.ShowNotification('~g~Graficos activados')
                else
                    graf = false
                    ClearTimecycleModifier()
                    ClearExtraTimecycleModifier()
                    ESX.ShowNotification('~r~Graficos desactivados')
                end
            elseif action == 'voz' then
                ExecuteCommand('rvoz')
            elseif action == 'pj' then
                ExecuteCommand('fixpj')
            elseif action == 'gps' then
                GPS()
            elseif action == 'cerrar' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end

VehMenu = function()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'veh', {
            title = 'Acciones de vehiculo', 
            align = Config.Align,
            elements = {
                {label = 'Encender/Apagar motor', value = 'motor'},
                {label = 'Abrir/Cerrar ventanas', value = 'ventanas'},
                {label = 'Abrir/Cerrar puertas', value = 'puertas'},
                {label = 'Asientos', value = 'asientos'}, 
                {label = '<span = style = color:red; span>Cerrar</span>', value = 'cerrar'}
            }}, function(data, menu)
            local val = data.current.value 
            if val == 'motor' then
                if motor then
                    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(),false), false, false, false)
                    motor = false
                elseif not motor then
                    motor = true
                    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(),false), true, false, false)
                end
                while (motor == false) do
                    SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId(),false),true)
                    Citizen.Wait(0)
                end
            elseif val == 'ventanas' then
                Ventanas()
            elseif val == 'puertas' then
                Puertas()
            elseif val == 'asientos' then
                CambiarAsiento()
            elseif val == 'cerrar' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end

AdministracionMenu = function()
    local godmode = true
    local invisible = true

    local elements = {
        {label = 'Noclip', value = 'noclip'},
        {label = 'GodMode', value = 'godmode'},
        {label = 'Invisible', value = 'invisible'},
        {label = 'Abrir vehículo', value = 'abrirveh'},
        {label = 'Cerrar vehículo', value = 'cerrarveh'},
        {label = 'Reparar vehiculo', value = 'fix'},
        {label = 'Poner Ped', value = 'ped'},
        {label = 'Mostrar cordenadas', value = 'coordss'},
        {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'apx_admin', {
        title = 'Menu de administración', 
        align = Config.Align,
        elements = elements
    }, function(data, menu)
        local adm = data.current.value
            if adm  == 'noclip' then
                TriggerEvent('apx_noclip')
            elseif adm  == 'godmode' then
                if godmode then
                    SetEntityInvincible(PlayerPedId(), true)
                    ESX.ShowNotification('Has activado el ~g~Godmode.')
                    godmode = false
                else
                    SetEntityInvincible(PlayerPedId(), false)
                    ESX.ShowNotification('Has desactivado el ~r~Godmode.')
                    godmode = true
                end
            elseif adm == 'invisible' then
                if invisible then
                    SetEntityVisible(PlayerPedId(), false)
                    ESX.ShowNotification('Has activado el ~g~Invisible.')
                    invisible = false
                else
                    SetEntityVisible(PlayerPedId(), true)
                    ESX.ShowNotification('Has desactivado el ~r~Invisible.')
                    invisible = true
                end
            elseif adm == 'abrirveh' then
                local coords = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 8.0, 0, 71)
                if coords < 1 then
                    ESX.ShowNotification('No estas cerca de un vehiculo.')
                else
                    SetVehicleDoorsLocked(coords, 1)
                    ESX.ShowNotification('Vehiculo ~g~desbloqueado.')
                end
            elseif adm == 'cerrarveh' then
                local coords = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 8.0, 0, 71)
                if coords < 1 then
                    ESX.ShowNotification('No estas cerca de un vehiculo.')
                else
                    SetVehicleDoorsLocked(coords, 2)
                    ESX.ShowNotification('Vehiculo ~r~bloqueado.')
                end
            elseif adm == 'fix' then
                TriggerEvent('apx_fix')
            elseif adm == 'ped' then
                ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), 'ped_menu', {
                    title = 'Menú de Peds',
                }, function(menuData, menuHandle)
                    local pedModel = menuData.value
                                
                    if not type(pedModel) == "number" then pedModel = 'pedModel' end
                    if IsModelInCdimage(pedModel) then
                        while not HasModelLoaded(pedModel) do
                            Citizen.Wait(15)
                            RequestModel(pedModel)
                        end
                        SetPlayerModel(PlayerId(), pedModel)
                        menuHandle.close()
                    else
                        ESX.ShowNotification('~r~Ped no encontrado')
                    end
                end, function(menuData, menuHandle)
                    menuHandle.close()
                end)
            elseif adm == 'coordss' then
                TriggerEvent('apx_coords')
            elseif adm == 'cerrar' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end

-- PLUS FUNCTION --

CreateThread(function()
    while true do 
        local apx = 1000
        if apx_noclip then
            apx = 0
            local x,y,z = Posicion()
            local dx,dy,dz = Direccion()
            local speed = 2.0

            SetEntityVelocity(PlayerPedId(), 0.05,  0.05,  0.05)

            if IsControlPressed(0, 32) then
                apx = 0
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end

            if IsControlPressed(0, 269) then
                apx = 0
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            SetEntityCoordsNoOffset(PlayerPedId(),x,y,z,true,true,true)
        end
        Citizen.Wait(apx)
    end
end)

-- EVENTS --

RegisterNetEvent('apx_noclip')
AddEventHandler('apx_noclip',function()
	apx_noclip = not apx_noclip

    if apx_noclip then
    	SetEntityInvincible(PlayerPedId(), true)
    	SetEntityVisible(PlayerPedId(), false, false)
    else
    	SetEntityInvincible(PlayerPedId(), false)
    	SetEntityVisible(PlayerPedId(), true, false)
    end

    if apx_noclip == true then 
        ESX.ShowNotification('Has activado el ~g~noclip.')
    else
        ESX.ShowNotification('Has desactivado el ~r~noclip.')
    end
end)

RegisterNetEvent('apx_fix')
AddEventHandler('apx_fix', function()
    if IsPedInAnyVehicle(PlayerPedId()) then 
        SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))
        SetVehicleDeformationFixed(GetVehiclePedIsIn(PlayerPedId()))
        SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId()), false)
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), true, true)
        ESX.ShowNotification('~g~Coche reparado')
    else
        ESX.ShowNotification('~r~Debes de estar dentro de un vehículo')
    end
end)

RegisterNetEvent('apx_coords')
AddEventHandler('apx_coords', function()
    coordsVisible = not coordsVisible
	  while true do
		local apx = 250
		
		if coordsVisible then
			apx = 5

			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
			local playerH = GetEntityHeading(PlayerPedId())

			TxT(("~r~X~w~: %s ~r~Y~w~: %s ~r~Z~w~: %s ~r~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		Citizen.Wait(apx)
	end
end)

-- COMMANDS --

RegisterCommand('rvoz', function()
    NetworkClearVoiceChannel()
    NetworkSessionVoiceLeave()
    Wait(50)
    NetworkSetVoiceActive(false)
    MumbleClearVoiceTarget(2)
    Wait(1000)
    MumbleSetVoiceTarget(2)
    NetworkSetVoiceActive(true)
    ESX.ShowNotification('~g~Chat de voz reiniciado.')
  end)

RegisterCommand('fixpj', function()
    local hp = GetEntityHealth(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                TriggerEvent('dpc:ApplyClothing')
                SetEntityHealth(PlayerPedId(), hp)
            end)
        end)
    end)
end, false)

-- FUNCTIONS --

TxT = function(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(6)
	SetTextScale(0.4, 0.4)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.85, 0.020)
end

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

Posicion = function()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
  	return x,y,z
end

Direccion = function()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
  
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
  
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
	  x = x/len
	  y = y/len
	  z = z/len
	end
  
	return x,y,z
end

GPS = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gps',{
        title = 'GPS Rápido',
		    align = Config.Align,
		    elements = {
			  {label = 'Garage Cental', value = 'garaje'},
			  {label = 'Comisaria', value = 'comisaria'}, 
			  {label = 'Hospital', value = 'hospital'}, 
			  {label = 'Concesionario', value = 'conce'},
			  {label = 'Mecánico', value = 'mecanico'},
			  {label = 'Badulake Central', value = 'badu'},	
		 }
  },
	function(data, menu)
		local fastgps = data.current.value
		
		if fastgps == 'garaje' then
			SetNewWaypoint(215.12, -815.74)
		elseif fastgps == 'comisaria' then 
			SetNewWaypoint(411.28, -978.73)
		elseif fastgps == 'hospital' then 
			SetNewWaypoint(291.37, -581.63)
        elseif fastgps == 'conce' then
			SetNewWaypoint(-33.78, -1102.12)
		elseif fastgps == 'mecanico' then
			SetNewWaypoint(-359.59, -133.44)
		elseif fastgps == 'badu' then
			SetNewWaypoint(-708.01, -913.8)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

CambiarAsiento = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'asientos', {
		title = 'Selección de asientos',
		align = Config.Align,
		elements = {
            {label = 'Asiento 1', value = 'asiento1'},
            {label = 'Asiento 2', value = 'asiento2'},
            {label = 'Asiento 3', value = 'asiento3'},
            {label = 'Asiento 4', value = 'asiento4'},   
        }}, function(data, menu)
        local asientos = data.current.value 
		if asientos == 'asiento1' then 
			SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), -1)
            menu.close()
		elseif asientos == 'asiento2' then
			SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 0)
            menu.close()
		elseif asientos == 'asiento3' then 
			SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 1)
            menu.close()
		elseif asientos == 'asiento4' then 
			SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 2)
            menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

Ventanas = function()
    local izquierdafrontal = true
    local derechafrontal = true
    local izquierdaatras = true
    local derechaatras = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'apx_ventanas', {
			title    = 'Ventanas',
			align    = Config.Align,
			elements = {
                {label = 'Ventanilla delantera izquierda', value = 'izquierdafrontal'},
                {label = 'Ventanilla delantera derecha', value = 'derechafrontal'},
                {label = 'Ventanilla trasera izquierda', value = 'izquierdaatras'},
                {label = 'Ventanilla trasera derecha', value = 'derechaatras'},
                {label = 'Bajar todas las ventanillas', value = 'bajartodas'},
                {label = 'Subir todas las ventanillas', value = 'subirtodas'}
            }}, function(data, menu)
                local vent = data.current.value 
			if vent == 'izquierdafrontal' then
				if not izquierdafrontal then
					izquierdafrontal = true
					RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 0, false)
				elseif izquierdafrontal then
					izquierdafrontal = false
					RollDownWindow(GetVehiclePedIsIn(PlayerPedId(),false), 0, false)
				end
			elseif vent == 'derechafrontal' then
				if not derechafrontal then
					derechafrontal = true
					RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 1, false)
				elseif derechafrontal then
					derechafrontal = false
					RollDownWindow(GetVehiclePedIsIn(PlayerPedId(),false), 1, false)
				end
			elseif vent == 'izquierdaatras' then
				if not izquierdaatras then
					izquierdaatras = true
					RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 2, false)
				elseif izquierdaatras then
					izquierdaatras = false
					RollDownWindow(GetVehiclePedIsIn(PlayerPedId(),false), 2, false)
				end
			elseif vent == 'derechaatras' then
				if not derechaatras then
					derechaatras = true
					RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 3, false)
				elseif derechaatras then
					derechaatras = false
					RollDownWindow(GetVehiclePedIsIn(PlayerPedId(),false), 3, false)
				end
			elseif vent == 'bajartodas' then
				izquierdafrontal = true
				derechafrontal = true
				izquierdaatras = true
				derechaatras = true
				RollDownWindows(GetVehiclePedIsIn(PlayerPedId(), false))
			elseif vent == 'subirtodas' then
				izquierdafrontal = false
				derechafrontal = false
				izquierdaatras = false
				derechaatras = false
				RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 0, false)
				RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 1, false)
				RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 2, false)
				RollUpWindow(GetVehiclePedIsIn(PlayerPedId(),false), 3, false)
			end
		end, function(data, menu)
            menu.close()
	end)
end

local izquierdafrontal = false
local derechafrontal = false
local izquierdaatras = false
local backrightdoors = false
Puertas = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_controls_doors', {
			title    = 'Puertas',
			align    = Config.Align,
			elements = {
                {label = 'Puerta delantera izquierda', value = 'izquierdafrontal'},
                {label = 'Puerta delantera derecha', value = 'derechafrontal'},
                {label = 'Puerta trasera izquierda', value = 'izquierdaatras'},
                {label = 'Puerta trasera derecha', value = 'derechaatras'},
                {label = 'Abrir todas las puertas', value = 'abrirtodas'},
                {label = 'Cerrar todas las puertas', value = 'cerrartodas'}
            }}, function(data, menu)
                local puert = data.current.value
			if puert == 'izquierdafrontal' then
				if not izquierdafrontal then
					izquierdafrontal = true
					SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 0, false)
				elseif izquierdafrontal then
					izquierdafrontal = false
					SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId(),false), 0, false)
				end
			elseif puert == 'derechafrontal' then
				if not derechafrontal then
					derechafrontal = true
					SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 1, false)
				elseif derechafrontal then
					derechafrontal = false
					SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId(),false), 1, false)
				end
			elseif puert == 'izquierdaatras' then
				if not izquierdaatras then
					izquierdaatras = true
					SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 2, false)
				elseif izquierdaatras then
					izquierdaatras = false
					SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId(),false), 2, false)
				end
			elseif puert== 'derechaatras' then
				if not derechaatras then
					derechaatras = true
					SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 3, false)
				elseif derechaatras then
					derechaatras = false
					SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId(),false), 3, false)
				end
			elseif puert == 'abrirtodas' then
				izquierdafrontal = true
				derechafrontal = true
				izquierdaatras = true
				derechaatras = true
				SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 0, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 1, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 2, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 3, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 4, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(),false), 5, false)
			elseif puert == 'cerrartodas' then
				izquierdafrontal = false
				derechafrontal = false
				izquierdaatras = false
				derechaatras = false
				SetVehicleDoorsShut(GetVehiclePedIsIn(PlayerPedId(),false))															
			end
		end, function(data, menu)
            menu.close()
	end)
end
