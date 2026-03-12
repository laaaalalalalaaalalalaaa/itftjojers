SMODS.Atlas {
  key = "ITFTEnhancements",
  path = "BFDIEnhancements.png",
  px = 71,
  py = 95
}

SMODS.Seal {
  key = "the",
  badge_colour = HEX("CE9D50"),
  atlas = "ITFTEnhancements",
  pos = { x = 0, y = 0 },
  config = { extra = { odds = 7, mult = 57 } },
  loc_vars = function(self, info_queue, center)
    local num, denom = SMODS.get_probability_vars(self, 1, self.config.extra.odds, "the")
    return { vars = { num, denom, self.config.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play and SMODS.pseudorandom_probability(self, "the", 1, self.config.extra.odds) then return { mult = self.config.extra.mult } end
  end
}