DeriveGamemode("sandbox") -- Use sanbox as our default

GM.Name    = "SledBuild Remastered 1.0"
GM.Author  = "jotalanusse"
GM.Email   = "jotalanusse@gmail.com"
GM.Website = "jotalanusse.github.io"

-- Global shared variables
COLORS = {
  MAIN = Color(150, 0, 255)
}

CONSOLE = {
  PREFIX = "[SBR] ",
  COLORS = {
    PREFIX = COLORS.MAIN,
    WARNING = Color(230, 225, 0),
    ERROR = Color(230, 0, 0),
    TEXT = Color(200, 200, 200), -- TODO: Find the best color
    RACE_ROUND = Color(0, 230, 0) -- TODO: Maybe change color?
  }
}

ROUND = {
  TIMES = {
    START = 5,
    RACE = 8,
    WAIT = 5,
  },

  STAGES = {
    WAITING = 1,
    STARTING = 2,
    RACING = 3,
  }
}

TEAMS = {
  BUILDING = 1,
  RACING = 2,
  SPECTATING = 3,
}

-- Create the new teams
local function SetTeams()
  team.SetUp(TEAMS.BUILDING, "Building", Color(80, 255, 80, 255)) -- TODO: Find a real color
  team.SetUp(TEAMS.RACING, "Racing", Color(160, 80, 255, 255)) -- TODO: Find a real color
end

-- Initialize
function GM:Initialize()
  print(CONSOLE.PREFIX .. "SledBuild Remastered initialized!") -- TODO: Remove

  SetTeams()
end
