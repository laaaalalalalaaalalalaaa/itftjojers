SMODS.Atlas {
  key = "ITFT",
  path = "BFDI.png",
  px = 71,
  py = 95
}

SMODS.Joker {
  key = "57ball",
  config = { extra = { is_contestant = true, chips = 57 } },
  rarity = 1,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 7) then
      return { chips = card.ability.extra.chips }
    end
  end
}

SMODS.Joker {
  key = "clock",
  rarity = 2,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 5,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 7) then
      return { repetitions = 1 }
    end
  end
}

SMODS.Joker {
  key = "wheel",
  config = { extra = { is_contestant = true, mult = 5 } },
  rarity = 2,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      return { mult = card.ability.extra.mult * (#G.jokers.cards - 1) }
    end
  end
}

SMODS.Joker {
  key = "feltcontainer",
  config = { extra = { is_contestant = true, consumable_slots = 1, mult = 4 } },
  rarity = 2,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.consumable_slots, card.ability.extra.mult } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  add_to_deck = function(self, card, from_debuff)
    G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumable_slots
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumable_slots
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return { mult = card.ability.extra.mult * itft_count_consumables() }
    end
  end
}

SMODS.Joker {
  key = "green",
  config = { extra = { is_contestant = true, added_mult = 3, current_mult = 0 } },
  rarity = 1,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.added_mult, card.ability.extra.current_mult } }
  end,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.current_mult > 0 then
      return { mult = card.ability.extra.current_mult }
    end

    if context.selling_card and not context.blueprint and context.card ~= card then
      card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.added_mult
      return { message = localize("k_upgrade_ex") }
    end
  end
}









SMODS.Joker {
  key = "noway",
  config = { extra = { is_contestant = true, odds = 2 } },
  rarity = 1,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "noway")
    return { vars = { num, denom } }
  end,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[#context.scoring_hand] and SMODS.pseudorandom_probability(card, "noway", 1, card.ability.extra.odds) then
      local _card = context.other_card
      local rank = pseudorandom_element({ "5", "7" }, pseudoseed("noway"))
      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('tarot1')
          card:juice_up()
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
          _card:flip()
          play_sound('card1', 1)
          _card:juice_up(0.3, 0.3)
          delay(0.2)
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        delay = 0.1,
        func = function()
          assert(SMODS.change_base(_card, nil, rank))
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        delay = 0.1,
        func = function()
          _card:flip()
          play_sound('tarot2', 1)
          _card:juice_up(0.3, 0.3)
          return true
        end
      }))
      delay(0.2)
      return { message = localize(rank, "ranks") }
    end
  end
}

SMODS.Joker {
  key = "refillstation",
  config = { extra = { is_contestant = true, mult = 10 } },
  rarity = 2,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 7) then
      return { mult = card.ability.extra.mult }
    end
  end
}

SMODS.Joker {
  key = "thesun",
  config = { extra = { is_contestant = true, mult = 2 } },
  rarity = 1,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 7) then
      local _card = context.other_card
      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('tarot1')
          card:juice_up()
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
          _card:flip()
          play_sound('card1', 1)
          _card:juice_up(0.3, 0.3)
          delay(0.2)
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        delay = 0.1,
        func = function()
          assert(SMODS.change_base(_card, "Hearts"))
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        delay = 0.1,
        func = function()
          _card:flip()
          play_sound('tarot2', 1)
          _card:juice_up(0.3, 0.3)
          return true
        end
      }))
      delay(0.2)
      return { mult = card.ability.extra.mult }
    end
  end
}

SMODS.Joker {
  key = "vase",
  config = { extra = { is_contestant = true } },
  rarity = 2,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
    return { }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 7) then
      local _card = context.other_card
      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('tarot1')
          card:juice_up()
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
          _card:flip()
          play_sound('card1', 1)
          _card:juice_up(0.3, 0.3)
          delay(0.2)
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        delay = 0.1,
        func = function()
          _card:set_ability("m_glass")
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        delay = 0.1,
        func = function()
          _card:flip()
          play_sound('tarot2', 1)
          _card:juice_up(0.3, 0.3)
          return true
        end
      }))
      delay(0.2)
      return { message = localize { key = "m_glass", type = "name_text", set = "Enhanced" }, colour = G.C.FILTER }
    end
  end
}

SMODS.Joker {
  key = "ti30",
  config = { extra = { is_contestant = true, xmult = 3 } },
  rarity = 3,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.xmult } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and #context.scoring_hand <= 2 then
      return { xmult = card.ability.extra.xmult }
    end
  end
}

SMODS.Joker {
  key = "wordswithfriendstile",
  config = { extra = { is_contestant = true, chips = 30 } },
  rarity = 1,
  atlas = "ITFT",
  pos = { x = 0, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 7) then
      return { chips = card.ability.extra.chips }
    end
  end
}

local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    return card_is_face_ref(self, from_boss) or ((self:get_id() == 5 or self:get_id() == 7) and next(SMODS.find_card("j_itft_wordswithfriendstile")))
end