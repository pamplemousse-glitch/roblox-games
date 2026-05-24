-- WeatherState: shared module for cave event state.
-- SporeLoop writes; SporeOrbManager and MoleFishing read.
-- All fields are nil/false when no event is active.

local WeatherState = {}

-- currentEvent: string name of the active cave event, nil when none active
WeatherState.currentEvent = nil

-- current: legacy compat table for SporeOrbManager's weatherMultiplierForTier check.
-- Always has affectsTiers={} in the new system so the old ipairs finds nothing (returns 1).
WeatherState.current = nil

-- surgeActive: true while Mycelium Surge is running.
-- SporeOrbManager reads this to double orb spawn density.
WeatherState.surgeActive = false

return WeatherState
