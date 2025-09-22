GAME_VERSION = "0.0.0"

function Game:setGlobals()

    -- Current room
    self.CURRENT_ROOM = 1
    
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
        NORTH = 1,
        EAST = 2,
        SOUTH = 3,
        WEST = 4
    }

    self.CURRENT_DIRECTION = self.DIRECTIONS.NORTH
    
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