local customFont = Drawing.new("Font", "Smallest Pixel-7")
customFont.Data = game:HttpGet("https://cdn.discordapp.com/attachments/1154475864742965330/1222521408853119067/smallest_pixel-7.ttf?ex=661684c9&is=66040fc9&hm=d3b8475eee8d8271883b58d2a4bcc8f8b5675653d50b8ba44e98fce6b9f879fa&")

if getgenv().Text then
    getgenv().Text:Remove()
end

local Text = Drawing.new("Text")
Text.Text = "Hello this is a font test"
Text.Outline = true
Text.Font = customFont
Text.Size = 11
Text.Position = Vector2.new(150, 100)
Text.Visible = true
Text.Color = Color3.fromRGB(255, 255, 255)

getgenv().Text = Text