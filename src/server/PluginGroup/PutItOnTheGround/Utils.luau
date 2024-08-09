local module = {}

function module.TranslatePrimaryPartPositionByGroundY(model, groundY)
    local ModelCenter = model:GetBoundingBox().Position
    local ModelOrientation, ModelSize = model:GetBoundingBox()
    local ModelBottomExtremity = ModelCenter - Vector3.new(0, ModelSize.Y / 2, 0)

    local WorldPivot = model.WorldPivot -- / CFrame

    -- / Calculate the difference between the Y axis on the ModelBottomExtremity and the groundY
    local YDifference = groundY - ModelBottomExtremity.Y

    -- / Adjust the model's WorldPivot CFrame by the YDifference
    local NewCFrame = WorldPivot * CFrame.new(0, YDifference, 0)

    -- / Pivot the model to the new CFrame
    model:PivotTo(NewCFrame)
end

function module.GetGroundYPosition(model)
	-- / For the given model, this creates a raycast from the model's center position downward on the Y axis until it meets any object other than the model itself.

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {model}

    local ModelCenter = model:GetBoundingBox().Position
    local ModelOrientation, ModelSize = model:GetBoundingBox()

    local raycastResult = workspace:Raycast(
        ModelCenter,
        Vector3.new(0, -10000, 0),
        raycastParams
    )

    if raycastResult then
        return raycastResult.Position.Y
    else
        return ModelCenter.Y - ModelSize.Y / 2
    end
end

return module
