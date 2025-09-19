GAME_VERSION = "0.0.0"

function Game:setGlobals()

    -- Current room
    self.CURRENT_ROOM = nil
    
    -- Total distinct in game movements
    self.MOVES = 0

    -- Game Timers
    self.TIME = {
        TOTAL = 0,
        INGAME = 0
    }

    -- Game state flags
    self.FLAGS = {}

    -- Enum Directions
    self.DIRECTIONS = {
        NORTH = 0,
        EAST = 1,
        SOUTH = 2,
        WEST = 3
    }
    
    self.MAJORSTATE = nil
    self.MINORSTATE = nil

    self.MAJORSTATES = {
        STARTMENU = 1,
        MAINGAME = 2
    }

    self.MINORSTATE = {
        DEFAULT = 1,
        TALKING = 2
    }
    self.IMG_DATA = {
        PLANES = {},
        ITEMS = {},
        CHARACTERS = {},
        UI = {}
    }
    self.INSTANCES = {
        CHARACTERS = {},
        ITEMS = {}
    }
end