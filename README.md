My macros for "vanilla" 1.12 wow (not tested in "classic")

# Resources:
- Wow Lua API: https://vanilla-wow-archive.fandom.com/wiki/World_of_Warcraft_API
- Spell numbers: Wowhead


# General macros

```
Reload UI/addons
/console reloadui

StartAttack (drsStartAttack), non existent in vanilla, AttackTarget() starts and stops, not spammable)
Put Attack spell in 1st slot from bottom of right bar
/script if not IsCurrentAction(36) then UseAction(36) end;

Start shooting wand (drsStartShoot())
Put Shoot spell in 2nd slot from bottom of right bar
/run if IsAutoRepeatAction(35) == nil then UseAction(35) end;

Attack tank's target
/target party4
/assist

Target icon
/script SetRaidTarget("target", 8);

```


# Other addons
- WeaponQuickSwap: swap weapons, not trivial in Vanilla
