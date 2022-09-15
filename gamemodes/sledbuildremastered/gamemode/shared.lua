SHRD = {}

DeriveGamemode("sandbox") -- Use sanbox as our default

-- Set the gamemode information
GM.Name    = "SledBuild Remastered v1.0"
GM.Author  = "jotalanusse"
GM.Email   = "jotalanusse@gmail.com"
GM.Website = "jotalanusse.github.io"

-- Global shared variables
COLORS = {
  MAIN = Color(150, 0, 255) -- Main gamemode color
}

-- Console settings
CONSOLE = {
  PREFIX = "[SBR] ", -- Prefix for all console messages

  -- List of default colors to be used
  COLORS = {
    PREFIX = COLORS.MAIN, -- Prefix color
    WARNING = Color(230, 225, 0), -- Warning color
    ERROR = Color(230, 0, 0), -- Error color
    TEXT = Color(200, 200, 200), -- TODO: Find the best color
    RACE_ROUND = Color(0, 230, 0) -- TODO: Maybe change color?
  }
}

-- Round settings
ROUND = {
  -- Timings to be used by the gamemode
  TIMES = {
    START = 5, -- Round starting and gates are open
    RACE = 8, -- Actual race duration
    WAIT = 5, -- Time after the race finishes before the next race
  },

  -- Different stages a round can be in (same as above)
  STAGES = {
    WAITING = 1,
    STARTING = 2,
    RACING = 3,
  }
}

-- Team enumerations
TEAMS = {
  BUILDING = 1,
  RACING = 2,
  SPECTATING = 3,
}

-- Create the teams
function SHRD.SetTeams()
  team.SetUp(TEAMS.BUILDING, "Building", Color(80, 255, 80, 255)) -- TODO: Find a real color
  team.SetUp(TEAMS.RACING, "Racing", Color(160, 80, 255, 255)) -- TODO: Find a real color
end

-- Initialize
function GM:Initialize()
  SHRD.SetTeams()
end
