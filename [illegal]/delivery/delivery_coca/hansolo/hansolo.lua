local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
delivery_coca = Tunnel.getInterface("delivery_coca")


local servico = false
local selecionado = 0
local quantidade = 0
local porcentagem = 0
local criado = false
local selec = false

Citizen.CreateThread(function()
	while true do
		idle = 1000
		if not servico then			
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(config2.start[1],config2.start[2],config2.start[3])
			local distance = GetDistanceBetweenCoords(config2.start[1],config2.start[2],cdz,x,y,z,true)

			if distance <= 3 then
				idle = 5
				DrawMarker(23,config2.start[1],config2.start[2],config2.start[3]-0.97,0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA INICIAR A ENTREGA DE COCA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and delivery_coca.checkPermission() then						
						servico = true						
						porcentagem = math.random(100)					
						
						TriggerEvent("Notify","sucesso","Você entrou em serviço.")
						TriggerEvent("Notify","importante","Vá até o próximo local e entregue a droga</b>.")
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

Citizen.CreateThread(function()
	while true do
		idle = 1000
		if servico then
			local ped = PlayerPedId()
			if selec == false then
				selecionado = math.random(#config2.locs)
				selec = true
			end
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(config2.locs[selecionado].x,config2.locs[selecionado].y,config2.locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(config2.locs[selecionado].x,config2.locs[selecionado].y,cdz,x,y,z,true)			
			if criado == false then
				CriandoBlipCocaina(config2.locs,selecionado)
				criado = true
			end
			if distance <= 15 then
				idle = 5
				DrawMarker(23,config2.locs[selecionado].x,config2.locs[selecionado].y,config2.locs[selecionado].z-0.90,0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				if distance <= 1.5 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ENTREGAR A DROGA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						if delivery_coca.checkPayment() then
							
							porcentagem = math.random(1,100)

							if porcentagem >= config2.percentage[1] and porcentagem <= config2.percentage[2] then
								delivery_coca.MarcarOcorrencia()
							end
							RemoveBlip(blips)
							
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(#config2.locs)
								else
									break
								end
							end							
							CriandoBlipCocaina(config2.locs,selecionado)
							TriggerEvent("Notify","importante","Vá até o próximo local e entregue a <b>Droga</b>.")
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

Citizen.CreateThread(function()
	while true do
		idle = 1000
		if servico then
			idle = 5
			if IsControlJustPressed(1,168) then
				servico = false
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
				criado = false
				selec = false
			end
		end
		Citizen.Wait(idle)
	end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlipCocaina(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Cocaina")
	EndTextCommandSetBlipName(blips)
end
