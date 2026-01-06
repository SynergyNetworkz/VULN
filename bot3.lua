local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ✅ EXACT ORIGINAL FULL SYSTEM (Ride/Fly/Equip/Pick/Drop Working)
task.spawn(function()
    local load = require(ReplicatedStorage:WaitForChild("Fsys")).load
    
    set_thread_identity(2)
    local clientData = load("ClientData")
    local items = load("KindDB")
    local router = load("RouterClient")
    local downloader = load("DownloadClient")
    local animationManager = load("AnimationManager")
    local petRigs = load("new:PetRigs")
    set_thread_identity(8)
    
    local petModels = {}
    local pets = {}
    local equippedPet = nil
    local mountedPet = nil
    local currentMountTrack = nil

    local function updateData(key, action)
        local data = clientData.get(key)
        local clonedData = table.clone(data)
        clientData.predict(key, action(clonedData))
    end

    local function getUniqueId()
        return HttpService:GenerateGUID(false)
    end

    local function getPetModel(kind)
        if petModels[kind] then return petModels[kind] end
        local streamed = downloader.promise_download_copy("Pets", kind):expect()
        petModels[kind] = streamed
        return streamed
    end

    -- ✅ EXACT ORIGINAL createPet
    function _G.RayzHub_createPet(id, properties)
        local uniqueId = getUniqueId()
        local pet = nil
        
        set_thread_identity(2)
        updateData("inventory", function(inventory)
            local newPets = table.clone(inventory.pets)
            local item = items[id]
            pet = {
                unique = uniqueId,
                category = "pets",
                id = id,
                kind = item.kind,
                newness_order = 0,
                properties = properties
            }
            newPets[uniqueId] = pet
            inventory.pets = newPets
            return inventory
        end)
        
        set_thread_identity(8)
        pets[uniqueId] = {data = pet, model = nil}
        return pet
    end

    local function neonify(model, entry)
        local petModel = model:FindFirstChild("PetModel")
        if not petModel then return end
        for neonPart, configuration in pairs(entry.neon_parts) do
            local trueNeonPart = petRigs.get(petModel).get_geo_part(petModel, neonPart)
            trueNeonPart.Material = configuration.Material
            trueNeonPart.Color = configuration.Color
        end
    end

    local function addPetWrapper(wrapper)
        updateData("pet_char_wrappers", function(petWrappers)
            wrapper.unique = #petWrappers + 1
            wrapper.index = #petWrappers + 1
            petWrappers[#petWrappers + 1] = wrapper
            return petWrappers
        end)
    end

    local function addPetState(state)
        updateData("pet_state_managers", function(petStates)
            petStates[#petStates + 1] = state
            return petStates
        end)
    end

    local function findIndex(array, finder)
        for index, value in pairs(array) do
            if finder(value, index) then return index end
        end
        return nil
    end

    local function removePetWrapper(uniqueId)
        updateData("pet_char_wrappers", function(petWrappers)
            local index = findIndex(petWrappers, function(wrapper)
                return wrapper.pet_unique == uniqueId
            end)
            if not index then return petWrappers end
            table.remove(petWrappers, index)
            for wrapperIndex, wrapper in pairs(petWrappers) do
                wrapper.unique = wrapperIndex
                wrapper.index = wrapperIndex
            end
            return petWrappers
        end)
    end

    local function removePetState(uniqueId)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        updateData("pet_state_managers", function(petStates)
            local index = findIndex(petStates, function(state)
                return state.char == pet.model
            end)
            if not index then return petStates end
            table.remove(petStates, index)
            return petStates
        end)
    end

    local function clearPetState(uniqueId)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        updateData("pet_state_managers", function(states)
            local index = findIndex(states, function(state)
                return state.char == pet.model
            end)
            if not index then return states end
            local clonedStates = table.clone(states)
            clonedStates[index] = table.clone(clonedStates[index])
            clonedStates[index].states = {}
            return clonedStates
        end)
    end

    local function setPetState(uniqueId, id)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        updateData("pet_state_managers", function(states)
            local index = findIndex(states, function(state)
                return state.char == pet.model
            end)
            if not index then return states end
            local clonedStates = table.clone(states)
            clonedStates[index] = table.clone(clonedStates[index])
            clonedStates[index].states = {{id = id}}
            return clonedStates
        end)
    end

    local function attachPlayerToPet(pet)
        local character = player.Character
        if not character or not character.PrimaryPart then return false end
        local ridePosition = pet:FindFirstChild("RidePosition", true)
        if not ridePosition then return false end

        local sourceAttachment = Instance.new("Attachment")
        sourceAttachment.Parent = ridePosition
        sourceAttachment.Position = Vector3.new(0, 1.237, 0)
        sourceAttachment.Name = "SourceAttachment"

        local stateConnection = Instance.new("RigidConstraint")
        stateConnection.Name = "StateConnection"
        stateConnection.Attachment0 = sourceAttachment
        stateConnection.Attachment1 = character.PrimaryPart.RootAttachment
        stateConnection.Parent = character
        return true
    end

    local function clearPlayerState()
        updateData("state_manager", function(state)
            local clonedState = table.clone(state)
            clonedState.states = {}
            clonedState.is_sitting = false
            return clonedState
        end)
    end

    local function setPlayerState(id)
        updateData("state_manager", function(state)
            local clonedState = table.clone(state)
            clonedState.states = {{id = id}}
            clonedState.is_sitting = true
            return clonedState
        end)
    end

    local function unmount(uniqueId)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        if currentMountTrack then
            currentMountTrack:Stop()
            currentMountTrack:Destroy()
        end
        local sourceAttachment = pet.model:FindFirstChild("SourceAttachment", true)
        if sourceAttachment then sourceAttachment:Destroy() end
        if player.Character then
            for _, d in pairs(player.Character:GetDescendants()) do
                if d:IsA("BasePart") and d:GetAttribute("HaveMass") then
                    d.Massless = false
                end
            end
        end
        clearPetState(uniqueId)
        clearPlayerState()
        pet.model:ScaleTo(1)
        mountedPet = nil
    end

    local function mount(uniqueId, playerState, petState)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        local playerChar = player.Character
        if not playerChar or not playerChar.PrimaryPart then return end
        mountedPet = uniqueId
        setPetState(uniqueId, petState)
        setPlayerState(playerState)
        pet.model:ScaleTo(2)
        attachPlayerToPet(pet.model)
        currentMountTrack = playerChar.Humanoid.Animator:LoadAnimation(animationManager.get_track("PlayerRidingPet"))
        playerChar.Humanoid.Sit = true
        for _, d in pairs(playerChar:GetDescendants()) do
            if d:IsA("BasePart") and d.Massless == false then
                d.Massless = true
                d:SetAttribute("HaveMass", true)
            end
        end
        currentMountTrack:Play()
    end

    local function fly(uniqueId)
        mount(uniqueId, "PlayerFlyingPet", "PetBeingFlown")
    end
    local function ride(uniqueId)
        mount(uniqueId, "PlayerRidingPet", "PetBeingRidden")
    end

    local function unequip(item)
        local pet = pets[item.unique]
        if not pet or not pet.model then return end
        unmount(item.unique)
        removePetWrapper(item.unique)
        removePetState(item.unique)
        pet.model:Destroy()
        pet.model = nil
        equippedPet = nil
    end

    local function equip(item)
        if equippedPet then unequip(equippedPet) end
        local petModel = getPetModel(item.kind):Clone()
        petModel.Parent = workspace
        pets[item.unique].model = petModel
        if item.properties.neon or item.properties.mega_neon then
            neonify(petModel, items[item.kind])
        end
        equippedPet = item
        addPetWrapper({
            char = petModel,
            mega_neon = item.properties.mega_neon,
            neon = item.properties.neon,
            player = player,
            entity_controller = player,
            controller = player,
            rp_name = item.properties.rp_name or "",
            pet_trick_level = item.properties.pet_trick_level,
            pet_unique = item.unique,
            pet_id = item.id,
            location = {full_destination_id = "housing", destination_id = "housing", house_owner = player},
            pet_progression = {friendship_level = item.properties.friendship_level, age = item.properties.age, percentage = 0},
            are_colors_sealed = false,
            is_pet = true
        })
        addPetState({
            char = petModel,
            player = player,
            store_key = "pet_state_managers",
            is_sitting = false,
            chars_connected_to_me = {},
            states = {}
        })
    end

    -- ✅ FULL REMOTE MOCKING (Equip/Unequip/Ride/Fly/Unmount/Pick/Drop)
    local oldGet = router.get
    local function createRemoteFunctionMock(callback)
        return {InvokeServer = function(_, ...) return callback(...) end}
    end
    local function createRemoteEventMock(callback)
        return {FireServer = function(_, ...) return callback(...) end}
    end

    local equipRemote = createRemoteFunctionMock(function(uniqueId, metadata)
        local pet = pets[uniqueId]
        if not pet then return end
        equip(pet.data)
        return true, {action = "equip", is_server = true}
    end)
    
    local unequipRemote = createRemoteFunctionMock(function(uniqueId)
        local pet = pets[uniqueId]
        if not pet then return end
        unequip(pet.data)
        return true, {action = "unequip", is_server = true}
    end)
    
    local rideRemote = createRemoteFunctionMock(function(item)
        ride(item.pet_unique)
    end)
    
    local flyRemote = createRemoteFunctionMock(function(item)
        fly(item.pet_unique)
    end)
    
    local unmountRemoteFunction = createRemoteFunctionMock(function()
        unmount(mountedPet)
    end)
    
    local unmountRemoteEvent = createRemoteEventMock(function()
        unmount(mountedPet)
    end)

    -- ✅ PICKUP/DROP PETS (Hold/Drop functionality)
    local pickupRemote = createRemoteFunctionMock(function(uniqueId)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        if equippedPet then unequip(equippedPet) end
        equippedPet = pet.data
        pet.model.Parent = player.Character
        pet.model:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0))
        return true, {action = "pickup", is_server = true}
    end)
    
    local dropRemote = createRemoteFunctionMock(function(uniqueId)
        local pet = pets[uniqueId]
        if not pet or not pet.model then return end
        pet.model.Parent = workspace
        pet.model:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0))
        return true, {action = "drop", is_server = true}
    end)

    router.get = function(name)
        if name == "ToolAPI/Equip" then return equipRemote end
        if name == "ToolAPI/Unequip" then return unequipRemote end
        if name == "AdoptAPI/RidePet" then return rideRemote end
        if name == "AdoptAPI/FlyPet" then return flyRemote end
        if name == "AdoptAPI/ExitSeatStatesYield" then return unmountRemoteFunction end
        if name == "AdoptAPI/ExitSeatStates" then return unmountRemoteEvent end
        if name == "PetAPI/PickupPet" then return pickupRemote end
        if name == "PetAPI/DropPet" then return dropRemote end
        return oldGet(name)
    end

    -- Clear existing pets
    for _, charWrapper in pairs(clientData.get("pet_char_wrappers") or {}) do
        pcall(function()
            oldGet("ToolAPI/Unequip"):InvokeServer(charWrapper.pet_unique)
        end)
    end

    -- EXPOSE FUNCTIONS FOR UI
    _G.RayzHub = {
        createPet = _G.RayzHub_createPet,
        GetPetByName = function(name)
            local Loads = require(ReplicatedStorage.Fsys).load
            local InventoryDB = Loads("InventoryDB")
            for i, v in pairs(InventoryDB.pets) do
                if v.name:lower() == name:lower() then
                    return v.id
                end
            end
            return false
        end
    }
