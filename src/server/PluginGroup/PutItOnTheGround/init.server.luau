--[[
	Written by SteadyOn
	
	Honestly I forgot how to make plugins so I used this devforum post https://devforum.roblox.com/t/how-to-create-your-own-plugin/1711475 as a starting point, lol.
]]

local SelectionService = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Utils = require(script.Utils)

local toolbar = plugin:CreateToolbar("Put it on the ground!")
local pluginButton = toolbar:CreateButton(
	"Selected Object", --Text that will appear below button
	"Button to insert a script", --Text that will appear if you hover your mouse on button
	"rbxassetid://18876974387") --Button icon

ChangeHistoryService:SetEnabled(true)

pluginButton.Click:Connect(function()
	local SelectedObjects = SelectionService:Get()

	if ChangeHistoryService:IsRecordingInProgress() then
		warn ("[Put It On The Ground] Operation failed as another operation is in progress.")
	else
		local recording = ChangeHistoryService:TryBeginRecording("Aligning " .. #SelectedObjects .. " Objects To Ground")

		if recording ~= nil then 
			local operationSuccess, errorNote = pcall(function()
				for _, object in pairs (SelectedObjects) do
					if object:IsA("Model") then
						print("[Put It On The Ground] Getting ground position for model: ", object)
						local groundY = Utils.GetGroundYPosition(object)
						print ("[Put It On The Ground] Ground Y position for model: ", object, " is: ", groundY, ". Translating model to ground...")
						Utils.TranslatePrimaryPartPositionByGroundY(object, groundY)
					end
				end
			end)

			if operationSuccess then 
				print ("[Put It On The Ground] All objects have been aligned to the ground.")
				ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
			else
				warn ("[Put It On The Ground] An error occurred while aligning objects to the ground, all changes have been reverted. \n Error message: (", errorNote, ")")
				ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Cancel)
			end
		else
			warn ("[Put It On The Ground] An error occurred while starting the recording.", "(", recording, ")")
			ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Cancel)
		end
	end

	pluginButton:SetActive(false)
end)