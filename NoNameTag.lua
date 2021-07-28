for index, v in pairs(charc:GetDescendants()) do
	if v:IsA("BillboardGui") then
	v:Destroy()
	print("NameTag Removed")
	end
end