end)

-- ✅ RAYFIELD UI (YouTube + Pets Only)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Synergy Networks | Adopt Me",
    LoadingTitle = "Loading Pet Spawner...",
    LoadingSubtitle = "by SN",
    ConfigurationSaving = {Enabled = true, FolderName = "RayzHubAdoptMe"},
    KeySystem = false
})

local petName = ""
local petType = "FR"

-- ❤️ Pets Tab
local PetsTab = Window:CreateTab("❤️ Pets", 4483362458)
PetsTab:CreateParagraph({
    Title = "🐾 Pet Spawner",
    Content = "Spawn → E(Equip) → RightClick(Ride/Fly)"
})

PetsTab:CreateInput({
    Name = "🔍 Pet Name",
    PlaceholderText = "Shadow Dragon, Unicorn, Griffin...",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        petName = input
        print("Pet name:", input)
    end,
})

PetsTab:CreateDropdown({
    Name = "✨ Type",
    Options = {"FR", "NFR", "MFR"},
    CurrentOption = {"FR"},
    Callback = function(Option)
        petType = Option[1]
        print("Pet type:", petType)
    end,
})

PetsTab:CreateButton({
    Name = "🚀 Spawn Pet",
    Callback = function()
        if not petName or petName == "" then
            Rayfield:Notify({Title = "❌ Error", Content = "Enter pet name!", Duration = 2})
            return
        end
        
        local petId = _G.RayzHub.GetPetByName(petName)
        if not petId then
            Rayfield:Notify({Title = "❌ Error", Content = "Pet Not Found!", Duration = 2})
            return
        end
        
        local properties = {
            pet_trick_level = 0,
            rideable = true,
            flyable = true,
            friendship_level = 0,
            age = 1,
            ailments_completed = 0,
            rp_name = ""
        }
        
        if petType == "NFR" then properties.neon = true
        elseif petType == "MFR" then properties.mega_neon = true end
        
        _G.RayzHub.createPet(petId, properties)
        Rayfield:Notify({
            Title = "✅ Spawning...",
            Content = petName .. " " .. petType .. "\n✅ E=Equip | RightClick=Ride/Fly ",
            Duration = 4
        })
    end,
})

PetsTab:CreateButton({
    Name = "🧹 Clear All Pets",
    Callback = function()
        local clientData = require(ReplicatedStorage.Fsys).load("ClientData")
        clientData.predict("inventory", function(inventory)
            inventory.pets = {}
            return inventory
        end)
        Rayfield:Notify({Title = "✅ Cleared!", Content = "All pets removed!", Duration = 2})
    end,
})

-- 🎉 Load Complete
Rayfield:Notify({
    Title = "Synergy Networks Loaded!",
    Content = "✅ FULL SYSTEM: Spawn/EQUIP/Ride/Fly/ Functional pets!",
    Duration = 7
})
