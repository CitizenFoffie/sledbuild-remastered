RND = {
  STATE = {
    totalRounds = 0,
    stage = ROUND_STAGES.WAITING,
    round = {
      startTime = 0,
      racers = {},
    }
  }
}

-- IsPlayerRacing: Returns true if the player is racing
function RND.IsPlayerRacing(ply)
  -- TODO: Should we compare this against "nil"?
  local racer = RND.STATE.round.racers[ply:SteamID()]
  if (racer and not racer.disqualified) then
    return true
  else
    return false
  end
end

-- AddPlayer: Adds a new player to the round
function RND.AddPlayer(ply, round)
  round.racers[ply:SteamID()] = {
    ply = ply,
    maxSpeed = 0,
    disqualified = false,
  }
end

-- DisqualifyPlayer: Disquialifies a player from the round
function RND.DisqualifyPlayer(ply, round)
  -- Check if player is even racing (on disconnection and death this will probably be called)
  if (RND.IsPlayerRacing(ply)) then
    round.racers[ply:SteamID()].disqualified = true
  end
end

-- TODO: Naming is sus
-- FinishPlayerRace: Updates a player when they finish the race
function RND.FinishPlayerRace(ply, round)
  local racer = RND.STATE.round.racers[ply:SteamID()]

  local index = table.maxn(round.racers) + 1
  round.racers[index] = {
    ply = ply,
    maxSpeed = racer.maxSpeed,
    time = CurTime() - round.startTime,
  }

  -- Once the racer finishes we can reset their state
  RND.STATE.round.racers[ply:SteamID()] = nil -- Remove the player from the racing list
end

-- ResetRacers: Bring racers back to the spawn on round end
function RND.ResetRacers(round)
  for k, v in pairs(round.racers) do
    local ply = v.ply

    -- Only iterate over non-disqualified racers (avoid deaths, and disconnections)
    if (RND.IsPlayerRacing(ply)) then
      if (not v.finished) then
        ply:PrintMessage(HUD_PRINTTALK, CONSOLE.PREFIX .. "You didn't finish the race, better luck next time.")

        if (ply:InVehicle()) then
          -- Teleport back to spawn
          local spawn = MAP.SelectRandomSpawn()
          VEHS.Teleport(ply:GetVehicle(), spawn:GetPos())
        else
          -- This code should be unreachable, players shouldn't be able to get off
          ply:PrintMessage(HUD_PRINTTALK, CONSOLE.PREFIX .. "How did you get off your sled? You shouldn't even be alive.")
          ply:Kill()
        end
      end
    end
  end
end

-- IncrementTotal: Add 1 to the total rounds
function RND.IncrementTotal()
  RND.STATE.totalRounds = RND.STATE.totalRounds + 1
end

-- Starting: Starts a new race
function RND.Starting(round)
  RND.STATE.stage = ROUND_STAGES.STARTING

  PLYS.ResetAllColors() -- Reset all player colors
  RND.IncrementTotal() -- Add one to the total races counter

  for k, v in pairs(player:GetAll()) do
    v:PrintMessage(HUD_PRINTTALK, CONSOLE.PREFIX .. "Race #" .. RND.STATE.totalRounds .. " just begun!")

    if (v:Team() == TEAMS.RACING) then
      if (v:InVehicle()) then
        v:PrintMessage(HUD_PRINTTALK, CONSOLE.PREFIX .. "Here we go!")
        RND.AddPlayer(v, round)
      else
        v:PrintMessage(HUD_PRINTTALK, CONSOLE.PREFIX .. "You can't be a racer and not be in a vehicle!")
        v:Kill()
      end
    elseif (v:Team() == TEAMS.BUILDING) then
      -- Look at them go!
    elseif (v:Team() == TEAMS.SPECTATING) then
      v:PrintMessage(HUD_PRINTTALK, CONSOLE.PREFIX .. "Make your bets!")
    end
  end

  -- Set round state
  round.startTime = CurTime()

  -- TODO: Track players and times (network)
  -- TODO: Notify of the new race (network)

  -- Let the map know we are starting
  MAP.GatesOpen()
  MAP.PushersEnable()

  timer.Create("SBR.RacingTimer", ROUNDS.START_TIME, 1, function() RND.Racing(round) end) -- We queue the next action
end

-- Racing: We are now officialy racing
function RND.Racing(round)
  RND.STATE.stage = ROUND_STAGES.RACING

  print("Round started!") --TODO: Remove, debug

  -- Starting time is over
  MAP.GatesClose()
  MAP.PushersDisable()

  timer.Create("SBR.EndTimer", ROUNDS.RACE_TIME, 1, function() RND.End(round) end) -- We queue the next action
end

-- End: End the current race
function RND.End(round)
  RND.STATE.stage = ROUND_STAGES.FINISHED
  print("Round ended!") --TODO: Remove, debug

  -- TODO: Add a total races count (player stats)
  RND.ResetRacers(round) -- Reset all racers and bring them back

  -- Reset the round information (don;t change the object reference)
  round.startTime = 0
  round.racers = {}

  timer.Create("SBR.StartTimer", ROUNDS.WAIT_TIME, 1, function() RND.Starting(round) end) -- We queue the next action
end
