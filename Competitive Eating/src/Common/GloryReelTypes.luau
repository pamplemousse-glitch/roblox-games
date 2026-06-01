-- Type defs for the Glory Reel highlight system.
-- Events are recorded into a buffer during a contest; on Results phase the
-- buffer is flushed into a per-player in-memory gallery (no DataStore for v1).

local GloryReelTypes = {}

export type GloryEventKind =
	  "PerfectBite"
	| "GoodBite"
	| "Miss"
	| "ChipmunkSwat"
	| "PlaceFinish"

export type GloryEvent = {
	kind      : GloryEventKind,
	timestamp : number,    -- seconds since contest start
	biteIndex : number?,
	place     : number?,   -- only for PlaceFinish
	label     : string?,   -- optional custom callout text override
}

export type GloryReel = {
	id        : number,
	createdAt : number,    -- os.time()
	events    : { GloryEvent },
}

return GloryReelTypes
