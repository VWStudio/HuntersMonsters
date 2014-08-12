/**
 * Created by agnither on 12.08.14.
 */
package com.agnither.hunters.view.ui.screens {
import com.agnither.hunters.model.Game;
import com.agnither.hunters.view.ui.screens.game.FieldView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class BattleScreen extends Screen {

    public static const ID: String = "BattleScreen";

    private var _game: Game;

    private var _field: FieldView;

    public function BattleScreen(refs:CommonRefs, game: Game) {
        _game = game;

        super(refs);
    }

    override protected function initialize():void {
        createFromConfig(_refs.guiConfig.battleScreen);

        FieldView.fieldX = _links.chip00.x;
        FieldView.fieldY = _links.chip00.y;
        FieldView.tileX = _links.chip10.x - _links.chip00.x;
        FieldView.tileY = _links.chip01.y - _links.chip00.y;

        _links.chip00.removeFromParent(true);
        _links.chip01.removeFromParent(true);
        _links.chip10.removeFromParent(true);

        _field = new FieldView(_refs, _game.field);
        addChild(_field);
    }
}
}
