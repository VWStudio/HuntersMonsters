/**
 * Created by mor on 03.12.2014.
 */
package com.agnither.hunters.view.ui.screens.map
{
import starling.display.Sprite;

public class RomanNumber extends Sprite
{
    public function RomanNumber()
    {
        super();
    }

    public function setNumber($val : uint) :void {

        var num : Number = $val % 4000;

        /*
         Если число больше или равно 4000 то делим нацело на 1000 и получаем количество тысяч, заосвываем их в этот же алгоритм, что бы вычислить как они выглядят в римских цифрах и их подчеркнуть сверху. И вычитаем из исходного числа эти тысячи.
         Если меньше то
         Берём разряд тысяч и переводим в римский эквивалент. Вычитаем их из числа.
         Берём разряд сотен и переводим в римский эквивалент. Вычитаем их из числа.
         Дальше также поступаем с десятками и единицами.
         Повторяем все эти действия пока не вычтеться всё.
         Ну и полученые цифрки выводим как положено - тысячи подчеркнутые сверху (если их много, если нет, то нужное количество М) и обычным стилем все остальные буквы которые у нас получились.
         */





    }
}
}
