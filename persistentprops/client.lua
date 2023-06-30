local isPropsFunctionalityEnabled = false -- Default value is set to "DISABLED"

function LoadPropsFunctionalityPreference()
    local kvpValue = GetResourceKvpString("propsFunctionalityEnabled")
    isPropsFunctionalityEnabled = kvpValue == "1"
    SetPedCanLosePropsOnDamage(PlayerPedId(), not isPropsFunctionalityEnabled)
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        args = {'[Props]', 'Loaded your preference : persistent props functionality is set to ^1' .. (isPropsFunctionalityEnabled and "^2 ^* TRUE" or "^1 ^* FALSE")}
    })
end

AddEventHandler("playerSpawned", function()
    LoadPropsFunctionalityPreference()
end)

Citizen.CreateThread(function()
  TriggerEvent("chat:addSuggestion", "/propson", "Enable persistent glasses and hats")
  TriggerEvent("chat:addSuggestion", "/propsoff", "Disables persistent glasses and hats")
end)

TriggerEvent('chat:addMessage', {
  color = { 0, 255, 0 },
  multiline = true,
  args = { 'Persistent Props by Tay McKenzieNZ loaded successfully.' }
})

RegisterCommand("propson", function(source, args, rawCommand)
    if isPropsFunctionalityEnabled then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0}, -- Red
            args = {'[Props]', 'Persistent props functionality is already ^2enabled.'}
        })
        return
    end
    isPropsFunctionalityEnabled = true
    SetPedCanLosePropsOnDamage(PlayerPedId(), false)
    SetResourceKvp("propsFunctionalityEnabled", "1")
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0}, -- Green
        args = {'[Props]', 'Persistent Glasses And Hats: ^2ENABLED'}
    })
end)

RegisterCommand("propsoff", function(source, args, rawCommand)
    if not isPropsFunctionalityEnabled then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0}, -- Red
            args = {'[Props]', 'Persistent props functionality is already ^1disabled.'}
        })
        return
    end
    isPropsFunctionalityEnabled = false
    SetPedCanLosePropsOnDamage(PlayerPedId(), true)
    SetResourceKvp("propsFunctionalityEnabled", "0")
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0}, -- Red
        args = {'[Props]', 'Persistent Glasses And Hats: ^1DISABLED'}
    })
end)

local lastped = nil

CreateThread(function()
    while true do
        if PlayerPedId() ~= lastped then
            lastped = PlayerPedId()
            SetPedCanLosePropsOnDamage(lastped, not isPropsFunctionalityEnabled)
        end
        Wait(500)
    end
end)
