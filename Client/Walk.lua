local latestWalkStyle = nil
local crouched = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		playerPed = PlayerPedId()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if (DoesEntityExist(playerPed) and not IsEntityDead(playerPed)) then
			--DisableControlAction(0, 44, true) -- Disable cover
			DisableControlAction(0,36,true)--INPUT_DUCK
			if (not IsPauseMenuActive()) then
				if (IsDisabledControlJustPressed(0,36)) then
					RequestAnimSet("move_ped_crouched")
					while (not HasAnimSetLoaded("move_ped_crouched")) do
						Citizen.Wait(100)
					end
					if crouched then
						if latestWalkStyle then
							SetPedMovementClipset(playerPed,latestWalkStyle,0.2)
						else
							ResetPedMovementClipset(playerPed,0)
						end
						crouched = false
					else
						SetPedMovementClipset(playerPed,"move_ped_crouched",0.25)
						crouched = true
					end
				end
			end
		end
	end
end)

function WalkMenuStart(name)
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  latestWalkStyle = name
  RemoveAnimSet(name)
end

function RequestWalking(set)
  RequestAnimSet(set)
  while not HasAnimSetLoaded(set) do
    Citizen.Wait(1)
  end 
end

function WalksOnCommand(source, args, raw)
  local WalksCommand = ""
  for a in pairsByKeys(DP.Walks) do
    WalksCommand = WalksCommand .. ""..string.lower(a)..", "
  end
  EmoteChatMessage(WalksCommand)
  EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
  local name = firstToUpper(args[1])

  if name == "Reset" then
      ResetPedMovementClipset(PlayerPedId()) return
  end

  local name2 = table.unpack(DP.Walks[name])
  if name2 ~= nil then
    WalkMenuStart(name2)
  else
    EmoteChatMessage("'"..name.."' is not a valid walk")
  end
end