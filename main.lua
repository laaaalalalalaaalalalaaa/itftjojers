SMODS.Atlas {
  key = "modicon",
  path = "ITFTIcon.png",
  px = 34,
  py = 34
}

to_big = to_big or function(x) return x end
to_number = to_number or function(x) return x end

function itft_count_consumables()
  if G.consumeables.get_total_count then
    return G.consumeables:get_total_count()
  else
    return #G.consumeables.cards + G.GAME.consumeable_buffer
  end
end

local allFolders = { "none", "items" }

local allFiles = { ["none"] = {}, ["items"] = { "Jokers", "Seals" } }

for i = 1, #allFolders do
  if allFolders[i] == "none" then
    for j = 1, #allFiles[allFolders[i]] do
      assert(SMODS.load_file(allFiles[allFolders[i]][j] .. ".lua"))()
    end
  else
    for j = 1, #allFiles[allFolders[i]] do
      assert(SMODS.load_file(allFolders[i] .. "/" .. allFiles[allFolders[i]][j] .. ".lua"))()
    end
  end
end

local ref = Card.start_dissolve
function Card:start_dissolve()
  if self.config.center.itft_shatters then
    return self:shatter()
  else
    return ref(self)
  end
end