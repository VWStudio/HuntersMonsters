/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.model {
import com.agnither.hunters.data.inner.InventoryVO;
import com.agnither.hunters.data.outer.ArmorVO;
import com.agnither.hunters.data.outer.ChipVO;
import com.agnither.hunters.data.outer.DropVO;
import com.agnither.hunters.data.outer.GoldDropVO;
import com.agnither.hunters.data.outer.MagicItemVO;
import com.agnither.hunters.data.outer.MonsterVO;
import com.agnither.hunters.data.outer.PlayerVO;
import com.agnither.hunters.data.outer.SpellVO;
import com.agnither.hunters.data.outer.WeaponVO;
import com.agnither.hunters.model.ai.AI;
import com.agnither.hunters.model.match3.Cell;
import com.agnither.hunters.model.match3.Field;
import com.agnither.hunters.model.match3.Match;
import com.agnither.hunters.model.player.AIPlayer;
import com.agnither.hunters.model.player.drop.Drop;
import com.agnither.hunters.model.player.drop.DropList;
import com.agnither.hunters.model.player.Player;
import com.agnither.hunters.model.player.drop.GoldDrop;
import com.agnither.hunters.model.player.drop.ItemDrop;
import com.agnither.hunters.model.player.inventory.Armor;
import com.agnither.hunters.model.player.inventory.MagicItem;
import com.agnither.hunters.model.player.inventory.Spell;
import com.agnither.hunters.model.player.inventory.Weapon;

import starling.events.Event;
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static function getMockPlayer():Player {
        var player: Player = new Player();
        player.init(PlayerVO.DICT[1], 5);

        var inventory: InventoryVO = new InventoryVO();
        inventory.spells.push(new Spell(SpellVO.DICT[1]));
        inventory.spells.push(new Spell(SpellVO.DICT[2]));
        inventory.weapon = new Weapon(WeaponVO.DICT[1], WeaponVO.DICT[1].randomDamage);
        inventory.armor.push(new Armor(ArmorVO.DICT[1], ArmorVO.DICT[1].randomDefence));

        player.initInventory(inventory);
        return player;
    }

    public static function getMockEnemy(monster: MonsterVO):AIPlayer {
        var player: AIPlayer = new AIPlayer(monster.difficulty);
        player.init(monster, monster.magic);

        var inventory: InventoryVO = new InventoryVO();
        for (var i:int = 0; i < monster.spells.length; i++) {
            inventory.spells.push(new Spell(SpellVO.DICT[monster.spells[i]]));
        }
        if (monster.weapon) {
            inventory.weapon = new Weapon(WeaponVO.DICT[monster.weapon]);
        }
        for (i = 0; i < monster.armor.length; i++) {
            inventory.armor.push(new Armor(ArmorVO.DICT[monster.armor[i]]));
        }

        player.initInventory(inventory);
        return player;
    }

    private var _player: Player;
    public function get player():Player {
        return _player;
    }

    private var _enemy: Player;
    public function get enemy():Player {
        return _enemy;
    }

    private var _currentPlayer: Player;
    public function get currentPlayer():Player {
        return _currentPlayer;
    }
    public function get currentEnemy():Player {
        return _currentPlayer == _player ? _enemy : _player;
    }

    private var _field: Field;
    public function get field():Field {
        return _field;
    }

    private var _drop: DropList;
    public function get dropList():DropList {
        return _drop;
    }

    private var _currentMonster: MonsterVO;

    public function Game() {

        _field = new Field();
        _field.addEventListener(Field.MATCH, handleMatch);
        _field.addEventListener(Field.MOVE, handleMove);

        _drop = new DropList();
    }

    public function init():void {
        AI.init(this);

        _player = getMockPlayer();

        _currentMonster = MonsterVO.DICT[1];
        _enemy = getMockEnemy(_currentMonster);

        _field.initChips(ChipVO.DICT[_player.hero.magic], ChipVO.DICT[_enemy.hero.magic]);
        _field.init();

        nextMove(_player);
    }

    public function selectCell(cell: Cell):void {
        _field.selectCell(cell);
    }

    public function checkSpell(spell: Spell):Boolean {
        return currentPlayer.checkSpell(spell.name);
    }

    public function selectSpell(spell: Spell):void {
//        currentPlayer.checkSpell(spell.name);
    }

    public function useSpell(spell: Spell):void {
        currentPlayer.useSpell(spell.name, currentEnemy.hero);
    }

    private function nextMove(player: Player):void {
        _currentPlayer = player;

        var ai: AIPlayer = currentPlayer as AIPlayer;
        if (ai) {
            AI.move(ai);
        }
    }

    private function drop():void {
        var drop: DropVO = DropVO.getRandomDrop(_currentMonster.drop);
        var content: Drop;
        switch (drop.item_type) {
            case DropVO.WEAPON:
                content = new ItemDrop(new Weapon(WeaponVO.DICT[drop.item_id], -1));
                break;
            case DropVO.ARMOR:
                content = new ItemDrop(new Armor(ArmorVO.DICT[drop.item_id], -1));
                break;
            case DropVO.ITEM:
                content = new ItemDrop(new MagicItem(MagicItemVO.DICT[drop.item_id]));
                break;
            case DropVO.GOLD:
                content = new GoldDrop(GoldDropVO.DICT[drop.item_id].random);
                break;
        }
        _drop.addContent(content);
    }

    private function handleMatch(e: Event):void {
        var match: Match = e.data as Match;
        switch (match.type) {
            case ChipVO.CHEST:
                drop();
                break;
            case ChipVO.WEAPON:
                currentEnemy.hero.hit(match.amount * currentPlayer.hero.damage);
                break;
            default:
                currentPlayer.manaList.addMana(match.type, match.amount);
                break;
        }


        // TODO: переделать нанесение урона (проверка типа урона и сравнение с типом матча)
    }

    private function handleMove(e: Event):void {
        nextMove(currentEnemy);
    }
}
}
