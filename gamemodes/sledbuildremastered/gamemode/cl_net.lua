NET = {

}

net.Receive("SendGamemodeMessage", function()
  local prefixColor = net.ReadColor()
  local message = net.ReadString()

  chat.AddText(prefixColor, CONSOLE.PREFIX, CONSOLE.COLORS.TEXT, message)
end)
