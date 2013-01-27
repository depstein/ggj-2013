require "Utility"
require "AssetManager"
require "SceneManager"
require "MouseManager"
require "KeyboardManager"
require "PhysicsData"
require "GameObject"
require "PhysicsGameObject"
require "Character"
require "Player"
require "Rope"
require "Communication"
require "BlobAsset"
require "EnemyManager"
require "GameManager"

Game = GameManager:new()

Game:init():start()
